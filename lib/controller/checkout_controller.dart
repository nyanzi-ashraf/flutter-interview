import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/model/NewModel/CouponApplyModel.dart';
import 'package:amazcart/model/NewModel/Cart/MyCheckoutModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/ShippingMethodModel.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CheckoutController extends GetxController {
  var addressLength = 0.obs;

  var isLoading = false.obs;

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  Rx<MyCheckoutModel> checkoutModel = MyCheckoutModel().obs;

  List<Shipping> selectedShipping = <Shipping>[].obs;

  final CurrencyController _currencyController = Get.put(CurrencyController());

  var packageCount = 0.obs;
  var totalQty = 0.obs;
  var subTotal = 0.0.obs;
  var shipping = 0.0.obs;
  var discountTotal = 0.0.obs;
  var taxTotal = 0.0.obs;
  var grandTotal = 0.0.obs;
  var gstTotal = 0.0.obs;
  var checkoutProducts = [].obs;

  var additionalShippingList = [].obs;

  var midTransProducts = [].obs;
  var sub = 0.0.obs;

  final TextEditingController couponCodeTextController =
      TextEditingController();

  var couponMsg = "".obs;
  var couponData = Coupon().obs;
  var couponApplied = false.obs;
  var couponDiscount = 0.0.obs;
  var couponId = 0.obs;

  Future<MyCheckoutModel?> getCheckout() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.CHECKOUT);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.statusCode.toString() + "By getx --- getCheckout()");
    var jsonString = jsonDecode(response.body);
    if (jsonString['message'] == 'success') {
      return MyCheckoutModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<ShippingMethodModel?> getShippingMethods() async {
    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.SHIPPING_LIST);

    var response = await http.get(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    var jsonString = jsonDecode(response.body);
    if (jsonString['msg'] == 'success') {
      return ShippingMethodModel.fromJson(jsonString);
    } else {
      //show error message
      return null;
    }
  }

  Future<MyCheckoutModel?> getCheckoutList() async {
    try {
      isLoading(true);
      var cartList = await getCheckout();
      if (cartList != null) {
        checkoutModel.value = cartList;

        getShipping();

        getProducts();

        countPackage();
        // print('Package Count: ${packageCount.value}');

        countQty();
        // print('Total QTY: ${totalQty.value}');

        calculateSubtotal();
        // print('Subtotal: ${subTotal.value}');

        calculateShipment();
        // print('Shipping: ${shipping.value}');

        calculateDiscount();
        // print('Discount: ${discountTotal.value}');

        // calculateTax();
        // // print('Tax: ${taxTotal.value}');

        calculateGST();
        // print('GST : ${gstTotal.value}');

        grandTotal.value =
            (subTotal.value + shipping.value + gstTotal.value).toPrecision(2) -
                discountTotal.value;
      } else {
        checkoutModel.value = MyCheckoutModel();
      }
      return cartList;
    } finally {
      isLoading(false);
    }
  }

  getShipping() {
    selectedShipping.clear();
    checkoutModel.value.packages!.forEach((key, value) {
      selectedShipping.add(value.shipping!.first);
    });
  }

  @override
  void onInit() {
    getCheckoutList();
    super.onInit();
  }

  void countPackage() {
    List keys = [];
    checkoutModel.value.packages!.forEach((key, value) {
      keys.add(key);
    });
    packageCount.value = keys.length;
  }

  void countQty() {
    int qty = 0;
    checkoutModel.value.packages!.forEach((key, value) {
      value.items!.forEach((value2) {
        qty += int.parse(value2.qty);
      });
    });
    totalQty.value = qty;
  }

  var productIds = <CheckoutItem>[].obs;

  void calculateSubtotal() {
    var sub = 0.0;
    checkoutModel.value.packages!.forEach((key, value) {
      value.items!.forEach((value2) {
        if (value2.productType == ProductType.PRODUCT) {
          productIds.add(value2);
          sub += value2.product!.sellingPrice * value2.qty;
        } else {
          sub += value2.giftCard!.sellingPrice * value2.qty;
        }
      });
    });
    subTotal.value = sub.toPrecision(2);
  }

  void calculateShipment() {
    var shippingCost2 = 0.0;

    var additionalCost = 0.0;

    double totalShipping = 0.0;

    for (int i = 0; i < packageCount.value; i++) {
      checkoutModel.value.packages!.forEach((key, value) {
        value.items!.forEach((CheckoutItem itemEl) {
          if (selectedShipping[i].costBasedOn == 'Price') {
            if (itemEl.price > 0) {
              totalShipping = (itemEl.price / 100) * selectedShipping[i].cost;
              additionalCost += itemEl.product!.sku!.additionalShipping;
            }
          } else if (value.shipping!.first.costBasedOn == 'Weight') {
            totalShipping = (double.parse(itemEl.product!.sku!.weight!) / 100) *
                selectedShipping[i].cost!;
            additionalCost += itemEl.product!.sku!.additionalShipping;
          } else {
            totalShipping = selectedShipping[i].cost!;
            additionalCost += itemEl.product!.sku!.additionalShipping;
          }
        });
      });
      shippingCost2 += totalShipping;
    }

    // checkoutModel.value.packages!.forEach((key, value) {
    //   value.items!.forEach((CheckoutItem itemEl) {
    //     if (value.shipping.first.costBasedOn == 'Price') {
    //       if (itemEl.price > 0) {
    //         shippingCost2 += (itemEl.price / 100) * value.shipping.first.cost;
    //         additionalCost += itemEl.product!.sku!.additionalShipping;
    //       }
    //     } else if (value.shipping.first.costBasedOn == 'Weight') {
    //       shippingCost2 += (double.parse(itemEl.product!.sku!.weight) / 100) *
    //           value.shipping.first.cost;
    //       additionalCost += itemEl.product!.sku!.additionalShipping;
    //     } else {
    //       log("CTRL -> ${value.shipping.first.cost.toString()}");
    //       log("CTRL -> ${itemEl.product!.sku!.additionalShipping.toString()}");
    //       shippingCost2 += value.shipping.first.cost;
    //       additionalCost += itemEl.product!.sku!.additionalShipping;
    //     }
    //   });
    // });
    shipping.value =
        shippingCost2.toPrecision(2) + additionalCost.toPrecision(2);
  }

  void calculateDiscount() {
    var discount = 0.0;
    if (checkoutModel.value != null)
      checkoutModel.value.packages!.forEach((key, value) {
        value.items!.forEach((element) {
          var dis = 0.0;
          if (element.productType == ProductType.PRODUCT) {
            print('hasdeal ? ${element.product!.product!.hasDeal!}');
            if (element.product!.product!.hasDeal! != null) {
              if (element.product!.product!.hasDeal!.discountType == 0) {
                dis += (element.product!.sellingPrice!.toDouble() -
                        (element.product!.sellingPrice!.toDouble() -
                            ((element.product!.product!.hasDeal!.discount!
                                        .toDouble() /
                                    100) *
                                element.product!.sellingPrice!.toDouble()))) *
                    element.qty;
              } else {
                dis += (element.product!.sellingPrice!.toDouble() -
                        (element.product!.sellingPrice!.toDouble() -
                            element.product!.product!.hasDeal!.discount!
                                .toDouble())) *
                    element.qty;
              }
            } else {
              if (element.product!.product!.hasDiscount == 'yes') {
                if (element.product!.product!.discountType == "0") {
                  dis += ((element.product!.product!.discount! / 100) *
                          element.product!.sellingPrice) *
                      element.qty;
                } else {
                  dis += element.product!.product!.discount! * element.qty;
                }
              } else {
                dis += 0 * element.qty;
              }
            }
          } else {
            if (element.giftCard!.endDate!.millisecondsSinceEpoch <
                DateTime.now().millisecondsSinceEpoch) {
              dis += 0 * element.qty;
            } else {
              if (element.giftCard!.discountType == "1" ||
                  element.giftCard!.discountType == 1) {
                dis += ((element.giftCard!.discount / 100) *
                        element.giftCard!.sellingPrice) *
                    element.qty;
                print('gc dis $dis');
              } else {
                dis += element.giftCard!.discount * element.qty;
              }
            }
          }
          discount += dis;
        });
      });
    discountTotal.value = discount.toPrecision(2);
  }

  void calculateTax() {
    var tax = 0.0;
    checkoutModel.value.packages!.forEach((key, value) {
      value.items!.forEach((element) {
        var dis = 0.0;
        if (element.productType == ProductType.PRODUCT) {
          if (element.product!.product!.tax > 0) {
            if (element.product!.product!.taxType == "0") {
              ///percent tax
              tax += (((element.product!.product!.tax / 100) *
                  element.totalPrice));
            } else {
              tax += (element.product!.product!.tax * element.qty);
            }
          }
        }
        tax += dis;
      });
    });
    taxTotal.value = tax.toPrecision(2);
  }

  void calculateGST() {
    var gst = 0.0;

    if (_currencyController.vendorType.value == "single") {
      checkoutModel.value.packages!.forEach((key, value) {
        value.items!.forEach((element) {
          if (checkoutModel.value.isGstModuleEnable == 1) {
            if (checkoutModel.value.isGstEnable == 1) {
              if (element.customer!.customerShippingAddress != null &&
                  (element.customer!.customerShippingAddress!.state ==
                      _currencyController.settingsModel.value.settings!.stateId
                          .toString())) {
                checkoutModel.value.sameStateGstList!.forEach((sameGST) {
                  gst += (element.totalPrice * sameGST.taxPercentage) / 100;
                });
              } else {
                checkoutModel.value.differantStateGstList!.forEach((diffGST) {
                  gst += (element.totalPrice * diffGST.taxPercentage) / 100;
                });
              }
            } else {
              gst += (element.totalPrice *
                      checkoutModel.value.flatGst!.taxPercentage) /
                  100;
            }
          }
        });
      });
    } else {
      checkoutModel.value.packages!.forEach((key, value) {
        value.items!.forEach((element) {
          if (checkoutModel.value.isGstModuleEnable == 1) {
            if (checkoutModel.value.isGstEnable == 1) {
              if ((element.customer!.customerShippingAddress != null &&
                      element.seller!.sellerBusinessInformation != null) &&
                  (element.customer!.customerShippingAddress!.state ==
                      element
                          .seller!.sellerBusinessInformation!.businessState)) {
                checkoutModel.value.sameStateGstList!.forEach((sameGST) {
                  gst += (element.totalPrice * sameGST.taxPercentage) / 100;
                });
              } else {
                checkoutModel.value.differantStateGstList!.forEach((diffGST) {
                  gst += (element.totalPrice * diffGST.taxPercentage) / 100;
                });
              }
            } else {
              gst += (element.totalPrice *
                      checkoutModel.value.flatGst!.taxPercentage) /
                  100;
            }
          }
        });
      });
    }
    gstTotal.value = gst.toPrecision(2);
  }

  void getProducts() {
    var prods = [];
    var prods2 = [];
    var tot = 0.0;
    checkoutModel.value.packages!.forEach((key, value) {
      value.items!.forEach((element) {
        if (element.productType == ProductType.PRODUCT) {
          prods.add({
            "name": element.product!.product!.productName,
            "quantity": element.qty,
            "price": element.price,
            "currency": 'USD',
            "sku": element.product!.sku!.sku
          });
          prods2.add({
            "name": element.product!.product!.productName,
            "quantity": element.qty,
            "price": element.price * 100,
            "sku": element.product!.sku!.sku
          });
        } else {
          prods.add({
            "name": element.giftCard!.name,
            "quantity": element.qty,
            "price": element.price,
            "currency": _currencyController.currencyCode.value,
            "sku": element.giftCard!.sku
          });
          prods2.add({
            "name": element.giftCard!.name,
            "quantity": element.qty,
            "price": element.price * 100,
            "sku": element.giftCard!.sku
          });
        }

        tot += (element.price) * element.qty;
      });
    });
    sub.value = tot;
    checkoutProducts.value = prods;
    midTransProducts.value = prods2;

    midTransProducts.add({
      "name": "Total Tax",
      "quantity": 1,
      "price": ((taxTotal.value + gstTotal.value) * 100).toInt(),
    });
    midTransProducts.add({
      "name": "Shipping",
      "quantity": 1,
      "price": (shipping.value * 100).toInt(),
    });
  }

  Future applyCoupon() async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());

    String token = await userToken.read(tokenKey);

    Uri userData = Uri.parse(URLs.APPLY_COUPON);

    Map data = {
      'coupon_code': couponCodeTextController.text,
      'shopping_amount': subTotal.value,
    };
    var response = await http.post(
      userData,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    var jsonString = jsonDecode(response.body);

    print(jsonString);
    print(response.statusCode);
    print(jsonString['error']);

    if (response.statusCode == 200) {
      if (jsonString.containsKey('error') || jsonString.containsKey('errors')) {
        couponApplied.value = false;
        couponCodeTextController.clear();
        couponMsg.value = jsonString['error'];
        SnackBars().snackBarError(jsonString['error']);
      } else {
        couponData.value = Coupon.fromJson(jsonString['coupon']);
        couponMsg.value = jsonString['message'];

        couponId.value = couponData.value.id;

        var prods = <CheckoutItem>[].obs;
        checkoutModel.value.packages!.forEach((key, value) {
          value.items!.forEach((element) {
            prods.add(element);
          });
        });

        print(prods.length);

        if (couponData.value.couponType == 1) {
          if (couponData.value.discountType == 0) {
            var cAmount = 0.0;
            couponData.value.products!.forEach((element) {
              prods.forEach((el) {
                if (element.productId == el.product!.productId) {
                  print(
                      '${element.productId} ==equals== ${el.product!.productId}');
                  print('calc');
                  cAmount += (el.totalPrice / 100) * couponData.value.discount;
                } else {
                  print(
                      '${element.productId} ==not--equals== ${el.product!.productId}');
                }
              });
            });
            couponDiscount.value = cAmount;
          } else {
            couponDiscount.value =
                double.parse(couponData.value.discount.toString());
          }
        } else if (couponData.value.couponType == 2) {
          if (couponData.value.discountType == 0) {
            couponDiscount.value = (subTotal.value / 100) *
                double.parse(couponData.value.discount.toString());
            if (couponDiscount.value > couponData.value.maximumDiscount) {
              couponDiscount.value =
                  double.parse(couponData.value.maximumDiscount.toString());
            }
          } else {
            couponDiscount.value =
                double.parse(couponData.value.discount.toString());
          }
        } else if (couponData.value.couponType == 3) {
          couponDiscount.value =
              double.parse(couponData.value.discount.toString());
          if (couponDiscount.value > couponData.value.maximumDiscount) {
            couponDiscount.value =
                double.parse(couponData.value.maximumDiscount.toString());
          }
        }

        grandTotal.value = grandTotal.value - couponDiscount.value;

        couponApplied.value = true;
        SnackBars().snackBarSuccess(jsonString['message']);
      }
    } else {
      couponCodeTextController.clear();
      SnackBars().snackBarError(jsonString['message']);
    }
    EasyLoading.dismiss();
  }

  void removeCoupon() async {
    couponApplied.value = false;
    couponCodeTextController.clear();

    grandTotal.value =
        (subTotal.value + shipping.value + taxTotal.value + gstTotal.value)
                .toPrecision(2) -
            discountTotal.value;
  }

  @override
  void onClose() {
    removeCoupon();
    super.onClose();
  }
}
