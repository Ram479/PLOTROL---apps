import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:plotrol/Helper/Logger.dart';
import 'package:plotrol/data/repository/Tenant_Details/get_tenant_repository.dart';
import 'package:plotrol/data/repository/orders/orders_repository.dart';
import 'package:plotrol/helper/api_constants.dart';
import 'package:plotrol/model/response/get_tenant_details/get_details_response.dart';
import 'package:plotrol/model/response/orders/get_orders_response.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/repository/get_properties/get_properties_repository.dart';
import '../model/response/adding_properties/get_properties_response.dart';

class HomeScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxString firsName = ''.obs;

  RxString lastName = ''.obs;

  RxString profileImage = ''.obs;

  RxString email = ''.obs;

  RxInt tenantId = 0.obs;

  PageController pageController = PageController();

  RxBool isPropertyLoading = true.obs;

  RxBool isOrderLoading = true.obs;

  RxBool isTenantDetailLoading = true.obs;

  final GetPropertiesRepository _getPropertiesRepository =
      GetPropertiesRepository();

  final GetOrdersRepository _getOrdersRepository = GetOrdersRepository();

  final GetTenantRepository _getTenantRepository = GetTenantRepository();

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  List<OrderDetails> todayOrders = [];

  List<OrderDetails> otherOrders = [];

  List<OrderDetails> activeOrders = [];

  List<OrderDetails> completedOrders = [];

  List<OrderDetails> acceptedOrders = [];

  List<OrderDetails> pendingOrders = [];

  List<OrderDetails> createdOrders = [];

  List<String> address = [];

  List<String> notes = [];

  List<String> phoneNumber = [];

  List<List<String>> tenantImages = [];

  List<PropertiesDetails> getPropertiesDetails = [];

  List<OrderDetails> getOrderDetails = [];

  RxString tenantFirstName = ''.obs;

  RxString tenantLastName = ''.obs;

  RxString tenantProfileImage = ''.obs;

  RxString tenantEmail = ''.obs;

  RxInt tenantStaffId = 0.obs;

  RxString tenantContactNumber = ''.obs;

  RxString tenantLocation = ''.obs;

  RxString tenantSuburb = ''.obs;

  RxString tenantCity = ''.obs;

  RxString tenantState = ''.obs;

  RxString tenantPinCode = ''.obs;

  RxString tenantAccountNumber = ''.obs;

  RxString tenantAccountName = ''.obs;

  RxString tenantIfSSSCode = ''.obs;

  RxString tenantBankName = ''.obs;

  RxString tenantBranchName = ''.obs;

  RxString tenantAccountType = ''.obs;

  void getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firsName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    profileImage.value = prefs.getString('tenantImage') ?? '';
    email.value = prefs.getString('EmailId') ?? '';
    tenantId.value = prefs.getInt('tenantId') ?? 0;
    update();
  }

  void onTapped(int index) {
    selectedIndex.value = index;
    update();
  }

  getPropertiesApiFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // ApiConstants.tenantId = prefs.getInt('tenantId') ?? 0;
    print('tenatIdLocation : ${ApiConstants.tenantId}');
    ApiConstants.getProperties = ApiConstants.getPropertiesLive;
    getProperties();
  }

  getOrdersApiFunction() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    //ApiConstants.tenantId = prefs.getInt('tenantId') ?? 0;
    print('TenantIdForOrders : ${ApiConstants.tenantId}');
    ApiConstants.getOrders = ApiConstants.getOrderLive;
    getOrders();
  }

  getProperties() {
    getPropertiesResult();
  }

  getPropertiesResult() async {
    GetProperties? result = await _getPropertiesRepository.getProperties();
    if (result?.status == true) {
      getPropertiesDetails = result?.details ?? [];
      getPropertiesDetails = result?.details?.where((detail) {
            bool hasImage = detail.tenantimage != null &&
                (detail.tenantimage?.isNotEmpty ?? false);
            bool hasPhoneNumber = detail.contactno != null &&
                (detail.contactno?.isNotEmpty ?? false);
            bool hasAddress =
                detail.address != null && (detail.address?.isNotEmpty ?? false);
            // return hasImage && hasPhoneNumber && hasAddress;
            return hasPhoneNumber && hasAddress;
          }).toList() ??
          [];
      isPropertyLoading.value = false;
      update();
    }
  }

  getOrders() {
    getOrdersResult();
  }

  getOrdersResult() async {
    GetOrders? result = await _getOrdersRepository.getOrders();
    if (result?.status == true) {
      getOrderDetails.clear();
      getOrderDetails = result?.details ?? [];
      pendingOrders.clear();
      todayOrders.clear();
      otherOrders.clear();
      acceptedOrders.clear();
      createdOrders.clear();
      activeOrders.clear();
      completedOrders.clear();
      DateTime now = DateTime.now();
      String today =
          DateFormat('yyyy-MM-dd').format(now); // Format to match assignDate

      for (var order in getOrderDetails) {
        if (order.orderstatus == 'created') {
          createdOrders.add(order);
        }
        DateTime? assignDate;
        try {
          assignDate = DateFormat('yyyy-MM-dd').parse(order.pending ?? '');
        } catch (e) {
          continue;
        }

        if (DateFormat('yyyy-MM-dd').format(assignDate) == today) {
          todayOrders.add(order);
        } else {
          otherOrders.add(order);
        }
        if (order.orderstatus == 'accepted') {
          acceptedOrders.add(order);
        } else if (order.orderstatus == 'active') {
          activeOrders.add(order);
        } else if (order.orderstatus == 'completed') {
          completedOrders.add(order);
        } else if (order.orderstatus == 'pending') {
          pendingOrders.add(order);
        }
      }
      logger.i('Todays Order : ${todayOrders}');
      logger.i('Other Orders : ${otherOrders}');
      logger.i('accepted friends : ${acceptedOrders}');
      logger.i('active Orders : ${activeOrders}');
      logger.i('completed orders : ${completedOrders}');
      logger.i('The whole response : ${getOrderDetails}');
      logger.i('The Created Orders : ${createdOrders}');
      isOrderLoading.value = false;
      update();
    }
  }

  getTenantApiFunction() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiConstants.tenantId = prefs.getInt('tenantId') ?? 0;
    logger.i('UsersStaffIdForOrders : ${ApiConstants.tenantId}');
    ApiConstants.getTenant = ApiConstants.getTenantLive;
    getTenant();
  }

  getTenant() async {
    await getTenantDetailResult();
  }

  getTenantDetailResult() async {
    GetTenantDetails? result = await _getTenantRepository.getTenant();
    if (result?.status == true) {
      tenantFirstName.value = result?.details?.firstname ?? '';
      tenantLastName.value = result?.details?.lastname ?? '';
      tenantEmail.value = result?.details?.primaryemail ?? '';
      tenantContactNumber.value = result?.details?.primarycontact ?? '';
      tenantSuburb.value = result?.details?.suburb ?? '';
      tenantCity.value = result?.details?.city ?? '';
      tenantState.value = result?.details?.state ?? '';
      tenantPinCode.value = result?.details?.postcode ?? '';
      tenantLocation.value = result?.details?.address ?? '';
      tenantProfileImage.value = result?.details?.tenantimage ?? '';
      isTenantDetailLoading.value = false;
      update();
    }
  }
}
