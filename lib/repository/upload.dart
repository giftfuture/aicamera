import 'dart:convert';
import 'package:dio/dio.dart';
import 'dart:io'; // Needed for File operations
import 'package:get/get.dart' hide FormData,MultipartFile;
import 'package:http_parser/http_parser.dart';
import 'package:aicamera/generated/json/logo_entity.g.dart';
import 'package:dio/dio.dart'; // Needed for FormData and MultipartFile
import 'package:flutter/material.dart';
import 'package:aicamera/models/base_response.dart';
import 'package:aicamera/models/photo_entity.dart';
import 'package:aicamera/models/carousel_req.dart';
import 'package:aicamera/service/http_service.dart';
import 'package:aicamera/utils/dialog_util.dart';

// Import your new entity models
import 'package:aicamera/models/upload_entity.dart';         // Adjust path if needed
import 'package:aicamera/models/upload_result_entity.dart'; // Adjust path if needed

import '../models/logo_entity.dart';

class UploadRepository extends GetxService {
  late HttpService _httpService;

  UploadRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }


  // --- 新增：上传图片方法 ---
  /// Uploads an image and associated data.
  ///
  /// Takes an [UploadEntity] containing the image path and other details.
  /// Returns an [UploadResultEntity] upon success, or null on failure.
  Future<UploadResultEntity?> uploadImage(UploadEntity req) async {
    // 1. Validate image path
    if (req.imgPath == null || req.imgPath!.isEmpty) {
      print('Error: Image path is null or empty.');
      LoadingUtil.toast("上传失败", "图片路径无效", Theme.of(Get.context!).colorScheme.error);
      return null;
    }

    File imageFile = File(req.imgPath!);
    if (!await imageFile.exists()) {
      print('Error: Image file does not exist at path: ${req.imgPath}');
      LoadingUtil.toast("上传失败", "图片文件不存在", Theme.of(Get.context!).colorScheme.error);
      return null;
    }

    try {
      // 2. Create FormData
      String fileName = imageFile.path.split('/').last;
      Map<String, dynamic> formDataMap = {
        // Add the image file using MultipartFile
        'img': await MultipartFile.fromFile(imageFile.path, filename: fileName),
      };

      // Add other fields from req if they are not null
      if (req.deviceId != null) formDataMap['deviceId'] = req.deviceId;
      if (req.source != null) formDataMap['source'] = req.source;
      if (req.userId != null) formDataMap['userId'] = req.userId;
      if (req.type != null) formDataMap['type'] = req.type;

      FormData formData = FormData.fromMap(formDataMap);

      // 3. Make the POST request
      // !!! Replace 'upload/image' with your actual API endpoint !!!
      const String uploadEndpoint = 'upload/image';
      print('Uploading image to endpoint: $uploadEndpoint with data: ${formData.fields}');

      final response = await _httpService.postForm(
        uploadEndpoint,
        data: formData,
        // Optional: Add progress tracking if needed
        // onSendProgress: (int sent, int total) {
        //   print('Upload progress: ${(sent / total * 100).toStringAsFixed(2)}%');
        // },
      );

      // 4. Parse the response
      print('Upload response raw data: ${response.data}');
      final responseData = response.data is String
          ? jsonDecode(response.data) // Decode if it's a JSON string
          : response.data as Map<String, dynamic>; // Assume it's a map

      // Use BaseResponseEntity for single object response
      final baseInfo = BaseResponseEntity<UploadResultEntity?>.fromJson(
          responseData,
          // Provide the function to convert the inner 'data' json to UploadResultEntity
              (dynamic json) {
            if (json == null) return null;
            // Ensure the json passed here is the actual data map for UploadResultEntity
            return UploadResultEntity.fromJson(json as Map<String, dynamic>);
          }
      );

      // 5. Handle result
      if (baseInfo.code == 0) {
        print('Image uploaded successfully. Result: ${baseInfo.data}');
        return baseInfo.data;
      } else {
        print('Upload failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("上传失败", baseInfo.msg ?? '未知错误', Theme.of(Get.context!).colorScheme.error);
        return null;
      }
    } catch (e, stackTrace) {
      print('Upload request exception: $e');
      print('Stack trace: $stackTrace');
      LoadingUtil.toast("上传异常", e.toString(), Theme.of(Get.context!).colorScheme.error);
      return null;
    }
  }

}
