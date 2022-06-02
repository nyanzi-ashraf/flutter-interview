import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/gift_card_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/authentication/LoginPage.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddToCartGiftCard extends StatefulWidget {
  final ProductModel productModel;
  AddToCartGiftCard(this.productModel);

  @override
  State<AddToCartGiftCard> createState() => _AddToCartGiftCardState();
}

class _AddToCartGiftCardState extends State<AddToCartGiftCard> {
  final GiftCardController giftCardController = Get.put(GiftCardController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  @override
  void initState() {
    giftCardController.productPrice.value = 0.0;
    giftCardController.finalPrice.value = 0.0;

    giftCardController.itemQuantity.value = 1;

    dynamic productPrice = 0.0;
    if (widget.productModel.giftCardEndDate!.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      productPrice = widget.productModel.giftCardSellingPrice;
    } else {
      if (widget.productModel.discountType == 0 ||
          widget.productModel.discountType == "0") {
        productPrice = (widget.productModel.giftCardSellingPrice! -
            ((widget.productModel.discount! / 100) *
                widget.productModel.giftCardSellingPrice!));
      } else {
        productPrice = (widget.productModel.giftCardSellingPrice! -
            widget.productModel.discount!);
      }
    }
    giftCardController.finalPrice.value = double.parse(productPrice.toString());

    giftCardController.productPrice.value =
        double.parse(productPrice.toString());
    super.initState();
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
            initialChildSize: 0.6,
            minChildSize: 0.4,
            maxChildSize: 1,
            builder: (_, scrollController2) {
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppStyles.darkBlueColor,
                                      ),
                                    ),
                                    child: FancyShimmerImage(
                                      imageUrl:
                                          "${AppConfig.assetPath}/${widget.productModel.giftCardThumbnailImage}",
                                      height: 70,
                                      width: 70,
                                      errorWidget: FancyShimmerImage(
                                        imageUrl:
                                            "${AppConfig.assetPath}/backend/img/default.png",
                                        boxFit: BoxFit.contain,
                                      ),
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
                                            '${(double.parse((giftCardController.finalPrice.value * currencyController.conversionRate.value).toString()).toPrecision(2))}${currencyController.appCurrency.value}',
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
                                        Text(
                                          'SKU: ${widget.productModel.giftCardSku}',
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Shipping'.tr + ': Email Delivery',
                            style: AppStyles.kFontBlack14w5,
                          ),
                        ),
                        Divider(),
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
                                    if (giftCardController.itemQuantity.value <=
                                        giftCardController.minOrder.value) {
                                      SnackBars().snackBarWarning(
                                          'Can\'t add less than'.tr +
                                              ' ${giftCardController.minOrder.value} ' +
                                              'products'.tr);
                                    } else {
                                      giftCardController.cartDecrease();
                                    }
                                  },
                                ),
                                SizedBox(width: 10),
                                Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: AppStyles.lightBlueColorAlt,
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: Obx(() {
                                      return Text(
                                        giftCardController.itemQuantity.value
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
                                    giftCardController.cartIncrease();
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
                            PinkButtonWidget(
                              height: 40,
                              width: 130,
                              btnText: 'Add to Cart'.tr,
                              btnOnTap: () async {
                                final LoginController loginController =
                                    Get.put(LoginController());

                                if (loginController.loggedIn.value) {
                                  Map data = {
                                    'product_id': widget.productModel.id,
                                    'qty':
                                        giftCardController.itemQuantity.value,
                                    'price':
                                        giftCardController.finalPrice.value,
                                    'seller_id': 1,
                                    'shipping_method_id': 1,
                                    'product_type': 'gift_card',
                                  };
                                  print(data);
                                  final CartController cartController =
                                      Get.put(CartController());
                                  await cartController
                                      .addToCart(data)
                                      .then((value) {
                                    if (value) {
                                      Future.delayed(Duration(seconds: 3), () {
                                        Get.back();
                                      });
                                    }
                                  });
                                } else {
                                  Get.back();
                                  Get.dialog(LoginPage(), useSafeArea: false);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
