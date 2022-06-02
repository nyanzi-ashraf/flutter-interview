import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/CustomerAddress.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AddressController extends GetxController {
  // final CheckoutController checkoutController = Get.put(CheckoutController());
  var isLoading = false.obs;

  var address = CustomerAddress().obs;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  var addressCount = 0.obs;

  var billingAddress = Address().obs;

  var shippingAddress = Address().obs;

  Future<CustomerAddress?> getAddress() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.ADDRESS_LIST);

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
      return CustomerAddress.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<CustomerAddress?> getAllAddress() async {
    try {
      isLoading(true);
      var products = await getAddress();
      if (products != null) {
        address.value = products;
        addressCount.value = products.addresses!.length;
        billingAddress.value = products.addresses!
            .where((element) => element.isBillingDefault == 1)
            .single;
        shippingAddress.value = products.addresses!
            .where((element) => element.isShippingDefault == 1)
            .single;
        // checkoutController.getCheckoutList();
      } else {
        address.value = CustomerAddress();
      }
      return products;
    } finally {
      isLoading(false);
    }
  }

  Future<bool> setDefaultBilling(int id) async {
    String token = await userToken.read(tokenKey);
    Uri userData = Uri.parse(URLs.ADDRESS_SET_DEFAULT_BILLING);
    Map data = {
      "id": id.toString(),
    };
    var body = json.encode(data);
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    // var jsonString = jsonDecode(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      await getAllAddress();
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setDefaultShipping(int id) async {
    String token = await userToken.read(tokenKey);
    Uri userData = Uri.parse(URLs.ADDRESS_SET_DEFAULT_SHIPPING);
    Map data = {
      "id": id.toString(),
    };
    var body = json.encode(data);
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
    // var jsonString = jsonDecode(response.body);
    if (response.statusCode == 200) {
      await getAllAddress();
      return true;
    } else {
      return false;
    }
  }

  @override
  void onInit() {
    getAllAddress();
    super.onInit();
  }
}
