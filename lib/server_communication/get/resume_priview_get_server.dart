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
  final response = await dio.get(
      'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/resumes/resume/');
  return (response.data as List)
      .map((json) => ResumePreviewServerData.fromJson(json))
      .toList();
}
