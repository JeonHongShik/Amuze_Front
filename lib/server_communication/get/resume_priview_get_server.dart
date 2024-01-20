import 'package:dio/dio.dart';

class ResumePreviewServerData {
  int? id;
  String? author;
  String? title;
  String? age;
  String? gender;
  List<String>? education;
  String? mainimage;

  ResumePreviewServerData({
    required this.id,
    required this.author,
    required this.title,
    required this.age,
    required this.gender,
    required this.education,
    required this.mainimage,
  });

  factory ResumePreviewServerData.fromJson(Map<String, dynamic> json) {
    try {
      List<String>? educationList;
      if (json['educations'] != null) {
        educationList = (json['educations'] as List)
            .map((e) => e['education'] as String)
            .toList();
      }
      return ResumePreviewServerData(
          id: json['id'],
          author: json['author'],
          title: json['title'],
          age: json['age'],
          gender: json['gender'],
          education: educationList,
          mainimage: json['mainimage']);
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<ResumePreviewServerData>> resumepreviewfetchData() async {
  var dio = Dio();
  try {
    final response = await dio.get(
        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/resumes/resume/');

    return (response.data as List)
        .map((json) => ResumePreviewServerData.fromJson(json))
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
