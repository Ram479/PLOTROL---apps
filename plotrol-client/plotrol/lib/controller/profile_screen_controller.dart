import 'package:get/get.dart';
import 'package:plotrol/controller/bottom_navigation_controller.dart';
import 'package:plotrol/controller/home_screen_controller.dart';
import 'package:plotrol/view/singup_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helper/api_constants.dart';
import 'autentication_controller.dart';

class ProfileScreenController extends GetxController {

  final AuthenticationController _authenticationController = Get.put(AuthenticationController());

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _authenticationController.authMode.value = 0;
    _authenticationController.mobileController.clear();
    Get.delete<BottomNavigationController>();
    Get.offAll(() => LoginScreen());
    update();
  }

}