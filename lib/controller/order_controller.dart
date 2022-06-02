import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/Order/OrderListModel.dart';
import 'package:amazcart/model/NewModel/Order/OrderToShipModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrderController extends GetxController with SingleGetTickerProviderMixin {
  // final OrderRefundListController orderRefundListController = Get.put(OrderRefundListController());

  var isLoading = false.obs;

  var isAllOrderLoading = false.obs;

  var isPendingOrderLoading = false.obs;

  var isToShipOrderLoading = false.obs;

  var isToReceiveOrderLoading = false.obs;

  var tabIndex = 0.obs;

  TabController? controller;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        'All'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
    Tab(
      child: Text(
        'To Pay'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
    Tab(
      child: Text(
        'To Ship'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
    Tab(
      child: Text(
        'To Receive'.tr,
        style: AppStyles.kFontBlack14w5,
      ),
    ),
  ];

  var allOrderListModel = OrderListModel().obs;

  var pendingOrderListModel = OrderListModel().obs;

  var toShippedOrderListModel = OrderToShipModel().obs;

  var toReceiveOrderListModel = OrderToShipModel().obs;

  Future<OrderListModel?> getAll() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ALL_ORDER_LIST);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return OrderListModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<OrderListModel?> getAllOrders() async {
    try {
      isAllOrderLoading(true);
      // await orderRefundListController.getRefundReasons();
      // print(orderRefundListController.refundReasons);
      var products = await getAll();
      if (products != null) {
        allOrderListModel.value = products;
        // allOrderListModel.value.orders.forEach((order) {
        //   order.packages.forEach((package) {
        //     package.refundReasons.addAll(orderRefundListController.refundReasons);
        //   });
        // });
      }
      return products;
    } finally {
      isAllOrderLoading(false);
    }
  }

  Future<OrderListModel?> getPending() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ALL_ORDER_PENDING_LIST);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return OrderListModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<OrderListModel?> getPendingOrders() async {
    try {
      isPendingOrderLoading(true);
      var products = await getPending();
      if (products != null) {
        pendingOrderListModel.value = products;
      }
      return products;
    } finally {
      isPendingOrderLoading(false);
    }
  }

  Future<OrderToShipModel?> getToShipped() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ORDER_TO_SHIP);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return OrderToShipModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<OrderToShipModel?> getToShipOrders() async {
    try {
      isToShipOrderLoading(true);
      var products = await getToShipped();
      if (products != null) {
        print(products);
        toShippedOrderListModel.value = products;
      }
      return products;
    } finally {
      isToShipOrderLoading(false);
    }
  }

  Future<OrderToShipModel?> getToReceive() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ORDER_TO_RECEIVE);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return OrderToShipModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<OrderToShipModel?>? getToReceiveOrders() async {
    try {
      isToReceiveOrderLoading(true);
      var products = await getToReceive();
      if (products != null) {
        toReceiveOrderListModel.value = products;
      }
      return products;
    } finally {
      isToReceiveOrderLoading(false);
    }
  }

  @override
  void onInit() {
    controller = TabController(vsync: this, length: tabs.length);
    super.onInit();
  }

  @override
  void onClose() {
    controller!.dispose();
    super.onClose();
  }
}
