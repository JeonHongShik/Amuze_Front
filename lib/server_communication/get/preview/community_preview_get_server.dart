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
  try {
    final response = await dio.get(
        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/communities/community/');

    return (response.data as List)
        .map((json) => CommunityPreviewServerData.fromJson(json))
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

// 커뮤니티 검색 ////////////////////////
Future<List<CommunityPreviewServerData>> communitysearchpreviewfetchData(
    String? searchtext) async {
  var dio = Dio();
  try {
    final response = await dio.get(
        'http://ec2-3-39-21-42.ap-northeast-2.compute.amazonaws.com/amuze/boardsearch/?q=$searchtext');
    print(searchtext);
    return (response.data as List)
        .map((json) => CommunityPreviewServerData.fromJson(json))
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
