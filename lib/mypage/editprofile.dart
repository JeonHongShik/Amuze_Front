import 'dart:math';

import 'package:amuze/main.dart';
import 'package:amuze/pagelayout/mypage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../gathercolors.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

var userInfoProvider = Provider.of<UserInfoProvider>;

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    var userInfoProvider = Provider.of<UserInfoProvider>(context);
    final TextEditingController nameController = TextEditingController(
        text: "${userInfoProvider.displayName}"); // 이름 컨트롤러 - 초기값 : 기존 카카오톡 닉네임

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: PrimaryColors.basic),
        backgroundColor: Colors.white,
        title: const Text(
          '프로필 수정',
          style: TextStyle(
            color: TextColors.high,
            fontSize: 20,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(userInfoProvider.photoURL ?? ''),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                elevation: 0.0,
                side: const BorderSide(
                  color:
                      Color.fromARGB(255, 218, 218, 218), // 임시-figma컬러 (수정필요)
                ),
              ),
              child: const Icon(
                Icons.camera_alt,
                color: Color(0xFFCBD9F5), // 임시컬러 (figma색, 수정필요)
                size: 22,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: Text(
                      '  이름',
                      style: TextStyle(
                        fontSize: 17,
                        color: TextColors.high,
                      ),
                    ),
                  ),
                  TextField(
                    controller: nameController, // 이름 컨트롤러
                    maxLength: 20,
                    style: const TextStyle(
                      height: 1,
                      fontSize: 17,
                      color: TextColors.high,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.only(left: 15),
                      filled: true,
                      fillColor: const Color(0xFFF4F4F4),
                      focusColor: const Color(0xFFF4F4F4),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('정말 탈퇴하시겠습니까?'),
                        actions: [
                          TextButton(
                            child: const Text('탈퇴하기'),
                            onPressed: () {},
                          ),
                          TextButton(
                            child: const Text('취소'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text(
                    '회원 탈퇴',
                    style: TextStyle(
                      fontSize: 16,
                      color: TextColors.disabled,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: ValueListenableBuilder(
            valueListenable: nameController,
            builder: ((context, value, child) {
              final bool hasNameText = nameController.text.isNotEmpty;

              return ElevatedButton(
                  onPressed: hasNameText
                      ? () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MyPage()));
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: hasNameText
                          ? PrimaryColors.basic
                          : PrimaryColors.disabled,
                      foregroundColor:
                          hasNameText ? Colors.white : TextColors.disabled,
                      minimumSize: Size(MediaQuery.of(context).size.width, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text(
                    '수정 완료',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ));
            })),
      ),
    );
  }
}
