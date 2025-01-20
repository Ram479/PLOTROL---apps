import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plotrolgigs/view/profile.dart';

import '../Controllers/bottom_navigation_controller.dart';
import 'home_screen.dart';
import 'ongoing_task.dart';
import 'order_status_screen.dart';

class HomeView extends StatelessWidget {
  final int selectedIndex;

  HomeView({super.key, required this.selectedIndex});

  final BottomNavigationController controller =
      Get.put(BottomNavigationController());

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptionsPlotRol = _widgetOptionsNearle();

    return GetX<BottomNavigationController>(initState: (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.selectedIndex.value != selectedIndex) {
          controller.selectedIndex.value = selectedIndex;
        }
      });
    }, builder: (controller) {
      return Scaffold(
        body: widgetOptionsPlotRol[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontFamily: 'Raleway',
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'Raleway',
          ),
          currentIndex: controller.selectedIndex.value,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home,
                  size: 25,
                ),
                label: 'Home',
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.work,
                size: 20,
              ),
              label: 'Tasks',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.check_box,
                size: 20,
              ),
              label: 'Completed',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 20,
              ),
              label: 'Profile',
            ),
          ],
          backgroundColor: Colors.white,
          iconSize: 40,
          elevation: 5,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          onTap: controller.onTapped,
        ),
      );
    });
  }

  List<Widget> _widgetOptionsNearle() => <Widget>[
        HomeScreen(),
        OrderStatusScreen(),
        const OngoingTaskScreen(),
        Profile(),
      ];
}
