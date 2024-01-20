import 'package:dio/dio.dart';

FormData createCommentFormData({
  String? uid,
  String? content,
  int? board,
}) {
  return FormData.fromMap({
    'uid': uid,
    'content': content,
    'board': board,
  });
}
