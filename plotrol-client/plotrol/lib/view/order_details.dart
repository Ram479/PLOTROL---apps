import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:plotrol/controller/order_details_controlller.dart';
import 'package:plotrol/globalWidgets/custom_scaffold_widget.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../controller/home_screen_controller.dart';
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
  final String staffName;
  final String staffMobileNumber;
  final String staffLocation;
  final String acceptedDate;
  final String startDate;
  final String completedDate;

  OrderDetailScreen({
    super.key,
    this.suburb = '',
    this.date = '',
    this.tenantName = '',
    this.address = '',
    this.tenantContactName = '',
    this.tenantLatitude = '',
    this.tenantLongitude = '',
    this.staffLocation = '',
    this.staffMobileNumber = '',
    this.staffName = '',
    required this.tasks,
    required this.propertyImage,
    this.orderImages,
    this.startDate = '',
    this.completedDate = '',
    this.acceptedDate = '',
    required this.type,
    required this.orderID,
  });

  final OrderDetailsController orderDetailsController =
      Get.put(OrderDetailsController());

  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(initState: (_) {
      if (type == 'completed') {
        orderDetailsController.setItems(tasks);
      }
    }, builder: (controller) {
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
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 140,
                    child: InkWell(
                      onTap: () {},
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
                                    : SizedBox.shrink(),
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
                                        SizedBox(
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
                  (type != 'completed')
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
                              .toList(),
                        )
                      : const SizedBox(),
                  type == 'completed'
                      ? const SizedBox(
                          height: 15,
                        )
                      : const SizedBox(),
                  type == 'completed'
                      ? const ReusableTextWidget(
                          text: 'Staff Uploads',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        )
                      : const SizedBox(),
                  type == 'completed'
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox(),
                  type == 'completed'
                      ? HorizontalImageListView(
                          imageUrls: orderImages ?? [],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 15,
                  ),
                  type != 'pending' && type != 'created'
                      ? const ReusableTextWidget(
                          text: 'Staff Details',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        )
                      : const SizedBox(),
                  type != 'pending' && type != 'created'
                      ? const SizedBox(
                          height: 10,
                        )
                      : const SizedBox(),
                  type != 'pending' && type != 'created'
                      ? Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6.0,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Colors.grey),
                                  const SizedBox(width: 10.0),
                                  ReusableTextWidget(
                                    text: staffName,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.grey),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: ReusableTextWidget(
                                      text: staffLocation,
                                      fontSize: 16,
                                      maxLines: 4,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const Icon(Icons.phone, color: Colors.grey),
                                  const SizedBox(width: 10.0),
                                  ReusableTextWidget(
                                    text: staffMobileNumber,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Row(
                                children: [
                                  const Icon(Icons.date_range,
                                      color: Colors.grey),
                                  const SizedBox(width: 10.0),
                                  ReusableTextWidget(
                                    text: date,
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  type == 'pending' || type == 'created'
                      ? const SizedBox()
                      : const SizedBox(
                          height: 20,
                        ),
                  const ReusableTextWidget(
                    text: 'Task Timeline',
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTimelineTile(
                          title: 'Accepted',
                          icon: Icons.lock_clock,
                          dateString: acceptedDate,
                          isFirst: true,
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
                  Get.back();
                },
                borderRadius: 10,
                controller: controller.btnController,
                child: const ReusableTextWidget(
                  text: 'Done',
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

class TimelineTileWithDates extends StatelessWidget {
  final DateTime acceptedDate;
  // final DateTime activatedDate;
  final DateTime completedDate;
  final String title;
  // Optional content widget for the tile body

  const TimelineTileWithDates({
    required this.acceptedDate,
    //required this.activatedDate,
    required this.completedDate,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      indicatorStyle: IndicatorStyle(
        // width: 30, // Adjust width of the indicator
        indicator: Icon(Icons.check, color: Colors.green),
        padding: EdgeInsets.all(8), // Adjust padding if needed
      ),

      // axis: TimelineAxis.horizontal,
      lineXY: 0.1, // Adjust line position if needed
      isFirst: false, // Set based on your timeline position
      isLast: false, // Set based on your timeline position
      startChild: _buildDateWidget(acceptedDate, "Started"),
      alignment: TimelineAlign.center,
      endChild: _buildDateWidget(completedDate, "Completed"),
      // Add content child if provided
      //endChild: content,
    );
  }

  Widget _buildDateWidget(DateTime date, String label) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
          Text(DateFormat('dd-MM-yyyy').format(date)),
        ],
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
    // DateTime parsedDate = DateFormat("yyyy-MM-dd HH:mm:ssZ").parse(dateString);
    // String formattedDate = DateFormat("dd-MM-yyyy").format(parsedDate);
    // String formattedTime = DateFormat("h:mm a").format(parsedDate);

    return Expanded(
      child: TimelineTile(
        axis: TimelineAxis.horizontal,
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
        endChild: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            ReusableTextWidget(
              text: title,
              fontSize: 15,
            ),

            /// we can add date and time if we need later
            // ReusableTextWidget(
            //   text: formattedDate,
            // ),
            // ReusableTextWidget(
            //   text: formattedTime,
            // ),
          ],
        ),
      ),
    );
  }
}
