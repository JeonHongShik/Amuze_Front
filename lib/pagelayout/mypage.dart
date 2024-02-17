import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:amuze/gathercolors.dart';
import 'package:amuze/main.dart';
import 'package:amuze/mypage/commentmanagement.dart';
import 'package:amuze/mypage/editprofile.dart';
import 'package:amuze/mypage/postmanagement.dart';
import 'package:amuze/mypage/savedpost.dart';
import 'package:amuze/pagelayout/dummypage.dart';

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
              text: '내 게시물 관리',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostManagement(),
                    ));
              }),
          MypageElement(
              icon: Icons.mode_edit_sharp,
              text: '내 댓글 관리',
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
          // MypageElement(
          //     icon: Icons.notifications,
          //     text: '알림 설정',
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => const DummyPage(),
          //         ),
          //       );
          //     }),
          MypageElement(
              icon: Icons.headset_mic,
              text: '문의 (카카오톡 채널상담)',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    title: const Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 2),
                      child: Text(
                        '카카오톡 채널 문의',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15.5,
                          fontWeight: FontWeight.bold,
                          color: TextColors.high,
                        ),
                      ),
                    ),
                    content: SizedBox(
                      width: 280,
                      child: GestureDetector(
                        onTap: () {},
                        child: const Text(
                          '확인을 누르면 카카오톡 채널로 이동합니다!',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    contentTextStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: TextColors.high,
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 125,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: backColors.disabled,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '취소',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: TextColors.high,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () async {
                              final url =
                                  Uri.parse('http://pf.kakao.com/_GDnSG/chat');
                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              } else {
                                print('Could not launch $url');
                              }
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              width: 125,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: PrimaryColors.basic,
                                  borderRadius: BorderRadius.circular(8)),
                              child: const Text(
                                '확인',
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
                  ),
                );
              }),
          const Spacer(),
          // 로그아웃 버튼
          GestureDetector(
            onTap: () async {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  title: Container(
                    width: 280,
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                    child: const Text(
                      '정말 로그아웃 하시겠습니까?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: TextColors.high,
                      ),
                    ),
                  ),
                  actions: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await signOut();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (Route<dynamic> route) => false);
                          },
                          child: Container(
                            width: 125,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: backColors.disabled,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              '로그아웃하기',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: TextColors.high,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 125,
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
                ),
              );
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