// Assume this file is located at repositories/template_repository.dart
// 假设此文件位于 repositories/template_repository.dart

import 'dart:convert'; // For jsonDecode if needed / 如果需要 jsonDecode 则导入

import 'package:dio/dio.dart'; // For FormData / FormData 所需
import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart' hide FormData, Response; // Hide Dio's types / 隐藏 Dio 的类型

// Import your project's models and services
// 导入您项目的模型和服务
// Adjust paths as necessary based on your project structure
// 根据您的项目结构调整必要的路径
import '../models/base_response.dart'; // Base response structure / 基础响应结构
import '../models/template_entity.dart'; // Input entity / 输入实体
import '../models/template_result_entity.dart'; // Output entity (for list items) / 输出实体 (用于列表项)
import '../service/http_service.dart'; // HTTP service / HTTP 服务
import '../utils/dialog_util.dart'; // Utility for showing toasts / 显示 toast 的工具类

/// Repository class for handling Template list operations.
/// 负责处理模板列表操作的 Repository 类。
class TemplateRepository extends GetxService {
  // Dependency injection for HttpService
  // HttpService 的依赖注入
  late HttpService _httpService;

  /// Initializes the repository by finding the HttpService instance.
  /// 通过查找 HttpService 实例来初始化 repository。
  TemplateRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }

  /// Fetches the template list from the backend based on category and pagination.
  /// 根据分类和分页从后端获取模板列表。
  ///
  /// Takes a [TemplateEntity] containing the request parameters.
  /// 接收包含请求参数的 [TemplateEntity]。
  /// Returns a List of [TemplateResultEntity] upon success, or null on failure.
  /// 成功时返回 [TemplateResultEntity] 列表，失败时返回 null。
  Future<List<TemplateResultEntity>?> getTemplateList(TemplateEntity req) async {
    // Endpoint for the standard template list
    // 标准模板列表的端点
    const String templateListEndpoint = 'photoTpl/templateList';

    try {
      // Log the request data being sent
      // 记录正在发送的请求数据
      print('[TemplateRepository] Sending request to $templateListEndpoint');
      final requestDataMap = req.toJson();
      print('[TemplateRepository] Request data map: $requestDataMap');

      // Make the POST request using postForm (as per the template)
      // 使用 postForm 发起 POST 请求 (根据模板)
      final response = await _httpService.postForm(
          templateListEndpoint,
          data: FormData.fromMap(requestDataMap) // Convert entity map to FormData / 将实体 map 转换为 FormData
      );

      // Log the raw response
      // 记录原始响应
      print('[TemplateRepository] Response status code: ${response.statusCode}');
      print('[TemplateRepository] Response raw data: ${response.data}');

      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        if ((response.data as String).isEmpty) {
          print('[TemplateRepository] Error: Empty response body received.');
          LoadingUtil.toast("获取失败", "服务器响应为空", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Empty server response
          return null;
        }
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('[TemplateRepository] Error decoding JSON response: $e');
          LoadingUtil.toast("获取失败", "服务器响应格式错误", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Server response format error
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        responseDataJson = response.data;
      } else {
        print('[TemplateRepository] Error: Unexpected response data type: ${response.data.runtimeType}');
        LoadingUtil.toast("获取失败", "服务器响应类型未知", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Unknown server response type
        return null;
      }

      // Parse the response using BaseResponseList
      // 使用 BaseResponseList 解析响应
      final baseInfo = BaseResponseList<TemplateResultEntity>.fromJson(responseDataJson);
      // final baseInfo = BaseResponseList<TemplateResultEntity>.fromJson(
      //     responseDataJson,
      //         (dynamic json) {
      //       if (json is Map<String, dynamic>) {
      //         try {
      //           return TemplateResultEntity.fromJson(json);
      //         } catch (e) {
      //           print("[TemplateRepository] Error converting list item to TemplateResultEntity: $e");
      //           return TemplateResultEntity(); // Example: return default object
      //         }
      //       } else {
      //         print("[TemplateRepository] Error: Expected list item to be a Map<String, dynamic>, but got ${json.runtimeType}");
      //         return TemplateResultEntity(); // Example: return default object
      //       }
      //     }
      // );

      // Handle result based on the response code
      // 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('[TemplateRepository] Template list fetched successfully. Count: ${baseInfo.data?.length ?? 0}');
        return baseInfo.data; // Return the list of results / 返回结果列表
      } else {
        // Handle backend error
        // 处理后端错误
        print('[TemplateRepository] Fetch template list failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("获取失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Fetch failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('[TemplateRepository] DioException during template list request: ${e.message}');
      print('[TemplateRepository] DioException type: ${e.type}');
      print('[TemplateRepository] DioException response data: ${e.response?.data}');
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
      print('[TemplateRepository] Generic exception during template list request: $e');
      print('[TemplateRepository] Stack trace: $stackTrace');
      LoadingUtil.toast("获取异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Fetch exception
      return null;
    }
  }

  /// Fetches the H5 menu template list from the backend.
  /// 从后端获取 H5 菜单模板列表。
  ///
  /// Takes a [TemplateEntity] containing the request parameters (source, categorys, page, pageSize).
  /// 接收包含请求参数的 [TemplateEntity] (source, categorys, page, pageSize)。
  /// Returns a List of [TemplateResultEntity] upon success, or null on failure.
  /// 成功时返回 [TemplateResultEntity] 列表，失败时返回 null。
  Future<List<TemplateResultEntity>?> getH5MenuList(TemplateEntity req) async {
    // Define the API endpoint for H5 menu templates
    // 定义 H5 菜单模板的 API 端点
    const String h5MenuListEndpoint = 'photoTpl/h5menuTplList'; // Use the provided URL / 使用提供的 URL

    try {
      // Log the request data being sent
      // 记录正在发送的请求数据
      print('[TemplateRepository] Sending request to $h5MenuListEndpoint');
      final requestDataMap = req.toJson();
      // Remove null values if the API doesn't expect them
      // 如果 API 不期望 null 值，则移除它们
      requestDataMap.removeWhere((key, value) => value == null);
      print('[TemplateRepository] Request data map for H5: $requestDataMap');

      // Make the POST request using postForm (as per the template)
      // 使用 postForm 发起 POST 请求 (根据模板)
      // If your API expects JSON, use _httpService.post instead
      // 如果您的 API 期望 JSON, 请改用 _httpService.post
      final response = await _httpService.postForm(
          h5MenuListEndpoint,
          data: FormData.fromMap(requestDataMap) // Convert entity map to FormData / 将实体 map 转换为 FormData
      );

      // Log the raw response
      // 记录原始响应
      print('[TemplateRepository] H5 Response status code: ${response.statusCode}');
      print('[TemplateRepository] H5 Response raw data: ${response.data}');

      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        if ((response.data as String).isEmpty) {
          print('[TemplateRepository] H5 Error: Empty response body received.');
          LoadingUtil.toast("获取失败", "服务器响应为空", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Empty server response
          return null;
        }
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('[TemplateRepository] H5 Error decoding JSON response: $e');
          LoadingUtil.toast("获取失败", "服务器响应格式错误", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Server response format error
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        responseDataJson = response.data;
      } else {
        print('[TemplateRepository] H5 Error: Unexpected response data type: ${response.data.runtimeType}');
        LoadingUtil.toast("获取失败", "服务器响应类型未知", Theme.of(Get.context!).colorScheme.error); // Fetch failed, Unknown server response type
        return null;
      }

      // Parse the response using BaseResponseList (assuming the 'data' field is a list)
      // 使用 BaseResponseList 解析响应 (假设 'data' 字段是一个列表)
      // Ensure BaseResponseList and TemplateResultEntity.fromJson are correctly implemented
      // 确保 BaseResponseList 和 TemplateResultEntity.fromJson 已正确实现
      final baseInfo = BaseResponseList<TemplateResultEntity>.fromJson(responseDataJson);
      // final baseInfo = BaseResponseList<TemplateResultEntity>.fromJson(
      //     responseDataJson,
      //     // Provide the function to convert each item in the list
      //     // 提供转换列表中每个项目的函数
      //         (dynamic json) {
      //       if (json is Map<String, dynamic>) {
      //         try {
      //           // Use the generated factory constructor for list items
      //           // 对列表项使用生成的工厂构造函数
      //           return TemplateResultEntity.fromJson(json);
      //         } catch (e) {
      //           print("[TemplateRepository] H5 Error converting list item to TemplateResultEntity: $e");
      //           return TemplateResultEntity(); // Example: return default object
      //         }
      //       } else {
      //         print("[TemplateRepository] H5 Error: Expected list item to be a Map<String, dynamic>, but got ${json.runtimeType}");
      //         return TemplateResultEntity(); // Example: return default object
      //       }
      //     }
      // );

      // Handle result based on the response code
      // 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('[TemplateRepository] H5 Menu Template list fetched successfully. Count: ${baseInfo.data?.length ?? 0}');
        return baseInfo.data; // Return the list of results / 返回结果列表
      } else {
        // Handle backend error
        // 处理后端错误
        print('[TemplateRepository] Fetch H5 Menu Template list failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("获取失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Fetch failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('[TemplateRepository] DioException during H5 menu template list request: ${e.message}');
      print('[TemplateRepository] DioException type: ${e.type}');
      print('[TemplateRepository] DioException response data: ${e.response?.data}');
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
      print('[TemplateRepository] Generic exception during H5 menu template list request: $e');
      print('[TemplateRepository] Stack trace: $stackTrace');
      LoadingUtil.toast("获取异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Fetch exception
      return null;
    }
  }

// Add other repository methods related to Templates if needed
// 如果需要，添加与模板相关的其他 repository 方法
}
