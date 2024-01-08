import 'package:dio/dio.dart';

class ResumeDetailServerData {
  int? id;
  String? author;
  String? title;
  String? age;
  String? gender;
  List<String>? education;
  List<String>? careers;
  List<String>? awards;
  //List<String>? completion;
  List<String>? regions;
  String? introduce;
  String? mainimage;
  String? otherimage1;
  String? otherimage2;
  String? otherimage3;
  String? otherimage4;

  ResumeDetailServerData({
    required this.id,
    required this.author,
    required this.title,
    required this.age,
    required this.gender,
    required this.education,
    required this.careers,
    required this.awards,
    //required this.completion,
    required this.introduce,
    required this.regions,
    required this.mainimage,
    required this.otherimage1,
    required this.otherimage2,
    required this.otherimage3,
    required this.otherimage4,
  });

  factory ResumeDetailServerData.fromJson(Map<String, dynamic> json) {
    try {
      List<String>? educationList;
      if (json['educations'] != null) {
        educationList = (json['educations'] as List)
            .map((e) => e['education'] as String)
            .toList();
      }
      List<String>? careersList;
      if (json['educations'] != null) {
        careersList = (json['careers'] as List)
            .map((e) => e['career'] as String)
            .toList();
      }
      List<String>? awardsList;
      if (json['educations'] != null) {
        awardsList =
            (json['awards'] as List).map((e) => e['award'] as String).toList();
      }
      /*List<String>? completionsList;
      if (json['completions'] != null) {
        completionsList = (json['completions'] as List)
            .map((e) => e['completion'] as String)
            .toList();
      }*/
      List<String>? regionsList;
      if (json['regions'] != null) {
        regionsList = (json['regions'] as List)
            .map((e) => e['region'] as String)
            .toList();
      }
      return ResumeDetailServerData(
        id: json['id'],
        author: json['author'],
        title: json['title'],
        age: json['age'],
        gender: json['gender'],
        education: educationList,
        careers: careersList,
        awards: awardsList,
        //completion: completionsList,
        regions: regionsList,
        introduce: json['introduce'],
        mainimage: json['mainimage'],
        otherimage1: json['otherimages1'],
        otherimage2: json['otherimages2'],
        otherimage3: json['otherimages3'],
        otherimage4: json['otherimages4'],
      );
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<ResumeDetailServerData>> resumedetailfetchData(int id) async {
  var dio = Dio();
  final response = await dio.get(
      'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/resumes/resume/${id.toString()}/');
  return [ResumeDetailServerData.fromJson(response.data)];
}
