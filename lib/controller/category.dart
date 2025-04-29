// Assume this file is located at controller/category_controller.dart
// 假设此文件位于 controller/category_controller.dart

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';

// Import repositories
// 导入 Repositories
// Adjust paths as necessary / 根据需要调整路径

// Import entity models
// 导入实体模型
// Adjust paths as necessary / 根据需要调整路径
import '../models/category_entity.dart';
import '../models/category_entity_result.dart';
import '../models/category_sub_entity.dart';
import '../models/category_sub_entity_result.dart';

// Import utility for showing toasts/loading
// 导入用于显示 toast/loading 的工具类
// Adjust path as necessary / 根据需要调整路径
import '../repository/category.dart';
import '../repository/categorysub.dart';
import '../utils/dialog_util.dart';

/// GetX Controller to manage fetching and state for categories and sub-categories.
/// 管理获取分类和子分类及其状态的 GetX 控制器。
class CategoryController extends GetxController {

  // --- Dependencies ---
  // Instantiate or find repository instances
  // 实例化或查找 repository 实例
  final CategoryRepository _categoryRepository = CategoryRepository().init(); // Or Get.find<CategoryRepository>();
  final CategorySubRepository _categorySubRepository = CategorySubRepository().init(); // Or Get.find<CategorySubRepository>();

  // --- State Variables ---

  // Observable list to hold the main menu/category items
  // 用于保存主菜单/分类项的可观察列表
  final RxList<CategoryEntityResult> menuList = <CategoryEntityResult>[].obs;

  // Observable list to hold the sub-category items for a selected category
  // 用于保存所选分类的子分类项的可观察列表
  final RxList<CategorySubEntityResult> subCategoryList = <CategorySubEntityResult>[].obs;

  // Loading state for fetching the main menu list
  // 获取主菜单列表的加载状态
  final RxBool isMenuLoading = false.obs;

  // Loading state for fetching the sub-category list
  // 获取子分类列表的加载状态
  final RxBool isSubCategoryLoading = false.obs;

  // --- Lifecycle Methods ---

  @override
  void onInit() {
    super.onInit();
    // Optionally fetch initial data here, e.g., the main menu list
    // 可选：在此处获取初始数据，例如主菜单列表
    // Example: fetchMenuList(CategoryEntity(/* provide initial params */));
    // 示例：fetchMenuList(CategoryEntity(/* 提供初始参数 */));
  }

  // --- Public Methods ---

  /// Fetches the main menu/category list from the repository.
  /// 从 repository 获取主菜单/分类列表。
  ///
  /// Takes a [CategoryEntity] with request parameters.
  /// 接收包含请求参数的 [CategoryEntity]。
  Future<void> fetchMenuList(CategoryEntity requestData) async {
    // Prevent concurrent fetches
    // 防止并发获取
    if (isMenuLoading.value) {
      print("[CategoryController] Menu list fetch already in progress.");
      return;
    }

    try {
      // Set loading state and optionally clear previous list
      // 设置加载状态并可选地清除先前的列表
      isMenuLoading.value = true;
      // menuList.clear(); // Uncomment if you want to clear before fetching / 如果想在获取前清除，取消注释
      update(); // Notify UI about loading start / 通知 UI 加载开始

      print("[CategoryController] Calling repository getMenuList...");
      // Call the repository method to fetch data
      // 调用 repository 方法获取数据
      final List<CategoryEntityResult>? result = await _categoryRepository.getMenuList(requestData);

      // Update the list state if data is fetched successfully
      // 如果数据获取成功，则更新列表状态
      if (result != null) {
        menuList.assignAll(result); // Update the list state / 更新列表状态
        print("[CategoryController] Menu list fetched successfully. Count: ${result.length}");
      } else {
        // Error message is likely shown by the repository's toast
        // 错误消息很可能由 repository 的 toast 显示
        print("[CategoryController] Fetch menu list failed (result is null).");
        menuList.clear(); // Clear list on failure / 失败时清除列表
      }
    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic
      // 处理控制器逻辑期间的任何意外错误
      print('[CategoryController] Error fetching menu list: $e');
      print('[CategoryController] Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "获取菜单列表失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Failed to fetch menu list
      menuList.clear(); // Clear list on error / 出错时清除列表
    } finally {
      // Always set loading state back to false when done
      // 完成后始终将加载状态设置回 false
      isMenuLoading.value = false;
      update(); // Notify UI about loading end / 通知 UI 加载结束
    }
  }

  /// Fetches the sub-category list for a given category from the repository.
  /// 从 repository 获取给定分类的子分类列表。
  ///
  /// Takes a [CategorySubEntity] with request parameters (like source and parent category IDs).
  /// 接收包含请求参数的 [CategorySubEntity] (例如 source 和父分类 ID)。
  Future<void> fetchSubCategoryList(CategorySubEntity requestData) async {
    // Prevent concurrent fetches
    // 防止并发获取
    if (isSubCategoryLoading.value) {
      print("[CategoryController] Sub-category list fetch already in progress.");
      return;
    }

    try {
      // Set loading state and clear previous list
      // 设置加载状态并清除先前的列表
      isSubCategoryLoading.value = true;
      subCategoryList.clear(); // Clear before fetching new sub-categories / 获取新子分类前清除
      update(); // Notify UI about loading start / 通知 UI 加载开始

      print("[CategoryController] Calling repository getCategoryList (for sub-categories)...");
      // Call the repository method to fetch data
      // 调用 repository 方法获取数据
      final List<CategorySubEntityResult>? result = await _categorySubRepository.getCategoryList(requestData);

      // Update the list state if data is fetched successfully
      // 如果数据获取成功，则更新列表状态
      if (result != null) {
        subCategoryList.assignAll(result); // Update the list state / 更新列表状态
        print("[CategoryController] Sub-category list fetched successfully. Count: ${result.length}");
      } else {
        // Error message is likely shown by the repository's toast
        // 错误消息很可能由 repository 的 toast 显示
        print("[CategoryController] Fetch sub-category list failed (result is null).");
        // List remains empty as it was cleared before try block
        // 列表保持为空，因为它在 try 块之前已被清除
      }
    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic
      // 处理控制器逻辑期间的任何意外错误
      print('[CategoryController] Error fetching sub-category list: $e');
      print('[CategoryController] Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "获取子分类列表失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Failed to fetch sub-category list
      // List remains empty
      // 列表保持为空
    } finally {
      // Always set loading state back to false when done
      // 完成后始终将加载状态设置回 false
      isSubCategoryLoading.value = false;
      update(); // Notify UI about loading end / 通知 UI 加载结束
    }
  }

  // Add other methods related to category selection, state management, etc.
  // 添加与分类选择、状态管理等相关的其他方法。
  // Example: Keep track of the currently selected main category
  // 示例：跟踪当前选中的主分类
  final Rx<CategoryEntityResult?> selectedCategory = Rx<CategoryEntityResult?>(null);

  void selectCategory(CategoryEntityResult category) {
    selectedCategory.value = category;
    // Optionally trigger fetching sub-categories when a main category is selected
    // 可选：当选择主分类时触发获取子分类
    if (category.categorys != null) { // Assuming categorys holds the ID(s) needed for sub-fetch
      // Construct the request for sub-categories based on the selected main category
      // 根据选中的主分类构造子分类的请求
      // Replace 'YOUR_SOURCE' with the actual source value needed
      // 将 'YOUR_SOURCE' 替换为所需的实际 source 值
      CategorySubEntity subRequest = CategorySubEntity(source: 'YOUR_SOURCE', categorys: category.categorys);
      fetchSubCategoryList(subRequest);
    } else {
      subCategoryList.clear(); // Clear sub-categories if parent has no sub-category IDs
    }
    update(); // Notify UI about selection change / 通知 UI 选择更改
  }

}
