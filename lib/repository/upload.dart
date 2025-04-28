import 'dart:convert';
import 'dart:io'; // Needed for File operations / File 操作所需

import 'package:dio/dio.dart'; // Needed for FormData and MultipartFile / FormData 和 MultipartFile 所需
import 'package:flutter/material.dart'; // Needed for Theme access / Theme 访问所需
import 'package:get/get.dart' hide FormData, MultipartFile; // Hide Dio's types to avoid conflicts / 隐藏 Dio 的类型以避免冲突

// Import base response and entity models
// 导入基础响应和实体模型
// Adjust paths as necessary based on your project structure
// 根据您的项目结构调整必要的路径
import '../models/base_response.dart';
import '../models/upload_entity.dart'; // Keep for metadata / 保留用于元数据
import '../models/upload_result_entity.dart';

// Import HttpService and utilities
// 导入 HttpService 和工具类
// Adjust paths as necessary
// 调整必要的路径
import '../service/http_service.dart';
import '../utils/dialog_util.dart'; // For showing toasts/loading / 用于显示 toast/loading


/// Repository class for handling image upload operations.
/// 负责处理图片上传操作的 Repository 类。
class UploadRepository extends GetxService {
  // Dependency injection for HttpService
  // HttpService 的依赖注入
  late HttpService _httpService;

  /// Initializes the repository by finding the HttpService instance.
  /// 通过查找 HttpService 实例来初始化 repository。
  UploadRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }

  /// Uploads an image file and associated metadata to the backend.
  /// 将图片文件及关联元数据上传到后端。
  ///
  /// Takes the [File] object of the image and an [UploadEntity] containing metadata.
  /// 接收图片的 [File] 对象和包含元数据的 [UploadEntity]。
  /// Returns an [UploadResultEntity] upon success, or null on failure.
  /// 成功时返回 [UploadResultEntity]，失败时返回 null。
  // --- MODIFIED Method Signature ---
  // --- 修改后的方法签名 ---
  Future<UploadResultEntity?> uploadImage(File imageFile, UploadEntity metadata) async {
    // 1. Validate image file (optional, could be done before calling)
    // 1. 验证图片文件（可选，可在调用前完成）
    //    File existence check is implicitly handled by MultipartFile.fromFile,
    //    but you could add checks for file size or type here if needed.
    //    文件存在性检查由 MultipartFile.fromFile 隐式处理，
    //    但如果需要，您可以在此处添加文件大小或类型的检查。
    //    Example check (uncomment if needed):
    //    示例检查（如果需要，取消注释）：
    //    if (!await imageFile.exists()) { // Note: exists() is async / 注意：exists() 是异步的
    //       print('Error: Image file does not exist at path: ${imageFile.path}');
    //       LoadingUtil.toast("上传失败", "图片文件不存在", Theme.of(Get.context!).colorScheme.error); // Upload failed, Image file does not exist
    //       return null;
    //    }

    try {
      // 2. Create FormData
      // 2. 创建 FormData
      String fileName = imageFile.path.split('/').last; // Extract filename from path / 从路径中提取文件名
      Map<String, dynamic> formDataMap = {
        // Add the image file using MultipartFile directly from the passed File object
        // 直接从传入的 File 对象使用 MultipartFile 添加图片文件
        // *** Ensure the key "file" matches your backend API expectation ***
        // *** 确保键 "file" 与您的后端 API 期望匹配 ***
        "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
      };

      // Add other metadata fields from the metadata entity
      // 从元数据实体添加其他字段
      if (metadata.deviceId != null) formDataMap['deviceId'] = metadata.deviceId;
      if (metadata.source != null) formDataMap['source'] = metadata.source;
      // if (metadata.userId != null) formDataMap['userId'] = metadata.userId; // Uncomment if needed / 如果需要，取消注释
      if (metadata.type != null) formDataMap['type'] = metadata.type;
      // Note: metadata.img is NOT added here, as the file is sent separately.
      // 注意：metadata.img 未在此处添加，因为文件是分开发送的。

      FormData formData = FormData.fromMap(formDataMap);

      // 3. Make the POST request
      // 3. 发起 POST 请求
      // !!! Replace '/offline/device/uploadImg/Lite' with your actual API endpoint !!!
      // !!! 将 '/offline/device/uploadImg/Lite' 替换为你的实际 API 端点 !!!
      const String uploadEndpoint = '/offline/device/uploadImg/Lite';
      print('Uploading image to endpoint: $uploadEndpoint');
      print('FormData fields: ${formData.fields}'); // Log form fields being sent / 记录发送的表单字段
      // print('FormData files: ${formData.files}'); // Use carefully, might log large data / 谨慎使用，可能会记录大量数据

      final response = await _httpService.postForm(
        uploadEndpoint,
        data: formData,
        // Optional: Add progress tracking if needed
        // 可选：如果需要，添加进度跟踪
        // onSendProgress: (int sent, int total) {
        //   if (total > 0) { // Avoid division by zero / 避免除以零
        //      print('Upload progress: ${(sent / total * 100).toStringAsFixed(2)}%');
        //   }
        // },
      );

      // 4. Parse the response
      // 4. 解析响应
      print('Upload response status code: ${response.statusCode}');
      print('Upload response raw data: ${response.data}'); // Log raw response / 记录原始响应

      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        // If response is a string, try to decode it as JSON
        // 如果响应是字符串，尝试将其解码为 JSON
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('Error decoding JSON response: $e');
          LoadingUtil.toast("上传失败", "服务器响应格式错误", Theme.of(Get.context!).colorScheme.error); // Upload failed, Server response format error
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        // If response is already a map, use it directly
        // 如果响应已经是 map，则直接使用
        responseDataJson = response.data;
      } else {
        // Handle unexpected response types
        // 处理意外的响应类型
        print('Error: Unexpected response data type: ${response.data.runtimeType}');
        LoadingUtil.toast("上传失败", "服务器响应类型未知", Theme.of(Get.context!).colorScheme.error); // Upload failed, Unknown server response type
        return null;
      }


      // Use BaseResponseEntity for standardized response structure
      // 对标准化响应结构使用 BaseResponseEntity
      final baseInfo = BaseResponseEntity<UploadResultEntity?>.fromJson(
          responseDataJson,
          // Provide the function to convert the inner 'data' json to UploadResultEntity
          // 提供将内部 'data' json 转换为 UploadResultEntity 的函数
              (dynamic json) {
            if (json == null) return null; // Handle null data field / 处理 null 数据字段
            // Ensure the json passed here is the actual data map for UploadResultEntity
            // 确保此处传递的 json 是 UploadResultEntity 的实际数据 map
            if (json is Map<String, dynamic>) {
              try {
                // Attempt to convert the map to UploadResultEntity
                // 尝试将 map 转换为 UploadResultEntity
                return UploadResultEntity.fromJson(json);
              } catch (e) {
                // Log error if conversion fails
                // 如果转换失败，则记录错误
                print("Error converting 'data' field to UploadResultEntity: $e");
                return null; // Return null if conversion fails / 如果转换失败则返回 null
              }
            } else {
              // Log error if the 'data' field is not a map
              // 如果 'data' 字段不是 map，则记录错误
              print("Error: Expected 'data' field to be a Map<String, dynamic>, but got ${json.runtimeType}");
              return null; // Return null if type is wrong / 如果类型错误则返回 null
            }
          }
      );

      // 5. Handle result based on response code
      // 5. 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('Image uploaded successfully. Result: ${baseInfo.data?.toJson()}'); // Use toJson if available / 如果可用则使用 toJson
        // Show success message (optional) / 显示成功消息（可选）
        // LoadingUtil.toast("上传成功", "图片已成功上传", Colors.green); // Upload successful, Image uploaded successfully
        return baseInfo.data; // Return the parsed result data / 返回解析的结果数据
      } else {
        // Handle backend error based on code and message
        // 根据代码和消息处理后端错误
        print('Upload failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("上传失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Upload failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('DioException during upload: ${e.message}');
      print('DioException type: ${e.type}');
      print('DioException response: ${e.response?.data}');
      String errorMessage = e.message ?? '无法连接服务器'; // Cannot connect to server
      // Provide more specific error messages based on DioExceptionType
      // 根据 DioExceptionType 提供更具体的错误消息
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout) {
        errorMessage = '网络超时，请检查连接'; // Network timeout, please check connection
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = '网络连接错误'; // Network connection error
      } else if (e.response != null) {
        // Use server message if available
        // 如果可用，则使用服务器消息
        errorMessage = '服务器错误: ${e.response?.statusCode}'; // Server error
      }
      LoadingUtil.toast("网络错误", errorMessage, Theme.of(Get.context!).colorScheme.error); // Network error
      return null;
    } catch (e, stackTrace) {
      // Catch any other unexpected errors during the process
      // 捕获过程中的任何其他意外错误
      print('Generic exception during upload: $e');
      print('Stack trace: $stackTrace');
      LoadingUtil.toast("上传异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Upload exception
      return null;
    }
  }
}
