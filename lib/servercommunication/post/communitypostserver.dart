import 'package:dio/dio.dart';

FormData createCommunityFormData({
  String? title,
  String? content,
  String? writer,
  int? likes,
}) {
  return FormData.fromMap({
    'title': title,
    'content': content,
    'writer': writer,
    'likes': likes,
  });
}
