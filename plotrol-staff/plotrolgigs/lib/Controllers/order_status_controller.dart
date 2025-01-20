import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderStatusController extends GetxController with GetSingleTickerProviderStateMixin{

  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: this);
  }

  void changeTabIndex(int index) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    tabController.index = index;
    update();
  }
}