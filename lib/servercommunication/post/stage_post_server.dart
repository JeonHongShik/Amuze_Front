import 'package:dio/dio.dart';
import 'dart:io';

FormData createStageFormData({
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
