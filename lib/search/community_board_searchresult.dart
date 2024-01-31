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
                return Text('Error: ${snapshot.error}');
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
