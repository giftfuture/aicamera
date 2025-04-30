// Assume this file is located at controller/autogenpic_controller.dart
// 假设此文件位于 controller/autogenpic_controller.dart

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';

// Import the repository that handles the actual picture generation logic
// 导入处理实际图片生成逻辑的 repository
// Adjust the path based on your project structure
// 根据您的项目结构调整路径

// Import the necessary entity models
// 导入必要的实体模型
// Adjust paths as needed
// 根据需要调整路径
import '../models/autogenpic_entity.dart';

// Import utility for showing loading/toast messages
// 导入用于显示加载/提示消息的工具类
// Adjust path as needed
// 根据需要调整路径
import '../models/autogenpic_result.entity.dart';
import '../repository/autogenpic.dart';
import '../utils/dialog_util.dart';

/// GetX Controller to manage the AutoGenPic (automatic picture generation) process.
/// 管理 AutoGenPic (自动图片生成) 过程的 GetX 控制器。
class AutoGenPicController extends GetxController {

  // --- Dependencies ---
  // Use Get.find() or direct instantiation with init() to get the repository instance.
  // 使用 Get.find() 或直接实例化并调用 init() 来获取 repository 实例。
  // Ensure AutoGenPicRepository is registered if using Get.find().
  // 如果使用 Get.find()，请确保 AutoGenPicRepository 已注册。
  final AutoGenPicRepository _repository = AutoGenPicRepository().init(); // Or Get.find<AutoGenPicRepository>();
  // --- State Variables ---
  // Observable variable to track loading state during picture generation.
  // 用于跟踪图片生成过程中加载状态的可观察变量。
  final RxBool isLoading = false.obs;

  // Observable variable to hold the result after a successful generation request.
  // 用于在成功生成请求后保存结果的可观察变量。
  final Rx<AutoGenPicResultEntity?> generationResult = Rx<AutoGenPicResultEntity?>(null);


  // Holds any error message during the process
  // 保存过程中的任何错误消息
  final RxnString errorMessage = RxnString(null); // Use RxnString for nullable string

  // --- Public Methods ---

  /// Initiates the picture generation process.
  /// 启动图片生成过程。
  ///
  /// Takes an [AutoGenPicEntity] containing the necessary parameters for generation.
  /// 接收包含生成所需参数的 [AutoGenPicEntity]。
  // --- Public Methods ---

  /// Initiates the picture generation process.
  /// 启动图片生成过程。
  ///
  /// Takes an [AutoGenPicEntity] containing all necessary request parameters.
  /// 接收包含所有必需请求参数的 [AutoGenPicEntity]。
  Future<void> generatePicture(AutoGenPicEntity requestData) async {
    // Prevent concurrent calls
    // 防止并发调用
    if (isLoading.value) {
      print("[AutoGenPicController] Generation already in progress.");
      // Optionally show a toast message
      // LoadingUtil.toast("提示", "正在生成中，请稍候...", Colors.grey); // "Generating, please wait..."
      return;
    }

    isLoading.value = true;
    generationResult.value = null; // Clear previous result / 清除先前结果
    errorMessage.value = null; // Clear previous error / 清除先前错误
    update(); // Notify UI about loading start / 通知 UI 加载开始

    try {
      print("[AutoGenPicController] Calling repository generatePic...");
      // Call the repository method
      // 调用 repository 方法
      final AutoGenPicResultEntity? result = await _repository.generatePic(requestData);

      if (result != null) {
        // Success case
        // 成功情况
        generationResult.value = result;
        print("[AutoGenPicController] Generation successful. Result ID: ${result.id}");
        // Optionally show a success message
        // LoadingUtil.toast("成功", "图片生成任务已提交！", Colors.green); // "Success", "Image generation task submitted!"
      } else {
        // Failure case (repository handled showing specific error toast)
        // 失败情况 (repository 已处理显示具体错误 toast)
        errorMessage.value = "生成请求失败，请重试。"; // "Generation request failed, please retry."
        print("[AutoGenPicController] Generation failed (repository returned null).");
      }

    } catch (e, stackTrace) {
      // Handle unexpected errors in the controller layer
      // 处理控制器层中的意外错误
      print('[AutoGenPicController] Error calling generatePicture: $e');
      print('[AutoGenPicController] Stack trace: $stackTrace');
      errorMessage.value = "发生意外错误: $e"; // "An unexpected error occurred"
      LoadingUtil.toast("错误", errorMessage.value!, Theme.of(Get.context!).colorScheme.error); // Error
    } finally {
      isLoading.value = false;
      update(); // Notify UI about loading end / 通知 UI 加载结束
    }
  }
  /// Clears the current generation state (loading, result, error).
  /// 清除当前的生成状态 (加载、结果、错误)。
  void clearState() {
    isLoading.value = false;
    generationResult.value = null;
    errorMessage.value = null;
    update(); // Notify listeners about the state change / 通知监听器状态变更
    print("[AutoGenPicController] State cleared.");
  }
// Optional: Add other methods related to generation state management if needed.
// 可选：如果需要，添加与生成状态管理相关的其他方法。
// For example, a method to poll for the final generated image based on the result ID.
// 例如，一个根据结果 ID 轮询最终生成图像的方法。
/*
  Future<void> pollForResult(int recordId) async {
    // Implementation to periodically check the status using another repository method
    // 使用另一个 repository 方法定期检查状态的实现
  }
*/
}
