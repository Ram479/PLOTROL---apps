import 'dart:io';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:dospace/dospace.dart' as dospace;
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plotrolgigs/Controllers/home_controller.dart';
import 'package:plotrolgigs/Data/Repository/Create_Notification/create_notification.dart';
import 'package:plotrolgigs/Modal/Request/createNotification_request.dart';
import 'package:plotrolgigs/Modal/Response/createNotification_response.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Data/Repository/orders/update_orders_repository.dart';
import '../Helper/Logger.dart';
import '../Modal/Request/update_orders.dart';
import '../Modal/Response/update_order_response.dart';
import '../globalWidgets/Googleplaces.dart';
import '../globalWidgets/flutter_toast.dart';
import '../helper/api_constants.dart';
import '../view/home_view.dart';
import '../view/order_details.dart';

class OrderDetailsController extends GetxController {

  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  final HomeScreenController homeScreenController = Get.put(HomeScreenController());

  TextEditingController liveAddress = TextEditingController();

  TextEditingController suburbController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController stateController = TextEditingController();

  TextEditingController postCodeController = TextEditingController();

  final UpdateOrderRepository _updateOrderRepository = UpdateOrderRepository();

  final CreateNotificationRepository createNotificationRepository = CreateNotificationRepository();

  RxInt currentIndex = 0.obs;

  RxList<String> uploadedImageList = <String>[].obs;

  RxString userCurrentLocation = ''.obs;

  RxString latitude = ''.obs;

  RxString longitude = ''.obs;

  RxString currentLat = ''.obs;

  RxString currentLong = ''.obs;

  bool isValid = false;

  RxInt userID = 0.obs;

  RxDouble distanceBetweenStaffAndTenant = 0.0.obs;

  final searchText = ''.obs;

  final predictions = <Map<String, dynamic>>[].obs;

  final selectedPlace = {}.obs;

  final GooglePlacesService placesService = GooglePlacesService();

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

  bool areAllChecked() {
    for (var item in items) {
      if (!item['isChecked']) {
         Toast.showToast('Please select all task to complete');
         return false;// If any item is not checked, return false
      }
    }
    return true; // All items are checked
  }

  getLocation() async {

    /// checking the permission is granted or not
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permission permanently denied');
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Permission granted, you can now use Geolocator to get the location
      Position position = await Geolocator
          .getCurrentPosition();
      currentLat.value = position.latitude.toString();
      currentLong.value = position.longitude.toString();
      getAddressFromLatLng(double. parse(currentLat.toString()),double.parse(currentLong.toString()));
      logger.i('Current Location: ${position
          .latitude}, ${position.longitude}');
    }

  }

  onSearchTextChanged(String text) async {
    searchText.value = text;
    if (text.length > 2) {
      try {
        final places = await placesService.getPlacesPredictions(text);
        predictions.assignAll(places);
        update();

      } catch (e) {
        logger.i('Error fetching predictions: $e');
      }
    } else {
      predictions.clear();
      update();
    }
  }

  getPlaceDetails(String placeId,locationAddress) async {
    try {
      final details = await placesService.getPlaceDetails(placeId);
      selectedPlace.value = details;
      logger.i('getPlaceDetailslatitude ${selectedPlace['geometry']['location']['lat']}');
      logger.i('getPlaceDetailslongitude ${selectedPlace['geometry']['location']['lng']}');
      getAddressFromLatLongs(selectedPlace['geometry']['location']['lat'],selectedPlace['geometry']['location']['lng'],locationAddress);
    } catch (e) {
      logger.i('Error fetching place details: $e');
    }
  }

  getAddressFromLatLongs(double latitudes, double longitudes,locationAddress) async {
    await placemarkFromCoordinates(latitudes, longitudes).then((List<Placemark> placemarks) async {
      Placemark place = placemarks[0];
      cityController.text = '${place.locality}';
      stateController.text = '${place.administrativeArea}';
      suburbController.text = '${place.subLocality!.isNotEmpty?place.subLocality:place.street}';
      postCodeController.text ='${place.postalCode}';
      liveAddress.text = locationAddress ?? '';
      latitude.value = double.parse(latitudes.toString()).toString();
      longitude.value = double.parse(longitudes.toString()).toString();
      predictions.clear();

      update();
      logger.i('latitude $latitude');
      logger.i('longitude $longitude');

    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLng(double latitudes, double longitudes) async {
    await placemarkFromCoordinates(
        latitudes, longitudes)
        .then((List<Placemark> placemarks) {
      /// Initializing the auto fill location.
      Placemark place = placemarks[0];
      latitude.value = double.parse(latitudes.toString()).toString();
      longitude.value = double.parse(longitudes.toString()).toString();
      suburbController.text = '${place.subLocality}';
      cityController.text = '${place.locality}';
      stateController.text = '${place.administrativeArea}';
      postCodeController.text = '${place.postalCode}';
      // addYourPropertiesController.stateController.text = '${place.administrativeArea}';
      // addYourPropertiesController.cityController.text = '${place.locality}';
      // addYourPropertiesController.suburbController.text = '${place.subLocality}';
      // addYourPropertiesController.postCodeController.text = '${place.postalCode}';
      // addYourPropertiesController.addressController.text =  '${place.street} ${place.subLocality} ${place.locality} ${place.administrativeArea} ${place.subAdministrativeArea} ${place.country} - ${place.postalCode}.';
      liveAddress.text  = '${place.street} ${place.subLocality} ${place.locality} ${place.administrativeArea} ${place.subAdministrativeArea} ${place.country} - ${place.postalCode}.';
      update();

    }).catchError((e) {
      debugPrint(e);
    });
  }

  List<XFile>? images = [];

  final _picker = ImagePicker();

  Future getImageList() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage(
        limit: 4
    );

    if (selectedImages.isEmpty) {
      Toast.showToast('No images selected');
      return;
    }

    if (selectedImages.length > 4) {
      Toast.showToast('Please select less than 4 images');
      return;
    }

    if ((images!.length + selectedImages.length) > 4) {
      Toast.showToast('You can only select up to 4 images in total');
      return;
    }

    print('SelectedImageLength : ${selectedImages.length}');
    print('ImageLength  : ${images!.length}');
    images!.addAll(selectedImages);
    update();
  }


  removeImageList(int val) {
    images?.removeAt(val);
    update();
  }

  uploadImageAndSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userID.value = prefs.getInt('userId') ?? 0;

    var httpClient = http.Client();
    var rng = Random();

    dospace.Spaces spaces = dospace.Spaces(
      region: "sgp1",
      accessKey: "DO002QLRX23UD4C47RH7",
      secretKey: "1lPnl90eFhUtd4yegiH3q3QgiMUc6Cd9ybpLCyBf628",
      httpClient: httpClient,
    );

    String bucketName = "nearle";
    String folderName = "plotrol";

    // Iterate over each image in the list
    for (int i = 0; i < images!.length; i++) {
      String imagePath = images![i].path;
      String dir = path.dirname(imagePath.split('/').last);
      String newPath = path.join(
        dir,
        'profile-${rng.nextInt(100).toString()}-${ userID.value}-$i.jpg',
      );
      print('NewPath: $newPath');

      String fileName = newPath.split('/').last;
      print('filename: $fileName');

      String? etag = await spaces.bucket(bucketName).uploadFile(
        '$folderName/$fileName',
        File(imagePath),
        'image',
        dospace.Permissions.public,
      );
      print('upload: $etag');

      String fileUrl = "https://images.nearle.app/$folderName/$fileName";
      uploadedImageList.add(fileUrl);
      update();
      print("file================= $uploadedImageList");
    }
    await spaces.close();
    updateOrders();
    // api goes here
   // addNewProperty();
    // createNewUser();
  }

  updateOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('The status : ${homeScreenController.updateStatus.value}');
    if(homeScreenController.updateStatus.value == 'accepted') {
      updateOrdersResult(
        UpdateOrdersRequest(
          orderheaderid: homeScreenController.updateOrderId.value,
          orderstatus: homeScreenController.updateStatus.value,
          processing: homeScreenController.statusTime.value,
        )
      );
    }
    else if(homeScreenController.updateStatus.value == 'active') {
      updateOrdersResult(
        UpdateOrdersRequest(
          orderheaderid: homeScreenController.updateOrderId.value,
          orderstatus: homeScreenController.updateStatus.value,
          ready: homeScreenController.statusTime.value,
        ),
      );
    }
    else if(homeScreenController.updateStatus.value == 'completed') {
      updateOrdersResult(
        UpdateOrdersRequest(
          orderheaderid: homeScreenController.updateOrderId.value,
          orderstatus: homeScreenController.updateStatus.value,
          completed: homeScreenController.statusTime.value,
          orderimages: uploadedImageList,
        ),
      );
    }
  }

  updateOrdersResult(UpdateOrdersRequest data)async{
    UpdateOrdersResponse? result = await _updateOrderRepository.updateOrders(data);
    if(result?.status == true){
      Get.offAll(() => HomeView(selectedIndex: 0));
      homeScreenController.getOrdersApiFunction();
    }
  }

  Future<void> createNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    createNotificationResult(
      CreateNotificationRequest(
        token: token,
        notification: Notifications(
          title: title,
          body: body,
          sound: 'ring',
        ),
      ),
    );
  }

  createNotificationResult(CreateNotificationRequest data) async {
    CreateNotificationResponse? result = await createNotificationRepository.createNotification(data);
    if(result?.status == true) {
      logger.i('Notification sent successful');
    }
   }

  double calculateDistance(double tenantLat, double tenantLong, double staffLat, double lon2) {
    print('tenant lat : ${tenantLat}');
    print('tenantLong : ${tenantLong}');
    print('Staff lat : ${staffLat}');
    print('Staff long : ${lon2}');
    const double R = 6371; // Radius of the Earth in km
    final double dLat = (staffLat - tenantLat) * pi / 180;
    final double dLon = (lon2 - tenantLong) * pi / 180;
    final double a =
        sin(dLat / 2) * sin(dLat / 2) +
            cos(tenantLat * pi / 180) * cos(staffLat * pi / 180) *
                sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final double distance = R * c;
    distanceBetweenStaffAndTenant.value = distance;// Distance in km
    print('The KMS in ${distance}');
    return distance;
  }

  bool distanceValidation() {
    logger.i('Distance Between Staff : ${distanceBetweenStaffAndTenant.value}');
    if(distanceBetweenStaffAndTenant.value > 1) {
      Toast.showToast('Ensure you are in a correct location before you start the task');
      return false;
    }
    else {
      return true;
    }
  }

  bool completeTaskValidation() {
    if(images?.isEmpty ?? false) {
       Toast.showToast('Please upload the image to complete');
       return false;
     }
     else {
       //uploadImageAndSave();
       return true;
     }
  }


  void handleButtonPress(String type, int orderID) async {

    if (type == 'accepted') {
      isValid = distanceValidation();
      btnController.reset();
    } else if (type == 'active') {
      isValid = areAllChecked() && completeTaskValidation();
      btnController.reset();
    } else if(type == 'completed') {
      Get.back();
      btnController.reset();
    }

    if (isValid || (type == 'pending')) {
      homeScreenController.updateStatus.value = getStatusKey(type);
      homeScreenController.updateOrderId.value = orderID;
      DateTime now = DateTime.now();
      String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
      homeScreenController.statusTime.value = formattedTime;
      ApiConstants.updateOrders = ApiConstants.updateOrderLive;
      if (type != 'active') {
        updateOrders(); // Use Get.context for context in GetX
      } else {
        uploadImageAndSave();
      }
      btnController.reset();
    }
  }


}