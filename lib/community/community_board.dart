import 'package:amuze/community/community_post.dart';
import 'package:amuze/community/communitywrite/communitywrite.dart';
import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/resume/resume_board.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../server_communication/get/community_preview_get_server.dart';

class CommunityBoard extends StatefulWidget {
  const CommunityBoard({super.key});

  @override
  State<CommunityBoard> createState() => _CommunityBoardState();
}

class _CommunityBoardState extends State<CommunityBoard> {
  late Future<List<CommunityPreviewServerData>> serverData;

  @override
  void initState() {
    super.initState();
    serverData = communitypreviewfetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        title: const Text(
          '커뮤니티',
          style: TextStyle(color: PrimaryColors.basic),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DummyPage(),
                  )),
              icon: const Icon(
                Icons.search,
                size: 30,
                color: PrimaryColors.basic,
              ))
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(17, 0, 10, 0),
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '전체 7',
                  style: TextStyle(
                    color: TextColors.medium,
                    fontSize: 12,
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  const Communitywrite(),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
                            var begin = const Offset(1.0, 0.0);
                            var end = Offset.zero;
                            var tween = Tween(begin: begin, end: end);
                            var offsetAnimation = animation.drive(tween);

                            return SlideTransition(
                              position: offsetAnimation,
                              child: child,
                            );
                          },
                        ),
                      ).then((_) {
                        setState(() {
                          serverData = communitypreviewfetchData();
                        });
                      });
                    },
                    child: const Text(
                      '게시글 작성하기',
                      style: TextStyle(
                        color: TextColors.medium,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CommunityPreviewServerData>>(
              future: serverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerList();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var data = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          print(data.id);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommunityPost(id: data.id),
                              ) ////수정 필요///////////
                              ).then((_) => setState(
                                () {
                                  serverData = communitypreviewfetchData();
                                },
                              ));
                        },
                        child: Container(
                          height: 120,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(color: backColors.disabled))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 5, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      data.title!,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                        color: TextColors.high,
                                      ),
                                    ),
                                    const Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.bookmark_border,
                                          size: 25,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 220,
                                  child: Text(
                                    data.content!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: TextColors.medium,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(right: 15),
                                  child: Row(
                                    children: [
                                      Text(
                                        '공감 8',
                                        style: TextStyle(
                                          color: TextColors.medium,
                                          fontSize: 11,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        '댓글 2',
                                        style: TextStyle(
                                          color: TextColors.medium,
                                          fontSize: 11,
                                        ),
                                      ),
                                      Spacer(),
                                      Text(
                                        '01/11 08:41',
                                        style: TextStyle(
                                          color: TextColors.medium,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Text('No data available');
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10, // Shimmer 효과를 표시할 아이템 수 (임의로 5개 설정)
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!, // 기본 배경색
          highlightColor: Colors.grey[100]!, // 강조 배경색
          child: Container(
            height: 120, // 셀의 높이
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Colors.grey)),
            ),
            // Shimmer 효과가 적용될 콘텐츠를 정의
            child: Row(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 90,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 45,
                          color: Colors.grey,
                        ),
                        Container(
                          height: 45,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
