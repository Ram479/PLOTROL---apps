import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plotrol/controller/autentication_controller.dart';
import 'package:plotrol/controller/book_your_service_controller.dart';
import 'package:plotrol/controller/create_account_controller.dart';
import 'package:plotrol/controller/home_screen_controller.dart';
import 'package:plotrol/globalWidgets/text_widget.dart';
import 'package:plotrol/view/order_details.dart';
import 'package:plotrol/view/properties_details.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';

import '../globalWidgets/flutter_toast.dart';
import '../model/response/orders/get_orders_response.dart';
import 'all_properties_dart.dart';
import 'book_your_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  final AuthenticationController authController =
      Get.put(AuthenticationController());

  final CreateAccountController createAccountController =
      Get.put(CreateAccountController());

  final BookYourServiceController bookYourServiceController =
      Get.put(BookYourServiceController());

  DateTime? currentBackPressTime;

  Future<bool> _willPopCallback() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 1)) {
      currentBackPressTime = now;
      Toast.showToast("Press one more time to exit");
      return Future.value(false);
    } else {
      Get.back();
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return GetBuilder<HomeScreenController>(initState: (_) async {
          //SharedPreferences prefs = await SharedPreferences.getInstance();
          // if(prefs.getInt('userId') == null) {
          //   Get.to(() => LoginScreen());
          // }
          controller.getDetails();
          controller.isPropertyLoading.value = true;
          controller.getPropertiesApiFunction();
          bookYourServiceController.isCategoryLoading.value = true;
          bookYourServiceController.getCategories();
          controller.getTenantApiFunction();
        }, builder: (controller) {
          return WillPopScope(
            onWillPop: () => _willPopCallback(),
            child: SafeArea(
              child: Scaffold(
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
                          child: (controller.profileImage.value.isNotEmpty)
                              ? ClipOval(
                                  child: !controller.isTenantDetailLoading.value
                                      ? Image.network(
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                          controller.tenantProfileImage.value,
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
                                          controller.tenantFirstName.value ??
                                              '',
                                          controller.tenantLastName.value) ??
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
                            ReusableTextWidget(
                              text:
                                  'Hi ${controller.tenantFirstName.toUpperCase()}',
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            const ReusableTextWidget(
                              text: 'Do you need any service?',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                body: Padding(
                  padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 2.h),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ReusableTextWidget(
                          text: 'Book Your Services',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        SizedBox(height: 120, child: CategoriesTypeWidget()),
                        const ReusableTextWidget(
                          text: 'Ongoing Task',
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        OnGoingTask(
                          status: 'active',
                        ),
                        SizedBox(
                          height: 2.5.h,
                        ),
                        Row(
                          children: [
                            const ReusableTextWidget(
                              text: 'Your Properties',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                            const Spacer(),
                            InkWell(
                              onTap: () {
                                Get.to(() => AllProperties());
                              },
                              child:
                                  (controller.getPropertiesDetails.isNotEmpty)
                                      ? const ReusableTextWidget(
                                          text: 'See All',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          isUnderText: TextDecoration.underline,
                                        )
                                      : const SizedBox(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        PropertyWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}

/// Property widget
class PropertyWidget extends StatelessWidget {
  PropertyWidget({
    super.key,
  });

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(builder: (controller) {
      return (controller.getPropertiesDetails.isEmpty &&
              !controller.isPropertyLoading.value)
          ? const SizedBox(
              height: 150,
              child: Center(
                child: ReusableTextWidget(
                  text: 'No data Found add your properties',
                  fontSize: 15,
                  // fontWeight: FontWeight.w700,
                ),
              ),
            )
          : SizedBox(
              height: 240,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.getPropertiesDetails.length,
                itemBuilder: (context, index) {
                  return controller.isPropertyLoading.value
                      ? _buildShimmerCard()
                      : Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                color: Colors.grey,
                                width: 0.3,
                              ) // Adjust radius
                              ),
                          child: SizedBox(
                            height: 150,
                            width: 180,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(10.0),
                                    topRight: Radius.circular(10.0),
                                  ),
                                  child: (controller.getPropertiesDetails[index]
                                              .tenantimage?.firstOrNull !=
                                          null)
                                      ? InkWell(
                                          onTap: () {
                                            Get.to(
                                                () => PropertiesDetailsScreen(
                                                      propertyImage: controller
                                                          .getPropertiesDetails[
                                                              index]
                                                          .tenantimage,
                                                      address: controller
                                                          .getPropertiesDetails[
                                                              index]
                                                          .address,
                                                      contactNumber: controller
                                                          .getPropertiesDetails[
                                                              index]
                                                          .contactno,
                                                    ));
                                          },
                                          child: Image.network(
                                              height: 100,
                                              width: Get.width,
                                              fit: BoxFit.fill,
                                              '${controller.getPropertiesDetails[index].tenantimage?.first}'),
                                        )
                                      : const SizedBox(),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ReusableTextWidget(
                                    text:
                                        '${controller.getPropertiesDetails[index].notes}',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: ReusableTextWidget(
                                    maxLines: 2,
                                    text:
                                        '${controller.getPropertiesDetails[index].address}',
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.black),
                                            foregroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.white),
                                            shape: WidgetStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        5), // Adjust radius
                                              ),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.to(() => BookYourService(
                                                  tenantImage: controller
                                                      .getPropertiesDetails[
                                                          index]
                                                      .tenantimage,
                                                  address: controller
                                                          .getPropertiesDetails[
                                                              index]
                                                          .address ??
                                                      '',
                                                  contactNumber: controller
                                                          .getPropertiesDetails[
                                                              index]
                                                          .contactno ??
                                                      '',
                                                  locationID: controller
                                                          .getPropertiesDetails[
                                                              index]
                                                          .locationid ??
                                                      0,
                                                ));
                                          },
                                          child: const ReusableTextWidget(
                                            text: 'BOOK SERVICE',
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        size: 20,
                                        Icons.edit,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
            );
    });
  }

  Widget _buildShimmerCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Colors.grey, width: 0.3),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: SizedBox(
          height: 150,
          width: 180,
          // Placeholder structure similar to your actual card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                  ),
                ),
                height: 100,
                width: Get.width,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 16,
                  width: 120,
                  color: Colors.grey[300],
                ),
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  height: 32,
                  width: 160,
                  color: Colors.grey[300],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 100,
                      color: Colors.grey[300],
                    ),
                    const Spacer(),
                    Icon(
                      Icons.edit,
                      size: 20,
                      color: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Category Widget
class CategoriesTypeWidget extends StatelessWidget {
  CategoriesTypeWidget({super.key});

  final BookYourServiceController controller =
      Get.put(BookYourServiceController());

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
          DeviceType deviceType) {
        return GetBuilder<BookYourServiceController>(builder: (controller) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return controller.isCategoryLoading.value
                  ? Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: CircleAvatar(
                              maxRadius: 40,
                              minRadius: 40,
                              backgroundColor: Colors.grey[300]!,
                            ),
                          ),
                          const SizedBox(height: 5),
                          ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: Container(
                              width: 80,
                              height: 20,
                              color: Colors.grey[300]!,
                            ),
                          ),
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        Get.to(() => AllProperties(
                              selectedCategory: controller
                                      .listOfCategories[index].categoryname ??
                                  '',
                              isFromCategory: true,
                            ));
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              maxRadius: 40,
                              minRadius: 40,
                              backgroundImage: NetworkImage(
                                controller
                                        .listOfCategories[index].serviceimage ??
                                    '',
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          ReusableTextWidget(
                            text: controller
                                    .listOfCategories[index].categoryname ??
                                '',
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ],
                      ),
                    );
            },
          );
        });
      },
    );
  }
}

/// OnGoing Task widget
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
    return GetBuilder<HomeScreenController>(
      initState: (_) {
        homeScreenController.isOrderLoading.value = true;
        homeScreenController.getOrdersApiFunction();
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
            height: 145,
            child: buildShimmerLoader(),
          );
        }

        if (isVerticalScrollable) {
          if (status == 'created') {
            if (controller.createdOrders.isEmpty) {
              return SizedBox(
                height: Get.height * 0.6,
                child: const Center(
                  child: ReusableTextWidget(
                    text: 'No Created Orders Found ☹',
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
              itemCount: controller.createdOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.createdOrders[index]);
              },
            );
          }
          if (status == 'pending') {
            if (controller.pendingOrders.isEmpty) {
              return SizedBox(
                height: Get.height * 0.6,
                child: const Center(
                  child: ReusableTextWidget(
                    text: 'No Pending Orders Found ☹',
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
          }
          if (status == 'accepted') {
            if (controller.acceptedOrders.isEmpty) {
              return SizedBox(
                height: Get.height * 0.6,
                child: const Center(
                  child: ReusableTextWidget(
                    text: 'No Accepted Orders Found ☹',
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
                    text: 'No Active Orders Found ☹',
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
                    text: 'No Orders Found for Today ☹',
                    fontSize: 15,
                  ),
                ),
              );
            }
            return ListView.builder(
              // physics: isForStatusScreen ? null : const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: controller.todayOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.todayOrders[index]);
              },
            );
          }
        } else {
          if (controller.activeOrders.isEmpty) {
            return SizedBox(
              height: Get.height * 0.25,
              child: const Center(
                child: ReusableTextWidget(
                  text: 'No Active Orders Found ☹',
                  fontSize: 15,
                ),
              ),
            );
          }
          return SizedBox(
            height: 145,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.activeOrders.length,
              itemBuilder: (context, index) {
                return buildOrderItem(controller.activeOrders[index]);
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
              staffMobileNumber: order.contactno ?? '',
              staffLocation: order.address ?? '',
              staffName: '${order.firstname} ${order.lastname}',
              startDate: order.ready ?? '',
              acceptedDate: order.processing ?? '',
              completedDate: order.completed ?? '',
            ));
      },
      child: Container(
        height: 180,
        width: 280,
        margin: isVerticalScrollable
            ? const EdgeInsets.symmetric(vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(color: Colors.grey, width: 1.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
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
                          : SizedBox.shrink(),
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
                              maxLines: 4,
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
                      padding: const EdgeInsets.all(4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableTextWidget(
                            text: order.orderstatus ?? '',
                            color: Colors.white,
                            fontSize: 10,
                            textAlign: TextAlign.center,
                          ),
                          if (order.orderstatus == 'completed')
                            const Icon(
                              size: 16,
                              Icons.check_circle,
                              color: Colors.white,
                            )
                        ],
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
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 5, // Placeholder item count for shimmer effect
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
    case 'created':
      return BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(10),
      );
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
