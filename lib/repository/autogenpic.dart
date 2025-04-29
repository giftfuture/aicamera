// Assume this file is located at repositories/autogenpic_repository.dart
// 假设此文件位于 repositories/autogenpic_repository.dart

import 'dart:convert'; // For jsonDecode if needed / 如果需要 jsonDecode 则导入

import 'package:dio/dio.dart'; // For FormData / FormData 所需
import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart' hide FormData, Response; // Hide Dio's types / 隐藏 Dio 的类型

// Import your project's models and services
// 导入您项目的模型和服务
// Adjust paths as necessary / 根据需要调整路径
import '../models/base_response.dart'; // Base response structure / 基础响应结构
import '../models/autogenpic_entity.dart'; // Input entity / 输入实体
import '../models/autogenpic_result.entity.dart'; // Output entity / 输出实体
import '../service/http_service.dart'; // HTTP service / HTTP 服务
import '../utils/dialog_util.dart'; // Utility for showing toasts / 显示 toast 的工具类

/// Repository class for handling AutoGenPic operations.
/// 负责处理 AutoGenPic 操作的 Repository 类。
class AutoGenPicRepository extends GetxService {
  // Dependency injection for HttpService
  // HttpService 的依赖注入
  late HttpService _httpService;

  /// Initializes the repository by finding the HttpService instance.
  /// 通过查找 HttpService 实例来初始化 repository。
  AutoGenPicRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }

  /// Calls the API to generate a picture based on the provided parameters.
  /// 调用 API 以根据提供的参数生成图片。
  ///
  /// Takes an [AutoGenPicEntity] containing the request parameters.
  /// 接收包含请求参数的 [AutoGenPicEntity]。
  /// Returns an [AutoGenPicResultEntity] upon success, or null on failure.
  /// 成功时返回 [AutoGenPicResultEntity]，失败时返回 null。
  Future<AutoGenPicResultEntity?> generatePicture(AutoGenPicEntity req) async {
    // !!! IMPORTANT: Replace with your actual API endpoint for picture generation !!!
    // !!! 重要提示：请替换为您的实际图片生成 API 端点 !!!
    const String generationEndpoint = '/autogen/generate'; // Example endpoint / 示例端点

    try {
      // Log the request data being sent
      // 记录正在发送的请求数据
      print('[AutoGenPicRepository] Sending request to $generationEndpoint');
      print('[AutoGenPicRepository] Request data: ${req.toJson()}');

      // Make the POST request using postForm, assuming the API expects form data
      // 使用 postForm 发起 POST 请求，假设 API 期望表单数据
      final response = await _httpService.postForm(
          generationEndpoint,
          data: FormData.fromMap(req.toJson()) // Convert entity to map for FormData / 将实体转换为 map 用于 FormData
      );

      // Log the raw response
      // 记录原始响应
      print('[AutoGenPicRepository] Response status code: ${response.statusCode}');
      print('[AutoGenPicRepository] Response raw data: ${response.data}');

      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        if ((response.data as String).isEmpty) {
          print('[AutoGenPicRepository] Error: Empty response body received.');
          LoadingUtil.toast("生成失败", "服务器响应为空", Theme.of(Get.context!).colorScheme.error); // Generation failed, Empty server response
          return null;
        }
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('[AutoGenPicRepository] Error decoding JSON response: $e');
          LoadingUtil.toast("生成失败", "服务器响应格式错误", Theme.of(Get.context!).colorScheme.error); // Generation failed, Server response format error
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        responseDataJson = response.data;
      } else {
        print('[AutoGenPicRepository] Error: Unexpected response data type: ${response.data.runtimeType}');
        LoadingUtil.toast("生成失败", "服务器响应类型未知", Theme.of(Get.context!).colorScheme.error); // Generation failed, Unknown server response type
        return null;
      }

      // Parse the response using the base response structure
      // 使用基础响应结构解析响应
      final baseInfo = BaseResponseEntity<AutoGenPicResultEntity?>.fromJson(
          responseDataJson,
          // Provide the function to convert the inner 'data' json to AutoGenPicResultEntity
          // 提供将内部 'data' json 转换为 AutoGenPicResultEntity 的函数
              (dynamic json) {
            if (json == null) return null;
            if (json is Map<String, dynamic>) {
              try {
                return AutoGenPicResultEntity.fromJson(json);
              } catch (e) {
                print("[AutoGenPicRepository] Error converting 'data' field to AutoGenPicResultEntity: $e");
                return null;
              }
            } else {
              print("[AutoGenPicRepository] Error: Expected 'data' field to be a Map<String, dynamic>, but got ${json.runtimeType}");
              return null;
            }
          }
      );

      // Handle result based on the response code
      // 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('[AutoGenPicRepository] Picture generation request successful. Result: ${baseInfo.data}');
        return baseInfo.data; // Return the parsed result data / 返回解析的结果数据
      } else {
        // Handle backend error
        // 处理后端错误
        print('[AutoGenPicRepository] Picture generation failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("生成失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Generation failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('[AutoGenPicRepository] DioException during generation request: ${e.message}');
      print('[AutoGenPicRepository] DioException type: ${e.type}');
      print('[AutoGenPicRepository] DioException response data: ${e.response?.data}');
      String errorMessage = e.message ?? '无法连接服务器'; // Cannot connect to server
      if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.sendTimeout || e.type == DioExceptionType.receiveTimeout) {
        errorMessage = '网络超时，请检查连接'; // Network timeout, please check connection
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = '网络连接错误'; // Network connection error
      } else if (e.response != null) {
        errorMessage = '服务器错误: ${e.response?.statusCode} - ${e.response?.data?.toString() ?? ''}'; // Server error
      }
      LoadingUtil.toast("网络错误", errorMessage, Theme.of(Get.context!).colorScheme.error); // Network error
      return null;
    } catch (e, stackTrace) {
      // Catch any other unexpected errors
      // 捕获任何其他意外错误
      print('[AutoGenPicRepository] Generic exception during generation request: $e');
      print('[AutoGenPicRepository] Stack trace: $stackTrace');
      LoadingUtil.toast("生成异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Generation exception
      return null;
    }
  }

// Add other repository methods related to AutoGenPic if needed
// 如果需要，添加与 AutoGenPic 相关的其他 repository 方法
}
