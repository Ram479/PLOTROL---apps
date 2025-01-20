import 'package:get/get.dart';
import 'package:plotrolgigs/Controllers/autentication_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/Authentication/singup_screen.dart';
import 'bottom_navigation_controller.dart';

class ProfileScreenController extends GetxController {

  final AuthenticationController authenticationController  = Get.put(AuthenticationController());

  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    authenticationController.authMode.value = 0;
    authenticationController.mobileController.clear();
    Get.delete<BottomNavigationController>();
    Get.offAll(() => LoginScreen());
  }

}