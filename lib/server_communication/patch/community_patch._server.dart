import 'package:dio/dio.dart';

FormData patchCommunityFormData({
  String? author,
  String? title,
  String? content,
}) {
  return FormData.fromMap({
    'uid': author,
    'title': title,
    'content': content,
  });
}
