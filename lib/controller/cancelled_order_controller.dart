import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/Order/OrderListModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CancelledOrderController extends GetxController {
  var isAllOrderLoading = false.obs;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  var cancelledOrderListModel = OrderListModel().obs;

  Future<OrderListModel?> getCancelled() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ALL_ORDER_CANCEL_LIST);

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

  Future<OrderListModel?> getCancelledOrders() async {
    try {
      isAllOrderLoading(true);
      var products = await getCancelled();
      if (products != null) {
        cancelledOrderListModel.value = products;
      }
      return products;
    } finally {
      isAllOrderLoading(false);
    }
  }

  @override
  void onInit() {
    getCancelledOrders();
    super.onInit();
  }
}
