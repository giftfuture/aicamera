import 'dart:convert';

import 'package:aicamera/generated/json/logo_entity.g.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:aicamera/models/base_response.dart';
import 'package:aicamera/models/photo_entity.dart';
import 'package:aicamera/models/carousel_req.dart';
import 'package:aicamera/service/http_service.dart';
import 'package:aicamera/utils/dialog_util.dart';

import '../models/logo_entity.dart';
class AutoGenPhotoRepository extends GetxService {
  late HttpService _httpService;


  AutoGenPhotoRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }

  // 获取自动生成图片列表
  Future<List<PhotoEntity>?> getAutoGenPhotos(CarouselReq req) async {
    try {
      final response = await _httpService.postForm('common/activity',
        data: FormData.fromMap(req.toMap())
      );
      // print('原始响应: ${response.data.runtimeType}');
      // print('原始响应内容: ${response.data}');
      // var baseInfo = BaseResponseList<PhotoEntity>.fromJson(
      //    (json) => PhotoEntity.fromJson(response.data.data),
      // );
      var baseInfo = BaseResponseList<PhotoEntity>.fromJson(response.data);
      if (baseInfo.code == 0) {
        return baseInfo.data;
      } else {
        LoadingUtil.toast("获取图片失败", baseInfo.msg,
            Theme.of(Get.context!).colorScheme.error);
        return null;
      }
    } catch (e, stackTrace) {
      print('请求异常: $e');
      print('堆栈跟踪: $stackTrace');
      return null;
    }
  }

  // 获取自动生成图片列表
  Future<LogoEntity?> getLogo(CarouselReq req) async {
    try {
      final response = await _httpService.postForm('offline/device/info',
          data: FormData.fromMap(req.toMap())
      );
      final baseInfo = BaseResponseEntity<LogoEntity?>.fromJson(
        response.data is String ? response.data as dynamic : response.data as Map<String, dynamic>,
            (dynamic json) => LogoEntity.fromJson(json.cast<String, dynamic>())
      );
      // print('原始响应内容: ${response.data}');
      // final baseInfo = await BaseResponseEntity.fromJson(response.data, (json) async => LogoEntity.fromJson(json));
      // var baseInfo = BaseResponseEntity<LogoEntity>.fromJson(
      //   response.data, (json) async => LogoEntity.fromJson(json), // Provide the conversion function
      // );
      if (baseInfo.code == 0) {
        return baseInfo.data;
      } else {
        LoadingUtil.toast("获取Logo失败", baseInfo.msg, Theme.of(Get.context!).colorScheme.error);
        return null;
      }
    } catch (e, stackTrace) {
      print('请求异常: $e');
      print('堆栈跟踪: $stackTrace');
      return null;
    }
  }

  // 获取图片详细信息
  // Future<PhotoEntity?> getPhotoDetail(String photoId) async {
  //   try {
  //     final response = await _httpService.get(
  //       '$_baseUrl/detail/$photoId',
  //     );
  //     var baseInfo = BaseResponse<PhotoEntity>.fromJson(
  //       response.data,
  //           (json) => PhotoEntity.fromJson(json),
  //     );
  //     if (baseInfo.code == 0) {
  //       return baseInfo.data;
  //     } else {
  //       LoadingUtil.toast("获取详情失败", baseInfo.msg,
  //           Theme.of(Get.context!).colorScheme.error);
  //       return null;
  //     }
  //   } catch (e) {
  //     return null;
  //   }
  // }
}