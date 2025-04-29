// Assume this file is located at controller/startgen_controller.dart
// 假设此文件位于 controller/startgen_controller.dart

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';

// Import the repository that handles the start generation logic
// 导入处理启动生成逻辑的 repository
// Adjust the path based on your project structure
// 根据您的项目结构调整路径

// Import the necessary entity models
// 导入必要的实体模型
// Adjust paths as needed / 根据需要调整路径
import '../models/startgen_entity.dart';
import '../models/startgen_result_entity.dart';

// Import utility for showing toasts/loading
// 导入用于显示 toast/loading 的工具类
// Adjust path as needed / 根据需要调整路径
import '../repository/startgen.dart';
import '../utils/dialog_util.dart';

/// GetX Controller to manage the start generation process.
/// 管理启动生成过程的 GetX 控制器。
class StartGenController extends GetxController {

  // --- Dependencies ---
  // Instantiate or find repository instance
  // 实例化或查找 repository 实例
  final StartGenRepository _repository = StartGenRepository().init(); // Or Get.find<StartGenRepository>();

  // --- State Variables ---

  // Observable variable to track loading state during the start generation request.
  // 用于跟踪启动生成请求期间加载状态的可观察变量。
  final RxBool isLoading = false.obs;

  // Observable variable to hold the result after a successful start generation request.
  // 用于在成功启动生成请求后保存结果的可观察变量。
  final Rx<StartGenResultEntity?> startResult = Rx<StartGenResultEntity?>(null);

  // --- Public Methods ---

  /// Initiates the image generation process by calling the backend.
  /// 通过调用后端来启动图片生成过程。
  ///
  /// Takes a [StartGenEntity] containing the necessary data for starting generation.
  /// 接收包含启动生成所需数据的 [StartGenEntity]。
  /// Returns the [StartGenResultEntity] if successful, otherwise null.
  /// 如果成功则返回 [StartGenResultEntity]，否则返回 null。
  Future<StartGenResultEntity?> startGeneration(StartGenEntity requestData) async {
    // Don't start a new request if one is already in progress.
    // 如果请求已在进行中，则不启动新的请求。
    if (isLoading.value) {
      print("[StartGenController] Start generation request already in progress.");
      return null; // Indicate no new operation started
    }

    StartGenResultEntity? result; // Variable to hold the result

    try {
      // Set loading state to true and clear previous result.
      // 将加载状态设置为 true 并清除先前结果。
      isLoading.value = true;
      startResult.value = null; // Clear previous result / 清除先前结果
      update(); // Notify listeners of state change / 通知监听器状态更改

      print("[StartGenController] Calling repository startGeneration...");
      // Call the repository method to start the generation.
      // 调用 repository 方法启动生成。
      result = await _repository.startGeneration(requestData);

      // Update the result state.
      // 更新结果状态。
      startResult.value = result;
      print("[StartGenController] Start generation result from repository: ${result?.toJson()}"); // Log result / 记录结果

      // Handle success or failure based on the result.
      // 根据结果处理成功或失败。
      if (result != null) {
        // Check the status from the result if needed (e.g., result.status == 1)
        // 如果需要，检查结果中的状态 (例如 result.status == 1)
        print("[StartGenController] Start generation request successful.");
        // Success toast is optional, maybe handle next steps (like polling) in UI
        // 成功提示是可选的，或许在 UI 中处理后续步骤 (例如轮询)
        // LoadingUtil.toast("成功", "图片生成任务已启动", Theme.of(Get.context!).colorScheme.primary); // Success, Image generation task started
      } else {
        // Error messages are likely handled within the repository's toast call.
        // 错误消息很可能在 repository 的 toast 调用中处理。
        print("[StartGenController] Start generation request failed (result is null).");
      }

    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic.
      // 处理控制器逻辑期间的任何意外错误。
      print('[StartGenController] Error in startGeneration: $e');
      print('[StartGenController] Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "启动生成失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Failed to start generation
      startResult.value = null; // Ensure result is null on error / 确保出错时结果为 null
      result = null; // Ensure returned result is null on error
    } finally {
      // Always set loading state back to false when done.
      // 完成后始终将加载状态设置回 false。
      isLoading.value = false;
      update(); // Notify listeners / 通知监听器
    }
    return result; // Return the result (or null if failed)
  }

// Add other methods related to generation state management if needed.
// 如果需要，添加与生成状态管理相关的其他方法。
}
