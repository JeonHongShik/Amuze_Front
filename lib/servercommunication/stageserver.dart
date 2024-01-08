// formData.dart 파일에 이 함수를 구현합니다.
import 'package:dio/dio.dart';
import 'dart:io';

FormData createStgaeFormData({
  String? uid,
  String? title,
  String? region,
  String? type,
  String? wishtype,
  String? pay,
  String? deadline,
  String? datetime,
  String? introduce,
  List<File>? photos,
}) {
  return FormData.fromMap({
    'author': uid,
    'title': title,
    'region': region,
    'type': type,
    'wishtype': wishtype,
    'pay': pay,
    'deadline': deadline,
    'datetime': datetime,
    'introduce': introduce,
    'photos': photos
        ?.map((File file) => MultipartFile.fromFileSync(file.path))
        .toList(),
  });
}
