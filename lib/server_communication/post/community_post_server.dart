import 'package:dio/dio.dart';

FormData createCommunityFormData({
  String? author,
  String? title,
  String? content,
  int? likes,
}) {
  return FormData.fromMap({
    'author': author,
    'title': title,
    'content': content,
    'likes': likes,
  });
}
