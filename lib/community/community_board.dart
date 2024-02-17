import 'package:amuze/community/community_post.dart';
import 'package:amuze/community/communitywrite/communitywrite.dart';
import 'package:amuze/gathercolors.dart';
import 'package:amuze/native_ads_test.dart';

import 'package:amuze/search/community_board_search.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../server_communication/get/preview/community_preview_get_server.dart';

class CommunityBoard extends StatefulWidget {
  const CommunityBoard({super.key});

  @override
  State<CommunityBoard> createState() => _CommunityBoardState();
}

class _CommunityBoardState extends State<CommunityBoard> {
  late Future<List<CommunityPreviewServerData>> serverData;
  int totalcount = 0;

  @override
  void initState() {
    super.initState();
    serverData = communitypreviewfetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
                    builder: (context) => const CommunityBoardSearch(),
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
                Text(
                  '전체 $totalcount',
                  style: const TextStyle(
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
                  return Center(
                    child: Column(
                      mainAxisSize:
                          MainAxisSize.min, // 아이콘과 텍스트를 중앙에 배치하기 위해 사용
                      children: [
                        const Text('게시물을 불러오지 못 했습니다.'),
                        const Text('다시 시도'),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: PrimaryColors.basic,
                          ), // 재시도 아이콘
                          onPressed: () {
                            // 아이콘이 눌렸을 때 데이터를 다시 불러오는 로직을 실행합니다.
                            setState(() {
                              serverData = communitypreviewfetchData();
                            });
                          },
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      totalcount = snapshot.data!.length;
                    });
                  });
                  return RefreshIndicator(
                    color: PrimaryColors.basic,
                    backgroundColor: Colors.white,
                    onRefresh: () async {
                      setState(() {
                        serverData = communitypreviewfetchData();
                      });
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          snapshot.data!.length + (snapshot.data!.length ~/ 10),
                      itemBuilder: (context, index) {
                        if (index % 11 == 10) {
                          return Column(
                            children: [
                              Container(
                                height: 1,
                                color: Colors.grey[200],
                              ),
                              const NativeAds(),
                              Container(
                                height: 1,
                                color: Colors.grey[200],
                              ),
                            ],
                          );
                        } else {
                          var realIndex = index - (index ~/ 6);
                          var reverseIndex =
                              snapshot.data!.length - 1 - realIndex;
                          var data = snapshot.data![reverseIndex];
                          return GestureDetector(
                            onTap: () {
                              print(data.id);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CommunityPost(id: data.id),
                                  )).then((_) => setState(
                                    () {
                                      serverData = communitypreviewfetchData();
                                    },
                                  ));
                            },
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                          color: backColors.disabled))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 10, 0, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(right: 20),
                                      width: MediaQuery.of(context).size.width,
                                      child: Text(
                                        data.content!,
                                        maxLines: 2,
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
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 15, 5),
                                      child: Row(
                                        children: [
                                          Text(
                                            '공감 ${data.likescount}',
                                            style: const TextStyle(
                                              color: TextColors.medium,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          Text(
                                            '댓글 ${data.commentscount}',
                                            style: const TextStyle(
                                              color: TextColors.medium,
                                              fontSize: 11,
                                            ),
                                          ),
                                          const Spacer(),
                                          data.createdat != null
                                              ? Text(
                                                  data.createdat!,
                                                  style: const TextStyle(
                                                    color: TextColors.medium,
                                                    fontSize: 11,
                                                  ),
                                                )
                                              : const SizedBox.shrink(),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('아직 커뮤니티 글이 없습니다.'));
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10, // Shimmer 효과를 표시할 아이템 수
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!, // 기본 배경색
          highlightColor: Colors.grey[100]!, // 강조 배경색
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: 20,
                      color: Colors.white,
                    ),
                    const Spacer(),
                    Container(
                      width: MediaQuery.of(context).size.width / 4,
                      height: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
