// formData.dart 파일에 이 함수를 구현합니다.
import 'package:dio/dio.dart';
import 'dart:io';

FormData patchResumeFormData({
  String? id,
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
    'id': id,
    'uid': uid,
    'title': title,
    'gender': gender,
    'age': age,
    'regions': regions,
    'educations': educations,
    'careers': careers,
    'awards': awards,
    'completions': completions,
    'introduce': introduce,
    'mainimage':
        mainimage != null ? MultipartFile.fromFileSync(mainimage.path) : 'null',
    'otherimages1': otherimages1 != null
        ? MultipartFile.fromFileSync(otherimages1.path)
        : 'null',
    'otherimages2': otherimages2 != null
        ? MultipartFile.fromFileSync(otherimages2.path)
        : 'null',
    'otherimages3': otherimages3 != null
        ? MultipartFile.fromFileSync(otherimages3.path)
        : 'null',
    'otherimages4': otherimages4 != null
        ? MultipartFile.fromFileSync(otherimages4.path)
        : 'null',
  });
}
