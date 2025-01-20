import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plotrol/controller/order_status_controller.dart';

import '../globalWidgets/text_widget.dart';
import 'home_screen.dart';

class OrderStatusScreen extends StatelessWidget {

  OrderStatusScreen({super.key});

  final OrderStatusController orderStatusController = Get.put(OrderStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          controller: orderStatusController.tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Colors.black,
          tabs: const [
            Tab(
              child: ReusableTextWidget(
                text: 'Created',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
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
        initState: (_) {
           orderStatusController.tabController.index = 0;
        },
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
                      status: 'created',
                      isForStatusScreen: true,
                    )
                ),
                SizedBox(
                    height: 200,
                    width: Get.width,
                    child: OnGoingTask(
                      isVerticalScrollable: true,
                      status: 'pending',
                      isForStatusScreen: true,
                    )
                ),
                SizedBox(
                    height: 200,
                    width: Get.width,
                    child: OnGoingTask(
                      isVerticalScrollable: true,
                      status: 'accepted',
                      isForStatusScreen: true,
                    )
                ),
                SizedBox(
                    width: Get.width,
                    child: OnGoingTask(
                      isVerticalScrollable: true,
                      status: 'active',
                      isForStatusScreen: true,
                    )
                ),
                SizedBox(
                    width: Get.width,
                    child: OnGoingTask(
                      isVerticalScrollable: true,
                      status: 'completed',
                      isForStatusScreen: true,
                    )
                ),
              ],
            ),
          );
        }
       ),
    );
  }
}
