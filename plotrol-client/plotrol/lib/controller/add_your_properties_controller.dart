import 'dart:io';
import 'dart:math';

import 'package:dospace/dospace.dart' as dospace;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:plotrol/controller/autentication_controller.dart';
import 'package:plotrol/data/repository/adding_properties/adding_properties_repository.dart';
import 'package:plotrol/data/repository/get_properties/get_properties_repository.dart';
import 'package:plotrol/globalWidgets/flutter_toast.dart';
import 'package:plotrol/model/response/adding_properties/adding_properties_response.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Helper/Logger.dart';
import '../globalWidgets/Googleplaces.dart';
import '../model/request/adding_properties_request/adding_properties_request.dart';
import '../view/main_screen.dart';
import '../widgets/location_map.dart';
import 'home_screen_controller.dart';

class AddYourPropertiesController extends GetxController {
  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  TextEditingController mobileNumberController = TextEditingController();

  TextEditingController notesController = TextEditingController();

  TextEditingController locationName = TextEditingController();

  TextEditingController suburbController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController stateController = TextEditingController();

  TextEditingController postCodeController = TextEditingController();

  TextEditingController addressController = TextEditingController();

  final AuthenticationController _authenticationController =
      Get.put(AuthenticationController());

  // final CreateAccountController _createAccountController = Get.put(CreateAccountController());
  //
  final HomeScreenController _homeScreenController =
      Get.put(HomeScreenController());

  //
  // final BottomNavigationController _bottomNavigationController = Get.put(BottomNavigationController());

  AddPropertiesRepository addPropertiesRepository = AddPropertiesRepository();

  RxInt tenantId = 0.obs;

  RxList<String> uploadedImageList = <String>[].obs;

  final searchText = ''.obs;
  final predictions = <Map<String, dynamic>>[].obs;
  final selectedPlace = {}.obs;

  RxString userCurrentLocation = ''.obs;

  RxString latitude = ''.obs;

  RxString longitude = ''.obs;

  RxString currentLat = ''.obs;

  RxString currentLong = ''.obs;

  final GetPropertiesRepository _getPropertiesRepository =
      GetPropertiesRepository();

  final isDropdownOpened = false.obs;

  void toggleDropdown() {
    isDropdownOpened.value = !isDropdownOpened.value;
    update();
  }

  final GooglePlacesService placesService = GooglePlacesService();

  @override
  void onInit() {
    getLocation();
    // TODO: implement onInit
    super.onInit();
  }

  List<XFile>? images = [];

  final _picker = ImagePicker();

  Future getImageList() async {
    final List<XFile> selectedImages = await _picker.pickMultiImage(limit: 4);
    if (selectedImages.isNotEmpty &&
        (selectedImages.length < 4 && images!.length < 4)) {
      print('SelectedImageLength : ${selectedImages.length}');
      print('ImageLength  : ${images!.length}');
      images!.addAll(selectedImages);
      update();
    } else {
      Toast.showToast('Please Select less than 4 Images');
    }
  }

  removeImageList(int val) {
    images?.removeAt(val);
    update();
  }

  uploadImageAndSave() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    tenantId.value = prefs.getInt('tenantId') ?? 0;

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
        'profile-${rng.nextInt(100).toString()}-${tenantId.value}-$i.jpg',
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
    addNewProperty();
    // createNewUser();
  }

  addYourPropertiesValidation() {
    // if (images?.isEmpty ?? false) {
    //   btnController.reset();
    //   Toast.showToast('Please add your property Images');
    // } else
    if (mobileNumberController.text.isEmpty) {
      btnController.reset();
      Toast.showToast('Please Enter the Mobile Number');
    } else if (locationName.text.isEmpty) {
      btnController.reset();
      Toast.showToast('Please Enter the Location Name');
    } else if (locationName.text.length > 25) {
      btnController.reset();
      Toast.showToast('Location name must be 25 characters or less');
    } else if (notesController.text.isEmpty) {
      btnController.reset();
      Toast.showToast('Please add information to locate your property');
    } else {
      uploadImageAndSave();
      btnController.reset();
    }
  }

  addNewProperty() {
    addYourPropertiesResult(
      AddYourPropertiesRequest(
        tenantid: _homeScreenController.tenantId.value,
        moduleid: _authenticationController.moduleId.value,
        locationid: 0,
        address: addressController.text,
        suburb: suburbController.text,
        city: cityController.text,
        state: stateController.text,
        postcode: postCodeController.text,
        latitude: latitude.value,
        longitude: longitude.value,
        locationname: locationName.text,
        tenantimage: uploadedImageList,
        contactno: mobileNumberController.text,
        notes: notesController.text,
        email: _authenticationController.email.value,
      ),
    );
  }

  addYourPropertiesResult(AddYourPropertiesRequest data) async {
    AddYourPropertiesResponse? result =
        await addPropertiesRepository.addProperties(data);
    if (result?.status == true) {
      Get.offAll(() => HomeView(selectedIndex: 0));
      Toast.showToast('Your Properties Added SuccessFully');
      notesController.clear();
      uploadedImageList.clear();
      mobileNumberController.clear();
      locationName.clear();
      uploadedImageList.clear();
      images?.clear();
    } else {
      Toast.showToast(
          'There is some issue in adding your Properties Please Try Again Later');
    }
  }

  getLocation() async {
    /// checking the permission is granted or not
    try {
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
        Position position = await Geolocator.getCurrentPosition();
        currentLat.value = position.latitude.toString();
        currentLong.value = position.longitude.toString();
        getAddressFromLatLng(double.parse(currentLat.toString()),
            double.parse(currentLong.toString()));
        logger
            .i('Current Location: ${position.latitude}, ${position.longitude}');
      }
    } catch (e) {
      Toast.showToast('Please retry: ${e.toString()}');
    }
  }

  void showMap(
    BuildContext context,
  ) async {
    Position position = await Geolocator.getCurrentPosition();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationMap(
          initialLatitude: position.latitude,
          initialLongitude: position.longitude,
          refreshLocation: getLocation,
        ),
      ),
    );

    // print("Address: $address");
  }

  onSearchTextChanged(String text) async {
    searchText.value = text;
    if (text.length > 2) {
      try {
        final places = await placesService.getPlacesPredictions(text);
        print('PLACES: ${places}');
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

  getPlaceDetails(String placeId, locationAddress) async {
    try {
      final details = await placesService.getPlaceDetails(placeId);
      selectedPlace.value = details;
      logger.i(
          'getPlaceDetailslatitude ${selectedPlace['geometry']['location']['lat']}');
      logger.i(
          'getPlaceDetailslongitude ${selectedPlace['geometry']['location']['lng']}');
      getAddressFromLatLongs(selectedPlace['geometry']['location']['lat'],
          selectedPlace['geometry']['location']['lng'], locationAddress);
    } catch (e) {
      logger.i('Error fetching place details: $e');
    }
  }

  getAddressFromLatLongs(
      double latitudes, double longitudes, locationAddress) async {
    await placemarkFromCoordinates(latitudes, longitudes)
        .then((List<Placemark> placemarks) async {
      Placemark place = placemarks[0];
      cityController.text = '${place.locality}';
      stateController.text = '${place.administrativeArea}';
      suburbController.text =
          '${place.subLocality!.isNotEmpty ? place.subLocality : place.street}';
      postCodeController.text = '${place.postalCode}';
      addressController.text = locationAddress ?? '';
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
    await placemarkFromCoordinates(latitudes, longitudes)
        .then((List<Placemark> placemarks) {
      /// Initializing the auto fill location.
      Placemark place = placemarks[0];
      latitude.value = double.parse(latitudes.toString()).toString();
      longitude.value = double.parse(longitudes.toString()).toString();
      suburbController.text = '${place.subLocality}';
      // mobileNumberController.text =
      //     _homeScreenController.tenantContactNumber.value;
      cityController.text = '${place.locality}';
      stateController.text = '${place.administrativeArea}';
      postCodeController.text = '${place.postalCode}';
      addressController.text =
          '${place.street} ${place.subLocality} ${place.locality} ${place.administrativeArea} ${place.subAdministrativeArea} ${place.country} - ${place.postalCode}.';
      update();
    }).catchError((e) {
      Toast.showToast('Please retry: ${e.toString()}');
      debugPrint(e);
    });
  }

  // getProperties() {
  //   getPropertiesResult();
  // }
  //
  // getPropertiesResult() async {
  //   GetProperties? result = await _getPropertiesRepository.getProperties();
  //   if (result?.status == true) {
  //     List<PropertiesDetails> details = result?.details ?? [];
  //     for (var detail in details) {}
  //   }
  // }
}
