import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';

void main() {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized;

  KakaoSdk.init(
    nativeAppKey: 'eabfebdd6a97136a8764ecfc05c8b8fe',
    javaScriptAppKey: '1405eb959f73904bf61cb1f7163e37d4',
  );

  runApp(
    //store를 한 개만 사용할 때는 ChangeNotifierProvider를 써야함. 두 개 이상은 노션에 정리해놨음
    ChangeNotifierProvider(
      //create는 ChangeNotifierProvider의 필수 요소
      create: (c) => Store1(),
      child: const MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

//state 보관소. class로 만든 후 ChangeNotifierProvider - create에 등록해줘야 함.
class Store1 extends ChangeNotifier {
  var name = '카카오 로그인 구현 중';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void get_user_info() async {
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공1'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');
    } catch (error) {
      print('사용자 정보 요청 실패1 $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<Store1>().name),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: ElevatedButton(
            child: Text('카카오 로그인'),
            onPressed: () async {
              if (await isKakaoTalkInstalled()) {
                try {
                  await UserApi.instance.loginWithKakaoTalk();
                  print('카카오톡으로 로그인 성공2');
                  get_user_info();
                } catch (error) {
                  print('카카오톡으로 로그인 실패2 $error');

                  try {
                    await UserApi.instance.loginWithKakaoAccount();
                    print('카카오계정으로 로그인 성공3');
                    get_user_info();
                  } catch (error) {
                    print('카카오계정으로 로그인 실패3 $error');
                  }
                }
              } else {
                try {
                  await UserApi.instance.loginWithKakaoAccount();
                  print('카카오계정으로 로그인 성공4');
                  get_user_info();
                } catch (error) {
                  print('카카오 계정으로 로그인 실패4 $error');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
