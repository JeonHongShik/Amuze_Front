import 'package:dio/dio.dart';
import 'dart:io';

FormData patchStageFormData({
  String? uid,
  String? title,
  String? region,
  String? type,
  String? wishtype,
  String? pay,
  String? deadline,
  String? datetime,
  String? introduce,
  File? mainimage,
  File? otherimages1,
  File? otherimages2,
  File? otherimages3,
  File? otherimages4,
}) {
  return FormData.fromMap({
    'uid': uid,
    'title': title,
    'region': region,
    'type': type,
    'wishtype': wishtype,
    'pay': pay,
    'deadline': deadline,
    'datetime': datetime,
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
