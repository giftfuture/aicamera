// Assume this file is located at lib/repository/autogenpic_repository.dart
// 假设此文件位于 lib/repository/autogenpic_repository.dart

import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart'; // For Theme access
// Import Dio if your HttpService returns Dio Response
// 如果您的 HttpService 返回 Dio Response，请导入 Dio
import 'package:dio/dio.dart' as dio; // Use prefix to avoid conflicts with GetX Response

// Import your HTTP utility and base response model if you have one
// 导入您的 HTTP 工具类和基础响应模型 (如果有)
// *** Adjust paths as necessary ***
// *** 根据需要调整路径 ***
import '../utils/dialog_util.dart'; // Assuming you have LoadingUtil for toasts

// Import the request and result entity models
// 导入请求和结果实体模型
// *** Adjust paths as necessary ***
// *** 根据需要调整路径 ***
import '../models/autogenpic_entity.dart';
import '../models/autogenpic_result.entity.dart';
// Assuming models have .fromJson constructors generated
// 假设模型具有生成的 .fromJson 构造函数

/// Repository class responsible for interacting with the AutoGenPic API endpoint.
/// 负责与 AutoGenPic API 端点交互的 Repository 类。
class AutoGenPicRepository {
  // Use Get.find<HttpUtil>() if HttpUtil is registered with GetX
  // 如果 HttpUtil 已在 GetX 中注册，请使用 Get.find<HttpUtil>()
  final HttpUtil _httpUtil = HttpUtil(); // Or Get.find<HttpUtil>();

  /// Initializes the repository (can be used for setup if needed).
  /// 初始化 repository (如果需要，可用于设置)。
  AutoGenPicRepository init() {
    // Perform any initialization if required
    // 如果需要，执行任何初始化
    return this;
  }

  /// Calls the API to generate a picture based on the provided data.
  /// 调用 API 以根据提供的数据生成图片。
  ///
  /// Takes [AutoGenPicEntity] as input data.
  /// 接收 [AutoGenPicEntity] 作为输入数据。
  /// Returns [AutoGenPicResultEntity?] on success, null on failure.
  /// 成功时返回 [AutoGenPicResultEntity?]，失败时返回 null。
  Future<AutoGenPicResultEntity?> generatePic(AutoGenPicEntity requestData) async {
    const String apiUrl = "gen/id/h5gen"; // API endpoint path / API 端点路径

    try {
      print("[AutoGenPicRepository] Calling API: $apiUrl with data: ${requestData.toJson()}");

      // Make the POST request using your HTTP utility
      // 使用您的 HTTP 工具类发出 POST 请求
      // Assuming HttpUtil.post returns a Dio Response<dynamic> object
      // 假设 HttpUtil.post 返回一个 Dio Response<dynamic> 对象
      final dio.Response<dynamic> response = await _httpUtil.post( // Ensure the type is Response<dynamic> from dio
        apiUrl, data: requestData.toJson(), // Send the entity converted to JSON / 发送转换为 JSON 的实体
      );

      // --- Response Handling ---
      // Check if the response status code indicates success (e.g., 200-299)
      // 检查响应状态码是否表示成功 (例如 200-299)
      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        // Check if the response data is not null and is a Map
        // 检查响应数据是否不为 null 且为 Map
        if (response.data != null && response.data is Map<String, dynamic>) {
          try {
            // *** FIX: Pass response.data (the Map) to fromJson ***
            // *** 修复：将 response.data (Map) 传递给 fromJson ***
            final result = AutoGenPicResultEntity.fromJson(response.data as Map<String, dynamic>);
            print("[AutoGenPicRepository] API call successful. Result: $result");
            return result;
          } catch (e, stackTrace) {
            // Handle errors during JSON parsing
            // 处理 JSON 解析期间的错误
            print("[AutoGenPicRepository] Error parsing successful response: $e");
            print("[AutoGenPicRepository] Stack trace: $stackTrace");
            LoadingUtil.toast("解析错误", "无法解析响应数据", Theme.of(Get.context!).colorScheme.error); // Parse Error, Failed to parse response data
            return null;
          }
        } else {
          // Handle cases where response data is null or not a Map, even with success status code
          // 处理响应数据为 null 或不是 Map 的情况，即使状态码成功
          print("[AutoGenPicRepository] API call successful (status ${response.statusCode}) but response data is null or not a Map.");
          LoadingUtil.toast("响应错误", "服务器响应格式无效", Theme.of(Get.context!).colorScheme.error); // Response Error, Invalid server response format
          return null;
        }
      } else {
        // Handle non-successful status codes (e.g., 4xx, 5xx)
        // 处理不成功的状态码 (例如 4xx, 5xx)
        String errorMessage = "请求失败，状态码: ${response.statusCode}"; // "Request failed, status code: ..."
        // Try to get a more specific error message from the response body if available
        // 如果可用，尝试从响应正文中获取更具体的错误消息
        if (response.data != null && response.data is Map && response.data['message'] != null) {
          errorMessage = response.data['message'];
        }
        print("[AutoGenPicRepository] API call failed with status ${response.statusCode}. Message: $errorMessage");
        LoadingUtil.toast("请求失败", errorMessage, Theme.of(Get.context!).colorScheme.error); // Request Failed
        return null;
      }
    } catch (e, stackTrace) {
      // Handle exceptions thrown by HttpUtil/Dio (network errors, timeouts, etc.)
      // 处理 HttpUtil/Dio 抛出的异常 (网络错误、超时等)
      print('[AutoGenPicRepository] Error calling generatePic API: $e');
      print('[AutoGenPicRepository] Stack trace: $stackTrace');
      // Show a generic error toast, DioError might contain more specific info
      // 显示通用错误 toast，DioError 可能包含更具体的信息
      String errorMsg = "网络错误: $e";
      if (e is dio.DioException) { // More specific error handling for Dio exceptions
        errorMsg = "网络请求出错: ${e.message}"; // Network request error
        // You can check e.type for different Dio error types (connectTimeout, receiveTimeout, response, cancel, etc.)
      }
      LoadingUtil.toast("错误", errorMsg, Theme.of(Get.context!).colorScheme.error); // Error
      return null;
    }
  }
}

// --- Placeholder for HttpUtil (Replace with your actual implementation) ---
// --- HttpUtil 的占位符 (替换为您的实际实现) ---
// Ensure this mock (or your actual HttpUtil) returns a dio.Response object
// 确保此模拟 (或您的实际 HttpUtil) 返回一个 dio.Response 对象
class HttpUtil {
  Future<dio.Response<dynamic>> post(String path, {dynamic data}) async {
    // Simulate network delay and response
    print("--- [HttpUtil Mock] POST to '$path' with data: $data ---");
    await Future.delayed(Duration(seconds: 1));

    // Simulate a successful Dio response
    if (path == "gen/id/h5gen") {
      // The actual data payload
      final responseData = {
        "id": Random().nextInt(10000),
        "finished_ts": DateTime.now().add(Duration(minutes: 2)).millisecondsSinceEpoch,
        "queue": 0,
        "status": 1, // Success status within the data
        "ts": DateTime.now().millisecondsSinceEpoch
      };
      // Wrap it in a Dio Response object
      return dio.Response(
          data: responseData, // The actual JSON map goes here
          statusCode: 200, // HTTP success status code
          requestOptions: dio.RequestOptions(path: path) // Basic request options
      );
    }

    // Simulate an error response (e.g., 400 Bad Request)
    return dio.Response(
        data: {"message": "模拟错误：无效的请求"}, // "Mock Error: Invalid request"
        statusCode: 400,
        requestOptions: dio.RequestOptions(path: path)
    );

    // Simulate a network error by throwing DioException
    // throw dio.DioException(
    //    requestOptions: dio.RequestOptions(path: path),
    //    message: "模拟网络连接超时", // "Mock network connection timeout"
    //    type: dio.DioExceptionType.connectionTimeout
    // );
  }
}
