import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plotrolgigs/globalWidgets/custom_scaffold_widget.dart';
import 'package:plotrolgigs/view/privacy_and_policy_page.dart';
import 'package:plotrolgigs/view/profile_information_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/autentication_controller.dart';
import '../Controllers/create_account_controller.dart';
import '../Controllers/home_controller.dart';
import '../Controllers/profile_screen_controller.dart';
import '../globalWidgets/text_widget.dart';

class Profile extends StatelessWidget {
  Profile({super.key});

  final CreateAccountController createAccountController =
      Get.put(CreateAccountController());

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final ProfileScreenController profileScreenController =
      Get.put(ProfileScreenController());

  @override
  Widget build(BuildContext context) {
    //homeScreenController.getDetails();
    return CustomScaffold(
      body: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: const ReusableTextWidget(
              text: 'Profile',
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          body: Sizer(
            builder: (context, orientation, deviceType) {
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  child: GetBuilder<HomeScreenController>(initState: (_) {
                    homeScreenController.getDetails();
                    homeScreenController.getRiderApiFunction();
                    print('Init state is printed');
                  }, builder: (controller) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              minRadius: 50,
                              maxRadius: 50,
                              backgroundColor: Colors.grey.withOpacity(0.4),
                              child: (controller
                                      .riderProfileImage.value.isNotEmpty)
                                  ? ClipOval(
                                      child: !controller
                                              .isRiderDetailsLoading.value
                                          ? Image.network(
                                              fit: BoxFit.cover,
                                              width: 100,
                                              height: 100,
                                              controller
                                                  .riderProfileImage.value,
                                            )
                                          : Shimmer.fromColors(
                                              baseColor: Colors.grey[300]!,
                                              highlightColor: Colors.grey[100]!,
                                              child: Container(
                                                width: 50,
                                                height: 50,
                                                color: Colors.white,
                                              ),
                                            ),
                                    )
                                  : ReusableTextWidget(
                                      text:
                                          authenticationController.getInitials(
                                                  controller.riderFirstName
                                                          .value ??
                                                      '',
                                                  controller
                                                      .riderLastName.value) ??
                                              '',
                                      fontSize: 40,
                                      fontWeight: FontWeight.w600,
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                !controller.isRiderDetailsLoading.value
                                    ? ReusableTextWidget(
                                        text:
                                            '${controller.riderFirstName.value} ${controller.riderLastName.value}',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      )
                                    : Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 200,
                                          height: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                const SizedBox(
                                  height: 5,
                                ),
                                !controller.isRiderDetailsLoading.value
                                    ? ReusableTextWidget(
                                        text: controller.riderEmail.value,
                                        fontSize: 16,
                                      )
                                    : Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 200,
                                          height: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TaskCountCard(
                          completedCount: 10,
                          pendingCount: 5,
                          ongoingCount: 6,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.person, color: Colors.black),
                          title: const ReusableTextWidget(
                            text: 'Profile Information',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          onTap: () {
                            Get.to(() => ProfileInformationScreen());
                          },
                        ),
                        ListTile(
                          leading:
                              const Icon(Icons.feedback, color: Colors.black),
                          title: const ReusableTextWidget(
                            text: "FAQ's",
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          onTap: () {
                            Get.to(() => const WebViewApp(
                                  url: 'https://www.plotrol.com/faq',
                                  appBarText: "FAQ's",
                                ));
                          },
                        ),

                        // Payment History
                        // ListTile(
                        //   leading: Icon(Icons.history, color: Colors.black),
                        //   title: const ReusableTextWidget(
                        //     text: 'History',
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        //   onTap: () {
                        //     // Handle payment history action
                        //   },
                        // ),

                        // Settings
                        // ListTile(
                        //   leading: Icon(Icons.settings, color: Colors.black),
                        //   title:  ReusableTextWidget(
                        //     text: 'Settings',
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        //   onTap: () {
                        //     // Handle settings action
                        //   },
                        // ),

                        // Logout
                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.black),
                          title: ReusableTextWidget(
                            text: 'Logout',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                          onTap: () {
                            profileScreenController.logout();
                          },
                        ),
                      ],
                    );
                  }),
                ),
              );
            },
          )),
    );
  }
}

class TaskCountCard extends StatelessWidget {
  final int completedCount;
  final int pendingCount;
  final int ongoingCount;

  TaskCountCard({
    required this.completedCount,
    required this.pendingCount,
    required this.ongoingCount,
  });

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCountItem('Completed', controller.completedOrders.length),
              VerticalDivider(
                color: Colors.grey,
                thickness: 0.5,
              ), // Vertical divider between Pending and On Going
              _buildCountItem('Accepted', controller.acceptedOrders.length),
              VerticalDivider(
                color: Colors.grey,
                thickness: 0.5,
              ), // Vertical divider between Pending and On Going
              _buildCountItem('On Going', controller.activeOrders.length),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountItem(String label, int count) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ReusableTextWidget(
          text: label,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 8),
        ReusableTextWidget(
          text: count.toString(),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
