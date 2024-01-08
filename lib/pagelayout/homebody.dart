import 'dart:math';

import 'package:amuze/community/community_board.dart';
import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/resume/resume_board.dart';
import 'package:amuze/stage/stage_post.dart';
import 'package:amuze/server_communication/get/stage_preview_get_server.dart';
import 'package:amuze/stage/stage_board.dart';
import 'package:flutter/material.dart';

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
                    imagePath: null,
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

  @override
  void initState() {
    super.initState();
    serverData = stagepreviewfetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 700,
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
                    serverData = stagepreviewfetchData();
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
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                // 항목 수를 5개로 제한합니다.
                int itemCount = min(snapshot.data!.length, 5);
                return Expanded(
                  child: Column(
                    children: List.generate(itemCount, (index) {
                      var data = snapshot.data![index];
                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              print(data.mainimage);
                              print(data.title);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        StagePost(id: data.id),
                                  )).then((_) => setState(() {
                                    serverData = stagepreviewfetchData();
                                  }));
                            },
                            child: Container(
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
                                                    'assets/images/공고임시이미지.png'),
                                                fit: BoxFit.fill)),
                                      ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.55,
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
                                              Text(
                                                data.title!,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
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
                                                    '${data.pay!}원',
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
                                                  Text(
                                                    data.region!,
                                                    style: const TextStyle(
                                                      fontSize: 12.5,
                                                      color: TextColors.medium,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                              child: data.datetime != ''
                                                  ? Text(
                                                      '공연 날짜 - ${data.datetime}',
                                                      style: const TextStyle(
                                                        fontSize: 12.5,
                                                        color:
                                                            TextColors.medium,
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
                              ]),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          )
                        ],
                      );
                    }),
                  ),
                );
              } else {
                return const Text('No data available');
              }
            },
          ),
        ],
      ),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 760,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
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
                    MaterialPageRoute(builder: (context) => const DummyPage()),
                  ),
                },
                child: const Text(
                  '전체보기',
                  style: TextStyle(color: TextColors.high),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////

//커뮤니티게시판들//////////////////////////////////////////////////////////////////////
class ComunityBoards extends StatelessWidget {
  final String title;
  const ComunityBoards({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 760,
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: TextColors.high),
              ),
              TextButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DummyPage()),
                  ),
                },
                child: const Text(
                  '전체보기',
                  style: TextStyle(color: TextColors.high),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Container(
            height: 120,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////