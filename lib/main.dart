import 'dart:convert';
import 'dart:io';

import 'package:amuze/pagelayout/dummypage.dart';
import 'package:amuze/homepage.dart';
import 'package:amuze/message.dart';
import 'package:amuze/loginpage.dart';
import 'package:amuze/server_communication/patch/resume_patch_server.dart';
import 'package:amuze/server_communication/patch/stage_patch_server.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:multi_image_picker_plus/multi_image_picker_plus.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'server_communication/patch/community_patch._server.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFlutterNotifications();
  showFlutterNotification(message);

  print('Handling a background message ${message.messageId}');
  print("$message");
}

///  [AndroidNotificationChannel] 채널생성
late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }
  channel = const AndroidNotificationChannel(
    'high_importance_channel', //채널 id
    'High Importance Notifications', //채널 title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// 알림 채널 만들기
  ///
  /// AndroidManifest.xml 파일에 채널설정 기본 fcm 설정
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// ios 설정
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  isFlutterLocalNotificationsInitialized = true;
}

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: 'launch_background',
        ),
      ),
    );
  }
}

/// [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void initializeNotification() async {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    var androidNotiDetails = AndroidNotificationDetails(
      channel.id,
      channel.name,
      channelDescription: channel.description,
    );

    var details = NotificationDetails(android: androidNotiDetails);
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        details,
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    print(message);
  });
}

void main() async {
  // 웹 환경에서 카카오 로그인을 정상적으로 완료하려면 runApp() 호출 전 아래 메서드 호출 필요
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //firebase 초기화
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeNotification();

  if (!kIsWeb) {
    await setupFlutterNotifications();
  }

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
          ),
          ChangeNotifierProvider(
            create: (c) => ResumeWriteProvider(),
          ),
          ChangeNotifierProvider(
            create: (c) => StageWriteProvider(),
          ),
          ChangeNotifierProvider(
            create: (c) => CommunityWriteProvider(),
          ),
        ],
        child: MaterialApp(
          initialRoute: auth.FirebaseAuth.instance.currentUser == null
              ? '/login'
              : '/home',
          routes: {
            '/login': (context) => const LoginPage(),
            '/home': (context) => const HomePage(),
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

  Future<void> updateUserName(String newName) async {
    // FlutterSecureStorage에 새로운 이름 저장
    await storage.write(key: 'displayName', value: newName);

    // UserInfoProvider의 정보 갱신
    await loadUserInfo();
  }

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

//이력서 작성 Provider//////////////////////////////////////////////////////////
class ResumeWriteProvider extends ChangeNotifier {
  String? uid;
  String? id;
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
  List<ImageItem> _filemainimage = [];
  List<Asset> _assetmainimage = [];

  List<ImageItem> _fileotherimages = [];
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
  List<ImageItem> get filemainimage => _filemainimage;
  List<Asset> get assetmainimage => _assetmainimage;

  List<ImageItem> get fileotherimages => _fileotherimages;
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

  void setFileMainimage(List<ImageItem> filemainimage) {
    _filemainimage = filemainimage;
    notifyListeners();
  }

  void setAssetMainimage(List<Asset> assetmainimage) {
    _assetmainimage = assetmainimage;
    notifyListeners();
  }

  void setFileOtherimages(List<ImageItem> fileotherimages) {
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

  Future<void> postResumeData() async {
    Dio dio = Dio();

    String careersString = _careers.join(",");
    String regionsString = _regions.join(",");
    String educationsString = _educations.join(",");
    String awardsString = _awards.join(",");
    String completionsString = _completions.join(",");

    // FormData 객체 생성
    FormData formData = FormData.fromMap({
      'uid': uid,
      'id': id,
      'title': _title,
      'gender': _gender,
      'age': _age,
      'regions': regionsString,
      'educations': educationsString,
      'careers': careersString,
      'awards': awardsString,
      'completions': completionsString,
      'introduce': _introduce,
    });

    // 메인 이미지 추가
    if (_filemainimage.isNotEmpty) {
      if (_filemainimage.first.isFile && _filemainimage.first.file != null) {
        formData.files.add(MapEntry(
          'mainimage',
          await MultipartFile.fromFile(_filemainimage.first.file!.path),
        ));
      } else if (_filemainimage.first.isPath &&
          _filemainimage.first.path != null) {
        formData.fields.add(MapEntry('mainimage', _filemainimage.first.path!));
      }
    }

    // 다른 이미지들 추가
    for (int i = 0; i < _fileotherimages.length && i < 4; i++) {
      if (_fileotherimages[i].isFile && _fileotherimages[i].file != null) {
        formData.files.add(MapEntry(
          'otherimages${i + 1}',
          await MultipartFile.fromFile(_fileotherimages[i].file!.path),
        ));
      } else if (_fileotherimages[i].isPath &&
          _fileotherimages[i].path != null) {
        formData.fields
            .add(MapEntry('otherimages${i + 1}', _fileotherimages[i].path!));
      }
    }

    try {
      // 서버에 POST 요청
      Response response = await dio.post(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/resumes/resume/create/',
          data: formData);
      print(response.data); // 응답 출력
    } catch (e) {
      print(e);
    }
  }

  Future<void> patchResumeData() async {
    Dio dio = Dio();
    String careersString = _careers.join(",");
    String regionsString = _regions.join(",");
    String educationsString = _educations.join(",");
    String awardsString = _awards.join(",");
    String completionsString = _completions.join(",");

    FormData formData = patchResumeFormData(
      id: id,
      uid: uid,
      title: _title,
      age: _age,
      gender: _gender,
      educations: educationsString,
      careers: careersString,
      awards: awardsString,
      completions: completionsString,
      regions: regionsString,
      introduce: _introduce,
    );
    if (_filemainimage.isNotEmpty) {
      if (_filemainimage.first.isFile && _filemainimage.first.file != null) {
        formData.files.add(MapEntry(
          'mainimage',
          await MultipartFile.fromFile(_filemainimage.first.file!.path),
        ));
      } else if (_filemainimage.first.isPath &&
          _filemainimage.first.path != null) {
        formData.fields.add(MapEntry('mainimage', _filemainimage.first.path!));
      }
    } else {
      formData.fields.add(const MapEntry('mainimage', 'null'));
    }

    for (int i = 0; i < _fileotherimages.length && i < 4; i++) {
      if (_fileotherimages[i].isFile && _fileotherimages[i].file != null) {
        formData.files.add(MapEntry(
          'otherimages${i + 1}',
          await MultipartFile.fromFile(_fileotherimages[i].file!.path),
        ));
      } else if (_fileotherimages[i].isPath &&
          _fileotherimages[i].path != null) {
        formData.fields
            .add(MapEntry('otherimages${i + 1}', _fileotherimages[i].path!));
      } else {
        formData.fields.add(MapEntry('otherimages${i + 1}', 'null'));
      }
    }

    try {
      // 서버에 POST 요청
      Response response = await dio.patch(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/resumes/resume/patch/$id/',
          data: formData);
      print(response.data); // 응답 출력
    } catch (e) {
      print(e);
    }
  }
}
///////////////////////////////////////////////////////////////////////////////

//공고 작성 Provider///////////////////////////////////////////////////////////
class ImageItem {
  File? file;
  String? path;

  ImageItem.fromFile(File file) {
    this.file = file;
  }

  ImageItem.fromPath(String path) {
    this.path = path;
  }

  bool get isFile => file != null;
  bool get isPath => path != null;
}

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

  List<ImageItem> _filemainimage = [];
  List<Asset> _assetmainimage = [];

  List<ImageItem> _fileotherimages = [];
  List<Asset> _assetotherimages = [];
  List<String> _convertedimagenames = [];

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

  List<ImageItem> get filemainimage => _filemainimage;
  List<Asset> get assetmainimage => _assetmainimage;

  List<ImageItem> get fileotherimages => _fileotherimages;
  List<Asset> get assetotherimages => _assetotherimages;
  List<String> get convertedimagenames => _convertedimagenames;

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

  void setFileMainimage(List<ImageItem> filemainimage) {
    _filemainimage = filemainimage;
    notifyListeners();
  }

  void setAssetMainimage(List<Asset> assetmainimage) {
    _assetmainimage = assetmainimage;
    notifyListeners();
  }

  void setFileOtherimages(List<ImageItem> fileotherimages) {
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

  void reset() {
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
  }

  Future<void> mergeDateAndTimeAsync() async {
    if (_date.isNotEmpty && _time.isNotEmpty) {
      _datetime = '$_date $_time';
    } else {
      _datetime = '';
    }

    notifyListeners();
  }

  Future<void> splitDateAndTimeAsync() async {
    if (_datetime.isNotEmpty) {
      List<String> parts = _datetime.split(' ');
      if (parts.length >= 2) {
        _date = parts[0];
        _time = parts.sublist(1).join(' '); // "2:40 PM"을 얻기 위해 나머지 부분을 합칩니다.
      }
    } else {
      _date = '';
      _time = '';
    }

    notifyListeners();
  }

  Future<void> postStageData() async {
    Dio dio = Dio();
    await mergeDateAndTimeAsync();

    // FormData 객체 생성
    FormData formData = FormData.fromMap({
      'uid': uid,
      'title': _title,
      'region': _region,
      'type': _type,
      'wishtype': _wishtype,
      'pay': _pay,
      'deadline': _deadline,
      'datetime': _datetime,
      'introduce': _introduce,
    });

    // 메인 이미지 추가
    if (_filemainimage.isNotEmpty) {
      if (_filemainimage.first.isFile && _filemainimage.first.file != null) {
        formData.files.add(MapEntry(
          'mainimage',
          await MultipartFile.fromFile(_filemainimage.first.file!.path),
        ));
      } else if (_filemainimage.first.isPath &&
          _filemainimage.first.path != null) {
        formData.fields.add(MapEntry('mainimage', _filemainimage.first.path!));
      }
    }

    // 다른 이미지들 추가
    for (int i = 0; i < _fileotherimages.length && i < 4; i++) {
      if (_fileotherimages[i].isFile && _fileotherimages[i].file != null) {
        formData.files.add(MapEntry(
          'otherimages${i + 1}',
          await MultipartFile.fromFile(_fileotherimages[i].file!.path),
        ));
      } else if (_fileotherimages[i].isPath &&
          _fileotherimages[i].path != null) {
        formData.fields
            .add(MapEntry('otherimages${i + 1}', _fileotherimages[i].path!));
      }
    }

    try {
      // 서버에 POST 요청
      Response response = await dio.post(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/posts/post/create/',
          data: formData);
      print(response.data); // 응답 출력
    } catch (e) {
      print(e);
    }
  }

  Future<void> patchStageData() async {
    Dio dio = Dio();
    await mergeDateAndTimeAsync();
    FormData formData = patchStageFormData(
      uid: uid,
      title: _title,
      region: _region,
      type: _type,
      wishtype: _wishtype,
      pay: _pay,
      deadline: _deadline,
      datetime: _datetime,
      introduce: _introduce,
    );
    if (_filemainimage.isNotEmpty) {
      if (_filemainimage.first.isFile && _filemainimage.first.file != null) {
        formData.files.add(MapEntry(
          'mainimage',
          await MultipartFile.fromFile(_filemainimage.first.file!.path),
        ));
      } else if (_filemainimage.first.isPath &&
          _filemainimage.first.path != null) {
        formData.fields.add(MapEntry('mainimage', _filemainimage.first.path!));
      }
    } else {
      formData.fields.add(const MapEntry('mainimage', 'null'));
    }

    for (int i = 0; i < _fileotherimages.length && i < 4; i++) {
      if (_fileotherimages[i].isFile && _fileotherimages[i].file != null) {
        formData.files.add(MapEntry(
          'otherimages${i + 1}',
          await MultipartFile.fromFile(_fileotherimages[i].file!.path),
        ));
      } else if (_fileotherimages[i].isPath &&
          _fileotherimages[i].path != null) {
        formData.fields
            .add(MapEntry('otherimages${i + 1}', _fileotherimages[i].path!));
      } else {
        formData.fields.add(MapEntry('otherimages${i + 1}', 'null'));
      }
    }

    try {
      Response response = await dio.patch(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/posts/post/patch/${id.toString()}/',
          data: formData);
      print(response.data); // 응답 출력
    } catch (e) {
      print(e);
    }
  }
}

// 커뮤니티 게시물 작성 Provider /////////////////////////////////////
class CommunityWriteProvider extends ChangeNotifier {
  String? uid;
  int? id;
  String? author;
  String _title = '';
  String _content = '';

  String get title => _title;
  String get content => _content;

  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void setContent(String content) {
    _content = content;
    notifyListeners();
  }

  void reset() {
    id = null;
    author = '';
    _title = '';
    _content = '';
  }

  Future<void> postCommunityData() async {
    Dio dio = Dio();

    FormData formdata = FormData.fromMap({
      'uid': author,
      'title': _title,
      'content': _content,
    });

    try {
      // 서버에 POST 요청
      Response response = await dio.post(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/community/create/',
          data: formdata);
      print(response.data); // 응답 출력
    } catch (e) {
      print(e);
    }
  }

  Future<void> patchCommunityData() async {
    Dio dio = Dio();

    FormData formData = patchCommunityFormData(
      author: author,
      title: title,
      content: content,
    );

    try {
      Response response = await dio.patch(
          'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/community/patch/${id.toString()}/',
          data: formData);
      print(response.data);
    } catch (e) {
      print(e);
    }
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
