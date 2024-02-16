import 'package:dio/dio.dart';

class MyStageServerData {
  int? id;
  String? author;
  String? title;
  String? mainimage;
  String? region;
  String? type;
  String? pay;
  String? datetime;

  MyStageServerData({
    required this.id,
    required this.author,
    required this.title,
    required this.region,
    required this.type,
    required this.pay,
    required this.datetime,
    required this.mainimage,
  });

  factory MyStageServerData.fromJson(Map<String, dynamic> json) {
    try {
      return MyStageServerData(
          id: json['id'],
          author: json['author'],
          title: json['title'],
          region: json['region'],
          type: json['type'],
          pay: json['pay'],
          datetime: json['datetime'],
          mainimage: json['mainimage']);
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<MyStageServerData>> mystagefetchData(String uid) async {
  var dio = Dio();

  try {
    final response = await dio.get(
        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/posts/mypost/$uid/');

    return (response.data as List)
        .map((json) => MyStageServerData.fromJson(json))
        .toList();
  } on DioException catch (e) {
    // DioException 처리
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print('연결 시간 초과');
        break;
      case DioExceptionType.receiveTimeout:
        print('응답 시간 초과');
        break;
      case DioExceptionType.badResponse:
        print('서버 응답 오류: ${e.response?.statusCode}');
        break;
      case DioExceptionType.connectionError:
        print('연결 오류');
        break;
      default:
        print('알 수 없는 DioException: ${e.message}');
    }
    rethrow; // 오류를 상위로 전파
  } catch (e) {
    // 기타 오류 처리
    print('알 수 없는 오류: $e');
    rethrow;
  }
}
