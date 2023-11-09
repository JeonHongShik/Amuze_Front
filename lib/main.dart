import 'package:amuze/homepage.dart';
import 'package:amuze/loadingscreen.dart';
import 'package:amuze/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  //firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //우리 앱의 Key값
  KakaoSdk.init(
    nativeAppKey: 'eabfebdd6a97136a8764ecfc05c8b8fe',
    javaScriptAppKey: '1405eb959f73904bf61cb1f7163e37d4',
  );

  //KakaoSDK로 키 해시 값 받을 때 사용, 키 해시 값 카카오디벨로퍼에 등록해야 함
  //print(await KakaoSdk.origin);

  //앱을 세로로 고정
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(
      //프로바이더 등록
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (c) => UserInfoProvider(),
          ),
          ChangeNotifierProvider(
            create: (c) => BottomNavigationProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          home: FutureBuilder(
            future: _checkTokenValidity(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                //토큰이 있으면 홈페이지
                if (snapshot.data == true) {
                  return HomePage();
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
      ),
    );
  });
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

//secure_storage를 쉽게 사용하기 위해 프로바이더에 넣어놈
//프로바이더는 앱 모든 곳에서 사용 가능
class UserInfoProvider extends ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String? kakaoid;
  String? name;
  String? profile;

  UserInfoProvider() {
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    kakaoid = await storage.read(key: 'kakaoid');
    name = await storage.read(key: 'name');
    profile = await storage.read(key: 'profile');

    notifyListeners();
  }
}

//이거는 사용 안하는데 test폴더의 widget_test.dart 파일에서의 오류 때문에 유지
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
