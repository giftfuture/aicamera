// Assume this file is located at controller/template_controller.dart
// 假设此文件位于 controller/template_controller.dart

import 'package:flutter/material.dart'; // For Theme access / Theme 访问所需
import 'package:get/get.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart'; // For pagination/refresh / 分页/刷新所需

// Import the repository that handles the template fetching logic
// 导入处理模板获取逻辑的 repository
// *** Adjust the path based on your project structure ***
// *** 根据您的项目结构调整路径 ***
// Import the necessary entity models
// 导入必要的实体模型
// Adjust paths as needed / 根据需要调整路径
import '../models/template_entity.dart';
import '../models/template_result_entity.dart';

// Import utility for showing toasts/loading
// 导入用于显示 toast/loading 的工具类
// Adjust path as needed / 根据需要调整路径
import '../repository/template.dart';
import '../utils/dialog_util.dart';

/// GetX Controller to manage fetching and state for templates based on categories.
/// 管理根据分类获取模板及其状态的 GetX 控制器。
class TemplateController extends GetxController {

  // --- Dependencies ---
  // Instantiate or find repository instance
  // 实例化或查找 repository 实例
  // *** Ensure TemplateRepository is created and registered if using Get.find() ***
  // *** 如果使用 Get.find()，请确保 TemplateRepository 已创建并注册 ***
  final TemplateRepository _repository = TemplateRepository().init(); // Or Get.find<TemplateRepository>();

  // --- State Variables ---

  // Observable list to hold the template items for a selected category
  // 用于保存所选分类的模板项的可观察列表
  final RxList<TemplateResultEntity> templateList = <TemplateResultEntity>[].obs;

  // Loading state for fetching the template list (used for initial load/refresh)
  // 获取模板列表的加载状态 (用于初始加载/刷新)
  final RxBool isLoading = false.obs;

  // Loading state specifically for the "load more" operation
  // 专门用于“加载更多”操作的加载状态
  final RxBool isLoadingMore = false.obs;

  // Pagination control
  // 分页控制
  EasyRefreshController refreshController = EasyRefreshController();
  int currentPage = 1; // Track current page / 跟踪当前页
  bool noMoreData = false; // Flag to indicate if all data is loaded / 指示是否已加载所有数据的标志
  final int _itemsPerPage = 20; // Define how many items per page / 定义每页的项目数 (可根据需要调整)

  // Store the current request parameters to handle pagination/refresh
  // 存储当前请求参数以处理分页/刷新
  TemplateEntity? currentRequestData;

  // --- Public Methods ---

  /// Fetches the initial list of templates for a given category (or refreshes).
  /// 获取给定分类的初始模板列表 (或刷新)。
  ///
  /// Takes a [TemplateEntity] with request parameters (source, categorys).
  /// Page and pageSize will be set internally.
  /// 接收包含请求参数的 [TemplateEntity] (source, categorys)。
  /// page 和 pageSize 将在内部设置。
  Future<void> fetchInitialTemplates(TemplateEntity requestData) async {
    // Prevent concurrent fetches
    // 防止并发获取
    if (isLoading.value) {
      print("[TemplateController] Template list fetch already in progress.");
      refreshController.finishRefresh(success: false); // Indicate refresh failed if already loading / 如果已在加载，则指示刷新失败
      return;
    }

    // Reset pagination and store request data
    // 重置分页并存储请求数据
    currentPage = 1;
    noMoreData = false;
    requestData.page = currentPage.toString();
    requestData.pageSize = _itemsPerPage.toString(); // Use internal page size / 使用内部页面大小
    currentRequestData = requestData; // Store for load more / 存储以备加载更多

    try {
      // Set loading state and clear previous list
      // 设置加载状态并清除先前的列表
      isLoading.value = true;
      templateList.clear(); // Clear list for initial fetch/refresh / 初始获取/刷新时清除列表
      update(); // Notify UI about loading start / 通知 UI 加载开始

      print("[TemplateController] Calling repository getTemplateList (Page 1)...");
      // Call the repository method to fetch data
      // 调用 repository 方法获取数据
      // *** Ensure TemplateRepository has a method like getTemplateList ***
      // *** 确保 TemplateRepository 有类似 getTemplateList 的方法 ***
      final List<TemplateResultEntity>? result = await _repository.getTemplateList(currentRequestData!);

      // Update the list state if data is fetched successfully
      // 如果数据获取成功，则更新列表状态
      if (result != null) {
        templateList.assignAll(result); // Update the list state / 更新列表状态
        print("[TemplateController] Initial templates fetched successfully. Count: ${result.length}");
        // Check if there might be no more data based on page size
        // 根据页面大小检查是否可能没有更多数据
        if (result.length < _itemsPerPage) {
          noMoreData = true;
          refreshController.finishLoad(success: true, noMore: true); // Update refresh controller / 更新刷新控制器
        } else {
          refreshController.finishLoad(success: true, noMore: false);
          refreshController.resetLoadState(); // Reset load state for next page / 为下一页重置加载状态
        }
        refreshController.finishRefresh(success: true); // Indicate refresh success / 指示刷新成功
      } else {
        // Error message is likely shown by the repository's toast
        // 错误消息很可能由 repository 的 toast 显示
        print("[TemplateController] Fetch initial templates failed (result is null).");
        noMoreData = true; // Assume no data on failure / 失败时假设无数据
        refreshController.finishLoad(success: false, noMore: true);
        refreshController.finishRefresh(success: false); // Indicate refresh failure / 指示刷新失败
      }
    } catch (e, stackTrace) {
      // Handle any unexpected errors during the controller logic
      // 处理控制器逻辑期间的任何意外错误
      print('[TemplateController] Error fetching initial templates: $e');
      print('[TemplateController] Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "获取模板列表失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Failed to fetch template list
      noMoreData = true;
      refreshController.finishLoad(success: false, noMore: true);
      refreshController.finishRefresh(success: false);
    } finally {
      // Always set loading state back to false when done
      // 完成后始终将加载状态设置回 false
      isLoading.value = false;
      update(); // Notify UI about loading end / 通知 UI 加载结束
    }
  }

  /// Fetches the next page of templates.
  /// 获取下一页模板。
  Future<void> loadMoreTemplates() async {
    if (isLoadingMore.value || noMoreData || currentRequestData == null) {
      print("[TemplateController] Cannot load more: isLoadingMore=$isLoadingMore, noMoreData=$noMoreData, currentRequestData=$currentRequestData");
      refreshController.finishLoad(success: true, noMore: noMoreData); // Finish load immediately / 立即完成加载
      return;
    }

    isLoadingMore.value = true; // Use separate loading flag for load more / 为加载更多使用独立的加载标志
    currentPage++;
    currentRequestData!.page = currentPage.toString(); // Update page number / 更新页码
    // pageSize remains the same
    // pageSize 保持不变
    update();

    try {
      print("[TemplateController] Calling repository getTemplateList (Page $currentPage)...");
      final List<TemplateResultEntity>? result = await _repository.getTemplateList(currentRequestData!);

      if (result != null) {
        templateList.addAll(result); // Append new data / 追加新数据
        print("[TemplateController] More templates loaded successfully. Count: ${result.length}");
        if (result.length < _itemsPerPage) {
          noMoreData = true;
          refreshController.finishLoad(success: true, noMore: true); // No more data / 没有更多数据
        } else {
          noMoreData = false; // Reset flag if a full page was loaded / 如果加载了完整页面则重置标志
          refreshController.finishLoad(success: true, noMore: false); // More data might exist / 可能存在更多数据
        }
      } else {
        print("[TemplateController] Load more templates failed (result is null).");
        noMoreData = true; // Assume no more data on failure / 失败时假设没有更多数据
        refreshController.finishLoad(success: false, noMore: true);
        currentPage--; // Revert page number on failure / 失败时恢复页码
        currentRequestData!.page = currentPage.toString();
      }
    } catch (e, stackTrace) {
      print('[TemplateController] Error loading more templates: $e');
      print('[TemplateController] Stack trace: $stackTrace');
      LoadingUtil.toast("错误", "加载更多模板失败: $e", Theme.of(Get.context!).colorScheme.error); // Error, Failed to load more templates
      noMoreData = true;
      refreshController.finishLoad(success: false, noMore: true);
      currentPage--; // Revert page number on error / 出错时恢复页码
      currentRequestData!.page = currentPage.toString();
    } finally {
      isLoadingMore.value = false;
      update();
    }
  }


  // Add other methods related to template selection, state management, etc. if needed
  // 如果需要，添加与模板选择、状态管理等相关的其他方法
  // Example: Clear templates when category changes
  // 示例：当分类改变时清除模板
  void clearTemplates() {
    templateList.clear();
    currentPage = 1;
    noMoreData = false;
    currentRequestData = null;
    isLoading.value = false;
    isLoadingMore.value = false;
    // Reset refresh controller state if needed
    // 如果需要，重置刷新控制器状态
    // refreshController.resetLoadState();
    // refreshController.resetRefreshState();
    update();
  }
}
