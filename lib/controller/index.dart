import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import '../models/logo_entity.dart';
import '../models/photo_entity.dart';
import '../models/carousel_req.dart';
import '../repository/index.dart';
import '../utils/dialog_util.dart';

class AutoGenPhotoController extends GetxController {
  EasyRefreshController refreshController = EasyRefreshController();
  final AutoGenPhotoRepository _repository = AutoGenPhotoRepository().init();
  final RxList<PhotoEntity> photoData = <PhotoEntity>[].obs;
  final logoEntity = Rxn<LogoEntity>();
  final isShow = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAutoGenPhotos();
  }

  fetchAutoGenPhotos() async {
    try {
      var req = CarouselReq(type: '', source : '22',deviceId: '8b0e817bac894619add7916c669f8138'); // Adjust parameters as needed
      final photos = await _repository.getAutoGenPhotos(req);
      // print("####################################");
      // print(photos);
      if (photos != null) {
        photoData.value = photos;
      }
      refreshController.finishRefresh();
      update();
    } catch (e) {
      LoadingUtil.toast("错误", "获取图片失败", Theme.of(Get.context!).colorScheme.error);
      refreshController.finishRefresh();
    }
  }
  fetchLogo() async {
    try {
      var req = CarouselReq(type: '', source : '18',deviceId: '4e7496c740384cbbb0f99ad3eaf938cb'); // Adjust parameters as needed
      final photos = await _repository.getLogo(req);
      // print("####################################");
      // print(photos);
      if (photos != null) {
        logoEntity.value = photos;
      }
      refreshController.finishRefresh();
      update();
    } catch (e) {
      LoadingUtil.toast("错误", "获取Logo图片失败", Theme.of(Get.context!).colorScheme.error);
      refreshController.finishRefresh();
    }
  }
  // checkShow() {
  //   isShow.value = !isShow.value;
  // }

  // checkItem(int index) {
  //   photoData[index].isCheck = !photoData[index].isCheck;
  //   update();
  // }
  //
  // batchDelete() async {
  //   String batchIds = "";
  //   for (var element in photoData) {
  //     if (element.isCheck) {
  //       batchIds += ",${element.id}";
  //     }
  //   }
  //   batchIds = batchIds.replaceFirst(",", "");
  //   if (batchIds.contains(",")) {
  //     Get.dialog(
  //       AlertDialog(
  //         actionsAlignment: MainAxisAlignment.center,
  //         title: const Text('批量删除'),
  //         content: const Text('确认批量删除图片吗？'),
  //         actions: [
  //           IconButton(
  //             icon: const Icon(Icons.cancel, color: Colors.red),
  //             onPressed: () => Get.back(),
  //           ),
  //           IconButton(
  //             icon: const Icon(Icons.check_circle, color: Colors.green),
  //             onPressed: () async {
  //               Get.back();
  //               // Note: Repository method for batch delete would need to be implemented
  //               LoadingUtil.toast("操作成功", "批量删除成功", Theme.of(Get.context!).colorScheme.primary);
  //               fetchAutoGenPhotos();
  //             },
  //           ),
  //         ],
  //       ),
  //     );
  //   } else {
  //     LoadingUtil.toast("提示", "请选择需要批量删除的图片", Theme.of(Get.context!).colorScheme.error);
  //   }
  // }

}