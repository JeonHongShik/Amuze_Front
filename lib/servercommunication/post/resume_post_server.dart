// formData.dart 파일에 이 함수를 구현합니다.
import 'package:dio/dio.dart';
import 'dart:io';

FormData createResumeFormData({
  String? uid,
  String? title,
  String? gender,
  String? age,
  String? regions,
  String? educations,
  String? careers,
  String? awards,
  String? completions,
  String? introduce,
  File? mainimage,
  File? otherimages1,
  File? otherimages2,
  File? otherimages3,
  File? otherimages4,
}) {
  return FormData.fromMap({
    'author': uid,
    'title': title,
    'gender': gender,
    'age': age,
    'region': regions,
    'education': educations,
    'career': careers,
    'award': awards,
    'completion': completions,
    'introduce': introduce,
    if (mainimage != null)
      'mainimage': MultipartFile.fromFileSync(mainimage.path),
    if (otherimages1 != null)
      'otherimages1': MultipartFile.fromFileSync(otherimages1.path),
    if (otherimages2 != null)
      'otherimages2': MultipartFile.fromFileSync(otherimages2.path),
    if (otherimages3 != null)
      'otherimages3': MultipartFile.fromFileSync(otherimages3.path),
    if (otherimages4 != null)
      'otherimages4': MultipartFile.fromFileSync(otherimages4.path),
  });
}
