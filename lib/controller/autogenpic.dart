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

  // --- Public Methods ---

  /// Initiates the picture generation process.
  /// 启动图片生成过程。
  ///
  /// Takes an [AutoGenPicEntity] containing the necessary parameters for generation.
  /// 接收包含生成所需参数的 [AutoGenPicEntity]。
  Future<void> generatePicture(AutoGenPicEntity requestData) async {
    // Don't start a new generation if one is already in progress.
    // 如果生成已在进行中，则不启动新的生成。
    if (isLoading.value) {
      print("[AutoGenPicController] Generation already in progress.");
      return;
    }

    try {
      // Set loading state to true and clear previous result.
      // 将加载状态设置为 true 并清除先前结果。
      isLoading.value = true;
      generationResult.value = null; // Clear previous result / 清除先前结果
      update(); // Notify listeners of state change / 通知监听器状态更改

      print("[AutoGenPicController] Calling repository generatePicture...");
      // Call the repository method to perform the generation request.
      // 调用 repository 方法执行生成请求。
      final AutoGenPicResultEntity? result = await _repository.generatePicture(requestData);

      // Update the result state.
      // 更新结果状态。
      generationResult.value = result;
      print("[AutoGenPicController] Generation result from repository: ${result?.toJson()}"); // Log result / 记录结果

      // Show success or failure message based on the result.
      // 根据结果显示成功或失败消息。
      if (result != null) {
        // You might want to check result.status here as well if needed
        // 如果需要，您可能还需要在此处检查 result.status
        print("[AutoGenPicController] Generation request successful.");
        // Example success toast (optional)
        // 成功提示示例 (可选)
        // LoadingUtil.toast("成功", "图片生成请求已提交", Theme.of(Get.context!).colorScheme.primary); // Success, Image generation request submitted
      } else {
        // Error messages are likely handled within the repository's toast call,
        // but you could add specific controller-level feedback here if needed.
        // 错误消息很可能在 repository 的 toast 调用中处理，
        // 但如果需要，您可以在此处添加特定的控制器级别反馈。
        print("[AutoGenPicController] Generation request failed (result is null).");
      }

    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic.
      // 处理控制器逻辑期间的任何意外错误。
      print('[AutoGenPicController] Error: $e');
      print('[AutoGenPicController] Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "生成处理失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Generation processing failed
      generationResult.value = null; // Ensure result is null on error / 确保出错时结果为 null
    } finally {
      // Always set loading state back to false when done.
      // 完成后始终将加载状态设置回 false。
      isLoading.value = false;
      update(); // Notify listeners / 通知监听器
    }
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
