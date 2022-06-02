import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/MyCouponsModel.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MyCouponController extends GetxController {
  var isLoading = false.obs;

  var myCoupons = MyCouponsModel().obs;

  GetStorage userToken = GetStorage();
  var tokenKey = 'token';

  Future<MyCouponsModel?> getCoupons() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_COUPONS);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    print(response.body);
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return MyCouponsModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<MyCouponsModel?> getAllCoupons() async {
    print('address get');
    try {
      isLoading(true);
      var coupons = await getCoupons();
      if (coupons != null) {
        myCoupons.value = coupons;
      } else {
        myCoupons.value = MyCouponsModel();
      }
      return coupons;
    } finally {
      isLoading(false);
    }
  }

  Future<Map<bool, String>> deleteCoupon(id) async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_COUPON_DELETE);

    Map data = {
      "id": id.toString(),
    };
    var body = json.encode(data);
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
    print(response.body);
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);

    if (response.statusCode == 200) {
      return {
        true: jsonString['message'].toString().capitalizeFirst!,
      };
    } else {
      return {
        false: jsonString['message'].toString().capitalizeFirst!,
      };
    }
  }

  Future addCoupon(code) async {
    EasyLoading.show(status: 'Adding', maskType: EasyLoadingMaskType.black);

    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_COUPONS);

    Map data = {
      "code": code.toString(),
    };
    var body = json.encode(data);
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
    print(response.body);
    print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    print(jsonString);

    if (response.statusCode == 200) {
      if (jsonString.toString().contains('error')) {
        SnackBars()
            .snackBarWarning(jsonString['error'].toString().capitalizeFirst);
      } else {
        SnackBars()
            .snackBarSuccess(jsonString['message'].toString().capitalizeFirst);
      }
      EasyLoading.dismiss();
    } else if (response.statusCode == 201) {
      SnackBars()
          .snackBarSuccess(jsonString['message'].toString().capitalizeFirst);
      Future.delayed(Duration(seconds: 1), () {
        this.getAllCoupons();
      });
      EasyLoading.dismiss();
    } else {
      SnackBars()
          .snackBarError(jsonString['message'].toString().capitalizeFirst);
      EasyLoading.dismiss();
    }
  }

  @override
  void onInit() {
    getAllCoupons();
    super.onInit();
  }
}
