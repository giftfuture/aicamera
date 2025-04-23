import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Response,FormData;
import 'package:get_storage/get_storage.dart';
import '../utils/dialog_util.dart';
class HttpService extends GetxService {
  late Dio _dio;

  Future<HttpService> init({
    required String baseUrl,
  }) async {
    _dio = Dio();
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(milliseconds: 10000);
    _dio.options.receiveTimeout = const Duration(milliseconds: 10000);
    _dio.interceptors.add(HeaderInterceptor());
    _dio.interceptors.add(LogInterceptor(requestBody: true,responseBody: true));
    return this;
  }

  Future<Response<T>> get<T>(String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (error) {
      // throw ErrorHandler.handle(error);
      LoadingUtil.toast("请求失败", ErrorHandler.handle(error).failure.responseMessage, Theme.of(Get.context!).colorScheme.error);
      rethrow;
    }
  }

  Future<Response<T>> post<T>(String path,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress}) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } catch (error) {
      // throw ErrorHandler.handle(error);
      LoadingUtil.toast("请求失败", ErrorHandler.handle(error).failure.responseMessage, Theme.of(Get.context!).colorScheme.error);
      rethrow;
    }
  }

  Future<Response<T>> postForm<T>(String path, {
    required FormData data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress
  }) async {
    try {
      final formData = data;
      final response = await _dio.post<T>(
        path,
        data: formData,
        queryParameters: queryParameters,
        options: options ?? Options(
          contentType: Headers.multipartFormDataContentType, // 自动设置Content-Type
        ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (error) {
      LoadingUtil.toast(
          "请求失败",
          ErrorHandler.handle(error).failure.responseMessage,
          Theme.of(Get.context!).colorScheme.error
      );
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(String path,
      {dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress}) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } catch (error) {
      // throw ErrorHandler.handle(error);
      LoadingUtil.toast("请求失败", ErrorHandler.handle(error).failure.responseMessage, Theme.of(Get.context!).colorScheme.error);
      rethrow;
    }
  }

  Future<Response<T>> put<T>(String path,
      {dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress}) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (error) {
      // throw ErrorHandler.handle(error);
      LoadingUtil.toast("请求失败", ErrorHandler.handle(error).failure.responseMessage, Theme.of(Get.context!).colorScheme.error);
      rethrow;
    }
  }

}
class HeaderInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
    GetStorage box = GetStorage();
    String token = box.read('accessToken') ?? '';
    if (token.isNotEmpty) {
      options.headers
          .putIfAbsent('Authorization', () => 'Bearer $token');
    }
  }

}

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorized,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  defaultError
}
extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.success:
        return Failure(ResponseCode.success, ResponseMessage.success);
      case DataSource.noContent:
        return Failure(ResponseCode.noContent, ResponseMessage.noContent);
      case DataSource.badRequest:
        return Failure(ResponseCode.badRequest, ResponseMessage.badRequest);
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden);
      case DataSource.unauthorized:
        return Failure(ResponseCode.unauthorized, ResponseMessage.unauthorized);
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound);
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError,
            ResponseMessage.internalServerError);
      case DataSource.connectTimeout:
        return Failure(
            ResponseCode.connectTimeout, ResponseMessage.connectTimeout);
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel);
      case DataSource.receiveTimeout:
        return Failure(
            ResponseCode.receiveTimeout, ResponseMessage.receiveTimeout);
      case DataSource.sendTimeout:
        return Failure(ResponseCode.sendTimeout, ResponseMessage.sendTimeout);
      case DataSource.cacheError:
        return Failure(ResponseCode.cacheError, ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection,
            ResponseMessage.noInternetConnection);
      case DataSource.defaultError:
        return Failure(ResponseCode.defaultError, ResponseMessage.defaultError);
    }
  }
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else {
      failure = DataSource.defaultError.getFailure();
    }
  }

  Failure _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return DataSource.connectTimeout.getFailure();
      case DioExceptionType.sendTimeout:
        return DataSource.sendTimeout.getFailure();
      case DioExceptionType.receiveTimeout:
        return DataSource.receiveTimeout.getFailure();
      case DioExceptionType.badResponse:
        if (error.response != null &&
            error.response?.statusCode != null &&
            error.response?.statusMessage != null) {
          return Failure(error.response?.statusCode ?? 0,
              error.response?.statusMessage ?? "");
        } else {
          return DataSource.defaultError.getFailure();
        }
      case DioExceptionType.cancel:
        return DataSource.cancel.getFailure();
      default:
        return DataSource.defaultError.getFailure();
    }
  }
}

class Failure {
    late int responseCode;
    late String responseMessage;
  Failure(this.responseCode,this.responseMessage);
}

class ResponseCode {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequest = 400; // failure, API rejected request
  static const int unauthorized = 401; // failure, user is not authorised
  static const int forbidden = 403; // failure, API rejected request
  static const int internalServerError = 500; // failure, crash in server side
  static const int notFound = 404; // failure, not found

  // local status code
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int defaultError = -7;
}

class ResponseMessage {
  static const String success = "成功";
  static const String noContent = "请求成功并且服务器创建了新的资源";
  static const String badRequest = "请求错误，请重试";
  static const String unauthorized = "暂无权限，请重试";
  static const String forbidden = "请求已拒绝，请重试";
  static const String internalServerError = "服务器端崩溃，请重试";
  static const String notFound = "请求地址不正确，请重试";


  static const String connectTimeout = "连接超时，请重试";
  static const String cancel = "请求取消";
  static const String receiveTimeout = "接收超时，请重试";
  static const String sendTimeout = "请求超市，请重试";
  static const String cacheError = "缓存错误，请重试";
  static const String noInternetConnection = "请检查您的网络连接";
  static const String defaultError = "出了点问题，请稍后再试，请重试";
}
