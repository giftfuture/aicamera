import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Import the repository that handles the actual upload logic
// Adjust the path based on your project structure
import '../repository/upload.dart'; // Assuming upload.dart is in repository folder

// Import the necessary entity models
// Adjust paths as needed
import '../models/upload_entity.dart';
import '../models/upload_result_entity.dart';

// Import utility for showing loading/toast messages
// Adjust path as needed
import '../utils/dialog_util.dart';

/// GetX Controller to manage the image upload process.
/// 管理图片上传过程的 GetX 控制器。
class UploadController extends GetxController {

  // --- Dependencies ---
  // Use Get.find() to get the instance of UploadRepository,
  // assuming it's registered elsewhere (e.g., in main.dart or bindings).
  // 使用 Get.find() 获取 UploadRepository 的实例，
  // 假设它已在其他地方注册（例如 main.dart 或 bindings 中）。
  final UploadRepository _repository = UploadRepository().init();

  // --- State Variables ---
  // Observable variable to track loading state during upload.
  // 用于跟踪上传过程中加载状态的可观察变量。
  final RxBool isLoading = false.obs;

  // Observable variable to hold the result after a successful upload.
  // 用于在成功上传后保存结果的可观察变量。
  final Rx<UploadResultEntity?> uploadResult = Rx<UploadResultEntity?>(null);

  // --- Public Methods ---

  /// Initiates the image upload process.
  /// 启动图片上传过程。
  ///
  /// Takes an [UploadEntity] containing the necessary data for the upload.
  /// 接收包含上传所需数据的 [UploadEntity]。
  Future<void> uploadPhoto(File img, UploadEntity uploadData) async {
    // Don't start a new upload if one is already in progress.
    // 如果上传已在进行中，则不启动新的上传。
    if (isLoading.value) {
      print("Upload already in progress.");
      return;
    }

    try {
      // Set loading state to true and clear previous result.
      // 将加载状态设置为 true 并清除先前结果。
      isLoading.value = true;
      uploadResult.value = null; // Clear previous result
      update(); // Notify listeners of state change

      print("Calling repository uploadImage...");
      // Call the repository method to perform the upload.
      // 调用 repository 方法执行上传。
      final UploadResultEntity? result = await _repository.uploadImage(img, uploadData);

      // Update the result state.
      //更新结果状态。
      uploadResult.value = result;
      print("result:");
      print(result);
      // Show success or failure message based on the result.
      // 根据结果显示成功或失败消息。
      if (result != null) {
        // You might want to check result.status here as well if needed
        print("Upload successful in controller.");
        // LoadingUtil.toast("成功", "图片上传成功", Theme.of(Get.context!).colorScheme.primary);
      } else {
        // Error messages are likely handled within the repository's toast call,
        // but you could add specific controller-level feedback here if needed.
        print("Upload failed in controller (result is null).");
      }

    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic.
      // 处理控制器逻辑期间的任何意外错误。
      print('Error in UploadController: $e');
      print('Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "上传处理失败: $e", Theme.of(Get.context!).colorScheme.error);
      uploadResult.value = null; // Ensure result is null on error
    } finally {
      // Always set loading state back to false when done.
      // 完成后始终将加载状态设置回 false。
      isLoading.value = false;
      update(); // Notify listeners
    }
  }

// Optional: Add other methods related to upload state management if needed.
// 可选：如果需要，添加与上传状态管理相关的其他方法。
}
