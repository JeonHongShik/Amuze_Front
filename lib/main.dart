import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //create는 ChangeNotifierProvider의 필수 요소
          create: (c) => Store1(),
        ),
        ChangeNotifierProvider(
          create: (c) => AccountInfo(),
        )
      ],
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

class AccountInfo with ChangeNotifier {
  String? kakaoid;
  String? name;
  String? profile;

  Future<void> postAccountInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

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
        prefs.setBool('isFirstLogin', false);
      } else {
        throw Exception('서버 응답 오류 : ${response.statusCode}');
      }
    }

    // void setUser(String kakaoid, String name, String profile) {
    //   kakaoid = kakaoid;
    //   name = name;
    //   profile = profile;
    //   notifyListeners();
    // }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void get_user_info() async {
    try {
      //final String token = await getKakaoToken();
      User user = await UserApi.instance.me();

      print('사용자 정보 요청 성공1'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}');

      final accountInfo = AccountInfo();
      accountInfo.kakaoid = user.id.toString();
      accountInfo.name = user.kakaoAccount?.profile?.nickname;
      accountInfo.profile = user.kakaoAccount?.profile?.profileImageUrl;

      await accountInfo.postAccountInfo();
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
            child: const Text('카카오 로그인'),
            onPressed: () async {
              if (await AuthApi.instance.hasToken()) {
                try {
                  AccessTokenInfo tokenInfo =
                      await UserApi.instance.accessTokenInfo();
                  print(
                      '토큰 유효성 체크 성공 ${tokenInfo.id} / ${tokenInfo.expiresIn}');
                } catch (error) {
                  if (error is KakaoApiException &&
                      error.isInvalidTokenError()) {
                    print('토큰 만료 $error');
                  } else {
                    print('토큰 정보 조회 실패 $error');
                  }

                  if (await isKakaoTalkInstalled()) {
                    try {
                      await UserApi.instance.loginWithKakaoTalk();
                      print('카카오톡으로 로그인 성공2');
                      get_user_info();
                    } catch (error) {
                      print('카카오 로그인 실패2 $error');
                    }

                    try {
                      await UserApi.instance.loginWithKakaoAccount();
                      print('카카오계정으로 로그인 성공3');
                      get_user_info();
                    } catch (error) {
                      print('카카오 계정으로 로그인 실패3 $error');
                    }
                  } else {
                    try {
                      await UserApi.instance.loginWithKakaoAccount();
                      print('카카오계정으로 로그인 성고4');
                      get_user_info();
                    } catch (error) {
                      print('카카오계정으로 로그인 실패4');
                    }
                  }
                }
              } else {
                print('발급된 토큰 없음');
                if (await isKakaoTalkInstalled()) {
                  try {
                    await UserApi.instance.loginWithKakaoTalk();
                    print('카카오톡으로 로그인 성공2');
                    get_user_info();
                  } catch (error) {
                    print('카카오 로그인 실패2 $error');
                  }

                  try {
                    await UserApi.instance.loginWithKakaoAccount();
                    print('카카오계정으로 로그인 성공3');
                    get_user_info();
                  } catch (error) {
                    print('카카오 계정으로 로그인 실패3 $error');
                  }
                } else {
                  try {
                    await UserApi.instance.loginWithKakaoAccount();
                    print('카카오계정으로 로그인 성공4');
                    get_user_info();
                  } catch (error) {
                    print('카카오계정으로 로그인 실패4');
                  }
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
