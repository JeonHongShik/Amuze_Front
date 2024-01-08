import 'dart:io';

import 'package:amuze/main.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';

import '../gathercolors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

var userInfoProvider = Provider.of<UserInfoProvider>;

class _EditProfileState extends State<EditProfile> {
  File? fileSelectedImage;

  // 이미지 선택 및 변환 메서드
  Future<void> selectAndConvertImage() async {
    await requestPermissionIfNeeded();
    List<Asset> resultList = await MultiImagePicker.pickImages(
      cupertinoOptions: const CupertinoOptions(
        doneButton: UIBarButtonItem(title: 'Confirm'),
        cancelButton: UIBarButtonItem(title: 'Cancel'),
        albumButtonColor: PrimaryColors.basic,
      ),
      materialOptions: const MaterialOptions(
        maxImages: 4,
        enableCamera: true,
        actionBarTitle: "사진첩",
        allViewTitle: "All Photos",
        useDetailsView: true,
      ),
    );

    if (resultList.isNotEmpty) {
      File convertedFile = await _assetToFile(resultList.first);
      setState(() {
        fileSelectedImage = convertedFile;
      });
    }
  }

  // Asset을 File로 변환하는 메서드
  Future<File> _assetToFile(Asset asset) async {
    final byteData = await asset.getByteData();
    final tempFile =
        File("${(await getTemporaryDirectory()).path}/${asset.name}");
    final file = await tempFile.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    return file;
  }

  //카메라, 사진첩 권한 체크//////////////////////////////////
  Future<void> requestPermissionIfNeeded() async {
    var cameraStatus = await Permission.camera.status;
    var storageStatus = await Permission.storage.status;

    if (!cameraStatus.isGranted) {
      await Permission.camera.request();
    }

    if (!storageStatus.isGranted) {
      await Permission.storage.request();
    }
  }
///////////////////////////////////////////////////////////

  // Firestore 이름 업데이트
  Future<void> updateUserNameInFirestore(String newName) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'displayName': newName,
      });
    }
  }

  Future<void> updateUserNameInAuth(String newName) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(newName);
      await user.reload(); // 사용자 정보를 최신 상태로 새로고침
    }
  }

  Future<void> peristalsis() async {
    var dio = Dio();
    try {
      String url =
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/accounts/SignUp/';
      Response response = await dio.get(url);
      print("Response data: ${response.data}");
      print("Response status: ${response.statusCode}");
    } catch (e) {
      print("Error making GET request: $e");
    }
  }

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
              backgroundImage: fileSelectedImage != null
                  ? FileImage(fileSelectedImage!) as ImageProvider
                  : NetworkImage(userInfoProvider.photoURL ?? ''),
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
                child: IconButton(
                    onPressed: () async {
                      await selectAndConvertImage();
                    },
                    icon: const Icon(
                      Icons.camera_alt,
                      size: 22,
                      color: PrimaryColors.basic,
                    ))),
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
                      ? () async {
                          var userInfoProvider = Provider.of<UserInfoProvider>(
                              context,
                              listen: false);
                          await updateUserNameInAuth(nameController.text);
                          await updateUserNameInFirestore(nameController.text);
                          await userInfoProvider
                              .updateUserName(nameController.text);
                          await peristalsis();
                          Navigator.of(context).pop();
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
