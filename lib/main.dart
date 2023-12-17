import 'package:amuze/homepage.dart';
import 'package:amuze/loginpage.dart';
import 'package:amuze/resume/resume_board.dart';
import 'package:amuze/stage/stage_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

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
          ChangeNotifierProvider(
            create: (c) => IconChangeProvider(),
          )
        ],
        child: MaterialApp(
          initialRoute: auth.FirebaseAuth.instance.currentUser == null
              ? '/login'
              : '/home',
          routes: {
            '/login': (context) => const LoginPage(),
            '/home': (context) => HomePage(),
          },
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: Colors.white,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
        ),
      ),
    );
  });
}

//secure_storage를 쉽게 사용하기 위해 프로바이더에 넣어놈
//프로바이더는 앱 모든 곳에서 사용 가능
class UserInfoProvider extends ChangeNotifier {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  String? uid;
  String? displayName;
  String? photoURL;
  String? email;

  UserInfoProvider() {
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    uid = await storage.read(key: 'uid');
    displayName = await storage.read(key: 'displayName');
    photoURL = await storage.read(key: 'photoURL');
    email = await storage.read(key: 'email');

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
