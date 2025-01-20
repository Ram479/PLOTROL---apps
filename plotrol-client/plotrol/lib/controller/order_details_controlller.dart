import 'package:get/get.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';

class OrderDetailsController extends GetxController {

  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  RxInt currentIndex = 0.obs;

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  var items = <Map<String, dynamic>>[].obs;

  void setItems(List<String> itemList) {
    items.value = itemList.map((item) => {"name": item, "isChecked": false}).toList();
  }

  void toggleCheck(int index) {
    items[index]['isChecked'] = !items[index]['isChecked'];
    items.refresh();
  }
}