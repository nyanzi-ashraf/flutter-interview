import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariantDetail.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/authentication/LoginPage.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/custom_color_convert.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:radio_grouped_buttons/radio_grouped_buttons.dart';

class AddToCartWidget extends StatefulWidget {
  final int productID;

  AddToCartWidget(this.productID);

  @override
  _AddToCartWidgetState createState() => _AddToCartWidgetState();
}

class _AddToCartWidgetState extends State<AddToCartWidget> {
  final ProductDetailsController controller =
      Get.put(ProductDetailsController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  List<bool> selected = [];

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future getProductDetails() async {
    await controller.getProductDetails2(widget.productID).then((value) {
      controller.itemQuantity.value =
          controller.products.value.data!.product!.minimumOrderQty;
      controller.productId.value = widget.productID;

      controller.shippingValue.value =
          controller.products.value.data!.product!.shippingMethods!.first;

      controller.products.value.data!.variantDetails!.forEach((element) {
        if (element.name == 'Color') {
          element.code!.forEach((element2) {
            selected.add(false);
            selected[0] = true;
          });
        }
      });

      for (var i = 0;
          i < controller.products.value.data!.variantDetails!.length;
          i++) {
        getSKU.addAll({
          'id[$i]':
              "${controller.products.value.data!.variantDetails![i].attrValId!.first}-${controller.products.value.data!.variantDetails![i].attrId}",
        });
      }
      print(getSKU);
    });
  }

  Map getSKU = {};

  void addValueToMap<K, V>(Map<K, V> map, K key, V value) {
    map.update(key, (v) => value, ifAbsent: () => value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.5,
            maxChildSize: 1,
            builder: (_, scrollController2) {
              return Obx(() {
                if (controller.isCartLoading.value) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(25.0),
                          topRight: const Radius.circular(25.0),
                        ),
                      ),
                      child: Center(
                        child: CustomLoadingWidget(),
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0),
                      ),
                    ),
                    child: Scaffold(
                      backgroundColor: Colors.white,
                      body: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              controller: scrollController2,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: Container(
                                      width: 40,
                                      height: 5,
                                      decoration: BoxDecoration(
                                        color: Color(0xffDADADA),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Text(
                                    'Add to Cart'.tr,
                                    style: AppStyles.kFontBlack15w4,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Obx(() {
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppStyles.darkBlueColor,
                                          ),
                                        ),
                                        child: controller.products.value.data!
                                                    .variantDetails!.length ==
                                                0
                                            ? controller.visibleSKU.value
                                                        .variantImage !=
                                                    null
                                                ? Image.network(
                                                    AppConfig.assetPath +
                                                            '/' +
                                                            controller
                                                                .visibleSKU
                                                                .value
                                                                .variantImage! ??
                                                        "",
                                                    height: 70,
                                                    width: 70,
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object? exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        AppConfig.appLogo,
                                                        height: 70,
                                                        width: 70,
                                                        errorBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Object
                                                                    exception,
                                                                StackTrace?
                                                                    stackTrace) {
                                                          return Text(
                                                              'Error fetching Image'
                                                                  .tr);
                                                        },
                                                      );
                                                    },
                                                  )
                                                : Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        controller
                                                            .products
                                                            .value
                                                            .data!
                                                            .product!
                                                            .thumbnailImageSource!,
                                                    height: 70,
                                                    width: 70,
                                                  )
                                            : controller.productSKU.value.sku!
                                                        .variantImage !=
                                                    null
                                                ? Image.network(
                                                    AppConfig.assetPath +
                                                            '/' +
                                                            controller
                                                                .productSKU
                                                                .value
                                                                .sku!
                                                                .variantImage! ??
                                                        "",
                                                    height: 70,
                                                    width: 70,
                                                    fit: BoxFit.contain,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object? exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image.asset(
                                                        AppConfig.appLogo,
                                                        height: 70,
                                                        width: 70,
                                                        errorBuilder: (BuildContext
                                                                context,
                                                            Object? exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                          return Text(
                                                              'Error fetching Image'
                                                                  .tr);
                                                        },
                                                      );
                                                    },
                                                  )
                                                : Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        controller
                                                            .products
                                                            .value
                                                            .data!
                                                            .product!
                                                            .thumbnailImageSource!,
                                                    height: 70,
                                                    width: 70,
                                                    fit: BoxFit.contain,
                                                  ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.all(5),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Obx(() {
                                              return Text(
                                                '${double.parse((controller.finalPrice.value * currencyController.conversionRate.value).toStringAsFixed(2))}${currencyController.appCurrency.value}',
                                                style: AppStyles.kFontPink15w5
                                                    .copyWith(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold),
                                              );
                                            }),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            controller
                                                        .products
                                                        .value
                                                        .data!
                                                        .variantDetails!
                                                        .length ==
                                                    0
                                                ? Text(
                                                    'SKU: ${controller.visibleSKU.value.sku!}',
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  )
                                                : Text(
                                                    'SKU: ${controller.productSKU.value.sku!.sku!}',
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  ),
                                            controller.stockManage.value == 1
                                                ? Text(
                                                    'Stock Available: ${controller.stockCount.value.toString()}',
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: controller.products.value.data!
                                        .variantDetails!.length,
                                    itemBuilder: (context, variantIndex) {
                                      ProductVariantDetail variant = controller
                                          .products
                                          .value
                                          .data!
                                          .variantDetails![variantIndex];

                                      // getSKU.addAll({
                                      //   'id[$variantIndex]':
                                      //       "${variant.attrValId!.first}-${variant.attrId}",
                                      // });
                                      if (variant.name == 'Color') {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              child: Text(
                                                '${variant.name}: ',
                                                style: AppStyles.kFontBlack14w5,
                                              ),
                                            ),
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              child: Wrap(
                                                alignment: WrapAlignment.start,
                                                crossAxisAlignment:
                                                    WrapCrossAlignment.center,
                                                spacing: 10,
                                                runSpacing: 5,
                                                children: List.generate(
                                                    variant.code!.length,
                                                    (colorIndex) {
                                                  var bgColor = 0;
                                                  if (!variant.code![colorIndex]
                                                      .contains('#')) {
                                                    bgColor =
                                                        CustomColorConvert()
                                                            .colourNameToHex(
                                                                variant.code![
                                                                    colorIndex]);
                                                  } else {
                                                    bgColor =
                                                        CustomColorConvert()
                                                            .getBGColor(variant
                                                                    .code![
                                                                colorIndex]);
                                                  }
                                                  return GestureDetector(
                                                    onTap: () async {
                                                      setState(() {
                                                        selected.clear();
                                                        controller
                                                            .products
                                                            .value
                                                            .data!
                                                            .variantDetails!
                                                            .forEach((element) {
                                                          if (element.name ==
                                                              'Color') {
                                                            element.code!
                                                                .forEach(
                                                                    (element2) {
                                                              selected
                                                                  .add(false);
                                                            });
                                                          }
                                                        });
                                                        selected[colorIndex] =
                                                            !selected[
                                                                colorIndex];
                                                      });
                                                      addValueToMap(
                                                          getSKU,
                                                          'id[$variantIndex]',
                                                          '${variant.attrValId![colorIndex]}-${variant.attrId}');
                                                      Map data = {
                                                        'product_id': controller
                                                            .products
                                                            .value
                                                            .data!
                                                            .id,
                                                        'user_id': controller
                                                            .products
                                                            .value
                                                            .data!
                                                            .userId,
                                                      };
                                                      data!.addAll(getSKU);
                                                      await controller
                                                          .getSkuWisePrice(
                                                        data,
                                                      )
                                                          .then((value) {
                                                        if (value == false) {
                                                          setState(() {});
                                                        }
                                                      });
                                                    },
                                                    child: Container(
                                                      width: 50,
                                                      height: 50,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: selected[
                                                                  colorIndex]
                                                              ? AppStyles
                                                                  .pinkColor
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Stack(
                                                        children: [
                                                          Positioned.fill(
                                                            child: Container(
                                                              width: 30,
                                                              height: 30,
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Color(
                                                                    bgColor),
                                                              ),
                                                            ),
                                                          ),
                                                          selected[colorIndex]
                                                              ? Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Icon(
                                                                    Icons.done,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.all(5),
                                              child: Text(
                                                '${variant.name}: ',
                                                style: AppStyles.kFontBlack14w5,
                                              ),
                                            ),
                                            Container(
                                              child: CustomRadioButton(
                                                buttonLables: variant.value,
                                                buttonValues: variant.attrValId,
                                                radioButtonValue:
                                                    (value, index) async {
                                                  addValueToMap(
                                                      getSKU,
                                                      'id[$variantIndex]',
                                                      '$value-${variant.attrId}');
                                                  Map data = {
                                                    'product_id': controller
                                                        .products
                                                        .value
                                                        .data!
                                                        .id,
                                                    'user_id': controller
                                                        .products
                                                        .value
                                                        .data!
                                                        .userId,
                                                  };
                                                  data!.addAll(getSKU);
                                                  await controller
                                                      .getSkuWisePrice(
                                                    data,
                                                  )
                                                      .then((value) {
                                                    if (value == false) {
                                                      setState(() {});
                                                    }
                                                  });
                                                },
                                                horizontal: true,
                                                enableShape: false,
                                                buttonSpace: 0,
                                                buttonColor: Colors.white,
                                                selectedColor:
                                                    AppStyles.pinkColor,
                                                elevation: 3,
                                                buttonHeight: 30,
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                          Divider(),
                          // Container(
                          //   alignment: Alignment.centerLeft,
                          //   child: Text(
                          //     'Select Shipping: ',
                          //     style: AppStyles.kFontBlack14w5,
                          //   ),
                          // ),
                          // Divider(),
                          // Obx(() {
                          //   return DropdownButton<ShippingMethodElement>(
                          //     elevation: 1,
                          //     isExpanded: true,
                          //     underline: Container(),
                          //     value: controller.shippingValue.value,
                          //     items: controller
                          //         .products.value.data!.product!.shippingMethods
                          //         .map((e) {
                          //       return DropdownMenuItem<ShippingMethodElement>(
                          //         child: Text(
                          //           '${e.shippingMethod.methodName} - (${e.shippingMethod.shipmentTime})',
                          //           style: AppStyles.kFontBlack14w5,
                          //         ),
                          //         value: e,
                          //       );
                          //     }).toList(),
                          //     onChanged: (ShippingMethodElement value) {
                          //       setState(() {
                          //         controller.shippingValue.value = value;
                          //       });
                          //       controller.shippingID.value =
                          //           value.shippingMethodId;
                          //       print(controller.shippingID);
                          //     },
                          //   );
                          // }),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Quantity'.tr,
                                style: AppStyles.kFontBlack15w4,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    child: Icon(
                                      Icons.remove,
                                      color: AppStyles.greyColorDark,
                                      size: 30,
                                    ),
                                    onTap: () {
                                      if (controller.itemQuantity.value <=
                                          controller.minOrder.value) {
                                        SnackBars().snackBarWarning(
                                            'Can\'t add less than'.tr +
                                                ' ${controller.minOrder.value} ' +
                                                'products'.tr);
                                      } else {
                                        controller.cartDecrease();
                                      }
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: AppStyles.lightBlueColorAlt,
                                        border: Border.all(
                                            color: AppStyles.textFieldFillColor,
                                            width: 1),
                                      ),
                                      padding: EdgeInsets.all(15),
                                      child: Obx(() {
                                        return Text(
                                          controller.itemQuantity.value
                                              .toString(),
                                          style: AppStyles.kFontBlack15w4,
                                        );
                                      })),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    child: Icon(
                                      Icons.add,
                                      color: AppStyles.greyColorDark,
                                      size: 30,
                                    ),
                                    onTap: () {
                                      print(
                                          'Quantity ${controller.itemQuantity.value}');
                                      if (controller.stockManage.value == 1) {
                                        if (controller.itemQuantity.value >=
                                            controller.stockCount.value) {
                                          SnackBars().snackBarWarning(
                                              'Stock not available.'.tr);
                                        } else {
                                          controller.cartIncrease();
                                        }
                                      } else {
                                        if (controller.maxOrder.value == null) {
                                          controller.cartIncrease();
                                        } else {
                                          if (controller.itemQuantity.value >=
                                              controller.maxOrder.value) {
                                            SnackBars().snackBarWarning(
                                                'Can\'t add more than'.tr +
                                                    ' ${controller.maxOrder.value} ' +
                                                    'products'.tr);
                                          } else {
                                            controller.cartIncrease();
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Divider(),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // BlueButtonWidget(
                              //   height: 40.h,
                              //   width: 130.w,
                              //   btnText: 'Chat Us'.tr,
                              //   btnOnTap: () {
                              //     Get.to(() => ChatConversation());
                              //   },
                              // ),
                              // SizedBox(
                              //   width: 15.w,
                              // ),
                              Obx(() {
                                return controller.stockManage.value == 1
                                    ? PinkButtonWidget(
                                        height: 40,
                                        width: 130,
                                        btnText: 'Add to Cart'.tr,
                                        btnOnTap: () async {
                                          if (controller.stockCount.value > 0) {
                                            if (controller.minOrder.value >
                                                controller.stockCount.value) {
                                              SnackBars().snackBarWarning(
                                                  'No more stock'.tr);
                                            } else {
                                              Map data = {
                                                'product_id': controller
                                                    .productSkuID.value,
                                                'qty': controller
                                                    .itemQuantity.value,
                                                'price': controller
                                                    .productPrice.value,
                                                'seller_id': controller.products
                                                    .value.data!.userId,
                                                'shipping_method_id':
                                                    controller.shippingID.value,
                                                'product_type': 'product',
                                                'checked': true,
                                              };

                                              print(data);
                                              final CartController
                                                  cartController =
                                                  Get.put(CartController());
                                              await cartController
                                                  .addToCart(data)
                                                  .then((value) {
                                                if (value) {
                                                  Future.delayed(
                                                      Duration(seconds: 4), () {
                                                    Get.back();
                                                  });
                                                }
                                              });
                                            }
                                          } else {
                                            SnackBars().snackBarWarning(
                                                'No more stock'.tr);
                                          }
                                        },
                                      )
                                    : PinkButtonWidget(
                                        height: 40,
                                        width: 130,
                                        btnText: 'Add to Cart'.tr,
                                        btnOnTap: () async {
                                          final LoginController
                                              loginController =
                                              Get.put(LoginController());

                                          if (loginController.loggedIn.value) {
                                            Map data = {
                                              'product_id':
                                                  controller.productSkuID.value,
                                              'qty':
                                                  controller.itemQuantity.value,
                                              'price':
                                                  controller.productPrice.value,
                                              'seller_id': controller
                                                  .products.value.data!.userId,
                                              'shipping_method_id':
                                                  controller.shippingID.value,
                                              'product_type': 'product',
                                            };

                                            print(data);
                                            final CartController
                                                cartController =
                                                Get.put(CartController());
                                            await cartController
                                                .addToCart(data)
                                                .then((value) {
                                              if (value) {
                                                Future.delayed(
                                                    Duration(seconds: 3), () {
                                                  Get.back();
                                                });
                                              }
                                            });
                                          } else {
                                            Get.back();
                                            Get.dialog(LoginPage(),
                                                useSafeArea: false);
                                          }
                                        },
                                      );
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
            },
          ),
        ),
      ),
    );
  }
}
