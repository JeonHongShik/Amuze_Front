import 'package:dio/dio.dart';

class CommunityDetailServerData {
  int? id; // 게시물 id
  String? author; // 게시물 작성자명
  String? title;
  String? content;
  String? createdat;
  int? likescount;
  int? commentscount;

  CommunityDetailServerData({
    required this.id,
    required this.author,
    required this.title,
    required this.content,
    required this.createdat,
    required this.likescount,
    required this.commentscount,
  });

  factory CommunityDetailServerData.fromJson(Map<String, dynamic> json) {
    try {
      return CommunityDetailServerData(
        id: json['id'],
        author: json['author'],
        title: json['title'],
        content: json['content'],
        createdat: json['created_at'],
        likescount: json['likes_count'],
        commentscount: json['comments_count'],
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
