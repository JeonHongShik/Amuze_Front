import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

//처음 로그인 하는 경우 서버에 유저 정보를 보내는 함수
Future<void> postAccountInfo(
    String? kakaoid, String? name, String? profile) async {
  // SecureStorage는 안전한 로컬 저장소
  FlutterSecureStorage storage = const FlutterSecureStorage();
  bool isFirstLogin = await storage.read(key: 'isFirstLogin') == null;

  if (isFirstLogin) {
    final response = await http.post(
      Uri.parse(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/accounts/signup/'),
      body: {
        'kakaoid': kakaoid,
        'name': name,
        'profile': profile,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('post 성공');
      await storage.write(key: 'isFirstLogin', value: 'false');

      //
      await storage.write(key: 'kakaoid', value: kakaoid);
      await storage.write(key: 'name', value: name);
      await storage.write(key: 'profile', value: profile);
    } else {
      throw Exception('서버 응답 오류 : ${response.statusCode}');
    }
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  void getUserInfo() async {
    try {
      User user = await UserApi.instance.me();

      print('사용자 정보 요청 성공1'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');

      await postAccountInfo(
          user.id.toString(),
          user.kakaoAccount?.profile?.nickname,
          user.kakaoAccount?.profile?.profileImageUrl);
    } catch (error) {
      print('사용자 정보 요청 실패1 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ElevatedButton(
          child: const Text('카카오 로그인'),
          onPressed: () async {
            if (await isKakaoTalkInstalled()) {
              try {
                await UserApi.instance.loginWithKakaoTalk();
                print('카카오톡으로 로그인 성공2');
                getUserInfo();
              } catch (error) {
                print('카카오 로그인 실패2 $error');
              }

              try {
                await UserApi.instance.loginWithKakaoAccount();
                print('카카오계정으로 로그인 성공3');
                getUserInfo();
              } catch (error) {
                print('카카오 계정으로 로그인 실패3 $error');
              }
            } else {
              try {
                await UserApi.instance.loginWithKakaoAccount();
                print('카카오계정으로 로그인 성공4');
                getUserInfo();
              } catch (error) {
                print('카카오계정으로 로그인 실패4');
              }
            }
          },
        ),
      ),
    );
  }
}
