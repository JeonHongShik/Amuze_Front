import 'package:dio/dio.dart';

class CommentServerData {
  int? id; // 댓글id
  String? uid;
  String? content;
  int? board; //게시글id

  CommentServerData({
    required this.id,
    required this.uid,
    required this.content,
    required this.board,
  });

  factory CommentServerData.fromJson(Map<String, dynamic> json) {
    try {
      return CommentServerData(
        id: json['id'],
        uid: json['author'],
        content: json['content'],
        board: json['board'],
      );
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<CommentServerData>> commentfetchData(int id) async {
  var dio = Dio();
  final response = await dio.get(
      'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/comment/$id/');
  return (response.data as List)
      .map((json) => CommentServerData.fromJson(json))
      .toList();
}
