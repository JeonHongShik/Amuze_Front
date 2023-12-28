import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/servercommunication/get/stage_detail_get_server.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StagePost extends StatefulWidget {
  final int? id;

  const StagePost({super.key, this.id});

  @override
  State<StagePost> createState() => _StagePostState();
}

class _StagePostState extends State<StagePost> {
  final dio = Dio();
  late ScrollController _scrollController;
  double _containerTop = 0;

  late Future<List<StageDetailServerData>> serverData;
  List<String?> imageList = [];

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // 다이얼로그 외부 터치로 닫히지 않도록 설정
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('정말 삭제하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(); // 다이얼로그 닫기
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () async {
                // 2. 확인 버튼 누를 시 삭제 요청 보내기
                final bool success = await _deletePost(); // 게시물 삭제 함수 호출

                if (success) {
                  // 삭제 성공 시
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                  Navigator.of(context).pop();
                } else {
                  // 삭제 실패 시
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('삭제에 실패했습니다.'),
                    ),
                  );
                  Navigator.of(context).pop(); // 다이얼로그 닫기
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> _deletePost() async {
    try {
      final response = await dio.delete(
        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/posts/post/${widget.id.toString()}/delete/',
        // 필요한 헤더 및 인증 정보를 추가할 수 있음
      );

      if (response.statusCode == 200) {
        // 삭제 요청이 성공적으로 처리될 때
        return true;
      } else {
        // 삭제 요청이 실패할 때
        return false;
      }
    } catch (e) {
      // 오류 처리
      print('Error: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    serverData = stagedetailfetchData(widget.id!);
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      setState(() {
        _containerTop = _scrollController.offset;
        /*double maxScrollOffset = MediaQuery.of(context).size.height / 3 / 2;
        if (_containerTop > maxScrollOffset) {
          _containerTop = maxScrollOffset;
          _scrollController.jumpTo(maxScrollOffset);
        }
        */
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double imageHeight = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: imageHeight,
            pinned: true,
            backgroundColor: Colors.transparent, // AppBar 배경을 투명하게 설정
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                bool isExpanded = constraints.biggest.height > kToolbarHeight;
                return FlexibleSpaceBar(
                  background: isExpanded
                      ? Image.asset(
                          'assets/images/김채원.jpg',
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Colors.grey.shade300, // AppBar가 축소될 때의 배경색
                        ),
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                //borderRadius: BorderRadius.circular(15),
              ),
              child: FutureBuilder<List<StageDetailServerData>>(
                future: serverData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    return Column(
                      children: snapshot.data!.map((item) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 0, 0),
                                width: MediaQuery.of(context).size.width,
                                height: 110,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${item.title}' ?? 'No Title',
                                          style: const TextStyle(fontSize: 25),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              await _showDeleteDialog(context);
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                              color: IconColors.inactive,
                                            ))
                                      ],
                                    ),
                                    Container(
                                      height: 20,
                                    ),
                                    Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child:
                                            Text(item.author ?? 'No Author')),
                                  ],
                                )),
                            buildNullableInfo('공연 종류', item.wishtype),
                            buildNullableInfo('무대 종류', item.type),
                            buildNullableInfo('공연 일시', item.datetime),
                            buildNullableInfo('공고 마감기한', item.deadline),
                            buildNullableInfo('위치', item.region),
                            buildNullableInfo('페이', item.pay),
                            buildNullableInfo('공연 정보', item.introduce),
                          ],
                        );
                      }).toList(),
                    );
                  } else {
                    return const Center(child: Text('No Data Available'));
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

Widget buildNullableInfo(String label, String? value) {
  return value != null && value.isNotEmpty
      ? Container(
          margin: const EdgeInsets.only(left: 20),
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
          child: SizedBox(
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style:
                      const TextStyle(color: TextColors.medium, fontSize: 15),
                ),
                Text(
                  value,
                  style: const TextStyle(color: TextColors.high, fontSize: 20),
                )
              ],
            ),
          ),
        )
      : const SizedBox.shrink();
}
