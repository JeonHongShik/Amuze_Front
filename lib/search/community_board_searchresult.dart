import 'package:amuze/search/community_board_search.dart';
import 'package:amuze/server_communication/get/preview/community_preview_get_server.dart';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../community/community_post.dart';
import '../gathercolors.dart';

// 커뮤니티 검색 결과 페이지
class CommunityBoardSearchResult extends StatefulWidget {
  final String? searchtext;
  const CommunityBoardSearchResult({super.key, this.searchtext});

  @override
  State<CommunityBoardSearchResult> createState() =>
      _CommunityBoardSearchResultState();
}

class _CommunityBoardSearchResultState
    extends State<CommunityBoardSearchResult> {
  late Future<List<CommunityPreviewServerData>> serverData;
  // late final String searchtext = searchtext;

  @override
  void initState() {
    super.initState();
    serverData = communitysearchpreviewfetchData(widget.searchtext!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            print('searchtext : ${widget.searchtext}');
          },
          icon: const Icon(Icons.arrow_back),
          color: PrimaryColors.basic,
        ),
      ),
      body: Column(children: [
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
          child: FutureBuilder<List<CommunityPreviewServerData>>(
            future: serverData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const ShimmerList();
              } else if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 아이콘과 텍스트를 중앙에 배치하기 위해 사용
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
                            serverData = communitysearchpreviewfetchData(
                                widget.searchtext!);
                          });
                        },
                      ),
                    ],
                  ),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    // totalcount = snapshot.data!.length;
                  });
                });
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var data = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        print(data.id);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommunityPost(id: data.id),
                            ) ////수정 필요///////////
                            ).then((_) => setState(
                              () {
                                serverData = communitysearchpreviewfetchData(
                                    widget.searchtext!);
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
                          padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 15, 5),
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
                return const Center(child: Text('검색 결과가 없습니다.'));
              }
            },
          ),
        ),
      ]),
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
