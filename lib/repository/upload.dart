import 'dart:convert';
import 'dart:io'; // Needed for File operations / File 操作所需

import 'package:dio/dio.dart'; // Needed for FormData and MultipartFile / FormData 和 MultipartFile 所需
import 'package:flutter/material.dart'; // Needed for Theme access / Theme 访问所需
import 'package:get/get.dart' hide FormData, MultipartFile, Response; // Hide Dio's types to avoid conflicts / 隐藏 Dio 的类型以避免冲突
import 'package:http_parser/http_parser.dart'; // Needed for MediaType / MediaType 所需

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
  // --- Method Signature accepts File and Metadata ---
  // --- 方法签名接受 File 和 Metadata ---
  Future<UploadResultEntity?> uploadImage(File imageFile, UploadEntity metadata) async {

    // --- ADDED: Print image info just before creating FormData ---
    // --- 新增：在创建 FormData 之前打印图片信息 ---
    try {
      if (await imageFile.exists()) {
        final fileSize = await imageFile.length();
        final lastModified = await imageFile.lastModified();
        print("--- [UploadRepository] Preparing image File ---");
        print("  Path: ${imageFile.path}");
        print("  Size: $fileSize bytes (${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB)");
        print("  Last Modified: $lastModified");
        print("-------------------------------------------");
      } else {
        print("[UploadRepository] Error: Image file does not exist at path: ${imageFile.path}");
        LoadingUtil.toast("上传失败", "图片文件不存在", Theme.of(Get.context!).colorScheme.error);
        return null;
      }
    } catch (e) {
      print("[UploadRepository] Error getting image file info: $e");
      // Decide if you want to proceed even if info couldn't be read
      // 决定即使无法读取信息是否仍要继续
    }
    // --- End of added print statements ---


    try {
      // 2. Create FormData
      // 2. 创建 FormData
      String fileName = imageFile.path.split('/').last; // Extract filename from path / 从路径中提取文件名

      // *** Determine ContentType (Example: guessing based on extension) ***
      // *** 确定 ContentType（示例：根据扩展名猜测）***
      // You might need a more robust way (e.g., using the 'mime' package)
      // 您可能需要更健壮的方法（例如，使用 'mime' 包）
      String fileExtension = fileName.split('.').last.toLowerCase();
      MediaType? fileContentType;
      if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
        fileContentType = MediaType('image', 'jpeg');
      } else if (fileExtension == 'png') {
        fileContentType = MediaType('image', 'png');
      } else if (fileExtension == 'gif') {
        fileContentType = MediaType('image', 'gif');
      }
      // Add more types as needed, or use a package like 'mime'
      // 根据需要添加更多类型，或使用像 'mime' 这样的包
      print("[UploadRepository] Determined file Content-Type: ${fileContentType?.toString()}");


      // *** CRITICAL: Verify this key matches what Postman uses for the file ***
      // *** 关键：验证此键是否与 Postman 用于文件的键匹配 ***
      const String fileFormFieldName = "img"; // Or "image", "uploadFile", etc. / 或 "image"、"uploadFile" 等。

      MultipartFile multipartFile = await MultipartFile.fromFile(
        imageFile.path,
        filename: fileName,
        contentType: fileContentType, // Explicitly set Content-Type / 显式设置 Content-Type
      );

      Map<String, dynamic> formDataMap = {
        fileFormFieldName: multipartFile, // Use the verified key / 使用验证过的键
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

      // --- Enhanced Logging for FormData ---
      // --- 增强 FormData 日志记录 ---
      print("[UploadRepository] Preparing FormData:");
      formData.fields.forEach((entry) {
        print("  Field: ${entry.key} = ${entry.value}");
      });
      formData.files.forEach((entry) {
        print("  File: Key='${entry.key}', Filename='${entry.value.filename}', ContentType='${entry.value.contentType}', Length=${entry.value.length}");
      });
      print("----------------------------------");


      // 3. Make the POST request
      // 3. 发起 POST 请求
      // !!! Ensure this endpoint is correct !!!
      // !!! 确保此端点正确 !!!
      const String uploadEndpoint = '/offline/device/uploadImg/Lite';
      print('[UploadRepository] Uploading image to endpoint: $uploadEndpoint');

      // *** IMPORTANT: Check Headers in HttpService ***
      // *** 重要提示：检查 HttpService 中的 Headers ***
      // Ensure your _httpService includes necessary headers like 'Accept: application/json'
      // and any required 'Authorization' tokens. These are often set in Dio's BaseOptions.
      // 确保您的 _httpService 包含必要的 Headers，例如 'Accept: application/json'
      // 以及任何必需的 'Authorization' 令牌。这些通常在 Dio 的 BaseOptions 中设置。

      final response = await _httpService.postForm(
        uploadEndpoint,
        data: formData,
        onSendProgress: (int sent, int total) {
          if (total > 0) { // Avoid division by zero / 避免除以零
            // Optional: Debounce or throttle progress updates if needed
            // 可选：如果需要，对进度更新进行防抖或节流
            print('[UploadRepository] Upload progress: ${(sent / total * 100).toStringAsFixed(2)}% ($sent/$total bytes)');
          }
        },
        // Optional: Add specific options if needed, though HttpService should handle defaults
        // 可选：如果需要，添加特定选项，尽管 HttpService 应该处理默认值
        // options: Options(headers: {'Custom-Header': 'value'})
      );

      // 4. Parse the response
      // 4. 解析响应
      print('[UploadRepository] Upload response status code: ${response.statusCode}');
      // Log raw response data for debugging
      // 记录原始响应数据以进行调试
      print('[UploadRepository] Upload response raw data: ${response.data}');
      print('[UploadRepository] Upload response headers: ${response.headers}');


      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        // If response is a string, try to decode it as JSON
        // 如果响应是字符串，尝试将其解码为 JSON
        if ((response.data as String).isEmpty) {
          print('[UploadRepository] Error: Empty response body received.');
          LoadingUtil.toast("上传失败", "服务器响应为空", Theme.of(Get.context!).colorScheme.error); // Upload failed, Empty server response
          return null;
        }
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('[UploadRepository] Error decoding JSON response: $e');
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
        print('[UploadRepository] Error: Unexpected response data type: ${response.data.runtimeType}');
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
                print("[UploadRepository] Error converting 'data' field to UploadResultEntity: $e");
                return null; // Return null if conversion fails / 如果转换失败则返回 null
              }
            } else {
              // Log error if the 'data' field is not a map
              // 如果 'data' 字段不是 map，则记录错误
              print("[UploadRepository] Error: Expected 'data' field to be a Map<String, dynamic>, but got ${json.runtimeType}");
              return null; // Return null if type is wrong / 如果类型错误则返回 null
            }
          }
      );

      // 5. Handle result based on response code
      // 5. 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('[UploadRepository] Image uploaded successfully. Result: ${baseInfo.data?.toJson()}'); // Use toJson if available / 如果可用则使用 toJson
        // Show success message (optional) / 显示成功消息（可选）
        // LoadingUtil.toast("上传成功", "图片已成功上传", Colors.green); // Upload successful, Image uploaded successfully
        return baseInfo.data; // Return the parsed result data / 返回解析的结果数据
      } else {
        // Handle backend error based on code and message
        // 根据代码和消息处理后端错误
        print('[UploadRepository] Upload failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("上传失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Upload failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('[UploadRepository] DioException during upload: ${e.message}');
      print('[UploadRepository] DioException type: ${e.type}');
      // Log response data and headers from the error if available
      // 如果可用，记录错误中的响应数据和头信息
      print('[UploadRepository] DioException response data: ${e.response?.data}');
      print('[UploadRepository] DioException response headers: ${e.response?.headers}');
      String errorMessage = e.message ?? '无法连接服务器'; // Cannot connect to server
      // Provide more specific error messages based on DioExceptionType
      // 根据 DioExceptionType 提供更具体的错误消息
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout) {
        errorMessage = '网络超时，请检查连接'; // Network timeout, please check connection
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = '网络连接错误'; // Network connection error
      } else if (e.response != null) {
        // Use server message or status code if available
        // 如果可用，则使用服务器消息或状态码
        errorMessage = '服务器错误: ${e.response?.statusCode} - ${e.response?.data?.toString() ?? ''}'; // Server error
      }
      LoadingUtil.toast("网络错误", errorMessage, Theme.of(Get.context!).colorScheme.error); // Network error
      return null;
    } catch (e, stackTrace) {
      // Catch any other unexpected errors during the process
      // 捕获过程中的任何其他意外错误
      print('[UploadRepository] Generic exception during upload: $e');
      print('[UploadRepository] Stack trace: $stackTrace');
      LoadingUtil.toast("上传异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Upload exception
      return null;
    }
  }
}
