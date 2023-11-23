import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

//로그인 후 sucure_storage에 정보 저장
Future<void> saveFirebaseAccountInfo() async {
  auth.User? user = auth.FirebaseAuth.instance.currentUser;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String ProviderId = user?.providerData[0].providerId ?? '';

  FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
    'providerId': ProviderId,
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

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Align(
        alignment: const Alignment(0, 0.8),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
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
                          offset: const Offset(0, 4), // 그림자의 위치 조정
                        ),
                      ]),
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: 50,
                ),
                onTap: () async {
                  try {
                    OAuthToken token = await UserApi.instance
                        .loginWithKakaoAccount(); // 카카오 로그인
                    var provider = auth.OAuthProvider('oidc.kakao'); // 제공업체 id
                    var credential = provider.credential(
                      idToken: token.idToken, // 카카오 로그인에서 발급된 idToken
                      accessToken:
                          token.accessToken, // 카카오 로그인에서 발급된 accessToken
                    );
                    await auth.FirebaseAuth.instance
                        .signInWithCredential(credential);
                    if (context.mounted) {
                      await saveFirebaseAccountInfo();
                      Navigator.pushReplacementNamed(
                          context, '/home'); // 로그인 성공시 홈으로 이동
                    }
                  } catch (error) {
                    print('카카오계정으로 로그인 실패 $error');
                  }
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(
                      Size(MediaQuery.of(context).size.width * 0.55, 50)),
                ),
                child: const Text(
                  'Apple로 로그인 하기',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
