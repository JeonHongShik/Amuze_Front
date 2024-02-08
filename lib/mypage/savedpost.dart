import 'package:amuze/community/community_post.dart';
import 'package:amuze/main.dart';
import 'package:amuze/resume/resume_post.dart';
import 'package:amuze/server_communication/get/saved/saved_community_get_server.dart';
import 'package:amuze/server_communication/get/saved/saved_resume_get_server.dart';
import 'package:amuze/server_communication/get/saved/saved_stage_get_server.dart';
import 'package:amuze/stage/stage_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../gathercolors.dart';

class SavedPost extends StatefulWidget {
  const SavedPost({super.key});

  @override
  State<SavedPost> createState() => _SavedPostState();
}

class _SavedPostState extends State<SavedPost>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(
    length: 3,
    vsync: this,
    initialIndex: 0,
  );

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        backgroundColor: Colors.white,
        title: const Text(
          '저장한 게시물',
          style: TextStyle(
            color: TextColors.high,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor:
          const Color.fromARGB(255, 231, 231, 231), // 임시 (수정 필요) - body 배경색
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            labelColor: TextColors.high,
            labelStyle: const TextStyle(
              fontSize: 15,
            ),
            indicator: const BoxDecoration(
              color: Colors.white,
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(
                text: '이력서',
              ),
              Tab(
                text: '공고',
              ),
              Tab(
                text: '커뮤니티',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: const [
                MySavedResumes(),
                MySavedstages(),
                MySavedcommuities(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MySavedResumes extends StatefulWidget {
  const MySavedResumes({super.key});

  @override
  State<MySavedResumes> createState() => _MySavedResumesState();
}

class _MySavedResumesState extends State<MySavedResumes> {
  late Future<List<SavedResumeServerData>> serverData;
  late final uid;

  @override
  void initState() {
    super.initState();
    uid = Provider.of<UserInfoProvider>(context, listen: false).uid;
    serverData = savedresumefetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<SavedResumeServerData>>(
              future: serverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('내 이력서 불러오는 중...'));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length, // 데이터의 전체 길이를 사용합니다.
                    itemBuilder: (context, index) {
                      var reverseIndex = snapshot.data!.length - 1 - index;
                      var data = snapshot.data![reverseIndex];
                      return GestureDetector(
                        onTap: () {
                          print(data.id);
                          print(data.author);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ResumePost(id: data.id),
                              )).then((_) => setState(() {
                                serverData = savedresumefetchData(uid);
                              }));
                        },
                        child: Container(
                          height: 120,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              top: BorderSide(color: backColors.disabled),
                            ),
                          ),
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
                                                  'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${data.mainimage!}'),
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
                                                      : const SizedBox.shrink(),
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
                                                      : const SizedBox.shrink(),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 13),
                                              height: 22.5,
                                              child: (data.education != null &&
                                                      data.education!
                                                          .isNotEmpty)
                                                  ? Text(
                                                      data.education![0],
                                                      style: const TextStyle(
                                                        fontSize: 13,
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
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('저장한 이력서가 없습니다.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MySavedstages extends StatefulWidget {
  const MySavedstages({super.key});

  @override
  State<MySavedstages> createState() => _MySavedstagesState();
}

class _MySavedstagesState extends State<MySavedstages> {
  late Future<List<SavedStageServerData>> serverData;
  late final uid;

  @override
  void initState() {
    super.initState();
    uid = Provider.of<UserInfoProvider>(context, listen: false).uid;
    serverData = savedstagefetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<SavedStageServerData>>(
              future: serverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('내 공고 불러오는 중...'));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length, // 데이터의 전체 길이를 사용합니다.
                    itemBuilder: (context, index) {
                      var reverseIndex = snapshot.data!.length - 1 - index;
                      var data = snapshot.data![reverseIndex];
                      return GestureDetector(
                        onTap: () {
                          print(data.id);
                          print(data.author);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StagePost(id: data.id),
                              )).then((_) => setState(() {
                                serverData = savedstagefetchData(uid);
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
                                                'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${data.mainimage!}',
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
                  return const Center(child: Text('저장한 공고 게시글이 없습니다.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MySavedcommuities extends StatefulWidget {
  const MySavedcommuities({super.key});

  @override
  State<MySavedcommuities> createState() => _MySavedcommuitiesState();
}

class _MySavedcommuitiesState extends State<MySavedcommuities> {
  late Future<List<SavedCommunityServerData>> serverData;
  late final uid;

  @override
  void initState() {
    super.initState();
    uid = Provider.of<UserInfoProvider>(context, listen: false).uid;
    serverData = savedcommunityfetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<SavedCommunityServerData>>(
              future: serverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Text('내 커뮤니티 불러오는 중...'));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      var reverseIndex = snapshot.data!.length - 1 - index;
                      var data = snapshot.data![reverseIndex];
                      return GestureDetector(
                        onTap: () {
                          print(data.id);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CommunityPost(id: data.id),
                              ) ////수정 필요///////////
                              ).then((_) => setState(
                                () {
                                  serverData = savedcommunityfetchData(uid);
                                },
                              ));
                        },
                        child: Container(
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
                  return const Center(child: Text('저장한 커뮤니티 글이 없습니다.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
