import 'package:dio/dio.dart';

class MyCommunityServerData {
  int? id;
  // String? author;
  String? title;
  String? content;
  String? createdat;
  int? likescount;
  int? commentscount;

  MyCommunityServerData({
    required this.id,
    // required this.author,
    required this.title,
    required this.content,
    required this.createdat,
    required this.likescount,
    required this.commentscount,
  });

  factory MyCommunityServerData.fromJson(Map<String, dynamic> json) {
    try {
      return MyCommunityServerData(
        id: json['id'],
        // author: json['author'],
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

Future<List<MyCommunityServerData>> mycommunityfetchData(String uid) async {
  var dio = Dio();
  try {
    final response = await dio.get(
        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/mycommunity/$uid');

    return (response.data as List)
        .map((json) => MyCommunityServerData.fromJson(json))
        .toList();
  } on DioException catch (e) {
    // Handle DioException
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        print('Connection timeout');
        break;
      case DioExceptionType.receiveTimeout:
        print('Receive timeout');
        break;
      case DioExceptionType.badResponse:
        print('Server response error: ${e.response?.statusCode}');
        break;
      case DioExceptionType.connectionError:
        print('Connection error');
        break;
      default:
        print('Unknown DioException: ${e.message}');
    }
    rethrow; // Propagate the error
  } catch (e) {
    // Handle other exceptions
    print('Unknown error: $e');
    rethrow;
  }
}
