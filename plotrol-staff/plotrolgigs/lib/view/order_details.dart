import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:plotrolgigs/Controllers/home_controller.dart';
import 'package:plotrolgigs/globalWidgets/custom_scaffold_widget.dart';
import 'package:plotrolgigs/pushnotification.dart';
import 'package:plotrolgigs/view/property_details.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../Controllers/order_details_controlller.dart';
import '../Helper/Logger.dart';
import '../globalWidgets/text_widget.dart';

class OrderDetailScreen extends StatelessWidget {
  final String address;
  final String suburb;
  final String date;
  final String tenantName;
  final String tenantContactName;
  final List<String> tasks;
  final List<String> propertyImage;
  final List<String>? orderImages;
  final String type;
  final int orderID;
  final String tenantLatitude;
  final String tenantLongitude;
  final String acceptedDate;
  final String startDate;
  final String completedDate;
  final String assignedDate;
  final String tenantToken;
  final String staffName;

  OrderDetailScreen(
      {super.key,
      this.suburb = '',
      this.date = '',
      this.tenantName = '',
      this.address = '',
      this.tenantContactName = '',
      this.tenantLatitude = '',
      this.tenantLongitude = '',
      this.startDate = '',
      this.completedDate = '',
      this.acceptedDate = '',
      this.assignedDate = '',
      required this.tasks,
      required this.propertyImage,
      this.orderImages,
      required this.type,
      required this.orderID,
      required this.tenantToken,
      this.staffName = ''});

  final OrderDetailsController orderDetailsController =
      Get.put(OrderDetailsController());

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  final PushNotificationService notificationService = PushNotificationService();

  @override
  Widget build(BuildContext context) {
    logger.i('Type : $type');
    logger.i('orderHeaderID : $orderID');
    logger.i('orderImages  : ${orderImages}');
    logger.i('Tenant Address : ${address}');
    logger.i('Tenant token : ${tenantToken}');
    return GetBuilder<OrderDetailsController>(initState: (_) {
      if (type == 'accepted') {
        orderDetailsController.getLocation();
      }
      if (type == 'pending') {}
      if (type == 'active') {
        orderDetailsController.setItems(tasks);
      }
      if (type == 'completed') {
        orderDetailsController.setItems(tasks);
      }
    }, builder: (controller) {
      if (controller.latitude.value.isNotEmpty &&
          controller.longitude.value.isNotEmpty) {
        print('tenantLatitude: $tenantLatitude');
        if (tenantLatitude.trim().isNotEmpty &&
            tenantLongitude.trim().isNotEmpty) {
          controller.calculateDistance(
            double.parse(tenantLatitude),
            double.parse(tenantLongitude),
            double.parse(controller.latitude.value.toString()),
            double.parse(controller.longitude.value.toString()),
          );
        }
      }
      return CustomScaffold(
        body: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const ReusableTextWidget(
              text: 'Order Details',
              fontSize: 21,
              fontWeight: FontWeight.w700,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 140,
                    child: InkWell(
                      onTap: () {
                        Get.to(() => PropertyDetailsScreen(
                            tasks: tasks,
                            propertyImage: propertyImage,
                            address: suburb,
                            date: date,
                            tenantName: tenantName,
                            contact: tenantContactName));
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(
                              color: Colors.grey,
                              width: 0.3,
                            ) // Adjust radius
                            ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10.0),
                                  bottomLeft: Radius.circular(10.0),
                                ),
                                child: propertyImage.firstOrNull != null
                                    ? Image.network(
                                        propertyImage.firstOrNull ?? '',
                                        width: 120,
                                        height: 140,
                                        fit: BoxFit.fill,
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ReusableTextWidget(
                                          text: tenantName,
                                          fontSize: 15,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          color: Colors.grey,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                          child: SizedBox(
                                            width: Get.width * 0.40,
                                            child: ReusableTextWidget(
                                              text: suburb,
                                              fontSize: 15,
                                              maxLines: 3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.phone,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ReusableTextWidget(
                                          text: '+91 $tenantContactName',
                                          fontSize: 15,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.date_range,
                                          color: Colors.grey,
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        ReusableTextWidget(
                                          text: date,
                                          fontSize: 15,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  type == 'accepted'
                      ? const SizedBox(
                          height: 15,
                        )
                      : const SizedBox(),
                  ReusableTextWidget(
                    text: type == 'completed'
                        ? 'Completed Tasks'
                        : 'Task Details',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  type == 'active'
                      ? Obx(() {
                          return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // Background color of the container
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey, // Border color
                                  width: 1.0,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Column(
                                  children: List.generate(
                                      controller.items.length, (index) {
                                    return CheckboxListTile(
                                      checkColor: Colors.white,
                                      activeColor: Colors.black,
                                      contentPadding: EdgeInsets.zero,
                                      title: ReusableTextWidget(
                                        text: controller.items[index]['name'],
                                        fontSize: 16,
                                      ),
                                      value: controller.items[index]
                                          ['isChecked'],
                                      onChanged: (bool? value) {
                                        controller.toggleCheck(index);
                                      },
                                    );
                                  }),
                                ),
                              ));
                        })
                      : const SizedBox(),
                  type == 'completed'
                      ? Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            // Background color of the container
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey, // Border color
                              width: 1.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Column(
                              children: List.generate(controller.items.length,
                                  (index) {
                                return CheckboxListTile(
                                  checkColor: Colors.white,
                                  activeColor: Colors.grey,
                                  contentPadding: EdgeInsets.zero,
                                  title: ReusableTextWidget(
                                    text: controller.items[index]['name'],
                                    fontSize: 16,
                                  ),
                                  value: true,
                                  onChanged: (bool? value) {
                                    // controller.toggleCheck(index);
                                  },
                                );
                              }),
                            ),
                          ))
                      : const SizedBox(),
                  (type != 'active' && type != 'completed')
                      ? Wrap(
                          spacing: 4.0, // Space between each child
                          runSpacing: 6.0, // Space between each line
                          children: tasks
                              .map((category) => Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    margin: const EdgeInsets.only(right: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: ReusableTextWidget(
                                      text: category,
                                      fontSize: 16,
                                    ),
                                  ))
                              .toList())
                      : const SizedBox(),
                  const SizedBox(
                    height: 15,
                  ),
                  type == 'active'
                      ? const ReusableTextWidget(
                          text: 'Upload Images',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        )
                      : const SizedBox(),
                  type == 'completed'
                      ? const ReusableTextWidget(
                          text: 'Uploaded Images',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  type == 'active'
                      ? InkWell(
                          onTap: () {
                            controller.getImageList();
                          },
                          child: DottedBorder(
                            dashPattern: [6, 6],
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(12),
                            padding: const EdgeInsets.all(6),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              child: Container(
                                height: 180,
                                width: Get.width,
                                color: Colors.grey.withOpacity(0.5),
                                child: (controller.images?.isEmpty ?? false)
                                    ? const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 8),
                                          ReusableTextWidget(
                                            text: 'Upload Image',
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                          )
                                        ],
                                      )
                                    : ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.images!.length,
                                        itemBuilder: (context, index) {
                                          final XFile image =
                                              controller.images![index];
                                          return Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal:
                                                    5.0), // Add margin for spacing
                                            child: Stack(children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(
                                                    8.0), // Add rounded corners (optional)
                                                child: Image.file(
                                                  File(image.path),
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.error,
                                                        color: Colors.red,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Positioned(
                                                top:
                                                    -2, // Adjust position as needed
                                                right:
                                                    -2, // Adjust position as needed
                                                child: IconButton(
                                                  icon: const Icon(Icons.cancel,
                                                      color: Colors.white),
                                                  onPressed: () {
                                                    controller
                                                        .removeImageList(index);
                                                  },
                                                ),
                                              ),
                                            ]),
                                          );
                                        },
                                      ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                  type == 'completed'
                      ? HorizontalImageListView(
                          imageUrls: orderImages ?? [],
                        )
                      : const SizedBox(),
                  type == 'completed' || type == 'active'
                      ? const SizedBox(
                          height: 15,
                        )
                      : const SizedBox(),
                  const ReusableTextWidget(
                    text: 'Task Timeline',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 300,
                    child: Column(
                      children: [
                        CustomTimelineTile(
                          title: 'Assigned',
                          icon: Icons.person_2_sharp,
                          dateString: assignedDate,
                          isFirst: true,
                        ),
                        CustomTimelineTile(
                          title: 'Accepted',
                          icon: Icons.lock_clock,
                          dateString: acceptedDate,
                        ),
                        CustomTimelineTile(
                          title: 'Started',
                          icon: Icons.hourglass_bottom_rounded,
                          dateString: startDate,
                        ),
                        CustomTimelineTile(
                          title: 'Completed',
                          icon: Icons.check_circle,
                          dateString: completedDate,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: RoundedLoadingButton(
                width: Get.width,
                color: Colors.black,
                onPressed: () async {
                  controller.handleButtonPress(type, orderID);
                  logger.i('TenantToken : $tenantToken');
                  if (controller.isValid || type == 'pending') {
                    controller.createNotification(
                      token: tenantToken,
                      title: 'Order Status Update',
                      body: getBodyText(type, staffName),
                    );
                  }
                },
                borderRadius: 10,
                controller: controller.btnController,
                child: ReusableTextWidget(
                  text: getButtonLabel(type),
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

String getBodyText(String type, String staffName) {
  if (type == 'pending') {
    return '$staffName has accepted your order';
  } else if (type == 'accepted') {
    return '$staffName have started your order';
  } else if (type == 'active') {
    return '$staffName have completed your order';
  }
  return 'status';
}

String getButtonLabel(String type) {
  if (type == 'active') {
    return 'Complete Work';
  } else if (type == 'accepted') {
    return 'Start Work';
  } else if (type == 'completed') {
    return 'Done';
  } else {
    return 'Accept Order';
  }
}

String getStatusKey(String type) {
  if (type == 'active') {
    return 'completed';
  } else if (type == 'accepted') {
    return 'active';
  } else if (type == 'pending') {
    return 'accepted';
  } else {
    return '';
  }
}

class HorizontalImageListView extends StatelessWidget {
  final List<String> imageUrls;

  const HorizontalImageListView({super.key, required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150, // Adjust the height as per your requirement
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
              width: 8); // Adjust the spacing between items here
        },
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: 150, // Adjust the width as per your requirement
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrls[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomTimelineTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final String dateString;
  final bool isFirst;
  final bool isLast;

  CustomTimelineTile({
    required this.title,
    required this.icon,
    required this.dateString,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    String parseAndFormatDate(String? dateString) {
      if (dateString == null || dateString.isEmpty) {
        return '';
      }

      try {
        DateTime parsedDate =
            DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(dateString);
        String formattedDate = DateFormat("dd-MM-yyyy").format(parsedDate);
        String formattedTime = DateFormat("h:mm a").format(parsedDate);
        return '$formattedDate $formattedTime';
      } catch (e) {
        // Handle parsing error
        return 'Invalid date format';
      }
    }

    return Expanded(
      child: TimelineTile(
        axis: TimelineAxis.vertical,
        alignment: TimelineAlign.start,
        isFirst: isFirst,
        isLast: isLast,
        beforeLineStyle: LineStyle(
            thickness: 3,
            color: dateString.isEmpty ? Colors.grey : Colors.black),
        afterLineStyle: LineStyle(
            thickness: 3,
            color: dateString.isEmpty ? Colors.grey : Colors.black),
        indicatorStyle: IndicatorStyle(
          color: Colors.green,
          indicator: CircleAvatar(
            // radius: 45,
            backgroundColor: dateString.isEmpty ? Colors.grey : Colors.black,
            child: CircleAvatar(
              radius: 22,
              backgroundColor: Colors.white,
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: dateString.isEmpty ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
          height: 50,
          width: 50,
        ),
        endChild: Row(
          //  mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              width: 15,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReusableTextWidget(
                  text: title,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
                ReusableTextWidget(
                  text: parseAndFormatDate(dateString),
                ),
              ],
            ),

            /// we can add date and time if we need later
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
