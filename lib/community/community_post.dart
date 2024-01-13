import 'package:amuze/community/communitywrite/communitywrite.dart';
import 'package:amuze/main.dart';
import 'package:amuze/mypage/editprofile.dart';
import 'package:amuze/resume/resume_post.dart';
import 'package:amuze/server_communication/get/community_detail_get_server.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gathercolors.dart';

class CommunityPost extends StatefulWidget {
  final int? id;

  const CommunityPost({super.key, this.id});

  @override
  State<CommunityPost> createState() => _CommunityPostState();
}

class _CommunityPostState extends State<CommunityPost> {
  final dio = Dio();
  // late TextEditingController controller; // 댓글 컨트롤러
  // late ScrollController _scrollController;
  // double _containerTop = 0;
  late TextEditingController commentController = TextEditingController();

  late Future<List<CommunityDetailServerData>> serverData;

  Future<void> _showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/community/delete/${widget.id.toString()}/',
          data: {
            'uid': Provider.of<UserInfoProvider>(context, listen: false).uid
          });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    serverData = communitydetailfetchData(widget.id!);

    // _scrollController = ScrollController();
    // _scrollController.addListener(() {
    //   setState(() {
    //     _containerTop = _scrollController.offset;
    //   });
    // });
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColors.disabled,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: FutureBuilder<List<CommunityDetailServerData>>(
              future: serverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return Column(
                      children: snapshot.data!.map((item) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(19, 0, 12, 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: Text(
                                  '${item.title}',
                                  style: const TextStyle(
                                    fontSize: 21,
                                    fontWeight: FontWeight.w600,
                                    color: TextColors.high,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (item.author ==
                                  Provider.of<UserInfoProvider>(context,
                                          listen: false)
                                      .displayName)
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          final communityprovider = Provider.of<
                                                  CommunityWriteProvider>(
                                              context,
                                              listen: false);
                                          if (item.id != null) {
                                            communityprovider.id = item.id;
                                          }
                                          if (item.title != null &&
                                              item.title != '') {
                                            communityprovider
                                                .setTitle(item.title!);
                                          }
                                          if (item.content != null &&
                                              item.content != '') {
                                            communityprovider
                                                .setContent(item.content!);
                                            Navigator.push(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation,
                                                        secondaryAnimation) =>
                                                    const Communitywrite(),
                                                transitionsBuilder: (context,
                                                    animation,
                                                    secondaryAnimation,
                                                    child) {
                                                  var begin =
                                                      const Offset(1.0, 0.0);
                                                  var end = Offset.zero;
                                                  var tween = Tween(
                                                      begin: begin, end: end);
                                                  var offsetAnimation =
                                                      animation.drive(tween);

                                                  return SlideTransition(
                                                    position: offsetAnimation,
                                                    child: child,
                                                  );
                                                },
                                              ),
                                            ).then(
                                              (_) {
                                                setState(() {
                                                  serverData =
                                                      communitydetailfetchData(
                                                          widget.id!);
                                                });
                                              },
                                            );
                                          }
                                        },
                                        padding: EdgeInsets.zero,
                                        visualDensity: const VisualDensity(
                                          horizontal: -4,
                                          vertical: -4,
                                        ),
                                        icon: const Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: IconColors.inactive,
                                        )),
                                    IconButton(
                                      onPressed: () async {
                                        await _showDeleteDialog(context);
                                      },
                                      visualDensity: const VisualDensity(
                                        horizontal: -4,
                                        vertical: -4,
                                      ),
                                      padding: EdgeInsets.zero,
                                      icon: const Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: IconColors.inactive,
                                      ),
                                    ),
                                  ],
                                ),
                              if (item.author !=
                                  Provider.of<UserInfoProvider>(context,
                                          listen: false)
                                      .displayName)
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  visualDensity: const VisualDensity(
                                    horizontal: -4,
                                    vertical: -4,
                                  ),
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.bookmark_border_outlined,
                                    size: 25,
                                    color: IconColors.inactive,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            '${item.content}',
                            style: const TextStyle(
                              color: TextColors.high,
                              fontSize: 16.5,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '공감 8',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: TextColors.disabled,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '댓글 2',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: TextColors.disabled,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              const Text(
                                '01/12 19:55',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: TextColors.disabled,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                  visualDensity: const VisualDensity(
                                    horizontal: -4,
                                    vertical: -4,
                                  ),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.warning_amber_rounded,
                                    color: IconColors.inactive,
                                    size: 18,
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList());
                } else {
                  return const Center(
                    child: Text('No Data Available'),
                  );
                }
              },
            ),
          ),
          const SizedBox(
            height: 1,
          ),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: 50,
          ),
          const Spacer(),
          Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            color: TertiaryColors.basic,
            child: Row(
              children: [
                const SizedBox(
                  width: 7,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
                  height: 38,
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: commentController,
                    onChanged: (text) {},
                    maxLength: 300,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                      color: TextColors.high,
                    ),
                    cursorColor: TextColors.high,
                    cursorWidth: 1,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.send_outlined,
                    color: PrimaryColors.basic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
