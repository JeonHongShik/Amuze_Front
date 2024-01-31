import 'package:amuze/community/communitywrite/communitywrite.dart';
import 'package:amuze/main.dart';
import 'package:amuze/server_communication/get/comment_get_server.dart';
import 'package:amuze/server_communication/get/detail/community_detail_get_server.dart';
import 'package:amuze/server_communication/post/comment_post_server.dart';

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
  late TextEditingController commentController = TextEditingController();

  late Future<List<CommunityDetailServerData>> serverData;
  late Future<List<CommentServerData>> commentserverData;

  bool bookmarked = false;
  int bookmarkId = 0;
  bool ready = true;

  bool liked = false;
  int likeId = 0;
  bool likeready = true;
  int likecount = 0;

  int commenttotal = 0;

  Future<void> _showPostDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: const Text(
            '정말 게시물을 삭제하시겠습니까?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: TextColors.high,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: const Text(
              '게시물 삭제 시, 게시물을 복구할 수 없습니다.',
              textAlign: TextAlign.center,
            ),
          ),
          contentTextStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: TextColors.high,
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final bool success = await _deletePost();

                    if (success) {
                      Navigator.of(context).pop();
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
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: backColors.disabled,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '삭제하기',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: TextColors.high,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: PrimaryColors.basic,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
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

  Future<void> sendComment() async {
    String commentText = commentController.text;

    FormData formData = createCommentFormData(
      uid: Provider.of<UserInfoProvider>(context, listen: false).uid,
      content: commentText,
      board: widget.id,
    );

    try {
      final response = await dio.post(
        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/comment/create/',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          commentserverData = commentfetchData(widget.id!);
          commentController.clear();
        });
      } else {
        print('오류: ${response.statusCode}');
        print('응답 본문: ${response.data}');
      }
    } catch (e) {
      print('Error : $e');
      if (e is DioError) {
        // DioError의 경우, 서버 응답을 포함할 수 있습니다.
        print('서버 응답: ${e.response?.data}');
      }
    }
  }

  Future<void> _showCommentDeleteDialog(BuildContext context, int id) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))),
          title: Container(
            width: MediaQuery.of(context).size.width * 0.75,
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: const Text(
              '댓글을 삭제하시겠습니까?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: TextColors.high,
              ),
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    final bool success = await _deleteComment(id);

                    if (success) {
                      Navigator.of(context).pop();
                      setState(() {
                        commentserverData = commentfetchData(widget.id!);
                      });
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
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: backColors.disabled,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '삭제하기',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: TextColors.high,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.33,
                    height: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: PrimaryColors.basic,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Text(
                      '취소',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<bool> _deleteComment(int id) async {
    try {
      final response = await dio.delete(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/comment/delete/${id.toString()}/',
          data: {
            'uid': Provider.of<UserInfoProvider>(context, listen: false).uid,
            'board': widget.id
          });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<void> _checkBookmarked() async {
    try {
      final provider = Provider.of<UserInfoProvider>(context, listen: false);
      final response = await dio.get(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/bookmarks/bookmark/board/check/${provider.uid}/${widget.id.toString()}/');

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          bookmarked = response.data['bookmark'];
          if (bookmarked) {
            bookmarkId = response.data['id'];
          }
        });
        print('/////////////////////////////$bookmarked');
        print('/////////////////////////////$bookmarkId');
      }
    } catch (e) {
      print('CheckError : $e');
    }
  }

  Future<void> _checkLiked() async {
    try {
      final provider = Provider.of<UserInfoProvider>(context, listen: false);
      final response = await dio.get(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/check_like/${provider.uid}/${widget.id.toString()}/');

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          liked = response.data['check_like'];
        });
        print('/////////////$liked');
      }
    } catch (e) {
      print('ChecklkikesError : $e');
    }
  }

  void _toggleBookmarked() async {
    final provider = Provider.of<UserInfoProvider>(context, listen: false);
    if (bookmarked == false) {
      try {
        final response = await dio.post(
            'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/bookmarks/bookmark/board/',
            data: {'author': provider.uid, 'board': widget.id});
        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            bookmarked = true;
            bookmarkId = response.data['id'];
            ready = true;
          });
          print('//////////////////////$bookmarkId');
        }
      } catch (e) {
        print('postError : $e');
      }
    } else if (bookmarked == true) {
      try {
        final response = await dio.delete(
            'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/bookmarks/bookmark/board/delete/$bookmarkId/',
            data: {'uid': provider.uid});
        if (response.statusCode == 200 || response.statusCode == 201) {
          setState(() {
            bookmarked = !bookmarked;
            ready = true;
          });
        }
      } catch (e) {
        print('deletError : $e');
      }
    }
  }

  void _toggleliked() async {
    final provider = Provider.of<UserInfoProvider>(context, listen: false);

    try {
      final response = await dio.post(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/like_add_count/${widget.id}/',
          data: {'uid': provider.uid});
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          liked = !liked;
          likeready = !likeready;
          likecount += liked ? 1 : -1;
        });
      }
    } catch (e) {
      print('likepostError : $e');
    }
  }

  @override
  void initState() {
    super.initState();
    serverData = communitydetailfetchData(widget.id!);
    serverData.then((data) {
      if (data.isNotEmpty) {
        setState(() {
          likecount = data.first.likescount ?? 0;
        });
      }
    });
    commentserverData = commentfetchData(widget.id!);
    _checkBookmarked();
    _checkLiked();
  }

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
      body: SingleChildScrollView(
        child: Column(
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
                      child: Text('커뮤니티 글 불러오는 중...'),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                        children: snapshot.data!.map((item) {
                      return Container(
                        padding: const EdgeInsets.fromLTRB(19, 0, 12, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  // width:
                                  //     MediaQuery.of(context).size.width * 0.7,
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
                                        .uid)
                                  Row(
                                    children: [
                                      IconButton(
                                          onPressed: () async {
                                            final communityprovider = Provider
                                                .of<CommunityWriteProvider>(
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
                                          await _showPostDeleteDialog(context);
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
                                        .uid)
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    visualDensity: const VisualDensity(
                                      horizontal: -4,
                                      vertical: -4,
                                    ),
                                    onPressed: () {
                                      if (ready == true) {
                                        setState(() {
                                          ready = false;
                                        });
                                        _toggleBookmarked();
                                      }
                                    },
                                    icon: Icon(
                                      bookmarked
                                          ? Icons.bookmark
                                          : Icons.bookmark_border,
                                      color: SecondaryColors.basic,
                                      size: 30,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Text(
                              '${item.content}',
                              style: const TextStyle(
                                color: TextColors.high,
                                fontSize: 16.5,
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _toggleliked();
                                  },
                                  child: Icon(
                                    liked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                                Text(
                                  ' $likecount',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: TextColors.disabled,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Spacer(),
                                Text(
                                  item.createdat!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: TextColors.disabled,
                                  ),
                                ),
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
              width: MediaQuery.of(context).size.width,
              height: 45,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  top: BorderSide(color: Colors.grey.withOpacity(0.3)),
                ),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 15),
                    child: Text(
                      '댓글 $commenttotal',
                      style: const TextStyle(
                          color: PrimaryColors.basic, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 65,
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: TextFormField(
                    controller: commentController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0), // 테두리 둥글게
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // 활성 상태가 아닐 때 테두리
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8.0), // 포커스 상태일 때 테두리
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                        ),
                        hintText: '댓글 달기'),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      sendComment();
                    },
                    icon: const Icon(Icons.send))
              ],
            ),
            FutureBuilder<List<CommentServerData>>(
              future: commentserverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('댓글 불러오는 중...'));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      commenttotal = snapshot.data!.length;
                    });
                  });
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var comment = snapshot.data![index];
                      final userprovider =
                          Provider.of<UserInfoProvider>(context, listen: false);
                      return Column(
                        children: [
                          ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '익명',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    if (userprovider.uid == comment.uid) ...[
                                      GestureDetector(
                                        onTap: () async {
                                          await _showCommentDeleteDialog(
                                              context, comment.id!);
                                        },
                                        child: Container(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: const Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: IconColors.inactive,
                                          ),
                                        ),
                                      )
                                    ]
                                  ],
                                ),
                                const SizedBox(
                                    height: 8), // 여기에서 원하는 간격을 조절합니다.
                              ],
                            ),
                            subtitle: Text(comment.content!),
                          ),
                          Container(
                            color: Colors.grey.withOpacity(0.3),
                            height: 1,
                          )
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No comments yet.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
