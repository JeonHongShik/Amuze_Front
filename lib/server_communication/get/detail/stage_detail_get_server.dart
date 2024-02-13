import 'package:dio/dio.dart';

class StageDetailServerData {
  int? id;
  String? author;
  String? title;
  String? region;
  String? type;
  String? wishtype;
  String? pay;
  String? deadline;
  String? datetime;
  String? introduce;
  String? mainimage;
  String? otherimages1;
  String? otherimages2;
  String? otherimages3;
  String? otherimages4;

  StageDetailServerData({
    required this.id,
    required this.author,
    required this.title,
    required this.region,
    required this.type,
    required this.wishtype,
    required this.pay,
    required this.deadline,
    required this.datetime,
    required this.introduce,
    required this.mainimage,
    required this.otherimages1,
    required this.otherimages2,
    required this.otherimages3,
    required this.otherimages4,
  });

  factory StageDetailServerData.fromJson(Map<String, dynamic> json) {
    try {
      return StageDetailServerData(
        id: json['id'],
        author: json['author'],
        title: json['title'],
        region: json['region'],
        type: json['type'],
        wishtype: json['wishtype'],
        pay: json['pay'],
        deadline: json['deadline'],
        datetime: json['datetime'],
        introduce: json['introduce'],
        mainimage: json['mainimage'],
        otherimages1: json['otherimages1'],
        otherimages2: json['otherimages2'],
        otherimages3: json['otherimages3'],
        otherimages4: json['otherimages4'],
      );
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<StageDetailServerData>> stagedetailfetchData(int id) async {
  var dio = Dio();
  try {
    final response = await dio.get(
        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/posts/post/${id.toString()}/');

    return [StageDetailServerData.fromJson(response.data)];
  } on DioException catch (e) {
    if (e.response?.statusCode == 404) {
      print('e : $e');
      throw Exception('NotFound');
    } else {
      throw Exception('Error');
    }
  }
}
