// Assume this file is located at controller/category_sub_controller.dart
// 假设此文件位于 controller/category_sub_controller.dart

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';

// Import the repository that handles the sub-category fetching logic
// 导入处理子分类获取逻辑的 repository
// Adjust the path based on your project structure
// 根据您的项目结构调整路径

// Import the necessary entity models
// 导入必要的实体模型
// Adjust paths as needed
// 根据需要调整路径
import '../models/category_sub_entity.dart';
import '../models/category_sub_entity_result.dart';

// Import utility for showing toasts/loading
// 导入用于显示 toast/loading 的工具类
// Adjust path as needed
// 根据需要调整路径
import '../repository/categorysub.dart';
import '../utils/dialog_util.dart';

/// GetX Controller to manage fetching and state for sub-categories.
/// 管理获取子分类及其状态的 GetX 控制器。
class CategorySubController extends GetxController {

  // --- Dependencies ---
  // Instantiate or find repository instance
  // 实例化或查找 repository 实例
  final CategorySubRepository _repository = CategorySubRepository().init(); // Or Get.find<CategorySubRepository>();

  // --- State Variables ---

  // Observable list to hold the sub-category items
  // 用于保存子分类项的可观察列表
  final RxList<CategorySubEntityResult> subCategoryList = <CategorySubEntityResult>[].obs;

  // Loading state for fetching the sub-category list
  // 获取子分类列表的加载状态
  final RxBool isLoading = false.obs;

  // --- Public Methods ---

  /// Fetches the sub-category list for a given category from the repository.
  /// 从 repository 获取给定分类的子分类列表。
  ///
  /// Takes a [CategorySubEntity] with request parameters (like source and parent category IDs).
  /// 接收包含请求参数的 [CategorySubEntity] (例如 source 和父分类 ID)。
  Future<void> fetchSubCategoryList(CategorySubEntity requestData) async {
    // Prevent concurrent fetches
    // 防止并发获取
    if (isLoading.value) {
      print("[CategorySubController] Sub-category list fetch already in progress.");
      return;
    }

    try {
      // Set loading state and clear previous list
      // 设置加载状态并清除先前的列表
      isLoading.value = true;
      subCategoryList.clear();
      update(); // Notify UI about loading start / 通知 UI 加载开始

      print("[CategorySubController] Calling repository getCategoryList...");
      // Call the repository method to fetch data
      // 调用 repository 方法获取数据
      final List<CategorySubEntityResult>? result = await _repository.getCategoryList(requestData);

      // Update the list state if data is fetched successfully
      // 如果数据获取成功，则更新列表状态
      if (result != null) {
        subCategoryList.assignAll(result); // Update the list state / 更新列表状态
        print("[CategorySubController] Sub-category list fetched successfully. Count: ${result.length}");
      } else {
        // Error message is likely shown by the repository's toast
        // 错误消息很可能由 repository 的 toast 显示
        print("[CategorySubController] Fetch sub-category list failed (result is null).");
        // List remains empty as it was cleared before try block
        // 列表保持为空，因为它在 try 块之前已被清除
      }
    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic
      // 处理控制器逻辑期间的任何意外错误
      print('[CategorySubController] Error fetching sub-category list: $e');
      print('[CategorySubController] Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "获取子分类列表失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Failed to fetch sub-category list
      // List remains empty
      // 列表保持为空
    } finally {
      // Always set loading state back to false when done
      // 完成后始终将加载状态设置回 false
      isLoading.value = false;
      update(); // Notify UI about loading end / 通知 UI 加载结束
    }
  }

// Add other methods related to sub-category selection, state management, etc. if needed
// 如果需要，添加与子分类选择、状态管理等相关的其他方法
}
