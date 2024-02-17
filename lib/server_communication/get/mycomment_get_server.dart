import 'package:dio/dio.dart';

class MyCommentServerData {
  int? id;
  String? title;
  String? content;
  int? board; //게시글id

  MyCommentServerData({
    required this.id,
    required this.title,
    required this.content,
    required this.board,
  });

  factory MyCommentServerData.fromJson(Map<String, dynamic> json) {
    try {
      return MyCommentServerData(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        board: json['board'],
      );
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<MyCommentServerData>> mycommentfetchData(String uid) async {
  var dio = Dio();
  final response = await dio.get(
      'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/mycomment/$uid/');
  return (response.data as List)
      .map((json) => MyCommentServerData.fromJson(json))
      .toList();
}
