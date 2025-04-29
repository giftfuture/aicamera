// Assume this file is located at repositories/genprogress_repository.dart
// 假设此文件位于 repositories/genprogress_repository.dart

import 'dart:convert'; // For jsonDecode if needed / 如果需要 jsonDecode 则导入

import 'package:dio/dio.dart'; // For FormData / FormData 所需
import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart' hide FormData, Response; // Hide Dio's types / 隐藏 Dio 的类型

// Import your project's models and services
// 导入您项目的模型和服务
// Adjust paths as necessary based on your project structure
// 根据您的项目结构调整必要的路径
import '../models/base_response.dart'; // Base response structure / 基础响应结构
// Input parameter is just an ID, not a full entity
// 输入参数只是一个 ID，不是完整的实体
import '../models/genprogress_entity.dart'; // Output entity / 输出实体
import '../service/http_service.dart'; // HTTP service / HTTP 服务
import '../utils/dialog_util.dart'; // Utility for showing toasts / 显示 toast 的工具类

/// Repository class for handling Generation Progress operations.
/// 负责处理生成进度操作的 Repository 类。
class GenProgressRepository extends GetxService {
  // Dependency injection for HttpService
  // HttpService 的依赖注入
  late HttpService _httpService;

  /// Initializes the repository by finding the HttpService instance.
  /// 通过查找 HttpService 实例来初始化 repository。
  GenProgressRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }

  /// Fetches the generation progress/status from the backend.
  /// 从后端获取生成进度/状态。
  ///
  /// Takes the generation ID [genId] as input.
  /// 接收生成 ID [genId] 作为输入。
  /// Returns a [GenProgressEntity] upon success, or null on failure.
  /// 成功时返回 [GenProgressEntity]，失败时返回 null。
  Future<GenProgressEntity?> getProgress(int genId) async {
    // Define the API endpoint
    // 定义 API 端点
    const String progressEndpoint = 'offline/device/genProgress'; // Use the provided URL / 使用提供的 URL

    try {
      // Log the request data being sent
      // 记录正在发送的请求数据
      print('[GenProgressRepository] Sending request to $progressEndpoint');
      final requestDataMap = {'genId': genId.toString()}; // Pass genId as String for form data / 将 genId 作为 String 传递给表单数据
      print('[GenProgressRepository] Request data map: $requestDataMap');

      // Make the POST request using postForm (as per the template)
      // 使用 postForm 发起 POST 请求 (根据模板)
      // Note: A GET request with query parameters might be more conventional for fetching status.
      // 注意：对于获取状态，使用带查询参数的 GET 请求可能更常规。
      // Example GET: final response = await _httpService.get(progressEndpoint, queryParameters: {'genId': genId});
      final response = await _httpService.postForm(
          progressEndpoint,
          data: FormData.fromMap(requestDataMap) // Send genId as form data / 将 genId 作为表单数据发送
      );

      // Log the raw response
      // 记录原始响应
      print('[GenProgressRepository] Response status code: ${response.statusCode}');
      print('[GenProgressRepository] Response raw data: ${response.data}');

      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        if ((response.data as String).isEmpty) {
          print('[GenProgressRepository] Error: Empty response body received.');
          // Don't show toast for progress checks, just return null or handle silently
          // 对进度检查不显示 toast，仅返回 null 或静默处理
          return null;
        }
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('[GenProgressRepository] Error decoding JSON response: $e');
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        responseDataJson = response.data;
      } else {
        print('[GenProgressRepository] Error: Unexpected response data type: ${response.data.runtimeType}');
        return null;
      }

      // Parse the response using BaseResponseEntity (assuming the 'data' field holds the GenProgressEntity)
      // 使用 BaseResponseEntity 解析响应 (假设 'data' 字段包含 GenProgressEntity)
      // Ensure BaseResponseEntity and GenProgressEntity.fromJson are correctly implemented
      // 确保 BaseResponseEntity 和 GenProgressEntity.fromJson 已正确实现
      final baseInfo = BaseResponseEntity<GenProgressEntity?>.fromJson(
          responseDataJson,
          // Provide the function to convert the inner 'data' json to GenProgressEntity
          // 提供将内部 'data' json 转换为 GenProgressEntity 的函数
              (dynamic json) {
            if (json == null) return null;
            if (json is Map<String, dynamic>) {
              try {
                // Use the generated factory constructor
                // 使用生成的工厂构造函数
                return GenProgressEntity.fromJson(json);
              } catch (e) {
                print("[GenProgressRepository] Error converting 'data' field to GenProgressEntity: $e");
                return null;
              }
            } else {
              print("[GenProgressRepository] Error: Expected 'data' field to be a Map<String, dynamic>, but got ${json.runtimeType}");
              return null;
            }
          }
      );

      // Handle result based on the response code
      // 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('[GenProgressRepository] Progress fetched successfully. Status: ${baseInfo.data?.status}');
        return baseInfo.data; // Return the parsed result data / 返回解析的结果数据
      } else {
        // Handle backend error - maybe don't show toast for polling checks
        // 处理后端错误 - 轮询检查时可能不显示 toast
        print('[GenProgressRepository] Fetch progress failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        // LoadingUtil.toast("获取失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Fetch failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('[GenProgressRepository] DioException during progress request: ${e.message}');
      // Don't show toast for network errors during polling?
      // 轮询期间的网络错误是否显示 toast？
      // LoadingUtil.toast("网络错误", e.message ?? '无法连接服务器', Theme.of(Get.context!).colorScheme.error); // Network error
      return null;
    } catch (e, stackTrace) {
      // Catch any other unexpected errors
      // 捕获任何其他意外错误
      print('[GenProgressRepository] Generic exception during progress request: $e');
      print('[GenProgressRepository] Stack trace: $stackTrace');
      // LoadingUtil.toast("获取异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Fetch exception
      return null;
    }
  }

// Add other repository methods if needed
// 如果需要，添加其他 repository 方法
}
