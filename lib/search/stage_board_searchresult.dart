import 'package:amuze/server_communication/get/preview/stage_preview_get_server.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../gathercolors.dart';
import '../stage/stage_post.dart';

class StageBoardSearchResult extends StatefulWidget {
  final String? searchtext;
  const StageBoardSearchResult({super.key, this.searchtext});

  @override
  State<StageBoardSearchResult> createState() => _StageBoardSearchResultState();
}

class _StageBoardSearchResultState extends State<StageBoardSearchResult> {
  // final TextEditingController controller = TextEditingController(text: searchtext);
  // late String researchtext = controller.text;
  // FocusNode searchFocus = FocusNode();
  late Future<List<StagePreviewServerData>> serverData;

  @override
  void initState() {
    super.initState();
    serverData = stagesearchpreviewfetchData(widget.searchtext!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: PrimaryColors.basic,
        ),
      ),
      // appBar: AppBar(
      //   toolbarHeight: 110,
      //   leadingWidth: MediaQuery.of(context).size.width,
      //   // backgroundColor: Colors.white,
      //   leading: Padding(
      //     padding: const EdgeInsets.only(left: 5),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         // Amuze 로고

      //         // children: [
      //         //   const Text(
      //         //     'Amuze',
      //         //     style: TextStyle(
      //         //       color: Colors.white,
      //         //       // color: PrimaryColors.basic,
      //         //       fontSize: 25,
      //         //       fontWeight: FontWeight.bold,
      //         //     ),
      //         //   ),
      //         //   const SizedBox(height: 10),

      //         IconButton(
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           },
      //           icon: const Icon(Icons.arrow_back),
      //           color: PrimaryColors.basic,
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.only(left: 15),
      //           child: Row(
      //             children: [
      //               Container(
      //                 width: MediaQuery.of(context).size.width * 0.82,
      //                 height: 40,
      //                 decoration: BoxDecoration(
      //                   color: backColors.disabled,
      //                   borderRadius: BorderRadius.circular(20),
      //                 ),
      //                 child: Container(
      //                   alignment: AlignmentDirectional.centerStart,
      //                   child: TextField(
      //                     controller: controller,
      //                     focusNode: searchFocus,
      //                     decoration: InputDecoration(
      //                         contentPadding:
      //                             const EdgeInsets.fromLTRB(10, 18, 0, 0),
      //                         hintText: '공고 게시물을 검색해보세요!',
      //                         hintStyle:
      //                             const TextStyle(color: TextColors.medium),
      //                         enabledBorder: InputBorder.none,
      //                         suffix: Padding(
      //                           padding:
      //                               const EdgeInsets.fromLTRB(0, 10, 15, 0),
      //                           child: GestureDetector(
      //                             onTap: () => controller.clear(),
      //                             child: const Icon(
      //                               Icons.cancel,
      //                               color: IconColors.disabled,
      //                             ),
      //                           ),
      //                         )),
      //                   ),
      //                 ),
      //               ),
      //               IconButton(
      //                 onPressed: () {
      //                   if (controller.text.isNotEmpty) {
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => StageBoardSearchResult(
      //                           searchtext: searchtext,
      //                         ),
      //                       ),
      //                     );
      //                   }
      //                   print('검색어 : $searchtext');
      //                 },
      //                 icon: const Icon(
      //                   Icons.search,
      //                 ),
      //                 color: PrimaryColors.basic,
      //                 iconSize: 30,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 18),
            width: MediaQuery.of(context).size.width,
            height: 35,
            child: const Text(
              '검색결과',
              style: TextStyle(
                fontSize: 13,
                color: TextColors.medium,
              ),
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
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      // totalcount = snapshot.data!.length;
                    });
                  });
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
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 13),
                                        height: 42,
                                        child: data.title != null
                                            ? Text(
                                                data.title!,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontSize: 16.5,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              )
                                            : const SizedBox.shrink(),
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
                                                  data.pay != null
                                                      ? Text(
                                                          '${data.pay}원 · ',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            color: TextColors
                                                                .medium,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  data.type != null
                                                      ? Text(
                                                          '${data.type!} · ',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            color: TextColors
                                                                .medium,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                  data.region != null
                                                      ? Text(
                                                          data.region!,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 13,
                                                            color: TextColors
                                                                .medium,
                                                          ),
                                                        )
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 13),
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
                  return const Center(child: Text('검색된 공고 게시물이 없습니다.'));
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
