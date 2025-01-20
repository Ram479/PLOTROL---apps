import 'dart:io' show Platform;
import 'dart:math';

import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:plotrol/data/repository/autentication/login_repository.dart';
import 'package:plotrol/globalWidgets/text_widget.dart';
import 'package:plotrol/model/request/autentication_request/autentication_request.dart';
import 'package:plotrol/model/response/autentication_response/autentication_response.dart';
import 'package:plotrol/view/otp_screen.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Helper/Logger.dart';
import '../globalWidgets/flutter_toast.dart';

class AuthenticationController extends GetxController {
  RxString otp = "".obs;
  RxString smsOtp = "".obs;
  RxString resendOtp = "".obs;
  RxBool logInStatus = false.obs;
  RxInt selectedIndex = 0.obs;

  final RoundedLoadingButtonController btnController =
      RoundedLoadingButtonController();

  final RoundedLoadingButtonController introBtnController =
      RoundedLoadingButtonController();

  OtpTimerButtonController otpTimerController = OtpTimerButtonController();

  TextEditingController mobileController = TextEditingController();

  TextEditingController otpController = TextEditingController();

  WebViewController webViewController = WebViewController();

  LoginRepository loginRepository = LoginRepository();

  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Country selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('IN');

  String? fcmEntryToken;

  var isChecked = false.obs;
  var isEnabled = true.obs;
  RxString mobileNumber = '0'.obs;
  RxInt authMode = 0.obs;
  RxBool isScrollView = false.obs;
  RxString userFcmToken = ''.obs;
  RxString contactNo = "".obs;
  RxInt configId = 0.obs;
  RxInt categoryId = 0.obs;
  RxInt subCategoryId = 0.obs;
  RxInt moduleId = 0.obs;
  RxInt tenantId = 0.obs;
  RxInt locationId = 0.obs;
  RxString firstName = ''.obs;
  RxString lastName = ''.obs;
  RxString userProfileImage = ''.obs;
  RxString email = ''.obs;

  @override
  void onInit() {
    fcmToken();
    super.onInit();
  }

  /// Terms and conditions CheckBox enable and disable
  void toggleCheckbox(bool? value) {
    if (isEnabled.value) {
      isChecked.value = value!;
    }
  }

  void enableCheckbox(bool value) {
    isEnabled.value = value;
  }

  void resetSelection() {
    isChecked.value = false; // Reset the isChecked value to false
  }

  /// login screen validation using the mobile number and the Terms and conditions checkbox
  void loginScreenValidation(mobile, context) {
    if (mobileController.text.isEmpty) {
      Toast.showToast('Please Enter the Mobile Number');
      btnController.reset();
    } else if (mobileController.text.length > 10) {
      Toast.showToast('The Number Should be not digit large');
      btnController.reset();
    } else if (!RegExp(
            r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$')
        .hasMatch(mobileController.text)) {
      Toast.showToast('Please Enter the Valid Number');
      btnController.reset();
    } else if (!isChecked.value) {
      Toast.showToast('Please Accept Our Terms and Conditions');
      btnController.reset();
    } else {
      signIn(context);
      btnController.reset();
    }
  }

  signIn(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    signInResult(
      LoginRequest(
        configid: 1,
        contactno: mobileController.text,
        deviceid: prefs.getString('deviceId'),
        devicetype: Platform.operatingSystem,
        userfcmtoken: fcmEntryToken,
      ),
      context,
    );
  }

  signInResult(LoginRequest data, context) async {
    LoginResponse? result = await loginRepository.signIn(data);
    if (result?.status == true) {
      authMode.value = result?.details?.authmode ?? 0;
      logInStatus.value = result?.status ?? false;
      contactNo.value = result?.details?.contactno ?? '';
      userFcmToken.value = result?.details?.userfcmtoken ?? '';
      configId.value = result?.details?.configid ?? 0;
      categoryId.value = result?.details?.categoryid ?? 0;
      subCategoryId.value = result?.details?.subcategoryid ?? 0;
      tenantId.value = result?.details?.tenantid ?? 0;
      moduleId.value = result?.details?.moduleid ?? 0;
      locationId.value = result?.details?.locationid ?? 0;
      firstName.value = result?.details?.firstname ?? '';
      lastName.value = result?.details?.lastname ?? '';
      userProfileImage.value = result?.details?.tenantimage ?? '';
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('userId', result?.details?.userid ?? 0);
      prefs.setString('firstName', result?.details?.firstname ?? '');
      prefs.setString('lastName', result?.details?.lastname ?? '');
      prefs.setString('tenantImage', result?.details?.tenantimage ?? '');
      prefs.setInt('tenantId', result?.details?.tenantid ?? 0);
      prefs.setString('EmailId', result?.details?.email ?? '');
      resetSelection();
    }
    if (authMode.value != 1) {
      sendSmsOtp(mobileController.text);
      btnController.reset();
    } else {
      otpController.clear();
      resendOtp.value = '123456';
      logger.i('AuthMode : ${authMode}');
      if (authMode.value == 1) {
        var snackBar = const SnackBar(
          backgroundColor: Colors.black,
          content: ReusableTextWidget(
            text:
                'Please enter your 6 digit verification code provided by PlotRol',
            color: Colors.white,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      Get.to(() => OtpScreen(
            otp: resendOtp.value,
            authMode: authMode.value,
            logInStatus: logInStatus.value,
          ));
    }
  }

  // Future<String> profileImageString() async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   return prefs.get('tenantImage').toString();
  // }

  fcmToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    firebaseMessaging.getToken().then((token) {
      fcmEntryToken = token;
      prefs.setString('fcmToken', token!);
    });
  }

  String? getInitials(String firstName, [String? lastName]) {
    if (firstName.isEmpty) {
      return '';
    }
    if (lastName == null || lastName.isEmpty) {
      int middleIndex = firstName.length ~/ 2;
      return firstName[middleIndex].toUpperCase();
    }
    return '${firstName[0].toUpperCase()}${lastName[0].toUpperCase()}';
  }

  sendSmsOtp(String mobile, {authmode = 0}) async {
    int otpInput = await otpGenerator();
    smsOtp.value = otpInput.toString();
    if (authmode == 1) {
      onNavigateToProfileNumberVerification(otp: "123456", authmode: authmode);
    } else {
      receiveSmsOtp(mobile, smsOtp.toString());
    }
  }

  receiveSmsOtp(String phoneNumber, String otp) async {
    final response = await get(Uri.parse(
        'http://msg.lionsms.com/api/smsapi?key=aff7056ac03a660b7c20a870f13d2173&route=1&sender=SRIHTR&number=$phoneNumber&sms=Dear customer, use this One Time Password $otp to sign-in to plotrol app. This OTP will be valid for the next 5 mins.&templateid=1407169337463925961'));
    receiveOtp(response, otp);
  }

  receiveOtp(model, otp) async {
    onNavigateToProfileNumberVerification(otp: otp);
  }

  onNavigateToProfileNumberVerification({String? otp, authmode = 0}) {
    otpController.clear();
    resendOtp.value = otp ?? '';
    Get.to(() => OtpScreen(
          otp: resendOtp.value,
          authMode: authmode,
          logInStatus: logInStatus.value,
        ));
  }

  otpGenerator() {
    var rng = Random();
    var next = rng.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    return next.toInt();
  }
}
