import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/model/NewModel/ShippingMethodModel.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

enum SelectCourierOption { three, one, two }

class OrderRefundListController extends GetxController {
  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  // var isLoading = false.obs;
  //
  // var refundReasons = <RefundReason>[].obs;
  //
  // var reasonValue = RefundReason().obs;
  //
  // Future<OrderRefundReasonModel> fetchRefundReasons() async {
  //   var jsonString;
  //   try {
  //     Uri userData = Uri.parse(URLs.REFUND_REASONS_LIST);
  //     var response = await http.get(
  //       userData,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     );
  //     jsonString = jsonDecode(response.body);
  //   } catch (e) {
  //     print(e);
  //   }
  //   return OrderRefundReasonModel.fromJson(jsonString);
  // }
  //
  // Future getRefundReasons() async {
  //   try {
  //     isLoading(true);
  //     var data = await fetchRefundReasons();
  //     if (data != null) {
  //       refundReasons.value = data.reasons;
  //       reasonValue.value = data.reasons.last;
  //     }
  //   } catch (e) {
  //     print(e);
  //     isLoading(false);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  TextEditingController refundCommentController =
      TextEditingController(text: '');

  var shippingWay = 'courier'.obs;

  var isCourier = true.obs;

  var isSelectedShipping = false.obs;

  var selectedCourier = SelectCourierOption.three.obs;

  var couriers = 3.obs;

  var dropOffCouriers = 3.obs;

  TextEditingController dropOffAddressController =
      TextEditingController(text: '');

  final AddressController addressController = Get.put(AddressController());

  var moneyGetMethod = 'Wallet'.obs;

  var bankNameController = TextEditingController().obs;
  var branchNameController = TextEditingController().obs;
  var accountNameController = TextEditingController().obs;
  var accountNumberController = TextEditingController().obs;

  var productIds = <String>[].obs;

  var isLoading = false.obs;

  var shippingMethods = <Shipping>[].obs;
  var shippingFirst = Shipping().obs;

  @override
  void onInit() {
    // getRefundReasons();
    getShipping();
    super.onInit();
  }

  Future getShipping() async {
    try {
      isLoading(true);
      Uri uri = Uri.parse(URLs.SHIPPING_LIST);
      var response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      var shippingModel = shippingMethodModelFromJson(response.body);
      if (shippingModel.msg == 'success') {
        shippingMethods.value = shippingModel.shippings!;
        shippingFirst.value = shippingModel.shippings!.first;
      }
    } catch (e) {
      isLoading(false);
      print(e);
    } finally {
      isLoading(false);
    }
  }

  var dataMap = Map<dynamic, dynamic>().obs;

  void addValueToMap<K, V>(RxMap<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  void removeValueToMap<K, V>(RxMap<K, V> map, K key) {
    // map.update(key, (list) => value, ifAbsent: () => value);
    map.remove(key);
  }

  Future saveData() async {
    if (!dataMap.containsKey('order_id')) {
      SnackBars().snackBarWarning('Select a product first!');
    } else {
      var moneyMethod = '';
      if (moneyGetMethod.value == "Wallet") {
        moneyMethod = 'wallet';

        dataMap.addAll({
          'additional_info': refundCommentController.text,
          'shipping_way': '${shippingWay.value}',
          'couriers': couriers.value,
          'drop_off_couriers': dropOffCouriers.value,
          'pick_up_address_id': addressController.shippingAddress.value.id,
          'drop_off_courier_address': dropOffAddressController.text,
          'money_get_method': moneyMethod,
          'product_ids': productIds,
        });
      } else {
        moneyMethod = 'bank_transfer';

        dataMap.addAll({
          'additional_info': refundCommentController.text,
          'shipping_way': '${shippingWay.value}',
          'couriers': couriers.value,
          'drop_off_couriers': dropOffCouriers.value,
          'pick_up_address_id': addressController.shippingAddress.value.id,
          'drop_off_courier_address': dropOffAddressController.text,
          'money_get_method': moneyMethod,
          'bank_name': bankNameController.value.text,
          'branch_name': branchNameController.value.text,
          'account_name': accountNameController.value.text,
          'account_no': accountNumberController.value.text,
          'product_ids': productIds,
        });
      }

      print(dataMap);

      // return;

      EasyLoading.show(
          maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
      String token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.REFUND_STORE);
      var body = json.encode(dataMap);
      print(body);
      var response = await http.post(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
      print(response.statusCode);
      print(response.body);

      var jsonString = jsonDecode(response.body);

      if (response.statusCode == 201) {
        EasyLoading.dismiss();
        SnackBars().snackBarSuccessBottom(
            jsonString['message'].toString().capitalizeFirst);
        return true;
      } else {
        EasyLoading.dismiss();
        SnackBars()
            .snackBarError(jsonString['message'].toString().capitalizeFirst);
        return false;
      }
    }
  }
}
