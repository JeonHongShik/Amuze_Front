import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    var userInfoProvider = Provider.of<UserInfoProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        backgroundColor: Colors.white,
        title: const Text(
          '마이페이지',
          style: TextStyle(color: PrimaryColors.basic),
        ),
      ),
      body: Column(
        children: [
          Container(
            //프로필사진, 이름
            height: 120,
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.fromLTRB(10, 20, 0, 20),
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
            child: Row(
              children: [
                CircleAvatar(
                    radius: 30,
                    backgroundImage:
                        NetworkImage(userInfoProvider.photoURL ?? '')),
                const SizedBox(
                  width: 15,
                ),
                Text(
                  userInfoProvider.displayName ?? '',
                  style: const TextStyle(fontSize: 20, color: TextColors.high),
                )
              ],
            ),
          ),
          MypageElement(
              icon: Icons.article_rounded,
              text: '게시글 관리',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DummyPage(),
                    ));
              }),
          MypageElement(
              icon: Icons.mode_edit_sharp,
              text: '댓글 관리',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DummyPage(),
                    ));
              }),
          MypageElement(
              icon: Icons.bookmark,
              text: '저장한 게시글',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DummyPage(),
                    ));
              }),
          MypageElement(
              icon: Icons.notifications,
              text: '알림 설정',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DummyPage(),
                    ));
              }),
        ],
      ),
    );
  }
}

//마이페이지 요소////////////////////////////////////////////////////////////////
class MypageElement extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  const MypageElement(
      {required this.icon, required this.text, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
        child: Row(children: [
          Icon(
            icon,
            size: 30,
            color: SecondaryColors.basic,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 15),
          ),
        ]),
      ),
    );
  }
}
////////////////////////////////////////////////////////////////////////////////