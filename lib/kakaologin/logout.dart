import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

Future logout() async {
  try {
    await UserApi.instance.logout();
    print('로그아웃 성공, SDK에서 토큰 삭제');
  } catch (error) {
    print('로그아웃 실패, SDK에서 토큰 삭제 $error');
  }
}
