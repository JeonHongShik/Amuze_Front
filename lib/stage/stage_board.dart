import 'dart:math';

import 'package:amuze/gathercolors.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/stage/stage_post.dart';
import 'package:amuze/servercommunication/get/stage_priview_get_server.dart';

import 'package:amuze/stage/stagewrite/stagetitle.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StageBoard extends StatefulWidget {
  const StageBoard({super.key});

  @override
  State<StageBoard> createState() => _StageBoardState();
}

class _StageBoardState extends State<StageBoard> {
  late Future<List<StagePreviewServerData>> serverData;

  @override
  void initState() {
    super.initState();
    serverData = stagepreviewfetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        title: const Text(
          '공고 게시판',
          style: TextStyle(color: TextColors.high),
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
            padding: const EdgeInsets.only(left: 17),
            width: MediaQuery.of(context).size.width,
            height: 50,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '전체 100',
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
                                  const Stagetitle(),
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
                      );
                    },
                    child: const Text(
                      '공고 작성하기',
                      style: TextStyle(
                        color: TextColors.medium,
                        fontSize: 12,
                      ),
                    ))
              ],
            ),
          ),
          Expanded(
              child: FutureBuilder<List<StagePreviewServerData>>(
            future: serverData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerList();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length, // 데이터의 전체 길이를 사용합니다.
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        print(data.id);
                        print(data.author);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StagePost(id: data.id),
                            )).then((_) => setState(() {
                              serverData = stagepreviewfetchData();
                            }));
                      },
                      child: Container(
                        height: 120,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                top: BorderSide(color: backColors.disabled))),
                        child: Row(
                          children: [
                            (data.mainimage != null)
                                ? Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: backColors.disabled,
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              data.mainimage!,
                                            ),
                                            fit: BoxFit.fill)),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(left: 10),
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: backColors.disabled,
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                'assets/images/공고임시이미지.png'),
                                            fit: BoxFit.fill)),
                                  ),
                            Expanded(
                              child: SizedBox(
                                height: 86,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(left: 13),
                                      height: 42,
                                      child: Text(
                                        data.title!,
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
                                                const EdgeInsets.only(left: 13),
                                            height: 20,
                                            child: Row(
                                              children: [
                                                data.pay!.isNotEmpty
                                                    ? Text(
                                                        '${data.pay}원 · ',
                                                        style: const TextStyle(
                                                          fontSize: 13,
                                                          color:
                                                              TextColors.medium,
                                                        ),
                                                      )
                                                    : const SizedBox.shrink(),
                                                Text(
                                                  '${data.type!} · ',
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: TextColors.medium,
                                                  ),
                                                ),
                                                Text(
                                                  data.region!,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                    color: TextColors.medium,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 13),
                                            height: 22.5,
                                            child: Text(
                                              '공연 날짜 - ${data.datetime}',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: TextColors.medium,
                                              ),
                                            ),
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
                  },
                );
              } else {
                return const Text('No data available');
              }
            },
          )),
        ],
      ),
    );
  }
}

class DummyContainer extends StatelessWidget {
  const DummyContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 100,
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey))),
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
