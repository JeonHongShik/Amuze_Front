import 'package:dio/dio.dart';

class CommunityDetailServerData {
  int? id; // 게시물 id
  String? author; // 게시물 작성자명
  String? title;
  String? content;
  // String? likes;
  // String? date;

  CommunityDetailServerData({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    // required this.likes,
    // required this.date,
  });

  factory CommunityDetailServerData.fromJson(Map<String, dynamic> json) {
    try {
      return CommunityDetailServerData(
        id: json['id'],
        author: json['author'],
        title: json['title'],
        content: json['content'],
        //likes: json['likes'],
        //date: json['date'],
      );
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<CommunityDetailServerData>> communitydetailfetchData(int id) async {
  var dio = Dio();
  final response = await dio.get(
      'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/community/detail/${id.toString()}/');
  return [CommunityDetailServerData.fromJson(response.data)];
}
