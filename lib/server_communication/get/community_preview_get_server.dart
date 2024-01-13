import 'package:dio/dio.dart';

class CommunityPreviewServerData {
  int? id;
  // String? author;
  String? title;
  String? content;

  CommunityPreviewServerData({
    required this.id,
    // required this.author,
    required this.title,
    required this.content,
  });

  factory CommunityPreviewServerData.fromJson(Map<String, dynamic> json) {
    try {
      return CommunityPreviewServerData(
        id: json['id'],
        // author: json['author'],
        title: json['title'],
        content: json['content'],
      );
    } catch (e) {
      print("Error during JSON parsing: $e");
      rethrow;
    }
  }
}

Future<List<CommunityPreviewServerData>> communitypreviewfetchData() async {
  var dio = Dio();
  final response = await dio.get(
      'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/community/');

  return (response.data as List)
      .map((json) => CommunityPreviewServerData.fromJson(json))
      .toList();
}
