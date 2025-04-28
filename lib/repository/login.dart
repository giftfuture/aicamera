import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;

import '../models/base_response.dart';
import '../models/user_entity.dart';
import '../service/http_service.dart';
import '../utils/common.dart';
import '../utils/dialog_util.dart';

class LoginRepository extends GetxService{
  late HttpService _httpService;
  LoginRepository init() {
    _httpService = Get.find<HttpService>(tag: "User");
    return this;
  }

  Future<Map<String,dynamic>?> login(name,psd) async {
    try {
      final response = await _httpService.post('/offline/device/h5/reg', data: {
        "username": name,
        "password": psd,
        "slideVerificationToken": "cc7c3ea6565d438fb76c3f4736bc859a",
        "socialType": 10,
        "socialCode": "1024"
      });
      var baseInfo = BaseResponse.fromJson(response.data);
      if(baseInfo.code == 0){
        return baseInfo.data;
      }else{
        LoadingUtil.toast("登录失败", "${baseInfo.msg}", Theme.of(Get.context!).colorScheme.error);
        return {};
      }
    }catch(e){
      return {};
    }
  }

  Future<UserEntity?> getUserInfo(id) async {
    try {
      final response = await _httpService.get('/user/get?id=$id');
      var baseInfo = BaseResponse.fromJson(response.data);
      if(baseInfo.code == 0){
        return UserEntity.fromJson(baseInfo.data);
      }else{
        LoadingUtil.toast("登录失败", "${baseInfo.msg}", Theme.of(Get.context!).colorScheme.error);
        return null;
      }
    }catch(e){
      return null;
    }
  }


  Future<Map<String,dynamic>?> refreshToken(refreshToken) async {
    try {
      final response = await _httpService.post('/auth/refresh-token?refreshToken=$refreshToken');
      var baseInfo = BaseResponse.fromJson(response.data);
      if(baseInfo.code == 0){
        return baseInfo.data;
      }else{
        LoadingUtil.toast("登录失败", "${baseInfo.msg}", Theme.of(Get.context!).colorScheme.error);
        return null;
      }
    }catch(e){
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _httpService.post('/auth/logout');
      var baseInfo = BaseResponse.fromJson(response.data);
      if(baseInfo.code == 0){
        return true;
      }else{
        LoadingUtil.toast("退出登录失败", "${baseInfo.msg}", Theme.of(Get.context!).colorScheme.error);
        return false;
      }
    }catch(e){
      return false;
    }
  }


  Future<bool> updatePassword(oldPassword,newPassword) async {
    try {
      LoadingUtil.show(Get.context);
      Options options = Options();
      options.headers = {"login_user_id": '${Common.user?.id}'};
      final response = await _httpService.post('/usrcenter/user/profile/update-password',data: {
        "oldPassword": oldPassword,
        "newPassword": newPassword
      },options: options);
      LoadingUtil.hide(Get.context);
      var baseInfo = BaseResponse.fromJson(response.data);
      if(baseInfo.code == 0){
        return true;
      }else{
        LoadingUtil.toast("修改密码失败", "${baseInfo.msg}", Theme.of(Get.context!).colorScheme.error);
        return false;
      }
    }catch(e){
      LoadingUtil.hide(Get.context);
      return false;
    }
  }

  Future<bool> resetPassword(email,code,password,rePassword) async {
    try {
      LoadingUtil.show(Get.context);
      final response = await _httpService.post('/usrcenter/user/update-password',data: {
        "email": email,
        "code": code,
        "password": password,
        "rePassword": rePassword
      });
      LoadingUtil.hide(Get.context);
      var baseInfo = BaseResponse.fromJson(response.data);
      if(baseInfo.code == 0){
        return true;
      }else{
        LoadingUtil.toast("重置密码失败", "${baseInfo.msg}", Theme.of(Get.context!).colorScheme.error);
        return false;
      }
    }catch(e){
      LoadingUtil.hide(Get.context);
      return false;
    }
  }

  Future<String> emailCode(email) async {
    try {
      LoadingUtil.show(Get.context);
      FormData formData = FormData.fromMap({"email": email});
      final response = await _httpService.post('/user/emailCode',data: formData);
      LoadingUtil.hide(Get.context);
      var baseInfo = BaseResponse.fromJson(response.data);
      if(baseInfo.code == 0){
        return baseInfo.data;
      }else{
        LoadingUtil.toast("发送验证码失败", "${baseInfo.msg}", Theme.of(Get.context!).colorScheme.error);
        return "";
      }
    }catch(e){
      LoadingUtil.hide(Get.context);
      return "";
    }
  }

  Future<bool> userUpdate(UserEntity? userEntity) async {
    try {
      LoadingUtil.show(Get.context);
      final response = await _httpService.put('/user/update',data: userEntity?.toJson());
      LoadingUtil.hide(Get.context);
      var baseInfo = BaseResponse.fromJson(response.data);
      if(baseInfo.code == 0){
        return true;
      }else{
        LoadingUtil.toast("操作失败", "${baseInfo.msg}", Theme.of(Get.context!).colorScheme.error);
        return false;
      }
    }catch(e){
      LoadingUtil.hide(Get.context);
      return false;
    }
  }



}