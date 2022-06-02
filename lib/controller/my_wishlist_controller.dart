import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/MyWishListModel.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class MyWishListController extends GetxController {
  var isLoading = false.obs;

  var wishListModel = MyWishListModel().obs;

  GetStorage userToken = GetStorage();
  var tokenKey = 'token';

  var wishListCount = 0.obs;

  Future<MyWishListModel?> getWishlists() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_WISHLIST);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    // print(response.statusCode.toString() + "By getx");
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return MyWishListModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<MyWishListModel?> getAllWishList() async {
    print('wishlist get');
    try {
      isLoading(true);
      var wishlist = await getWishlists();
      if (wishlist != null) {
        wishListModel.value = wishlist;
        var count = 0;
        wishListModel.value.products!.values.forEach((element) {
          count += element.length;
        });
        wishListCount.value = count;
      } else {
        wishListModel.value = MyWishListModel();
      }
      return wishlist;
    } catch (e) {
      throw e.toString();
    } finally {
      isLoading(false);
    }
  }

  Future deleteWishListProduct(id) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_WISHLIST_DELETE);

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
    if (response.statusCode == 202) {
      EasyLoading.dismiss();
      SnackBars()
          .snackBarSuccess(jsonString['message'].toString().capitalizeFirst);
      wishListModel.value = MyWishListModel();
      wishListCount.value = 0;
      await getAllWishList();
    } else {
      EasyLoading.dismiss();
      SnackBars()
          .snackBarError(jsonString['message'].toString().capitalizeFirst);
    }
  }

  Future addProductToWishList(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.MY_WISHLIST);

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
    if (response.statusCode == 201) {
      EasyLoading.dismiss();
      SnackBars()
          .snackBarSuccess(jsonString['message'].toString().capitalizeFirst);
      wishListModel.value = MyWishListModel();
      wishListCount.value = 0;
      await getAllWishList();
    } else {
      EasyLoading.dismiss();
      SnackBars()
          .snackBarError(jsonString['message'].toString().capitalizeFirst);
    }
  }

  @override
  void onInit() {
    getAllWishList();
    super.onInit();
  }
}
