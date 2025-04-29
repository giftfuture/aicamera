// Assume this file is located at repositories/startgen_repository.dart
// 假设此文件位于 repositories/startgen_repository.dart

import 'dart:convert'; // For jsonDecode if needed / 如果需要 jsonDecode 则导入

import 'package:dio/dio.dart'; // For FormData / FormData 所需
import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart' hide FormData, Response; // Hide Dio's types / 隐藏 Dio 的类型

// Import your project's models and services
// 导入您项目的模型和服务
// Adjust paths as necessary based on your project structure
// 根据您的项目结构调整必要的路径
import '../models/base_response.dart'; // Base response structure / 基础响应结构
import '../models/startgen_entity.dart'; // Input entity / 输入实体
import '../models/startgen_result_entity.dart'; // Output entity / 输出实体
import '../service/http_service.dart'; // HTTP service / HTTP 服务
import '../utils/dialog_util.dart'; // Utility for showing toasts / 显示 toast 的工具类

/// Repository class for handling the start generation request.
/// 负责处理启动生成请求的 Repository 类。
class StartGenRepository extends GetxService {
  // Dependency injection for HttpService
  // HttpService 的依赖注入
  late HttpService _httpService;

  /// Initializes the repository by finding the HttpService instance.
  /// 通过查找 HttpService 实例来初始化 repository。
  StartGenRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }

  /// Sends the request to start the image generation process.
  /// 发送请求以启动图片生成过程。
  ///
  /// Takes a [StartGenEntity] containing the generation parameters.
  /// 接收包含生成参数的 [StartGenEntity]。
  /// Returns a [StartGenResultEntity] containing the task ID and estimated time upon success, or null on failure.
  /// 成功时返回包含任务ID和预估时间的 [StartGenResultEntity]，失败时返回 null。
  Future<StartGenResultEntity?> startGeneration(StartGenEntity req) async {
    // Define the API endpoint for starting generation
    // 定义启动生成的 API 端点
    const String startGenEndpoint = 'fast/portrait/startGen'; // Use the provided URL / 使用提供的 URL

    try {
      // Log the request data being sent
      // 记录正在发送的请求数据
      print('[StartGenRepository] Sending request to $startGenEndpoint');
      final requestDataMap = req.toJson();
      // Remove null values if the API doesn't expect them
      // 如果 API 不期望 null 值，则移除它们
      requestDataMap.removeWhere((key, value) => value == null);
      print('[StartGenRepository] Request data map: $requestDataMap');

      // Make the POST request using postForm (as per the template)
      // 使用 postForm 发起 POST 请求 (根据模板)
      // If your API expects JSON body, use _httpService.post instead
      // 如果您的 API 期望 JSON body, 请改用 _httpService.post
      final response = await _httpService.postForm(
          startGenEndpoint,
          data: FormData.fromMap(requestDataMap) // Convert entity map to FormData / 将实体 map 转换为 FormData
      );

      // Log the raw response
      // 记录原始响应
      print('[StartGenRepository] Response status code: ${response.statusCode}');
      print('[StartGenRepository] Response raw data: ${response.data}');

      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        if ((response.data as String).isEmpty) {
          print('[StartGenRepository] Error: Empty response body received.');
          LoadingUtil.toast("启动生成失败", "服务器响应为空", Theme.of(Get.context!).colorScheme.error); // Start generation failed, Empty server response
          return null;
        }
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('[StartGenRepository] Error decoding JSON response: $e');
          LoadingUtil.toast("启动生成失败", "服务器响应格式错误", Theme.of(Get.context!).colorScheme.error); // Start generation failed, Server response format error
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        responseDataJson = response.data;
      } else {
        print('[StartGenRepository] Error: Unexpected response data type: ${response.data.runtimeType}');
        LoadingUtil.toast("启动生成失败", "服务器响应类型未知", Theme.of(Get.context!).colorScheme.error); // Start generation failed, Unknown server response type
        return null;
      }

      // Parse the response using BaseResponseEntity (assuming the 'data' field holds the StartGenResultEntity)
      // 使用 BaseResponseEntity 解析响应 (假设 'data' 字段包含 StartGenResultEntity)
      // Ensure BaseResponseEntity and StartGenResultEntity.fromJson are correctly implemented
      // 确保 BaseResponseEntity 和 StartGenResultEntity.fromJson 已正确实现
      final baseInfo = BaseResponseEntity<StartGenResultEntity?>.fromJson(
          responseDataJson,
          // Provide the function to convert the inner 'data' json to StartGenResultEntity
          // 提供将内部 'data' json 转换为 StartGenResultEntity 的函数
              (dynamic json) {
            if (json == null) return null;
            if (json is Map<String, dynamic>) {
              try {
                // Use the generated factory constructor
                // 使用生成的工厂构造函数
                return StartGenResultEntity.fromJson(json);
              } catch (e) {
                print("[StartGenRepository] Error converting 'data' field to StartGenResultEntity: $e");
                return null;
              }
            } else {
              print("[StartGenRepository] Error: Expected 'data' field to be a Map<String, dynamic>, but got ${json.runtimeType}");
              return null;
            }
          }
      );

      // Handle result based on the response code
      // 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('[StartGenRepository] Start generation request successful. Result: ${baseInfo.data?.toJson()}');
        return baseInfo.data; // Return the parsed result data / 返回解析的结果数据
      } else {
        // Handle backend error
        // 处理后端错误
        print('[StartGenRepository] Start generation failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("启动生成失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Start generation failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('[StartGenRepository] DioException during start generation request: ${e.message}');
      print('[StartGenRepository] DioException type: ${e.type}');
      print('[StartGenRepository] DioException response data: ${e.response?.data}');
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
      print('[StartGenRepository] Generic exception during start generation request: $e');
      print('[StartGenRepository] Stack trace: $stackTrace');
      LoadingUtil.toast("请求异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Request exception
      return null;
    }
  }

// Add other repository methods if needed
// 如果需要，添加其他 repository 方法
}
