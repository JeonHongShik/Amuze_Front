import 'package:amuze/community/community_post.dart';
import 'package:amuze/main.dart';
import 'package:amuze/resume/resume_post.dart';
import 'package:amuze/server_communication/get/my/mycommunity_get_server.dart';
import 'package:amuze/server_communication/get/my/myresume_get_server.dart';
import 'package:amuze/server_communication/get/my/mystage_get_server.dart';
import 'package:amuze/stage/stage_post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../gathercolors.dart';

class PostManagement extends StatefulWidget {
  const PostManagement({super.key});

  @override
  State<PostManagement> createState() => _PostManagementState();
}

class _PostManagementState extends State<PostManagement>
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
          '나의 게시물 관리',
          style: TextStyle(
            color: PrimaryColors.basic,
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
                Myresumes(),
                Mystages(),
                Mycommunities(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Mystages extends StatefulWidget {
  const Mystages({super.key});

  @override
  State<Mystages> createState() => _MystagesState();
}

class _MystagesState extends State<Mystages> {
  late Future<List<MyStageServerData>> serverData;
  late final uid;

  @override
  void initState() {
    super.initState();
    uid = Provider.of<UserInfoProvider>(context, listen: false).uid;
    serverData = mystagefetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<MyStageServerData>>(
              future: serverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerList();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                                serverData = mystagefetchData(uid);
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
                  return const Center(child: Text('작성한 공고 게시글이 없습니다.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Myresumes extends StatefulWidget {
  const Myresumes({super.key});

  @override
  State<Myresumes> createState() => _MyresumesState();
}

class _MyresumesState extends State<Myresumes> {
  late Future<List<MyResumeServerData>> serverData;
  late final uid;

  @override
  void initState() {
    super.initState();
    uid = Provider.of<UserInfoProvider>(context, listen: false).uid;
    serverData = myresumefetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<MyResumeServerData>>(
              future: serverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerList();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                                builder: (context) => ResumePost(id: data.id),
                              )).then((_) => setState(() {
                                serverData = myresumefetchData(uid);
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
                                                  'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/${data.mainimage!}/'),
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
                                        child: Text(
                                          data.title!,
                                          overflow: TextOverflow.ellipsis,
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
                  return const Center(child: Text('작성한 이력서가 없습니다.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Mycommunities extends StatefulWidget {
  const Mycommunities({super.key});

  @override
  State<Mycommunities> createState() => _MycommunitiesState();
}

class _MycommunitiesState extends State<Mycommunities> {
  late Future<List<MyCommunityServerData>> serverData;
  late final uid;

  @override
  void initState() {
    super.initState();
    uid = Provider.of<UserInfoProvider>(context, listen: false).uid;
    serverData = mycommunityfetchData(uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<MyCommunityServerData>>(
              future: serverData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const ShimmerList();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                                builder: (context) =>
                                    CommunityPost(id: data.id),
                              ) ////수정 필요///////////
                              ).then((_) => setState(
                                () {
                                  serverData = mycommunityfetchData(uid);
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
                  return const Center(child: Text('작성한 커뮤니티 글이 없습니다.'));
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
