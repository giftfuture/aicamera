import 'package:flutter/material.dart';

import 'package:get/get.dart';




class TabsController extends GetxController {

  RxInt currentIndex = 0.obs; //新建一个变量，用于监听哪一个被选中
  PageController pageController = PageController(initialPage: 0);
  final List<Widget> pages = [
    // const MyPage(),
  ];

  /// 更新被选中的值
  void setCurrentIndex(index){
    currentIndex.value = index;
    update();
  }
}