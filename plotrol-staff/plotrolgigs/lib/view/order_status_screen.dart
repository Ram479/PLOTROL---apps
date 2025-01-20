import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plotrolgigs/globalWidgets/custom_scaffold_widget.dart';

import '../Controllers/order_status_controller.dart';
import '../globalWidgets/text_widget.dart';
import 'home_screen.dart';

class OrderStatusScreen extends StatelessWidget {
  OrderStatusScreen({super.key});

  final OrderStatusController orderStatusController =
      Get.put(OrderStatusController());

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          title: const ReusableTextWidget(
            text: 'Order Status',
            fontSize: 21,
            fontWeight: FontWeight.w700,
          ),
          bottom: TabBar(
            isScrollable: true,
            controller: orderStatusController.tabController,
            indicatorColor: Colors.black,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(
                child: ReusableTextWidget(
                  text: 'Pending',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Tab(
                child: ReusableTextWidget(
                  text: 'Accepted',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Tab(
                child: ReusableTextWidget(
                  text: 'Ongoing',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Tab(
                child: ReusableTextWidget(
                  text: 'Completed',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        body: GetBuilder<OrderStatusController>(
            initState: (_) {},
            builder: (controller) {
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    SizedBox(
                      height: 200,
                      width: Get.width,
                      child: OnGoingTask(
                        isVerticalScrollable: true,
                        isForStatusScreen: true,
                        status: 'pending',
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      width: Get.width,
                      child: OnGoingTask(
                        isVerticalScrollable: true,
                        isForStatusScreen: true,
                        status: 'accepted',
                      ),
                    ),
                    SizedBox(
                        width: Get.width,
                        child: OnGoingTask(
                          isVerticalScrollable: true,
                          isForStatusScreen: true,
                          status: 'active',
                        )),
                    SizedBox(
                        width: Get.width,
                        child: OnGoingTask(
                          isVerticalScrollable: true,
                          isForStatusScreen: true,
                          status: 'completed',
                        )),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
