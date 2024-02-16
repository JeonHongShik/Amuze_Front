import 'package:amuze/community/community_board.dart';
import 'package:amuze/community/community_post.dart';
import 'package:amuze/gathercolors.dart';

import 'package:amuze/resume/resume_board.dart';
import 'package:amuze/resume/resume_post.dart';
import 'package:amuze/server_communication/get/preview/community_preview_get_server.dart';
import 'package:amuze/server_communication/get/preview/resume_preview_get_server.dart';

import 'package:amuze/server_communication/get/preview/stage_preview_get_server.dart';
import 'package:amuze/stage/stage_board.dart';
import 'package:amuze/stage/stage_post.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //최상단 게시판 이동 버튼
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TopBoardRowBlank(),
                  TopBoard(
                    label: '공고 게시판',
                    imagePath: 'assets/images/공고_게시판_이미지.png',
                  ),
                  TopBoardRowBlank(),
                  TopBoard(
                    label: '이력서 게시판',
                    imagePath: 'assets/images/이력서_게시판_이미지_다른버전.png',
                  ),
                  TopBoardRowBlank(),
                  TopBoard(
                    label: '커뮤니티',
                    imagePath: 'assets/images/커뮤니티_게시판_이미지.png',
                  ),
                  TopBoardRowBlank()
                ],
              ),
            ),
            const ColumnBlank(),
            const StageBoards(title: '공고 게시물'),
            const ColumnBlank(),
            const ResumeBoards(title: '이력서 게시물'),
            const ColumnBlank(),
            const ComunityBoards(title: '커뮤니티'),
          ],
        ),
      ),
    );
  }
}

//최상단 게시판 이동 버튼////////////////////////////////////////////////////////
class TopBoard extends StatefulWidget {
  final String label;
  final String? imagePath;
  const TopBoard({super.key, required this.label, required this.imagePath});

  @override
  State<TopBoard> createState() => _TopBoardState();
}

class _TopBoardState extends State<TopBoard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.label == '공고 게시판') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StageBoard()),
          );
        } else if (widget.label == '이력서 게시판') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ResumeBoard()),
          );
        } else if (widget.label == '커뮤니티') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CommunityBoard()),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.25,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: widget.imagePath != null
                  ? DecorationImage(
                      image: AssetImage(widget.imagePath!), fit: BoxFit.cover)
                  : null,
              color: const Color(0xffd9d9d9),
            ),
          ),
          SizedBox(
            height: 30,
            width: MediaQuery.of(context).size.width * 0.25,
            child: Center(
              child: Text(
                widget.label,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: TextColors.high),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TopBoardRowBlank extends StatelessWidget {
  const TopBoardRowBlank({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.0625,
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

//HomeBody 세로 여백////////////////////////////////////////////////////////////
class ColumnBlank extends StatelessWidget {
  const ColumnBlank({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: MediaQuery.of(context).size.width,
      color: backColors.disabled,
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

//공고 게시물////////////////////////////////////////////////////////////////////
class StageBoards extends StatefulWidget {
  final String title;
  const StageBoards({super.key, required this.title});

  @override
  State<StageBoards> createState() => _StageBoardsState();
}

class _StageBoardsState extends State<StageBoards> {
  late Future<List<StagePreviewServerData>> serverData;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    serverData = stagepreviewfetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(23, 20, 25, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: TextColors.high),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const StageBoard()),
                  ).then((_) {
                    setState(() {
                      serverData = stagepreviewfetchData();
                    });
                  }),
                },
                child: const Text(
                  '전체보기',
                  style: TextStyle(
                    color: TextColors.disabled,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 22,
          ),
          FutureBuilder<List<StagePreviewServerData>>(
            future: serverData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerList();
              } else if (snapshot.hasError) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('게시물을 불러오지 못 했습니다.'),
                        const Text('다시 시도'),
                        IconButton(
                          icon: const Icon(
                            Icons.refresh,
                            color: PrimaryColors.basic,
                          ),
                          onPressed: () {
                            setState(() {
                              serverData = stagepreviewfetchData();
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      snapshot.data!.length > 5 ? 5 : snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var reverseIndex = snapshot.data!.length - 1 - index;
                    var data = snapshot.data![reverseIndex];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StagePost(id: data.id),
                            )).then((_) => setState(() {
                              serverData = stagepreviewfetchData();
                            }));
                      },
                      child: Column(children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 3,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                )
                              ]),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 10,
                              ),
                              (data.mainimage != null)
                                  ? Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                data.mainimage!,
                                              ),
                                              fit: BoxFit.fill)),
                                    )
                                  : Container(
                                      width: 85,
                                      height: 85,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: const DecorationImage(
                                              image: AssetImage(
                                                  'assets/images/공고게시물없음이미지.jpg'),
                                              fit: BoxFit.fill)),
                                    ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.55,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                        height: 34,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                data.title!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        )),
                                    SizedBox(
                                      height: 45,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${NumberFormat('#,###').format(int.tryParse(data.pay!) ?? 0)}원',
                                                  style: const TextStyle(
                                                    fontSize: 12.5,
                                                    color: TextColors.medium,
                                                  ),
                                                ),
                                                const Text(
                                                  ' · ',
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    color: TextColors.medium,
                                                  ),
                                                ),
                                                Text(
                                                  data.type!,
                                                  style: const TextStyle(
                                                    fontSize: 12.5,
                                                    color: TextColors.medium,
                                                  ),
                                                ),
                                                const Text(
                                                  ' · ',
                                                  style: TextStyle(
                                                    fontSize: 12.5,
                                                    color: TextColors.medium,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    data.region!,
                                                    style: const TextStyle(
                                                      fontSize: 12.5,
                                                      color: TextColors.medium,
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20,
                                            child: data.datetime != ''
                                                ? Text(
                                                    '공연 날짜 : ${data.datetime}',
                                                    style: const TextStyle(
                                                      fontSize: 12.5,
                                                      color: TextColors.medium,
                                                    ),
                                                  )
                                                : const SizedBox.shrink(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ]),
                    );
                  },
                );
              } else {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 100,
                  color: Colors.white,
                  child: const Center(
                    child: Text('게시물이 없습니다...'),
                  ),
                );
              }
            },
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
      shrinkWrap: true,
      itemCount: 5, // Shimmer 효과를 표시할 아이템 수
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Shimmer 효과의 기본 색상
              highlightColor: Colors.grey[100]!, // Shimmer 효과의 하이라이트 색상
              child: Row(
                children: [
                  Container(
                    width: 85,
                    height: 85,
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 10),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.55,
                          color: Colors.grey,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 12)),
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.5,
                          color: Colors.grey,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 12)),
                      Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.4,
                        color: Colors.grey,
                        margin: const EdgeInsets.only(left: 10),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

//이력서게시판//////////////////////////////////////////////////////////////////////
class ResumeBoards extends StatefulWidget {
  final String title;
  const ResumeBoards({super.key, required this.title});

  @override
  State<ResumeBoards> createState() => _ResumeBoardsState();
}

class _ResumeBoardsState extends State<ResumeBoards> {
  late Future<List<ResumePreviewServerData>> resumeserverData;
  final dio = Dio();

  @override
  void initState() {
    super.initState();
    resumeserverData = resumepreviewfetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(23, 20, 25, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: TextColors.high),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ResumeBoard()),
                  ).then((_) {
                    setState(() {
                      resumeserverData = resumepreviewfetchData();
                    });
                  }),
                },
                child: const Text(
                  '전체보기',
                  style: TextStyle(
                    color: TextColors.disabled,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          FutureBuilder<List<ResumePreviewServerData>>(
              future: resumeserverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ResumeShimmerList();
                } else if (snapshot.hasError) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Center(
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
                                resumeserverData = resumepreviewfetchData();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        snapshot.data!.length > 5 ? 5 : snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var reverseIndex = snapshot.data!.length - 1 - index;
                      var data = snapshot.data![reverseIndex];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResumePost(id: data.id),
                              )).then((_) => setState(() {
                                resumeserverData = resumepreviewfetchData();
                              }));
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ]),
                              child: Row(children: [
                                const SizedBox(
                                  width: 10,
                                ),
                                (data.mainimage != null)
                                    ? Container(
                                        width: 85,
                                        height: 85,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                  data.mainimage!,
                                                ),
                                                fit: BoxFit.fill)),
                                      )
                                    : Container(
                                        width: 85,
                                        height: 85,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            image: const DecorationImage(
                                                image: AssetImage(
                                                    'assets/images/이력서게시물없음이미지.png'),
                                                fit: BoxFit.fill)),
                                      ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 86,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.fromLTRB(
                                              13, 8, 0, 5),
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
                                                padding: const EdgeInsets.only(
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
                                                              color: TextColors
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
                                                              color: TextColors
                                                                  .medium,
                                                            ),
                                                          )
                                                        : const SizedBox
                                                            .shrink(),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 13),
                                                height: 22.5,
                                                child: (data.education !=
                                                            null &&
                                                        data.education!
                                                            .isNotEmpty)
                                                    ? Text(
                                                        data.education![0],
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              TextColors.medium,
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
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    color: Colors.white,
                    child: const Center(
                      child: Text('게시물이 없습니다...'),
                    ),
                  );
                }
              })
        ],
      ),
    );
  }
}

class ResumeShimmerList extends StatelessWidget {
  const ResumeShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5, // Shimmer 효과를 표시할 아이템 수
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Shimmer 효과의 기본 색상
              highlightColor: Colors.grey[100]!, // Shimmer 효과의 하이라이트 색상
              child: Row(
                children: [
                  Container(
                    width: 85,
                    height: 85,
                    color: Colors.white,
                    margin: const EdgeInsets.only(left: 10),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.55,
                          color: Colors.grey,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 12)),
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.4,
                          color: Colors.grey,
                          margin: const EdgeInsets.fromLTRB(10, 0, 0, 12)),
                      Container(
                        height: 20,
                        width: MediaQuery.of(context).size.width * 0.5,
                        color: Colors.grey,
                        margin: const EdgeInsets.only(left: 10),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////////////

//커뮤니티게시판들//////////////////////////////////////////////////////////////////////
class ComunityBoards extends StatefulWidget {
  final String title;
  const ComunityBoards({super.key, required this.title});

  @override
  State<ComunityBoards> createState() => _ComunityBoardsState();
}

class _ComunityBoardsState extends State<ComunityBoards> {
  late Future<List<CommunityPreviewServerData>> serverData;

  @override
  void initState() {
    super.initState();
    serverData = communitypreviewfetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(23, 20, 25, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: TextColors.high),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CommunityBoard()),
                  ).then((_) => setState(() {
                        serverData = communitypreviewfetchData();
                      }))
                },
                child: const Text(
                  '전체보기',
                  style: TextStyle(color: TextColors.disabled),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          FutureBuilder<List<CommunityPreviewServerData>>(
              future: serverData,
              builder: ((context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CommunityShimmerList();
                } else if (snapshot.hasError) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: Center(
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
                    ),
                  );
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount:
                        snapshot.data!.length > 5 ? 5 : snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var reverseIndex = snapshot.data!.length - 1 - index;
                      var data = snapshot.data![reverseIndex];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommunityPost(id: data.id),
                              )).then((_) => setState(() {
                                serverData = communitypreviewfetchData();
                              }));
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 3,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(18, 8, 18, 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.5,
                                      child: Text(
                                        data.title!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: TextColors.high,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      height: 20,
                                      child: Text(
                                        data.content!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w400,
                                          color: TextColors.disabled,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    const Row(
                                      children: [
                                        Text(
                                          '공감 3',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: TextColors.disabled,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          '댓글 2',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: TextColors.disabled,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          '01/13 10:05',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: TextColors.disabled,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    color: Colors.white,
                    child: const Center(
                      child: Text('게시물이 없습니다...'),
                    ),
                  );
                }
              }))
        ],
      ),
    );
  }
}

class CommunityShimmerList extends StatelessWidget {
  const CommunityShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 5, // Shimmer 효과를 표시할 아이템 수
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[300]!, // Shimmer 효과의 기본 색상
              highlightColor: Colors.grey[100]!, // Shimmer 효과의 하이라이트 색상
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.6,
                      color: Colors.grey,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                  Container(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.grey,
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 12)),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: Colors.grey,
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }
}
////////////////////////////////////////////////////////////////////////////////