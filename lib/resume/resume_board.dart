import 'package:amuze/gathercolors.dart';
import 'package:amuze/native_ads_test.dart';
import 'package:amuze/resume/resume_post.dart';
import 'package:amuze/resume/resumewrite/resumetitle.dart';
import 'package:amuze/search/resume_board_search.dart';
import 'package:amuze/server_communication/get/preview/resume_preview_get_server.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ResumeBoard extends StatefulWidget {
  const ResumeBoard({super.key});

  @override
  State<ResumeBoard> createState() => _ResumeBoardState();
}

class _ResumeBoardState extends State<ResumeBoard> {
  late Future<List<ResumePreviewServerData>> serverData;
  int totalcount = 0;

  @override
  void initState() {
    super.initState();
    serverData = resumepreviewfetchData();
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
          '이력서 게시판',
          style: TextStyle(color: PrimaryColors.basic),
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ResumeBoardSearch(),
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
            padding: const EdgeInsets.only(left: 17),
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
                                  const Resumetitle(),
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
                          serverData = resumepreviewfetchData();
                        });
                      });
                    },
                    child: const Text(
                      '이력서 작성하기',
                      style: TextStyle(
                        color: TextColors.medium,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<ResumePreviewServerData>>(
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
                              serverData = resumepreviewfetchData();
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
                        serverData = resumepreviewfetchData();
                      });
                    },
                    child: ListView.builder(
                      itemCount:
                          snapshot.data!.length + (snapshot.data!.length ~/ 5),
                      itemBuilder: (context, index) {
                        if (index % 6 == 5) {
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ResumePost(id: data.id),
                                  )).then((_) => setState(() {
                                    serverData = resumepreviewfetchData();
                                  }));
                            },
                            child: Container(
                              height: 120,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  border: Border(
                                      top: BorderSide(
                                          color: backColors.disabled))),
                              child: Row(
                                children: [
                                  (data.mainimage != null)
                                      ? Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              color: backColors.disabled,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    data.mainimage!,
                                                  ),
                                                  fit: BoxFit.fill)),
                                        )
                                      : Container(
                                          margin:
                                              const EdgeInsets.only(left: 10),
                                          width: 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: backColors.disabled,
                                              image: const DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/이력서게시물없음이미지.png'),
                                                  fit: BoxFit.fill)),
                                        ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 86,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            height: 42,
                                            child: Text(
                                              data.title!,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16.5,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 44,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 13),
                                                  height: 20,
                                                  child: Row(
                                                    children: [
                                                      data.age != null
                                                          ? Text(
                                                              '${data.age} · ',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    TextColors
                                                                        .medium,
                                                              ),
                                                            )
                                                          : const SizedBox
                                                              .shrink(),
                                                      data.gender != null
                                                          ? Text(
                                                              '${data.gender}',
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    TextColors
                                                                        .medium,
                                                              ),
                                                            )
                                                          : const SizedBox
                                                              .shrink(),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 13),
                                                  height: 22.5,
                                                  child: (data.education !=
                                                              null &&
                                                          data.education!
                                                              .isNotEmpty)
                                                      ? Text(
                                                          data.education![0],
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            color: TextColors
                                                                .medium,
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        )
                                                      : const SizedBox.shrink(),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  );
                } else {
                  return const Center(child: Text('아직 작성된 이력서가 없습니다.'));
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  color: Colors.white,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: MediaQuery.of(context).size.width / 3,
                        height: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: Colors.white,
                      ),
                    ],
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
