import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/Order/OrderModelRefundReason.dart';
import 'package:amazcart/model/NewModel/Order/OrderRefundModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class OrderRefundController extends GetxController {
  var isAllOrderLoading = false.obs;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  var refundOrderListModel = OrderRefundModel().obs;

  var isLoading = false.obs;

  var refundReasons = <RefundReason>[].obs;

  var reasonValue = RefundReason().obs;

  Future<OrderRefundModel?> fetchMyRefundList() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ALL_ORDER_REFUND_LIST);

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
      return OrderRefundModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<OrderRefundModel?> getMyRefundOrders() async {
    try {
      isAllOrderLoading(true);
      var products = await fetchMyRefundList();
      if (products != null) {
        refundOrderListModel.value = products;
      }
      return products;
    } finally {
      isAllOrderLoading(false);
    }
  }

  @override
  void onInit() {
    getMyRefundOrders();
    super.onInit();
  }
}
