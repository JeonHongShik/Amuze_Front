import 'dart:io';

import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/message.dart';
import 'package:amuze/homepage.dart';
import 'package:amuze/loginpage.dart';
import 'package:amuze/servercommunication/resumeserver.dart';
import 'package:amuze/servercommunication/stageserver.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get_core/get_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

late final AndroidNotificationChannel channel;
late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

//백그라운드 알림 설정
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //채널 설정
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', //채널 id
    'High Importance Notifications', // 채널 이름
    description: 'This channel is used for important notifications.', //채널 설명
    importance: Importance.max,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  print("백그라운드 메시지 처리 ${message.notification!.body!}");

  //FCM 메시지 창
  flutterLocalNotificationsPlugin?.show(
    message.hashCode,
    '제목'.toString(), //게시글 제목
    '댓글'.toString(), // 댓글

    // message.notification?.title.toString(),
    // message.notification?.body.toString(),
    //알림창 세부 디테일 앱 아이콘 등등.
    NotificationDetails(
        android: AndroidNotificationDetails(
          channel!.id,
          channel!.name,
          channelDescription: channel!.description,
        ),
        iOS: DarwinNotificationDetails(badgeNumber: 1)),
  );

  //알림 클릭시 이동 이벤트 background
  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print("onMessage ${message.data["action"].toString()}");
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      Navigator.of(GlobalVariable.navState.currentContext!)
          .push(MaterialPageRoute(builder: (context) => const DummyPage()));
    });
    return;
  });
  //
}

void initializeNotification() async {
  //백그라운드 설정
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.onMessage.listen((message) {
    _flutterNotificationShow(message);
  });

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    ),
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}
//

void _flutterNotificationShow(RemoteMessage message) {
  flutterLocalNotificationsPlugin?.show(
    message.hashCode,
    message.data['title'].toString(),
    message.data['body'].toString(),

    // message.notification?.title.toString(),
    // message.notification?.body.toString(),
    NotificationDetails(
        android: AndroidNotificationDetails(
          channel!.id,
          channel!.name,
          channelDescription: channel!.description,
          color: const Color.fromARGB(0, 255, 0, 0),
          icon: '@mipmap/logo', // 알람 앱바 이미지
          largeIcon:
              DrawableResourceAndroidBitmap('@mipmap/ico_manager'), // 알람 내 이미지
        ),
        iOS: DarwinNotificationDetails(badgeNumber: 1)),
  );
}
//

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  //기본 알림 설정
  initializeNotification();

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

  //알림 토큰
  final token = await FirebaseMessaging.instance.getToken();

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
          ),
          ChangeNotifierProvider(
            create: (c) => ResumeWriteProvider(),
          ),
          ChangeNotifierProvider(
            create: (c) => StageWriteProvider(),
          )
        ],
        child: MaterialApp(
          navigatorKey: GlobalVariable.navState,
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
  String? messagingToken;

  UserInfoProvider() {
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    uid = await storage.read(key: 'uid');
    displayName = await storage.read(key: 'displayName');
    photoURL = await storage.read(key: 'photoURL');
    email = await storage.read(key: 'email');
    messagingToken = await storage.read(key: 'messagingToken');

    notifyListeners();
  }
}

//이력서 작성 Provider//////////////////////////////////////////////////////////
class ResumeWriteProvider extends ChangeNotifier {
  String? uid;
  int? id;
  String _title = '';
  String _gender = '';
  String _age = '';
  List<String> _regions = [];
  List<String> _educations = [];
  List<String> _careers = [];
  List<String> _awards = [];
  List<String> _completions = [];
  String _introduce = '';

//사진들
  List<File> _filemainimage = [];
  List<Asset> _assetmainimage = [];

  List<File> _fileotherimages = [];
  List<Asset> _assetotherimages = [];
  List<String> _convertedimagenames = [];

  List<File> _photos = [];

  String get title => _title;
  String get gender => _gender;
  String get age => _age;
  List<String> get regions => _regions;
  List<String> get educations => _educations;
  List<String> get careers => _careers;
  List<String> get awards => _awards;
  List<String> get completions => _completions;
  String get introduce => _introduce;

//사진들
  List<File> get filemainimage => _filemainimage;
  List<Asset> get assetmainimage => _assetmainimage;

  List<File> get fileotherimages => _fileotherimages;
  List<Asset> get assetotherimages => _assetotherimages;
  List<String> get convertedimagenames => _convertedimagenames;

  List<File> get photos => _photos;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setGender(String gender) {
    _gender = gender;
    notifyListeners();
  }

  void setAge(String age) {
    _age = age;
    notifyListeners();
  }

  void setRegions(List<String> regions) {
    _regions = regions;
    notifyListeners();
  }

  void setEducations(List<String> educations) {
    _educations = educations;
    notifyListeners();
  }

  void setCareers(List<String> careers) {
    _careers = careers;
    notifyListeners();
  }

  void setAwards(List<String> awards) {
    _awards = awards;
    notifyListeners();
  }

  void setCompletions(List<String> completions) {
    _completions = completions;
    notifyListeners();
  }

  void setIntroduce(String introduce) {
    _introduce = introduce;
    notifyListeners();
  }

  void setFileMainimage(List<File> filemainimage) {
    _filemainimage = filemainimage;
    notifyListeners();
  }

  void setAssetMainimage(List<Asset> assetmainimage) {
    _assetmainimage = assetmainimage;
    notifyListeners();
  }

  void setFileOtherimages(List<File> fileotherimages) {
    _fileotherimages = fileotherimages;
    notifyListeners();
  }

  void setAssetOtherimages(List<Asset> assetotherimages) {
    _assetotherimages = assetotherimages;
    notifyListeners();
  }

  void setConvertedimagenames(List<String> convertedimagenames) {
    _convertedimagenames = convertedimagenames;
    notifyListeners();
  }

  void removeMainImage() {
    if (_filemainimage.isNotEmpty) {
      _filemainimage.removeAt(0);
    }

    if (_assetmainimage.isNotEmpty) {
      _assetmainimage.removeAt(0);
    }
    notifyListeners();
  }

  void removeOtherImageAt(int index) {
    if (index < _assetotherimages.length) {
      _assetotherimages.removeAt(index);
    }
    if (index < _fileotherimages.length) {
      _fileotherimages.removeAt(index);
    }
    notifyListeners();
  }

  void removeConvertedimagenames(String imageName) {
    convertedimagenames.remove(imageName);
  }

  void setPhotos(List<File> photos) {
    _photos = photos;
    notifyListeners();
  }

  void reset() {
    uid = '';
    id = null;
    _title = '';
    _gender = '';
    _age = '';
    _regions = [];
    _educations = [];
    _careers = [];
    _awards = [];
    _completions = [];
    _introduce = '';
    _filemainimage = [];
    _assetmainimage = [];
    _fileotherimages = [];
    _assetotherimages = [];
    _convertedimagenames = [];
    _photos = [];
    notifyListeners();
  }

  Future<void> mergeImages() async {
    _photos.clear(); // 기존의 photos 리스트를 비웁니다.

    if (_filemainimage.isNotEmpty) {
      _photos.add(_filemainimage[0]); // filemainimage의 첫 번째 이미지를 추가합니다.
    }
    if (_fileotherimages.isNotEmpty) {
      _photos.addAll(_fileotherimages);
    } // fileotherimages의 모든 이미지를 추가합니다.

    notifyListeners();
  }

  Future<void> postResumeData(String serverEndpoint) async {
    Dio dio = Dio();
    await mergeImages();
    FormData formData = createResumeFormData(
      uid: uid,
      title: _title,
      gender: _gender,
      age: _age,
      regions: _regions,
      educations: _educations,
      careers: _careers,
      awards: _awards,
      completions: _completions,
      introduce: _introduce,
      photos: _photos,
    );

    try {
      // 서버에 POST 요청
      Response response = await dio.post(serverEndpoint, data: formData);
      print(response.data); // 응답 출력
    } catch (e) {
      print(e);
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

//공고 작성 Provider///////////////////////////////////////////////////////////
class StageWriteProvider extends ChangeNotifier {
  String? uid;
  int? id;
  String _title = '';
  String _region = '';
  String _type = '';
  String _wishtype = '';
  String _pay = '';
  String _deadline = '';
  String _date = '';
  String _time = '';
  String _datetime = '';
  String _introduce = '';

  List<File> _filemainimage = [];
  List<Asset> _assetmainimage = [];

  List<File> _fileotherimages = [];
  List<Asset> _assetotherimages = [];
  List<String> _convertedimagenames = [];

  List<File> _photos = [];

  String get title => _title;
  String get region => _region;
  String get type => _type;
  String get wishtype => _wishtype;
  String get pay => _pay;
  String get deadline => _deadline;
  String get date => _date;
  String get time => _time;
  String get datetime => _datetime;
  String get introduce => _introduce;

  List<File> get filemainimage => _filemainimage;
  List<Asset> get assetmainimage => _assetmainimage;

  List<File> get fileotherimages => _fileotherimages;
  List<Asset> get assetotherimages => _assetotherimages;
  List<String> get convertedimagenames => _convertedimagenames;

  List<File> get photos => _photos;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setRegion(String region) {
    _region = region;
    notifyListeners();
  }

  void setType(String type) {
    _type = type;
    notifyListeners();
  }

  void setWishtype(String wishtype) {
    _wishtype = wishtype;
    notifyListeners();
  }

  void setPay(String pay) {
    _pay = pay;
    notifyListeners();
  }

  void setDeadline(String deadline) {
    _deadline = deadline;
    notifyListeners();
  }

  void setDate(String date) {
    _date = date;
    notifyListeners();
  }

  void setTime(String time) {
    _time = time;
    notifyListeners();
  }

  void setDatetime(String datetime) {
    _datetime = datetime;
    notifyListeners();
  }

  void setIntroduce(String introduce) {
    _introduce = introduce;
    notifyListeners();
  }

  void setFileMainimage(List<File> filemainimage) {
    _filemainimage = filemainimage;
    notifyListeners();
  }

  void setAssetMainimage(List<Asset> assetmainimage) {
    _assetmainimage = assetmainimage;
    notifyListeners();
  }

  void setFileOtherimages(List<File> fileotherimages) {
    _fileotherimages = fileotherimages;
    notifyListeners();
  }

  void setAssetOtherimages(List<Asset> assetotherimages) {
    _assetotherimages = assetotherimages;
    notifyListeners();
  }

  void setConvertedimagenames(List<String> convertedimagenames) {
    _convertedimagenames = convertedimagenames;
    notifyListeners();
  }

  void removeMainImage() {
    if (_filemainimage.isNotEmpty) {
      _filemainimage.removeAt(0);
    }

    if (_assetmainimage.isNotEmpty) {
      _assetmainimage.removeAt(0);
    }
    notifyListeners();
  }

  void removeOtherImageAt(int index) {
    if (index < _assetotherimages.length) {
      _assetotherimages.removeAt(index);
    }
    if (index < _fileotherimages.length) {
      _fileotherimages.removeAt(index);
    }
    notifyListeners();
  }

  void removeConvertedimagenames(String imageName) {
    convertedimagenames.remove(imageName);
  }

  void setPhotos(List<File> photos) {
    _photos = photos;
    notifyListeners();
  }

  void reset() {
    uid = '';
    id = null;
    _title = '';
    _region = '';
    _type = '';
    _wishtype = '';
    _pay = '';
    _deadline = '';
    _date = '';
    _time = '';
    _datetime = '';
    _introduce = '';
    _filemainimage = [];
    _assetmainimage = [];
    _fileotherimages = [];
    _assetotherimages = [];
    _convertedimagenames = [];
    _photos = [];
  }

  Future<void> mergeImages() async {
    _photos.clear(); // 기존의 photos 리스트를 비웁니다.

    if (_filemainimage.isNotEmpty) {
      _photos.add(_filemainimage[0]); // filemainimage의 첫 번째 이미지를 추가합니다.
    }
    if (_fileotherimages.isNotEmpty) {
      _photos.addAll(_fileotherimages);
    } // fileotherimages의 모든 이미지를 추가합니다.

    notifyListeners();
  }

  Future<void> mergeDateAndTimeAsync() async {
    if (_date.isNotEmpty && _time.isNotEmpty) {
      _datetime = '$_date $_time';
    } else {
      _datetime = '';
    }

    notifyListeners();
  }

  Future<void> postStageData(String serverEndpoint) async {
    Dio dio = Dio();
    await mergeImages();
    await mergeDateAndTimeAsync();
    FormData formData = createStgaeFormData(
      uid: uid,
      title: _title,
      region: _region,
      type: _type,
      wishtype: _wishtype,
      pay: _pay,
      deadline: _deadline,
      datetime: _datetime,
      introduce: _introduce,
      photos: _photos,
    );

    try {
      // 서버에 POST 요청
      Response response = await dio.post(serverEndpoint, data: formData);
      print(response.data); // 응답 출력
    } catch (e) {
      print(e);
    }
  }
}

//이거는 사용 안하는데 test폴더의 widget_test.dart 파일에서의 오류 때문에 유지
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
