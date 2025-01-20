// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plotrol/view/singup_screen.dart';
import 'package:sizer/sizer.dart';

import 'helper/api_constants.dart';

Future<void> main() async {
  ApiConstants.login = ApiConstants.loginDev;
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, screenType) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? uniqueDeviceId;
  String? deviceId;
  var iosDeviceInfo;
  var androidDeviceInfo;

  @override
  void initState() {
    // getId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // Future<String?> getId() async {
  //   var deviceInfo = DeviceInfoPlugin();
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (Platform.isIOS) {
  //     // import 'dart:io'
  //     iosDeviceInfo = await deviceInfo.iosInfo;
  //     deviceId = iosDeviceInfo.toMap().toString();
  //     uniqueDeviceId = iosDeviceInfo.id;
  //     prefs.setString('deviceId', uniqueDeviceId!);
  //     logger.i('iosDeviceInfodeviceId$deviceId');
  //     logger.i('uniqueDeviceId${prefs.getString('deviceId')}');
  //     return iosDeviceInfo.identifierForVendor; // Unique ID on iOS
  //   } else {
  //     androidDeviceInfo = await deviceInfo.androidInfo;
  //     deviceId = androidDeviceInfo.toMap().toString();
  //     uniqueDeviceId = androidDeviceInfo.id;
  //     prefs.setString('deviceId', uniqueDeviceId!);
  //     logger.i('androidDeviceInfodeviceId$deviceId');
  //     logger.i('uniqueDeviceId ${prefs.getString('deviceId')}');
  //   }
  //   return null;
  // }
}
