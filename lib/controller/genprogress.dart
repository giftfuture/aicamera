// Assume this file is located at controller/genprogress_controller.dart
// 假设此文件位于 controller/genprogress_controller.dart

import 'dart:async'; // For Timer / Timer 所需

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';

// Import the repository that handles progress fetching
// 导入处理进度获取的 repository
// Adjust the path based on your project structure
// 根据您的项目结构调整路径

// Import the necessary entity model
// 导入必要的实体模型
// Adjust path as needed / 根据需要调整路径
import '../models/genprogress_entity.dart';

// Import utility for showing toasts/loading (optional for polling)
// 导入用于显示 toast/loading 的工具类 (轮询时可选)
import '../repository/genprogress.dart';
import '../utils/dialog_util.dart';

/// GetX Controller to manage fetching and state for generation progress.
/// 管理获取生成进度及其状态的 GetX 控制器。
class GenProgressController extends GetxController {

  // --- Dependencies ---
  // Instantiate or find repository instance
  // 实例化或查找 repository 实例
  final GenProgressRepository _repository = GenProgressRepository().init(); // Or Get.find<GenProgressRepository>();

  // --- State Variables ---

  // Observable variable to hold the latest progress/result data
  // 用于保存最新进度/结果数据的可观察变量
  final Rx<GenProgressEntity?> progressResult = Rx<GenProgressEntity?>(null);

  // Loading state for fetching progress
  // 获取进度的加载状态
  final RxBool isLoading = false.obs;

  // Timer for periodic polling
  // 用于周期性轮询的定时器
  Timer? _pollingTimer;

  // ID of the generation task being monitored
  // 正在监控的生成任务的 ID
  int? _currentGenId;

  // --- Public Methods ---

  /// Starts polling for generation progress for a given ID.
  /// 开始轮询给定 ID 的生成进度。
  ///
  /// [genId]: The ID of the generation task to monitor.
  /// [genId]: 要监控的生成任务的 ID。
  /// [pollingInterval]: Duration between polling requests (default: 5 seconds).
  /// [pollingInterval]: 轮询请求之间的持续时间 (默认: 5 秒)。
  void startPollingProgress(int genId, {Duration pollingInterval = const Duration(seconds: 5)}) {
    stopPolling(); // Stop any previous polling / 停止任何先前的轮询
    _currentGenId = genId;
    print("[GenProgressController] Starting polling for genId: $_currentGenId");

    // Fetch immediately first time
    // 首次立即获取
    fetchProgress(_currentGenId!);

    // Start periodic timer
    // 启动周期性定时器
    _pollingTimer = Timer.periodic(pollingInterval, (timer) {
      if (_currentGenId == null || isLoading.value) {
        // Skip if no ID or already loading
        // 如果没有 ID 或已在加载中，则跳过
        return;
      }
      // Only fetch if the previous status was 'in progress' (or null)
      // 仅当先前状态为“进行中”（或 null）时才获取
      if (progressResult.value?.status == 1 || progressResult.value == null) {
        fetchProgress(_currentGenId!);
      } else {
        print("[GenProgressController] Status is ${progressResult.value?.status}, stopping polling.");
        stopPolling(); // Stop polling if status is not 'in progress' / 如果状态不是“进行中”，则停止轮询
      }
    });
  }

  /// Stops the periodic polling for progress.
  /// 停止周期性轮询进度。
  void stopPolling() {
    if (_pollingTimer != null && _pollingTimer!.isActive) {
      print("[GenProgressController] Stopping polling for genId: $_currentGenId");
      _pollingTimer!.cancel();
      _pollingTimer = null;
    }
    _currentGenId = null; // Clear the monitored ID / 清除监控的 ID
    // Optionally reset loading state if needed
    // 如果需要，可选择重置加载状态
    // isLoading.value = false;
    // update();
  }

  /// Fetches the generation progress from the repository.
  /// 从 repository 获取生成进度。
  ///
  /// Takes the generation ID [genId].
  /// 接收生成 ID [genId]。
  Future<void> fetchProgress(int genId) async {
    // Prevent concurrent fetches for the same ID
    // 防止对同一 ID 的并发获取
    if (isLoading.value) {
      print("[GenProgressController] Progress fetch already in progress for genId: $genId.");
      return;
    }

    try {
      isLoading.value = true;
      // Don't clear previous result during polling, just update it
      // 轮询期间不清除先前结果，仅更新它
      update(); // Notify UI about loading start / 通知 UI 加载开始

      print("[GenProgressController] Calling repository getProgress for genId: $genId...");
      // Call the repository method to fetch data
      // 调用 repository 方法获取数据
      final GenProgressEntity? result = await _repository.getProgress(genId);

      // Update the result state if data is fetched successfully
      // 如果数据获取成功，则更新结果状态
      if (result != null) {
        progressResult.value = result; // Update the result state / 更新结果状态
        print("[GenProgressController] Progress updated for genId: $genId. Status: ${result.status}, WaitSeconds: ${result.waitSeconds}, Img: ${result.img != null && result.img!.isNotEmpty}");

        // Check if generation is complete and stop polling
        // 检查生成是否完成并停止轮询
        if (result.status != 1) { // Assuming 1 means 'in progress' / 假设 1 表示“进行中”
          print("[GenProgressController] Generation status is ${result.status}, stopping polling.");
          stopPolling();
        }
      } else {
        // Handle null result from repository (e.g., network error, backend error)
        // 处理来自 repository 的 null 结果 (例如网络错误、后端错误)
        print("[GenProgressController] Fetch progress failed (result is null) for genId: $genId.");
        // Optionally stop polling on error, or let it retry
        // 可选：出错时停止轮询，或让其重试
        // stopPolling();
      }
    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic
      // 处理控制器逻辑期间的任何意外错误
      print('[GenProgressController] Error fetching progress for genId $genId: $e');
      print('[GenProgressController] Stack trace: $stackTrace');
      // Avoid showing toast during polling?
      // 轮询期间避免显示 toast？
      // LoadingUtil.toast("错误", "获取进度失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Failed to fetch progress
      // Optionally stop polling on error
      // 可选：出错时停止轮询
      // stopPolling();
    } finally {
      // Always set loading state back to false when done
      // 完成后始终将加载状态设置回 false
      isLoading.value = false;
      update(); // Notify UI about loading end / 通知 UI 加载结束
    }
  }

  @override
  void onClose() {
    // Ensure the timer is cancelled when the controller is disposed
    // 确保在控制器释放时取消定时器
    stopPolling();
    super.onClose();
  }

// Add other methods related to progress state management if needed
// 如果需要，添加与进度状态管理相关的其他方法
}
