import 'package:amuze/gathercolors.dart';
import 'package:amuze/homepage.dart';
import 'package:amuze/loadingscreen.dart';
import 'package:amuze/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

// 로그인 후 secure_storage에 정보 저장
Future<void> saveFirebaseAccountInfo() async {
  auth.User? user = auth.FirebaseAuth.instance.currentUser;

  String providerId = user?.providerData[0].providerId ?? '';

  final token = await FirebaseMessaging.instance.getToken(); //fcm 알림토큰

  await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
    'providerId': providerId,
    'uid': user?.uid,
    'email': user?.email,
    'displayName': user?.displayName,
    'photoURL': user?.photoURL,
    'messagingToken': token,
  });

  // SecureStorage는 안전한 로컬 저장소
  FlutterSecureStorage storage = const FlutterSecureStorage();
  await storage.write(key: 'uid', value: user?.uid);
  await storage.write(key: 'email', value: user?.email);
  await storage.write(key: 'displayName', value: user?.displayName);
  await storage.write(key: 'photoURL', value: user?.photoURL);
  await storage.write(key: 'messagingToken', value: token);
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool ready = true;

  //알람 권한 설정
  Future<void> requestPermissionIfNeeded() async {
    if (await Permission.notification.isRestricted ||
        await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> navigateToHome(BuildContext context) async {
    try {
      OAuthToken token;

      if (await isKakaoTalkInstalled()) {
        try {
          token = await UserApi.instance.loginWithKakaoTalk();
        } catch (error) {
          token = await UserApi.instance.loginWithKakaoAccount();
        }
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      var provider = auth.OAuthProvider('oidc.kakao');
      var credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );

      if (context.mounted) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent,
          pageBuilder: (context, animation1, animation2) {
            return const LoadingScreen();
          },
        );
      }
      await auth.FirebaseAuth.instance.signInWithCredential(credential);
      await saveFirebaseAccountInfo();
      await Provider.of<UserInfoProvider>(context, listen: false)
          .loadUserInfo();
      await peristalsis();

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false,
        );
      }
      await requestPermissionIfNeeded();
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
      if (context.mounted) {
        setState(() {
          ready = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TertiaryColors.basic,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
              child: Center(
            child: Image.asset('assets/images/amuze이름로고.png'),
          )),
          Align(
            alignment: const Alignment(0, 0.8),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: GestureDetector(
                      onTap: ready
                          ? () async {
                              setState(() {
                                ready = false;
                              });
                              await navigateToHome(context);
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage(
                                  'assets/images/kakao_login_large_narrow.png'),
                              fit: BoxFit.fill,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 1),
                              ),
                            ]),
                        width: MediaQuery.of(context).size.width * 0.55,
                        height: 50,
                      ),
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
