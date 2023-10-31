import 'package:amuze/homepage.dart';
import 'package:amuze/loadingscreen.dart';
import 'package:amuze/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  KakaoSdk.init(
    nativeAppKey: 'eabfebdd6a97136a8764ecfc05c8b8fe',
    javaScriptAppKey: '1405eb959f73904bf61cb1f7163e37d4',
  );

  //KakaoSDK로 키 해시 값 받을 때 사용
  //print(await KakaoSdk.origin);

  runApp(
    // 멀티프로바이더를 모든 곳에서 사용하기 위해서는 MateriaApp의 상위에 있어야함.
    MaterialApp(
      home: FutureBuilder(
        future: _checkTokenValidity(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //토큰이 있으면 홈페이지
            if (snapshot.data == true) {
              return const HomePage();
            }
            //토큰이 만료 됐거나 없으면 로그인페이지
            else {
              return const LoginPage();
            }
          }
          //아직 토큰 유효성 여부를 확인하고 있으면 로딩페이지
          else {
            return const LoadingScreen();
          }
        },
      ),
    ),
  );
}

//코드가 유효한지, 코드가 만료 됐거나 없는지 판단하는 함수
Future<bool> _checkTokenValidity() async {
  if (await AuthApi.instance.hasToken()) {
    try {
      await UserApi.instance.me();
      return true;
    } catch (e) {
      return false;
    }
  }
  return false;
}
