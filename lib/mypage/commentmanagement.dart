import 'package:amuze/community/community_post.dart';
import 'package:amuze/main.dart';
import 'package:amuze/server_communication/get/mycomment_get_server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gathercolors.dart';

class CommentManagement extends StatefulWidget {
  const CommentManagement({super.key});

  @override
  State<CommentManagement> createState() => _CommentManagementState();
}

class _CommentManagementState extends State<CommentManagement> {
  late Future<List<MyCommentServerData>> serverData;
  late final uid;

  @override
  void initState() {
    super.initState();
    uid = Provider.of<UserInfoProvider>(context, listen: false).uid;
    serverData = mycommentfetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: const IconThemeData(color: PrimaryColors.basic),
          backgroundColor: Colors.white,
          title: const Text(
            '내 댓글 관리',
            style: TextStyle(
              color: PrimaryColors.basic,
              fontSize: 20,
            ),
          ),
        ),
        body: FutureBuilder<List<MyCommentServerData>>(
          future: serverData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Text('내 댓글 불러오는 중...'),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('내 댓글을 불러오지 못 했습니다.'),
                    const Text('다시 시도'),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh,
                        color: PrimaryColors.basic,
                      ),
                      onPressed: () {
                        setState(() {
                          serverData = mycommentfetchData(uid);
                        });
                      },
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var comment = snapshot.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommunityPost(
                                id: comment.board,
                              ),
                            )).then((_) {
                          setState(() {
                            serverData = mycommentfetchData(uid);
                          });
                        });
                      },
                      child: Column(
                        children: [
                          ListTile(
                            title: Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: Text(
                                comment.title!,
                                style: const TextStyle(
                                    fontSize: 12, color: TextColors.medium),
                              ),
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.subdirectory_arrow_right,
                                  size: 15,
                                  color: IconColors.inactive,
                                ),
                                Expanded(
                                  child: Text(
                                    comment.content!,
                                    style: const TextStyle(fontSize: 16),
                                    maxLines: null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.withOpacity(0.3),
                            height: 1,
                          )
                        ],
                      ),
                    );
                  });
            } else {
              return const Center(
                  child: Text(
                '작성한 댓글이 없습니다.',
                style: TextStyle(color: TextColors.disabled),
              ));
            }
          },
        ));
  }
}
