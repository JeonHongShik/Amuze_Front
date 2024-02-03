import 'package:dio/dio.dart';

class AlarmServerData {
  String? messagebody;
  String? boardid; //게시글id
  int? id;

  AlarmServerData({
    required this.messagebody,
    required this.boardid,
    required this.id,
  });

  factory AlarmServerData.fromJson(Map<String, dynamic> json) {
    try {
      return AlarmServerData(
        messagebody: json['messagebody'],
        boardid: json['board_id'],
        id: json['id'],
      );
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<AlarmServerData>> alarmfetchData(String uid) async {
  var dio = Dio();
  final response = await dio.get(
      'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/chat/mynotification/$uid/');
  return (response.data as List)
      .map((json) => AlarmServerData.fromJson(json))
      .toList();
}
