// formData.dart 파일에 이 함수를 구현합니다.
import 'package:dio/dio.dart';
import 'dart:io';

FormData createResumeFormData({
  String? uid,
  String? title,
  String? gender,
  String? age,
  List<String>? regions,
  List<String>? educations,
  List<String>? careers,
  List<String>? awards,
  List<String>? completions,
  String? introduce,
  List<File>? photos,
}) {
  return FormData.fromMap({
    'author': uid,
    'title': title,
    'gender': gender,
    'age': age,
    'regions': regions,
    'educations': educations,
    'careers': careers,
    'awards': awards,
    'completions': completions,
    'introduce': introduce,
    'photos': photos
        ?.map((File file) => MultipartFile.fromFileSync(file.path))
        .toList(),
  });
}
