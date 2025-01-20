import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plotrolgigs/Controllers/home_controller.dart';
import 'package:plotrolgigs/globalWidgets/custom_scaffold_widget.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/autentication_controller.dart';
import '../Controllers/create_account_controller.dart';
import '../Modal/Response/get_orders.dart';
import '../globalWidgets/text_widget.dart';
import 'order_details.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final AuthenticationController authController =
      Get.put(AuthenticationController());

  final CreateAccountController createAccountController =
      Get.put(CreateAccountController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Sizer(
        builder: (BuildContext context, Orientation orientation,
            DeviceType deviceType) {
          return GetBuilder<HomeScreenController>(initState: (_) {
            homeScreenController.getRiderApiFunction();
          }, builder: (controller) {
            List<Widget> widgetList = [
              const ReusableTextWidget(
                text: 'Today Tasks',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(
                height: 1.h,
              ),
              OnGoingTask(isVerticalScrollable: true),
              SizedBox(
                height: 2.5.h,
              ),
            ];
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: AppBar(
                  backgroundColor: Colors.white,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      CircleAvatar(
                        minRadius: 25,
                        maxRadius: 25,
                        backgroundColor: Colors.grey.withOpacity(0.4),
                        child: (controller.riderProfileImage.value.isNotEmpty)
                            ? ClipOval(
                                child: !controller.isRiderDetailsLoading.value
                                    ? Image.network(
                                        fit: BoxFit.cover,
                                        width: 50,
                                        height: 50,
                                        controller.riderProfileImage.value,
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
                                text: authController.getInitials(
                                        controller.riderFirstName.value ?? '',
                                        controller.riderLastName.value) ??
                                    '',
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                              ),
                      ),
                      SizedBox(
                        width: 2.h,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(controller.notes[1]),
                          ReusableTextWidget(
                            text: controller.riderFirstName.isNotEmpty
                                ? 'Hi ${controller.riderFirstName.toUpperCase()}'
                                : 'Hi ${createAccountController.firstName.value.toUpperCase()}',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          const ReusableTextWidget(
                            text: 'Contribute more, earn more.',
                          ),
                        ],
                      ),
                      // const Spacer(),
                      // const Icon(Icons.notifications),
                    ],
                  ),
                ),
              ),
              body: Padding(
                padding: EdgeInsets.only(
                    left: 2.h, right: 2.h, top: 2.h, bottom: 2.h),
                child: ListView.builder(
                    itemCount: widgetList.length,
                    itemBuilder: (context, index) {
                      return widgetList[index];
                    }),
              ),
            );
          });
        },
      ),
    );
  }
}

class OnGoingTask extends StatelessWidget {
  final bool isVerticalScrollable;
  final bool isForStatusScreen;
  final String status;

  OnGoingTask({
    super.key,
    this.isVerticalScrollable = false,
    this.isForStatusScreen = false,
    this.status = '',
  });

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    print('The status : ${status}');
    return GetBuilder<HomeScreenController>(
      initState: (_) {
        homeScreenController.getOrdersApiFunction();
        homeScreenController.isOrderLoading.value = true;
      },
      builder: (controller) {
        // if (homeScreenController.getOrderDetails.isEmpty && !controller.isOrderLoading.value) {
        //   return const SizedBox(
        //     height: 145,
        //     child: Center(
        //       child: ReusableTextWidget(
        //         text: 'No Task Found',
        //         fontSize: 15,
        //       ),
        //     ),
        //   );
        // }

        if (homeScreenController.isOrderLoading.value) {
          return SizedBox(
            height: 500,
            child: buildShimmerLoader(),
          );
        }

        if (isVerticalScrollable) {
          if (status == 'accepted') {
            if (controller.acceptedOrders.isEmpty) {
              return SizedBox(
                height: Get.height * 0.6,
                child: const Center(
                  child: ReusableTextWidget(
                    text: 'No Accepted Tasks Found ☹',
                    fontSize: 15,
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: isForStatusScreen
                  ? null
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.acceptedOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.acceptedOrders[index]);
              },
            );
          } else if (status == 'pending') {
            if (controller.pendingOrders.isEmpty) {
              return SizedBox(
                height: Get.height * 0.6,
                child: const Center(
                  child: ReusableTextWidget(
                    text: 'No Pending Tasks Found ☹',
                    fontSize: 15,
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: isForStatusScreen
                  ? null
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.pendingOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.pendingOrders[index]);
              },
            );
          } else if (status == 'completed') {
            if (controller.completedOrders.isEmpty) {
              return SizedBox(
                height: Get.height * 0.6,
                child: const Center(
                  child: ReusableTextWidget(
                    text: 'No Completed Tasks Found ☹',
                    fontSize: 15,
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: isForStatusScreen
                  ? null
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.completedOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.completedOrders[index]);
              },
            );
          } else if (status == 'active') {
            if (controller.activeOrders.isEmpty) {
              return SizedBox(
                height: Get.height * 0.6,
                child: const Center(
                  child: ReusableTextWidget(
                    text: 'No Active Tasks Found ☹',
                    fontSize: 15,
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: isForStatusScreen
                  ? null
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.activeOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.activeOrders[index]);
              },
            );
          } else {
            if (controller.todayOrders.isEmpty) {
              return SizedBox(
                height: Get.height * 0.6,
                child: const Center(
                  child: ReusableTextWidget(
                    text: 'No Tasks Found for Today ☹',
                    fontSize: 15,
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: isForStatusScreen
                  ? null
                  : const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controller.todayOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.todayOrders[index]);
              },
            );
          }
        } else {
          return SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.todayOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.todayOrders[index]);
              },
            ),
          );
        }
      },
    );
  }

  Widget buildOrderItem(OrderDetails order) {
    return InkWell(
      onTap: () {
        print('order.latitude: ${order.latitude}');

        /// Accepted, Completed, Pending
        Get.to(() => OrderDetailScreen(
            tasks: order.categoryname ?? [],
            suburb: order.tenantsuburb ?? '',
            address: order.address ?? '',
            tenantName: order.tenantname ?? '',
            propertyImage: order.tenantimage ?? [],
            date: _formatDate(order.orderdate ?? ''),
            tenantContactName: order.tenantcontactno ?? '',
            type: order.orderstatus ?? '',
            orderID: order.orderheaderid ?? 0,
            tenantLatitude: order.latitude ?? '',
            tenantLongitude: order.longitude ?? '',
            orderImages: order.orderimages ?? [],
            startDate: order.ready ?? '',
            acceptedDate: order.processing ?? '',
            completedDate: order.completed ?? '',
            assignedDate: order.pending ?? '',
            tenantToken: order.tenanttoken ?? '',
            staffName: '${order.firstname} ${order.lastname}'));
      },
      child: Container(
        height: 145,
        width: 280,
        margin: isVerticalScrollable
            ? const EdgeInsets.symmetric(vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(color: Colors.grey, width: 0.1),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: order.tenantimage?.firstOrNull != null
                          ? Image.network(
                              order.tenantimage?.firstOrNull ?? '',
                              fit: BoxFit.cover,
                            )
                          : const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: ReusableTextWidget(
                          text: order.locationcity ?? '',
                          maxLines: 2,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            size: 15,
                            Icons.location_on,
                          ),
                          const SizedBox(width: 3),
                          SizedBox(
                            width: 120,
                            child: ReusableTextWidget(
                              text: order.address ?? '',
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    decoration: _getDecorationBasedOnStatus(order.orderstatus),
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: ReusableTextWidget(
                        text: order.orderstatus ?? '',
                        color: Colors.white,
                        fontSize: 10,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: order.categoryname
                          ?.map((category) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              margin: const EdgeInsets.only(right: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: ReusableTextWidget(text: category)))
                          .toList() ??
                      [const ReusableTextWidget(text: 'No Category')],
                ),
              ),
              const Spacer(),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // const Icon(
                  //   size: 15,
                  //   Icons.date_range,
                  // ),
                  // const SizedBox(width: 3),
                  ReusableTextWidget(
                    text: 'Order Date : ${_formatDate(order.orderdate ?? '')}',
                    fontSize: 13,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildShimmerLoader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        //physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 10, // Placeholder item count for shimmer effect
        itemBuilder: (context, index) {
          return Container(
            height: 145,
            width: 280,
            margin: isVerticalScrollable
                ? const EdgeInsets.symmetric(vertical: 4)
                : const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 120,
                            height: 15,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 120,
                            height: 15,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        width: 50,
                        height: 20,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 15,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const Spacer(),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        size: 15,
                        Icons.date_range,
                      ),
                      const SizedBox(width: 3),
                      Container(
                        height: 15,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return '';
    }
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return ''; // Return an empty string if parsing fails
    }
  }
}

BoxDecoration _getDecorationBasedOnStatus(String? status) {
  switch (status) {
    case 'pending':
      return BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(10),
      );
    case 'accepted':
      return BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(10),
      );
    case 'active':
      return BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
      );
    case 'completed':
      return BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(10),
      );
    default:
      return BoxDecoration(
        color: Colors.orangeAccent,
        borderRadius: BorderRadius.circular(10),
      );
  }
}
