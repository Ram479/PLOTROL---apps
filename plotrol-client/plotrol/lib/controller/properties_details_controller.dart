import 'package:get/get.dart';

class PropertiesDetailsController extends GetxController  {

  RxInt currentIndex = 0.obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
}