import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/mypage/commentmanagement.dart';
import 'package:amuze/mypage/editprofile.dart';
import 'package:amuze/mypage/postmanagement.dart';
import 'package:amuze/mypage/savedpost.dart';
import 'package:amuze/pagelayout/dummypage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

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
          style: TextStyle(
            color: PrimaryColors.basic,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            //프로필사진, 이름
            height: 120,
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.fromLTRB(15, 20, 0, 20),
            decoration: const BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: Colors.grey, width: 0.5))),
            child: Row(
              children: [
                Row(
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
                      style:
                          const TextStyle(fontSize: 20, color: TextColors.high),
                    ),
                  ],
                ),
                const Spacer(),
                // 프로필 수정 버튼
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const EditProfile(), // 프로필 수정 페이지로 이동
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(10, 30),
                      backgroundColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      side: const BorderSide(
                        width: 2,
                        color: Color.fromARGB(
                            255, 218, 218, 218), // 임시-figma컬러 (수정필요)
                      ),
                      elevation: 0.0,
                    ),
                    child: const Text(
                      '프로필 수정',
                      style: TextStyle(
                        color: TextColors.high,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          MypageElement(
              icon: Icons.article_rounded,
              text: '나의 게시물 관리',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostManagement(),
                    ));
              }),
          MypageElement(
              icon: Icons.mode_edit_sharp,
              text: '댓글 관리',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CommentManagement(),
                    ));
              }),
          MypageElement(
              icon: Icons.bookmark,
              text: '저장한 게시물',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedPost(),
                    ));
              }),
          MypageElement(
              icon: Icons.notifications,
              text: '알림 설정',
              onTap: () async {
                // 알림 설정 페이지로 가는 코드 현재 오류
                /* PackageInfo packageInfo = await PackageInfo.fromPlatform();
                String packageName = packageInfo.packageName;
                var intent = AndroidIntent(
                    action: 'android.settings.APPLICATION_SETTINGS',
                    data: 'package:$packageName');
                await intent.launch(); */
              }),
          MypageElement(
              icon: Icons.headset_mic, text: '문의 (카카오톡 채널상담)', onTap: () {}),
          const Spacer(),
          // 로그아웃 버튼
          GestureDetector(
            onTap: () async {
              await signOut();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            },
            child: Container(
              padding: const EdgeInsets.all(25),
              alignment: Alignment.bottomLeft,
              child: const Row(
                children: [
                  Icon(
                    Icons.logout_outlined,
                    color: IconColors.disabled,
                    size: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '로그아웃',
                    style: TextStyle(
                      fontSize: 15,
                      color: IconColors.disabled,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
        padding: const EdgeInsets.fromLTRB(18, 10, 10, 10),
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