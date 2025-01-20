import 'dart:math';
import 'package:dospace/dospace.dart' as dospace;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Data/Repository/Create_Account/create_account_repository.dart';
import '../Modal/Request/create_staff_request.dart';
import '../Modal/Response/create_staff_response.dart';
import '../globalWidgets/Googleplaces.dart';
import '../globalWidgets/flutter_toast.dart';
import '../helper/Logger.dart';
import '../view/home_view.dart';
import 'autentication_controller.dart';
import 'package:path/path.dart' as path;
import 'package:http/http.dart' as http;


class CreateAccountController extends GetxController {

  RxString userCurrentLocation = ''.obs;

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

  TextEditingController firstNameController = TextEditingController();

  TextEditingController lastNameController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController suburbController = TextEditingController();

  TextEditingController cityController = TextEditingController();

  TextEditingController stateController = TextEditingController();

  TextEditingController postCodeController = TextEditingController();

  TextEditingController  addressController = TextEditingController();

  TextEditingController  accountNumber = TextEditingController();

  TextEditingController  accountName = TextEditingController();

  TextEditingController  bankName = TextEditingController();

  TextEditingController  branchName = TextEditingController();

  TextEditingController  ifscCode = TextEditingController();

  TextEditingController  accountType = TextEditingController();

  ScrollController scrollController = ScrollController();

  final searchText = ''.obs;

  final predictions = <Map<String, dynamic>>[].obs;

  final selectedPlace = {}.obs;

  final GooglePlacesService placesService = GooglePlacesService();

  final AuthenticationController authenticationController = Get.put(AuthenticationController());

  final RoundedLoadingButtonController btnController = RoundedLoadingButtonController();

  final isDropdownOpenedForAddress = false.obs;

  final isDropdownOpenedForBankDetails = false.obs;

  CreateAccountRepository createAccountRepository = CreateAccountRepository();

  void toggleDropdownForAddress() {
    isDropdownOpenedForAddress.value = !isDropdownOpenedForAddress.value;
    update();
  }

  void toggleDropdownForBankDetails() {
    isDropdownOpenedForBankDetails.value = !isDropdownOpenedForBankDetails.value;
    update();
  }

  @override
  void onInit() {
    getLocation();
    // TODO: implement onInit
    super.onInit();
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
      addressController.text = locationAddress ?? '';
      // addYourPropertiesController.cityController.text = '${place.locality}';
      // addYourPropertiesController.stateController.text = '${place.administrativeArea}';
      // addYourPropertiesController.suburbController.text = '${place.subLocality!.isNotEmpty?place.subLocality:place.street}';
      // addYourPropertiesController.postCodeController.text ='${place.postalCode}';
      // addYourPropertiesController.addressController.text = locationAddress ?? '';
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
      addressController.text  = '${place.street} ${place.subLocality} ${place.locality} ${place.administrativeArea} ${place.subAdministrativeArea} ${place.country} - ${place.postalCode}.';
      update();

    }).catchError((e) {
      debugPrint(e);
    });
  }

  createNewUser() {
    createAccountResult(
        CreateAccountRequest(
          firstname: firstNameController.text,
          lastname: lastNameController.text,
          address: addressController.text,
          suburb: suburbController.text,
          city: cityController.text,
          state: stateController.text,
          email: emailController.text,
          configid: 3,
          contactno: authenticationController.mobileController.text,
          profileimage: uploadedFileUrl.value,
          staffsettings: Staffsettings(
            partnerid: 0,
            accountname: 'GIRI',
            accountno: '123344555667',
            accounttpye: '',
            accounttypeid: 0,
            bankname: 'SBI',
            baseprice: 500,
            branch: 'RS Puram' ,
            experience: 2,
            identificationno: '1273 2173 2813',
            ifsccode: 'SBI000238923',
            levelofexperience: 'Intermediate',
            staffsettingsid: 0,
            status: 0,
            userid: 0,
            yearsofexperience: 4,
          )
        )
    );
  }

  createAccountResult(CreateAccountRequest data) async {
    CreateAccountResponse? result = await createAccountRepository.createNewUser(data);
    // if(result?.details?.primarycontact == authenticationController.mobileController.text){
    //   Toast.showToast('Tenant Already Exits');
    // }
    if(firstNameController.text.isEmpty || addressController.text.isEmpty) {
      Toast.showToast('Oops! It looks like you forgot to enter your first name or the address field.');
      btnController.reset();
    }
    if(result?.status == true && (firstNameController.text.isNotEmpty || addressController.text.isNotEmpty)) {
      Get.to(() =>  HomeView(selectedIndex: 0,));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('firstName', result?.details?.firstname ?? '');
      prefs.setString('lastName', result?.details?.lastname ?? '');
      prefs.setString('staffImage', result?.details?.profileimage ?? '');
      prefs.setInt('userId', result?.details?.userid ?? 0);
      prefs.setString('EmailId', result?.details?.email ?? '');
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        profileImage == null;
        print('FirstName User Created');
        Toast.showToast('User Created Success');
    }
  }

  createAccountValidation() {
    if (firstNameController.text.isEmpty) {
      Toast.showToast('Please Enter the First Name');
    }
    else if (lastNameController.text.isEmpty) {
      Toast.showToast('Please Enter the Last Name');
    }
    else if (addressController.text.isEmpty) {
      Toast.showToast('Please Enter the address');
    }
    else if (cityController.text.isEmpty) {
      Toast.showToast('Please Enter the City Name');
    }
    else if (suburbController.text.isEmpty) {
      Toast.showToast('Please Enter the SubUrb Name');
    }
    else if (stateController.text.isEmpty) {
      Toast.showToast('Please Enter the State Name');
    }
    else if (postCodeController.text.isEmpty) {
      Toast.showToast('Please Enter the postalCode');
    }
    else if (accountNumber.text.isEmpty) {
      Toast.showToast('Please Enter the Account Number');
    }
    else if(accountName.text.isEmpty) {
      Toast.showToast('Please Enter the Account Name');
    }
    else if(accountType.text.isEmpty) {
      Toast.showToast('Please Enter the Account Type');
    }
    else if(bankName.text.isEmpty) {
      Toast.showToast('Please Enter the Bank Name');
    }
    else if(branchName.text.isEmpty) {
      Toast.showToast('Please Enter the Branch Name');
    }
    else {
      logger.i('ProfileImageSource : $profileImage');
      if (profileImage == null) {
        createNewUser();
      }
      else {
        uploadImageAndSave();
      }
    }
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
    createNewUser();
  }


  // shareImage() async {
  //   if(profileImage == null) return;
  //   Share.shareXFiles([profileImage!], text: 'Great picture');
  // }
  //
  // shareNetworkImages() async {
  //   String imageUrl = 'https://upload.wikimedia.org/wikipedia/commons/a/a1/Nachusa_Grasslands_Spring_2016.jpg'; // Replace with your image URL
  //   await shareNetworkImage(imageUrl);
  // }


  // Future<void> shareNetworkImage(String imageUrl) async {
  //   try {
  //     // Download the image
  //     final response = await http.get(Uri.parse(imageUrl));
  //
  //     if (response.statusCode == 200) {
  //       // Get the temporary directory
  //       final directory = await getTemporaryDirectory();
  //
  //       // Create a file to write the image
  //       final file = File('${directory.path}/image.jpg');
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       // Share the image using XFile
  //       await Share.shareXFiles([XFile(file.path)], text: 'Check out this image!, ${imageUrl}');
  //     } else {
  //       logger.i('Failed to download image');
  //     }
  //   } catch (e) {
  //     logger.i('Error sharing image: $e');
  //   }
  // }
}