// Assume this file is located at repositories/category_sub_repository.dart
// 假设此文件位于 repositories/category_sub_repository.dart

import 'dart:convert'; // For jsonDecode if needed / 如果需要 jsonDecode 则导入

import 'package:dio/dio.dart'; // For FormData / FormData 所需
import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart' hide FormData, Response; // Hide Dio's types / 隐藏 Dio 的类型

// Import your project's models and services
// 导入您项目的模型和服务
// Adjust paths as necessary based on your project structure
// 根据您的项目结构调整必要的路径
import '../models/base_response.dart'; // Base response structure / 基础响应结构
import '../models/category_sub_entity.dart'; // Input entity / 输入实体
import '../models/category_sub_entity_result.dart'; // Output entity (for list items) / 输出实体 (用于列表项)
import '../service/http_service.dart'; // HTTP service / HTTP 服务
import '../utils/dialog_util.dart'; // Utility for showing toasts / 显示 toast 的工具类

/// Repository class for handling Sub-Category list operations.
/// 负责处理子分类列表操作的 Repository 类。
class CategorySubRepository extends GetxService {
  // Dependency injection for HttpService
  // HttpService 的依赖注入
  late HttpService _httpService;

  /// Initializes the repository by finding the HttpService instance.
  /// 通过查找 HttpService 实例来初始化 repository。
  CategorySubRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }

  /// Fetches the sub-category list from the backend.
  /// 从后端获取子分类列表。
  ///
  /// Takes a [CategorySubEntity] containing the request parameters.
  /// 接收包含请求参数的 [CategorySubEntity]。
  /// Returns a List of [CategorySubEntityResult] upon success, or null on failure.
  /// 成功时返回 [CategorySubEntityResult] 列表，失败时返回 null。
  Future<List<CategorySubEntityResult>?> getCategoryList(CategorySubEntity req) async {
    // Define the API endpoint
    // 定义 API 端点
    const String categoryListEndpoint = 'photoTpl/categoryList'; // Use the provided URL / 使用提供的 URL

    try {
      // Log the request data being sent
      // 记录正在发送的请求数据
      print('[CategorySubRepository] Sending request to $categoryListEndpoint');
      final requestDataMap = req.toJson();
      print('[CategorySubRepository] Request data map: $requestDataMap');

      // Make the POST request using postForm (as per the template)
      // 使用 postForm 发起 POST 请求 (根据模板)
      // If your API expects JSON, use _httpService.post instead
      // 如果您的 API 期望 JSON, 请改用 _httpService.post
      final response = await _httpService.postForm(
          categoryListEndpoint,
          data: FormData.fromMap(requestDataMap) // Convert entity map to FormData / 将实体 map 转换为 FormData
      );

      // Log the raw response
      // 记录原始响应
      print('[CategorySubRepository] Response status code: ${response.statusCode}');
      print('[CategorySubRepository] Response raw data: ${response.data}');

      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        if ((response.data as String).isEmpty) {
          print('[CategorySubRepository] Error: Empty response body received.');
          LoadingUtil.toast("获取失败", "服务器响应为空", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Empty server response
          return null;
        }
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('[CategorySubRepository] Error decoding JSON response: $e');
          LoadingUtil.toast("获取失败", "服务器响应格式错误", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Server response format error
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        responseDataJson = response.data;
      } else {
        print('[CategorySubRepository] Error: Unexpected response data type: ${response.data.runtimeType}');
        LoadingUtil.toast("获取失败", "服务器响应类型未知", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Unknown server response type
        return null;
      }

      // Parse the response using BaseResponseList (assuming the 'data' field is a list)
      // 使用 BaseResponseList 解析响应 (假设 'data' 字段是一个列表)
      // Ensure BaseResponseList and CategorySubEntityResult.fromJson are correctly implemented
      // 确保 BaseResponseList 和 CategorySubEntityResult.fromJson 已正确实现
      final baseInfo = BaseResponseList<CategorySubEntityResult>.fromJson(
          responseDataJson,
          // Provide the function to convert each item in the list
          // 提供转换列表中每个项目的函数
              (dynamic json) {
            if (json is Map<String, dynamic>) {
              try {
                // Use the generated factory constructor for list items
                // 对列表项使用生成的工厂构造函数
                return CategorySubEntityResult.fromJson(json);
              } catch (e) {
                print("[CategorySubRepository] Error converting list item to CategorySubEntityResult: $e");
                // Return a default/null object or throw, depending on desired handling
                // 根据期望的处理方式返回默认/null对象或抛出异常
                return CategorySubEntityResult(); // Example: return default object
              }
            } else {
              print("[CategorySubRepository] Error: Expected list item to be a Map<String, dynamic>, but got ${json.runtimeType}");
              return CategorySubEntityResult(); // Example: return default object
            }
          }
      );

      // Handle result based on the response code
      // 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('[CategorySubRepository] Sub-Category list fetched successfully. Count: ${baseInfo.data?.length ?? 0}');
        return baseInfo.data; // Return the list of results / 返回结果列表
      } else {
        // Handle backend error
        // 处理后端错误
        print('[CategorySubRepository] Fetch sub-category list failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("获取失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Fetch failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('[CategorySubRepository] DioException during sub-category list request: ${e.message}');
      print('[CategorySubRepository] DioException type: ${e.type}');
      print('[CategorySubRepository] DioException response data: ${e.response?.data}');
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
      print('[CategorySubRepository] Generic exception during sub-category list request: $e');
      print('[CategorySubRepository] Stack trace: $stackTrace');
      LoadingUtil.toast("获取异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Fetch exception
      return null;
    }
  }

// Add other repository methods related to Sub-Categories if needed
// 如果需要，添加与子分类相关的其他 repository 方法
}
