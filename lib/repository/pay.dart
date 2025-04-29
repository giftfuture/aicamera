// Assume this file is located at repositories/pay_repository.dart
// 假设此文件位于 repositories/pay_repository.dart

import 'dart:convert'; // For jsonDecode if needed / 如果需要 jsonDecode 则导入

import 'package:dio/dio.dart'; // For FormData / FormData 所需
import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart' hide FormData, Response; // Hide Dio's types / 隐藏 Dio 的类型

// Import your project's models and services
// 导入您项目的模型和服务
// Adjust paths as necessary based on your project structure
// 根据您的项目结构调整必要的路径
import '../models/base_response.dart'; // Base response structure / 基础响应结构
import '../models/pay_entity.dart'; // Input entity / 输入实体
import '../models/pay_result_entity.dart'; // Output entity / 输出实体
import '../service/http_service.dart'; // HTTP service / HTTP 服务
import '../utils/dialog_util.dart'; // Utility for showing toasts / 显示 toast 的工具类

/// Repository class for handling Payment operations (e.g., creating orders).
/// 负责处理支付操作 (例如创建订单) 的 Repository 类。
class PayRepository extends GetxService {
  // Dependency injection for HttpService
  // HttpService 的依赖注入
  late HttpService _httpService;

  /// Initializes the repository by finding the HttpService instance.
  /// 通过查找 HttpService 实例来初始化 repository。
  PayRepository init() {
    _httpService = Get.find<HttpService>();
    return this;
  }

  /// Creates a payment order on the backend.
  /// 在后端创建支付订单。
  ///
  /// Takes a [PayEntity] containing the order details.
  /// 接收包含订单详情的 [PayEntity]。
  /// Returns a [PayResultEntity] containing payment parameters upon success, or null on failure.
  /// 成功时返回包含支付参数的 [PayResultEntity]，失败时返回 null。
  Future<PayResultEntity?> createOrder(PayEntity req) async {
    // Define the API endpoint for creating the order
    // 定义创建订单的 API 端点
    const String createOrderEndpoint = 'wx/offline/device/createOrder'; // Use the provided URL / 使用提供的 URL

    try {
      // Log the request data being sent
      // 记录正在发送的请求数据
      print('[PayRepository] Sending request to $createOrderEndpoint');
      final requestDataMap = req.toJson();
      // Remove null values if the API doesn't expect them
      // 如果 API 不期望 null 值，则移除它们
      requestDataMap.removeWhere((key, value) => value == null);
      print('[PayRepository] Request data map: $requestDataMap');

      // Make the POST request using postForm (as per the template)
      // 使用 postForm 发起 POST 请求 (根据模板)
      // If your API expects JSON body, use _httpService.post instead
      // 如果您的 API 期望 JSON body, 请改用 _httpService.post
      final response = await _httpService.postForm(
          createOrderEndpoint,
          data: FormData.fromMap(requestDataMap) // Convert entity map to FormData / 将实体 map 转换为 FormData
      );

      // Log the raw response
      // 记录原始响应
      print('[PayRepository] Response status code: ${response.statusCode}');
      print('[PayRepository] Response raw data: ${response.data}');

      // Handle potential non-JSON or unexpected responses
      // 处理潜在的非 JSON 或意外响应
      dynamic responseDataJson;
      if (response.data is String) {
        if ((response.data as String).isEmpty) {
          print('[PayRepository] Error: Empty response body received.');
          LoadingUtil.toast("创建订单失败", "服务器响应为空", Theme.of(Get.context!).colorScheme.error); // Create order failed, Empty server response
          return null;
        }
        try {
          responseDataJson = jsonDecode(response.data);
        } catch (e) {
          print('[PayRepository] Error decoding JSON response: $e');
          LoadingUtil.toast("创建订单失败", "服务器响应格式错误", Theme.of(Get.context!).colorScheme.error); // Create order failed, Server response format error
          return null;
        }
      } else if (response.data is Map<String, dynamic>) {
        responseDataJson = response.data;
      } else {
        print('[PayRepository] Error: Unexpected response data type: ${response.data.runtimeType}');
        LoadingUtil.toast("创建订单失败", "服务器响应类型未知", Theme.of(Get.context!).colorScheme.error); // Create order failed, Unknown server response type
        return null;
      }

      // Parse the response using BaseResponseEntity (assuming the 'data' field holds the PayResultEntity)
      // 使用 BaseResponseEntity 解析响应 (假设 'data' 字段包含 PayResultEntity)
      // Ensure BaseResponseEntity and PayResultEntity.fromJson are correctly implemented
      // 确保 BaseResponseEntity 和 PayResultEntity.fromJson 已正确实现
      final baseInfo = BaseResponseEntity<PayResultEntity?>.fromJson(
          responseDataJson,
          // Provide the function to convert the inner 'data' json to PayResultEntity
          // 提供将内部 'data' json 转换为 PayResultEntity 的函数
              (dynamic json) {
            if (json == null) return null;
            if (json is Map<String, dynamic>) {
              try {
                // Use the generated factory constructor
                // 使用生成的工厂构造函数
                return PayResultEntity.fromJson(json);
              } catch (e) {
                print("[PayRepository] Error converting 'data' field to PayResultEntity: $e");
                return null;
              }
            } else {
              print("[PayRepository] Error: Expected 'data' field to be a Map<String, dynamic>, but got ${json.runtimeType}");
              return null;
            }
          }
      );

      // Handle result based on the response code
      // 根据响应代码处理结果
      if (baseInfo.code == 0) { // Assuming 0 means success / 假设 0 表示成功
        print('[PayRepository] Order created successfully. Result: ${baseInfo.data?.toJson()}');
        return baseInfo.data; // Return the parsed result data / 返回解析的结果数据
      } else {
        // Handle backend error
        // 处理后端错误
        print('[PayRepository] Create order failed with code: ${baseInfo.code}, message: ${baseInfo.msg}');
        LoadingUtil.toast("创建订单失败", baseInfo.msg ?? '未知服务器错误', Theme.of(Get.context!).colorScheme.error); // Create order failed, Unknown server error
        return null;
      }
    } on DioException catch (e) { // Catch Dio specific network errors / 捕获 Dio 特定的网络错误
      print('[PayRepository] DioException during create order request: ${e.message}');
      print('[PayRepository] DioException type: ${e.type}');
      print('[PayRepository] DioException response data: ${e.response?.data}');
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
      print('[PayRepository] Generic exception during create order request: $e');
      print('[PayRepository] Stack trace: $stackTrace');
      LoadingUtil.toast("支付异常", e.toString(), Theme.of(Get.context!).colorScheme.error); // Payment exception
      return null;
    }
  }

// Add other repository methods related to payment (e.g., checking payment status) if needed
// 如果需要，添加与支付相关的其他 repository 方法 (例如检查支付状态)
}
