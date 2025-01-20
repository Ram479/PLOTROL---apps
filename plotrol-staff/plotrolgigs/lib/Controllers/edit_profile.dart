import 'dart:math';
import 'package:dospace/dospace.dart' as dospace;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:googleapis/apigeeregistry/v1.dart';
import 'package:googleapis/datamigration/v1.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plotrolgigs/Controllers/home_controller.dart';
import 'package:plotrolgigs/Data/Repository/Edit_Profile/edit_profile.dart';
import 'package:plotrolgigs/Modal/Request/edit_profile.dart';
import 'package:plotrolgigs/Modal/Response/edit_profile.dart';
import 'package:plotrolgigs/helper/api_constants.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;
import '../Helper/Logger.dart';
import '../globalWidgets/Googleplaces.dart';
import '../globalWidgets/flutter_toast.dart';
import '../view/home_view.dart';

class EditProfileController extends GetxController {

  RxString userCurrentLocation = ''.obs;

  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  RxString latitude = ''.obs;

  RxString longitude = ''.obs;

  RxString currentLat = ''.obs;

  RxString currentLong = ''.obs;

  RxInt tenantId = 0.obs;

  RxBool expandLocation = false.obs;

  RxString uploadedFileUrl = ''.obs;

  RxString firstName = ''.obs;

  RxString lastName = ''.obs;

  RxString userImage = ''.obs;

  RxString email = ''.obs;

  Position? currentPosition;

  TextEditingController? firstNameController = TextEditingController();

  TextEditingController? lastNameController = TextEditingController();

  TextEditingController? emailController = TextEditingController();

  TextEditingController? contactNumber = TextEditingController();

  TextEditingController? suburbController = TextEditingController();

  TextEditingController? cityController = TextEditingController();

  TextEditingController? stateController = TextEditingController();

  TextEditingController? postCodeController = TextEditingController();

  TextEditingController?  addressController = TextEditingController();

  TextEditingController  accountNumber = TextEditingController();

  TextEditingController  accountName = TextEditingController();

  TextEditingController  bankName = TextEditingController();

  TextEditingController  branchName = TextEditingController();

  TextEditingController  ifscCode = TextEditingController();

  TextEditingController  accountType = TextEditingController();

  final EditProfileRepository editProfileRepository = EditProfileRepository();

  final isDropdownOpenedForAddress = false.obs;

  final isDropdownOpenedForBankDetails = false.obs;

  final HomeScreenController homeScreenController = Get.put(HomeScreenController());

  final searchText = ''.obs;

  final predictions = <Map<String, dynamic>>[].obs;

  final selectedPlace = {}.obs;

  final GooglePlacesService placesService = GooglePlacesService();


  void toggleDropdownForAddress() {
    isDropdownOpenedForAddress.value = !isDropdownOpenedForAddress.value;
    update();
  }

  void toggleDropdownForBankDetails() {
    isDropdownOpenedForBankDetails.value = !isDropdownOpenedForBankDetails.value;
    update();
  }

  getInitialData() {
    firstNameController?.text =  homeScreenController.riderFirstName.value;
    lastNameController?.text = homeScreenController.riderLastName.value;
    emailController?.text = homeScreenController.riderEmail.value;
    contactNumber?.text = homeScreenController.riderContactNumber.value;
    addressController?.text = homeScreenController.riderLocation.value;
    suburbController?.text = homeScreenController.riderSuburb.value;
    cityController?.text = homeScreenController.riderCity.value;
    stateController?.text = homeScreenController.riderState.value;
    postCodeController?.text = homeScreenController.riderPinCode.value;
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
      cityController?.text = '${place.locality}';
      stateController?.text = '${place.administrativeArea}';
      suburbController?.text = '${place.subLocality!.isNotEmpty?place.subLocality:place.street}';
      postCodeController?.text ='${place.postalCode}';
      addressController?.text = locationAddress ?? '';
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
      suburbController?.text = '${place.subLocality}';
      cityController?.text = '${place.locality}';
      stateController?.text = '${place.administrativeArea}';
      postCodeController?.text = '${place.postalCode}';
      addressController?.text  = '${place.street} ${place.subLocality} ${place.locality} ${place.administrativeArea} ${place.subAdministrativeArea} ${place.country} - ${place.postalCode}.';
      update();

    }).catchError((e) {
      debugPrint(e);
    });
  }

  XFile? profileImage;

  final _picker = ImagePicker();

  Future getProfileImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      profileImage = selectedImage;
      update();
    }
    else {
      Toast.showToast('Image Not Selected');
    }
  }

  updateApiWithImage() {
    if(profileImage == null){
      updateStaffProfileApi();
    }
    else {
      uploadImageAndSave();
    }
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
      // endpointUrl: "https://nearle.sgp1.digitaloceanspaces.com",
    );

    String bucketName = "nearle";
    String folderName = "plotrol";

    String dir = path.dirname(profileImage!.path.split('/').last);
    String newPath =
    path.join(dir, 'profile-${rng.nextInt(100).toString()}-${tenantId.value}.jpg');
    print('NewPath: $newPath');

    String fileName = newPath.split('/').last;
    print('filename: $fileName');

    String? etag = await spaces.bucket(bucketName).uploadFile(
        '$folderName/$fileName',
        profileImage,
        'image',
        dospace.Permissions.public);
    print('upload: $etag');
    uploadedFileUrl.value = "https://images.nearle.app/$folderName/$fileName";
    update();
    print("file================= $uploadedFileUrl");
    await spaces.close();
    updateStaffProfileApi();
  }


  editStaff() {
    print('The Uploaded Url path  : ${uploadedFileUrl.value}');
    editProfileResult(
      EditStaffRequest(
         firstname: firstNameController?.text,
         lastname: lastNameController?.text,
         address: addressController?.text,
         suburb: suburbController?.text,
         city: cityController?.text,
         email: emailController?.text,
         state: stateController?.text,
         userid: homeScreenController.staffId.value,
          profileimage: uploadedFileUrl.value,
          staffsettings: Staffsettings(
           userid: homeScreenController.staffId.value,
           accountname: '',
           accountno: '',
           accounttpye: '',
           accounttypeid: 0,
           bankname: '',
           baseprice: 0,
           branch: '',
           experience: 0,
          identificationno: '',
          ifsccode: '',
          levelofexperience: '',
          partnerid: 0,
          staffsettingsid: 0,
          status: 0,
          yearsofexperience: 0,
        )
      )
    );
  }

  updateStaffProfileApi() {
    ApiConstants.editProfile = ApiConstants.editProfileLive;
    editStaff();
  }

  editProfileResult(EditStaffRequest data)async{
    EditStaffResponse? result = await editProfileRepository.editStaff(data);
    if(result?.status == true){
    //  homeScreenController.getRiderApiFunction();
      Toast.showToast('Your Profile Update Was Successful');
      Get.offAll(() => HomeView(selectedIndex: 3));
    }
  }
}