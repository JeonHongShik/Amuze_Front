import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future loginWithNewScopes() async {
  User user;

  try {
    user = await UserApi.instance.me();
  } catch (error) {
    print('사용자 정보 요청 실패 $error');
    return;
  }

  List<String> scopes = [];

  if (user.kakaoAccount?.emailNeedsAgreement == true) {
    scopes.add('account_email');
  }

  if (scopes.isNotEmpty) {
    print('사용자에게 추가 동의 받아야 하는 항목이 있습니다');

    // OpenID Connect 사용 시
    // scope 목록에 "openid" 문자열을 추가하고 요청해야 함
    // 해당 문자열을 포함하지 않은 경우, ID 토큰이 재발급되지 않음
    // scopes.add("openid")

    //scope 목록을 전달하여 카카오 로그인 요청
    OAuthToken token;
    try {
      token = await UserApi.instance.loginWithNewScopes(scopes);
      print('현재 사용자가 동의한 동의 항목: ${token.scopes}');
    } catch (error) {
      print('추가 동의 요청 실패 $error');
      return;
    }

    // 사용자 정보 재요청
    try {
      User user = await UserApi.instance.me();
      print('사용자 정보 요청 성공'
          '\n회원번호: ${user.id}'
          '\n닉네임: ${user.kakaoAccount?.profile?.nickname}'
          '\n이메일: ${user.kakaoAccount?.email}');
    } catch (error) {
      print('사용자 정보 요청 실패 $error');
    }
  }
}
