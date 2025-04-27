import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:jc_captcha/jc_captcha.dart';

import '../models/user_entity.dart';
import '../repository/login.dart';
import '../utils/common.dart';
import '../utils/dialog_util.dart';

class LoginController extends  GetxController{
  final LoginRepository _repository = LoginRepository().init();
  /// 用户名编辑控制器
  final  controllerUserName = TextEditingController().obs;
  /// 密码编辑控制器
  final controllerPassword = TextEditingController().obs;
  /// 是否隐藏密码
  final isShowPassword = false.obs;

  final formKey = GlobalKey<FormState>();

  showPassword(){
    isShowPassword.value = !isShowPassword.value;
  }
  final images = ["/assets/shangyuewan-fd3669eb.png","/yuyuan-7c02c0b3.png"];
  final imageIndex = 0.obs;
  login() async {
    if (formKey.currentState!.validate()) {
      Get.dialog(
          Column(
            children: [
              const Spacer(),
              GetBuilder(builder:(c){
                return CaptchaWidget(
                  imageUrl:
                  images[imageIndex.value],
                  onSuccess: () async {
                    Get.back();
                    LoadingUtil.show(Get.context);
                    Map<String,dynamic>? data = await _repository.login(controllerUserName.value.text, controllerPassword.value.text);
                    if(data == null || data.isEmpty){
                      // LoadingUtil.toast("登录失败", "登录返回数据为空，请稍后重试", Theme.of(Get.context!).colorScheme.error);
                      LoadingUtil.hide(Get.context);
                      return;
                    }
                    UserEntity? user = await _repository.getUserInfo(data["userId"]);
                    if(user == null){
                      // LoadingUtil.toast("登录失败", "获取用户数据为空，请稍后重试", Theme.of(Get.context!).colorScheme.error);
                      LoadingUtil.hide(Get.context);
                      return;
                    }
                    LoadingUtil.hide(Get.context);
                    Common.user = user;
                    GetStorage getStorage = GetStorage();
                    getStorage.write("accessToken", data["accessToken"]);
                    getStorage.write("refreshToken", data["refreshToken"]);
                    getStorage.write("expiresTime", data["expiresTime"]);
                    getStorage.write("user", user.toJson());
                    Get.offAllNamed("/home_tabs");
                    LoadingUtil.toast("成功", "登录成功", Theme.of(Get.context!).colorScheme.primary);
                  },
                  onFail: () {
                    if(imageIndex.value == 0){
                      imageIndex.value = 1;
                    }else{
                      imageIndex.value = 0;
                    }
                    update();
                    Get.back();
                    LoadingUtil.toast("失败", "验证失败", Theme.of(Get.context!).colorScheme.error);
                  },
                );
              }, init: this,),
              ElevatedButton.icon(
                onPressed: () {
                  if(imageIndex.value == 0){
                    imageIndex.value = 1;
                  }else{
                    imageIndex.value = 0;
                  }
                  update();
                },
                icon: const Icon(Icons.refresh),
                label: const Text("更换图形"),
              ),
              const Spacer(),
            ],
          )
      );
    }
  }


}