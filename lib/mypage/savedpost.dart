import 'package:flutter/material.dart';

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
                Text('이력서'),
                Text('공고'),
                Text('커뮤니티'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
