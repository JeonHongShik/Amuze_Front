import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future<String> getKakaoToken() async {
  if (await isKakaoTalkInstalled()) {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      User user = await UserApi.instance.me();
      print('카카오톡으로 로그인 성공');
      print(token.idToken);
      print(user);
      return token.accessToken.toString();
    } catch (error) {
      print('카카오 톡으로 로그인 실패 $error');

      if (error is PlatformException && error.code == 'CANCELED') {
        return 'error';
      }
    }
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      User user = await UserApi.instance.me();
      print('카카오계정으로 로그인 성공1');
      print(token);
      print(user);
      return token.accessToken.toString();
    } catch (error) {
      print('카카오계정으로 로그인 실패1 $error');
      return 'error';
    }
  } else {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      User user = await UserApi.instance.me();
      print('카카오계정으로 로그인 성공2');
      print(token);
      print(user);
      return token.accessToken.toString();
    } catch (error) {
      print('카카오계정으로 로그인 실패2 $error');
      return 'error';
    }
  }
}
