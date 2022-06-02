import 'package:amazcart/controller/order_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/account/orders/OrderList/OrderToPayList.dart';
import 'package:amazcart/view/account/orders/OrderList/OrderToReceiveList.dart';
import 'package:amazcart/view/account/orders/OrderList/OrderToShipList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AllOrdersList.dart';

class MyOrders extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  final int tabIndex;

  MyOrders(this.tabIndex);

  @override
  Widget build(BuildContext context) {
    orderController.controller!.index = tabIndex;

    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        title: Text(
          'My Orders'.tr,
          style: AppStyles.appFont.copyWith(
            color: AppStyles.blackColor,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        bottom: TabBar(
          controller: orderController.controller,
          labelColor: AppStyles.blackColor,
          labelPadding: EdgeInsets.zero,
          tabs: orderController.tabs,
          indicatorColor: AppStyles.pinkColor,
          unselectedLabelColor: AppStyles.greyColorDark,
        ),
      ),
      body: TabBarView(
        controller: orderController.controller,
        children: [
          AllOrdersListScreen(),
          OrderToPayListScreen(),
          OrderToShipListScreen(),
          OrderToReceiveListScreen(),
        ],
      ),
    );
  }
}
