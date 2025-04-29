// Assume this file is located at controller/pay_controller.dart
// 假设此文件位于 controller/pay_controller.dart

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';

// Import the repository that handles the payment logic
// 导入处理支付逻辑的 repository
// Adjust the path based on your project structure
// 根据您的项目结构调整路径

// Import the necessary entity models
// 导入必要的实体模型
// Adjust paths as needed / 根据需要调整路径
import '../models/pay_entity.dart';
import '../models/pay_result_entity.dart';

// Import utility for showing toasts/loading
// 导入用于显示 toast/loading 的工具类
// Adjust path as needed / 根据需要调整路径
import '../repository/pay.dart';
import '../utils/dialog_util.dart';

/// GetX Controller to manage the payment order creation process.
/// 管理支付订单创建过程的 GetX 控制器。
class PayController extends GetxController {

  // --- Dependencies ---
  // Instantiate or find repository instance
  // 实例化或查找 repository 实例
  // Ensure PayRepository is registered if using Get.find()
  // 如果使用 Get.find()，请确保 PayRepository 已注册
  final PayRepository _repository = PayRepository().init(); // Or Get.find<PayRepository>();

  // --- State Variables ---

  // Observable variable to track loading state during order creation.
  // 用于跟踪订单创建过程中加载状态的可观察变量。
  final RxBool isLoading = false.obs;

  // Observable variable to hold the result after a successful order creation.
  // 用于在成功创建订单后保存结果的可观察变量。
  final Rx<PayResultEntity?> paymentResult = Rx<PayResultEntity?>(null);

  // --- Public Methods ---

  /// Initiates the payment order creation process using the 'wx/offline/device/pay' endpoint.
  /// 使用 'wx/offline/device/pay' 端点启动支付订单创建过程。
  ///
  /// Takes a [PayEntity] containing the necessary data for the order.
  /// 接收包含订单所需数据的 [PayEntity]。
  /// Returns the [PayResultEntity] if successful, otherwise null.
  /// 如果成功则返回 [PayResultEntity]，否则返回 null。
  Future<PayResultEntity?> createWxOfflineOrder(PayEntity requestData) async {
    // Don't start a new request if one is already in progress.
    // 如果请求已在进行中，则不启动新的请求。
    if (isLoading.value) {
      print("[PayController] Create WX Offline Order request already in progress.");
      return null; // Indicate no new operation started
    }

    PayResultEntity? result; // Variable to hold the result

    try {
      // Set loading state to true and clear previous result.
      // 将加载状态设置为 true 并清除先前结果。
      isLoading.value = true;
      paymentResult.value = null; // Clear previous result / 清除先前结果
      update(); // Notify listeners of state change / 通知监听器状态更改

      print("[PayController] Calling repository createOrder (for WX Offline)...");
      // Call the repository method to create the order.
      // **Important**: Ensure PayRepository has a method specifically for this URL
      // or that createOrder can handle different endpoints. Assuming createOrder handles it.
      // **重要提示**: 确保 PayRepository 有专门处理此 URL 的方法，
      // 或者 createOrder 可以处理不同的端点。假设 createOrder 处理它。
      // If not, you might need a new method in the repository like `createWxOfflineOrder`.
      // 否则，您可能需要在 repository 中添加新方法，例如 `createWxOfflineOrder`。
      result = await _repository.createOrder(requestData); // Using the existing createOrder method

      // Update the result state.
      // 更新结果状态。
      paymentResult.value = result;
      print("[PayController] Create WX Offline Order result from repository: ${result?.toJson()}"); // Log result / 记录结果

      // Handle success or failure based on the result.
      // 根据结果处理成功或失败。
      if (result != null) {
        print("[PayController] Create WX Offline Order request successful.");
        // Success toast is optional, maybe handle payment initiation in UI
        // 成功提示是可选的，或许在 UI 中处理支付启动
        // LoadingUtil.toast("成功", "订单创建成功，请支付", Theme.of(Get.context!).colorScheme.primary); // Success, Order created, please pay
      } else {
        // Error messages are likely handled within the repository's toast call.
        // 错误消息很可能在 repository 的 toast 调用中处理。
        print("[PayController] Create WX Offline Order request failed (result is null).");
      }

    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic.
      // 处理控制器逻辑期间的任何意外错误。
      print('[PayController] Error in createWxOfflineOrder: $e');
      print('[PayController] Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "创建订单失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Failed to create order
      paymentResult.value = null; // Ensure result is null on error / 确保出错时结果为 null
      result = null; // Ensure returned result is null on error
    } finally {
      // Always set loading state back to false when done.
      // 完成后始终将加载状态设置回 false。
      isLoading.value = false;
      update(); // Notify listeners / 通知监听器
    }
    return result; // Return the result (or null if failed)
  }

// Add other methods related to payment state management if needed (e.g., checking payment status).
// 如果需要，添加与支付状态管理相关的其他方法 (例如检查支付状态)。
}
