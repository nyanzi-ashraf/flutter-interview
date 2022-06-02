import 'package:amazcart/controller/order_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderData.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/account/orders/OrderList/widgets/NoOrderPlacedWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'widgets/OrderListDataWidget.dart';

class OrderToPayListScreen extends StatelessWidget {
  final OrderController orderController = Get.put(OrderController());

  String deliverStateName(Package package) {
    var deliveryStatus;
    package.processes!.forEach((element) {
      if (package.deliveryStatus == element.id) {
        deliveryStatus = element.name;
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  String orderStatusGet(OrderData order) {
    var orderStatus;

    if (order.isCancelled == 0 &&
        order.isCompleted == 0 &&
        order.isConfirmed == 0 &&
        order.isPaid == 0) {
      orderStatus = 'Pending';
    } else {
      if (order.isCancelled == 1) {
        orderStatus = "Cancelled";
      } else if (order.isCompleted == 1) {
        orderStatus = 'Completed';
      } else if (order.isConfirmed == 1) {
        orderStatus = 'Confirmed';
      } else if (order.isPaid == 1) {
        orderStatus = 'Paid';
      }
    }
    return orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    orderController.getPendingOrders();

    return Obx(
      () {
        if (orderController.isPendingOrderLoading.value) {
          return Center(
            child: CustomLoadingWidget(),
          );
        } else {
          if (orderController.pendingOrderListModel.value.orders == null ||
              orderController.pendingOrderListModel.value.orders!.length == 0) {
            return NoOrderPlacedWidget();
          }
          return Container(
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  color: AppStyles.appBackgroundColor,
                  height: 5,
                  thickness: 5,
                );
              },
              itemCount:
                  orderController.pendingOrderListModel.value.orders!.length,
              itemBuilder: (context, index) {
                OrderData order =
                    orderController.pendingOrderListModel.value.orders![index];
                return OrderAllToPayListDataWidget(
                  order: order,
                );
              },
            ),
          );
        }
      },
    );
  }
}
