import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plotrolgigs/globalWidgets/custom_scaffold_widget.dart';
import 'package:rounded_loading_button_plus/rounded_loading_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Controllers/order_details_controlller.dart';
import '../globalWidgets/text_widget.dart';

class PropertyDetailsScreen extends StatelessWidget {
  final String address;
  final String date;
  final String tenantName;
  final List<String> tasks;
  final List<String> propertyImage;
  final String? contact;

  PropertyDetailsScreen({
    super.key,
    this.address = '',
    this.date = '',
    this.tenantName = '',
    required this.tasks,
    required this.propertyImage,
    this.contact,
  });

  final OrderDetailsController orderDetailsController =
      Get.put(OrderDetailsController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderDetailsController>(initState: (_) {
      //orderDetailsController.setItems(tasks);
    }, builder: (controller) {
      return CustomScaffold(
        body: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 350,
                          autoPlay: false,
                          enlargeCenterPage: false,
                          aspectRatio: 16 / 9,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          enableInfiniteScroll: true,
                          autoPlayAnimationDuration:
                              const Duration(milliseconds: 800),
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            orderDetailsController.onPageChanged(index);
                          },
                        ),
                        items: propertyImage
                            .map((item) => Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10.0),
                                        bottomRight: Radius.circular(10.0),
                                      ),
                                      child: Image.network(
                                        item,
                                        fit: BoxFit.cover,
                                        height: 350,
                                      ),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      Positioned(
                        top: 16,
                        left: 0,
                        child: IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons
                                    .location_on, // Choose the icon you want to use
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4.0),
                              Expanded(
                                child: ReusableTextWidget(
                                  text: address,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Colors.white,
                                  maxLines: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    return Center(
                      child: AnimatedSmoothIndicator(
                        activeIndex: orderDetailsController.currentIndex.value,
                        count: propertyImage.length,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Colors.black,
                          dotColor: Colors.grey,
                          dotHeight: 10.0,
                          dotWidth: 20.0,
                          spacing: 8.0,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ReusableTextWidget(
                      text: 'Task Details',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Obx(() {
                  //   return Container(
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         // Background color of the container
                  //         borderRadius: BorderRadius.circular(10.0),
                  //         border: Border.all(
                  //           color: Colors.grey, // Border color
                  //           width: 1.0,
                  //         ),
                  //       ),
                  //       child: Padding(
                  //         padding: EdgeInsets.only(left: 10, right: 10),
                  //         child: Column(
                  //           children:
                  //           List.generate(controller.items.length, (index) {
                  //             return CheckboxListTile(
                  //               checkColor: Colors.white,
                  //               activeColor: Colors.black,
                  //               contentPadding: EdgeInsets.zero,
                  //               title: ReusableTextWidget(
                  //                 text: controller.items[index]['name'],
                  //                 fontSize: 16,
                  //               ),
                  //               value: controller.items[index]['isChecked'],
                  //               onChanged: (bool? value) {
                  //                 controller.toggleCheck(index);
                  //               },
                  //             );
                  //           }),
                  //         ),
                  //       ));
                  // }),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Wrap(
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
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: ReusableTextWidget(
                      text: 'Holder Details',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Container(
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
                                text: tenantName,
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
                              const Icon(Icons.location_on, color: Colors.grey),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: ReusableTextWidget(
                                  text: address,
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
                                text: contact ?? '',
                                fontSize: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              const Icon(Icons.date_range, color: Colors.grey),
                              const SizedBox(width: 10.0),
                              ReusableTextWidget(
                                text: date,
                                fontSize: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
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
                  controller.btnController.reset();
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
