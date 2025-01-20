import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:plotrolgigs/Data/Repository/Rider_Details/get_rider_repository.dart';
import 'package:plotrolgigs/Modal/Response/get_rider_detais.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/Repository/orders/get_orders_repository.dart';
import '../Helper/Logger.dart';
import '../Modal/Response/get_orders.dart';
import '../helper/api_constants.dart';

class HomeScreenController extends GetxController {
  RxInt selectedIndex = 0.obs;

  RxString firsName = ''.obs;

  RxString lastName = ''.obs;

  RxString profileImage = ''.obs;

  RxString email = ''.obs;

  RxInt staffId = 0.obs;

  RxString contactNumber = ''.obs;

  RxString location = ''.obs;

  RxString suburb = ''.obs;

  RxString city = ''.obs;

  RxString state = ''.obs;

  RxString pinCode = ''.obs;

  RxString accountNumber = ''.obs;

  RxString accountName = ''.obs;

  RxString ifSSSCode = ''.obs;

  RxString bankName = ''.obs;

  RxString branchName = ''.obs;

  RxString accountType = ''.obs;

  RxString riderFirstName = ''.obs;

  RxString riderLastName = ''.obs;

  RxString riderProfileImage = ''.obs;

  RxString riderEmail = ''.obs;

  RxInt riderStaffId = 0.obs;

  RxString riderContactNumber = ''.obs;

  RxString riderLocation = ''.obs;

  RxString riderSuburb = ''.obs;

  RxString riderCity = ''.obs;

  RxString riderState = ''.obs;

  RxString riderPinCode = ''.obs;

  RxString riderAccountNumber = ''.obs;

  RxString riderAccountName = ''.obs;

  RxString riderIfSSSCode = ''.obs;

  RxString riderBankName = ''.obs;

  RxString riderBranchName = ''.obs;

  RxString riderAccountType = ''.obs;

  RxBool isPropertyLoading = true.obs;

  RxBool isOrderLoading = true.obs;

  RxBool isRiderDetailsLoading = true.obs;

  RxString updateStatus = ''.obs;

  RxInt updateOrderId = 0.obs;

  RxString statusTime = ''.obs;

  List<OrderDetails> todayOrders = [];

  List<OrderDetails> otherOrders = [];

  List<OrderDetails> activeOrders = [];

  List<OrderDetails> completedOrders = [];

  List<OrderDetails> acceptedOrders = [];

  List<OrderDetails> pendingOrders = [];
  List<OrderDetails> allOrders = [];

  final GetOrdersRepository _getOrdersRepository = GetOrdersRepository();

  final GetRiderRepository _getRiderRepository = GetRiderRepository();

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  // final OrderDetailsController orderDetailsController = Get.put(OrderDetailsController());

  List<OrderDetails> getOrderDetails = [];

  void getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firsName.value = prefs.getString('firstName') ?? '';
    lastName.value = prefs.getString('lastName') ?? '';
    profileImage.value = prefs.getString('staffImage') ?? '';
    email.value = prefs.getString('EmailId') ?? '';
    staffId.value = prefs.getInt('userId') ?? 0;
    contactNumber.value = prefs.getString('MobileNumber') ?? '';
    location.value = prefs.getString('location') ?? '';
    suburb.value = prefs.getString('suburb') ?? '';
    city.value = prefs.getString('city') ?? '';
    state.value = prefs.getString('state') ?? '';
    pinCode.value = prefs.getString('pincode') ?? '';
    accountName.value = prefs.getString('accountName') ?? '';
    accountNumber.value = prefs.getString('accountNumber') ?? '';
    ifSSSCode.value = prefs.getString('ifsscode') ?? '';
    bankName.value = prefs.getString('bankName') ?? '';
    branchName.value = prefs.getString('branchName') ?? '';
    accountType.value = prefs.getString('accountType') ?? '';
  }

  getOrdersApiFunction({String? status}) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // ApiConstants.userId  = prefs.getInt('userId') ?? 0;
    print('The selected status : $status');
    logger.i('UsersStaffIdForOrders : ${ApiConstants.userId}');
    ApiConstants.getOrders = ApiConstants.getOrderLive;
    getOrders();
  }

  getOrders() {
    getOrdersResult();
  }

  getOrdersResult() async {
    GetOrders? result = await _getOrdersRepository.getOrders();
    if (result?.status == true) {
      getOrderDetails.clear();
      getOrderDetails = result?.details ?? [];
      todayOrders.clear();
      otherOrders.clear();
      acceptedOrders.clear();
      activeOrders.clear();
      completedOrders.clear();
      pendingOrders.clear();
      DateTime now = DateTime.now();
      String today =
          DateFormat('yyyy-MM-dd').format(now); // Format to match assignDate

      for (var order in getOrderDetails) {
        allOrders.add(order);
        if (order.orderstatus == 'pending') {
          pendingOrders.add(order);
        }

        DateTime? assignDate;
        try {
          assignDate = DateFormat('yyyy-MM-dd').parse(order.pending ?? '');
        } catch (e) {
          // Handle parsing error if necessary
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
        }
      }
      logger.i('Todays Order : ${todayOrders}');
      logger.i('Other Orders : ${otherOrders}');
      logger.i('accepted Orders : ${acceptedOrders}');
      logger.i('active Orders : ${activeOrders}');
      logger.i('completed orders : ${completedOrders}');
      logger.i('The whole response : ${getOrderDetails}');
      logger.i('The pending Orders : ${pendingOrders}');
      isOrderLoading.value = false;
      update();
    }
  }

  getRiderApiFunction() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //ApiConstants.userId  = prefs.getInt('userId') ?? 0;
    logger.i('UsersStaffIdForOrders : ${ApiConstants.userId}');
    ApiConstants.getRider = ApiConstants.getRiderLive;
    getRider();
  }

  getRider() async {
    await getRiderDetailResult();
  }

  getRiderDetailResult() async {
    GetRiderDetails? result = await _getRiderRepository.getRider();
    if (result?.status == true) {
      riderFirstName.value = result?.details?.firstname ?? '';
      riderLastName.value = result?.details?.lastname ?? '';
      riderEmail.value = result?.details?.email ?? '';
      riderContactNumber.value = result?.details?.contactno ?? '';
      riderSuburb.value = result?.details?.suburb ?? '';
      riderCity.value = result?.details?.city ?? '';
      riderState.value = result?.details?.state ?? '';
      riderPinCode.value = result?.details?.postcode ?? '';
      riderLocation.value = result?.details?.address ?? '';
      riderProfileImage.value = result?.details?.profileimage ?? '';
      isRiderDetailsLoading.value = false;
      update();
    }
  }
}
