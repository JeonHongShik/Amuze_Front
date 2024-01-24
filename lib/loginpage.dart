import 'package:amuze/gathercolors.dart';
import 'package:amuze/loadingscreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:dio/dio.dart';

// 로그인 후 secure_storage에 정보 저장
Future<void> saveFirebaseAccountInfo() async {
  auth.User? user = auth.FirebaseAuth.instance.currentUser;

  String providerId = user?.providerData[0].providerId ?? '';

  await FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
    'providerId': providerId,
    'uid': user?.uid,
    'email': user?.email,
    'displayName': user?.displayName,
    'photoURL': user?.photoURL,
  });

  // SecureStorage는 안전한 로컬 저장소
  FlutterSecureStorage storage = const FlutterSecureStorage();
  await storage.write(key: 'uid', value: user?.uid);
  await storage.write(key: 'email', value: user?.email);
  await storage.write(key: 'displayName', value: user?.displayName);
  await storage.write(key: 'photoURL', value: user?.photoURL);
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

  Future<void> navigateToHome(BuildContext context) async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      var provider = auth.OAuthProvider('oidc.kakao');
      var credential = provider.credential(
        idToken: token.idToken,
        accessToken: token.accessToken,
      );

      if (context.mounted) {
        showGeneralDialog(
          context: context,
          barrierDismissible: false,
          barrierColor: Colors.transparent, // 투명한 배경색
          pageBuilder: (context, animation1, animation2) {
            return const LoadingScreen();
          },
        );
      }
      await auth.FirebaseAuth.instance.signInWithCredential(credential);
      await saveFirebaseAccountInfo();
      await peristalsis();

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
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
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 7,
                                offset: const Offset(0, 4),
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
