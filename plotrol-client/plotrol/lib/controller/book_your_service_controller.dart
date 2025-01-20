import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plotrol/controller/add_your_properties_controller.dart';
import 'package:plotrol/data/repository/categories/get_categories_repository.dart';
import 'package:plotrol/helper/api_constants.dart';
import 'package:plotrol/model/request/book_service/book_service.dart';
import 'package:plotrol/model/response/book_service/book_service.dart';
import 'package:plotrol/view/main_screen.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import '../Helper/Logger.dart';
import '../data/repository/book_your_service/book_your_service_repository.dart';
import '../globalWidgets/flutter_toast.dart';
import '../model/response/categories/get_categories.dart';
import 'autentication_controller.dart';
import 'home_screen_controller.dart';


class BookYourServiceController extends GetxController {


  final EasyInfiniteDateTimelineController dateTimelineController = EasyInfiniteDateTimelineController();

  final GetCategoriesRepository _getCategoriesRepository = GetCategoriesRepository();

  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  var dateTime = DateTime.now().obs;

  var selectedToTime = TimeOfDay.now().obs;

  var selectedFromTime = TimeOfDay.now().obs;

  RxList<bool> isSelected = RxList<bool>([false, false, false, false, false].obs); // Initial selection states

  final AuthenticationController _authenticationController = Get.put(AuthenticationController());

   final HomeScreenController _homeScreenController = Get.put(HomeScreenController());

  final AddYourPropertiesController _addYourPropertiesController = Get.put(AddYourPropertiesController());

  BookServiceRepository addPropertiesRepository = BookServiceRepository();

  RxBool isCategoryLoading = true.obs;

  RxInt locationId = 0.obs;

  List<String> selectedCategoryNames = [];

  List<String> selectedCategoryId = [];

  List<CategoryDetails> listOfCategories = [];

  void toggleSelection(int index) {
    isSelected[index] = !isSelected[index];
    if (isSelected[index]) {
      selectedCategoryNames.add(listOfCategories[index].categoryname ?? '');
      selectedCategoryId.add(listOfCategories[index].categoryid.toString() ?? '');
    } else {
      selectedCategoryNames.remove(listOfCategories[index].categoryname ?? '');
      selectedCategoryId.remove(listOfCategories[index].categoryid.toString() ?? '');
    }
    print('SelectedCategoryName : ${selectedCategoryNames}');
    update(); // Update UI when selection changes
  }

  void resetCategoryList() {
    selectedCategoryNames.clear();
    selectedCategoryId.clear();
  }

  void initializeSelection(String selectedCategory, String categoryId, {bool isUncheck = false}) {
    int index = listOfCategories.indexWhere((detail) => detail.categoryname == selectedCategory);
    if (index != -1) {
      isSelected[index] = true;
    }
  }

  void resetSelection() {
    isSelected.value = List<bool>.filled(listOfCategories.length, false); // Uncheck all categories
    update();
  }

  void updateDateTime(DateTime newDateTime) {
    dateTime.value = newDateTime;
    update();
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm();  // "jm" for "5:08 PM"
    return format.format(dt);
  }

  bookYourServiceValidation(int locationID) {
    if(selectedCategoryNames.isEmpty) {
      Toast.showToast('Please Select Your Service');
      btnController.reset();
    }
    else {
      ApiConstants.bookService = ApiConstants.bookServicesLive;
      locationId.value = locationID;
      bookServiceProperty();
      resetSelection();
      btnController.reset();
      _homeScreenController.getOrdersApiFunction();
    }
  }

  bookYourServiceApiFunction(locationId) {
  }

  void updateSelectedTime(TimeOfDay time) {
    selectedToTime.value = time;
    update();
  }

  getCategories() {
    ApiConstants.getCategories = ApiConstants.getCategoriesLive;
    getCategoriesResult();
  }

  getCategoriesResult() async {
    CategoriesResponse? result = await _getCategoriesRepository.getCategories();
    if(result?.status == true) {
      listOfCategories = result?.details ?? [];
      isCategoryLoading.value = false;
      update();
      logger.i('valueof the loader : ${isCategoryLoading.value}');
      isSelected.value = List<bool>.filled(listOfCategories.length, false);

    }
  }

  bookServiceProperty() {
    bookServiceResult(
          BookServiceRequest(
            categoryname : selectedCategoryNames,
            tenantid: _homeScreenController.tenantId.value,
            categoryid: selectedCategoryId,
            subcategoryid: _authenticationController.subCategoryId.value,
            configid: _authenticationController.configId.value,
            moduleid: _authenticationController.moduleId.value,
            startdate : dateTime.value.toString(),
            locationid: locationId.value,
            orderstatus: 'created',
            orderamount: 0,
            orderdate: DateTime.now().toString(),
            customerid: 0,
            cancelled: '',
            delivceryaddress: _addYourPropertiesController.addressController.text ?? '',
            delivered: '',
            deliverycharge: 0,
            deliverylat: '',
            deliverylocationid: 0,
            deliverylong: '',
            deliverytime: '',
            enddate: '',
            itemcount: 0,
            ordercharges: 0,
            orderheaderid: 0,
            orderid: '',
            ordernotes: '',
            ordervalue: 0,
            partnerid: 0,
            paymentstatus: 0,
            paymenttype: 0,
            pending: '',
            pickupaddress: '',
            pickuplat: '',
            pickuplong: '',
            processing: '',
            promoamount: 0,
            promoid: 0,
            promoname: '',
            promoterms: '',
            promovalue: 0,
            ready: '',
            remarks: '',
            taxamount: 0,
            tenantuserid: 0,
          ),
    );
  }

  bookServiceResult(BookServiceRequest data) async {
    BookServiceResponse? result = await addPropertiesRepository.bookService(data);
    if(result?.status == true) {
      resetCategoryList();
      Toast.showToast('Your Order Placed Successful');
      Get.offAll(() => HomeView(selectedIndex: 1));
    }
    else {
      Toast.showToast('There is some issue in Placing Your order Please Try Again Later');
    }
  }
}