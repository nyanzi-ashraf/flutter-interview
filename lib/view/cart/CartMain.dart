import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/model/NewModel/Cart/MyCartModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/seller/StoreHome.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/custom_dialog_widget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amazcart/view/cart/CartCheckout.dart';

class CartMain extends StatefulWidget {
  final bool? hasMargin;
  CartMain(this.hasMargin);
  @override
  _CartMainState createState() => _CartMainState();
}

class _CartMainState extends State<CartMain> {
  bool _anonymous = false;
  bool _cart = false;

  final CartController cartController = Get.put(CartController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  bool checked(List<MyCart> cartItems) {
    var list = [];
    cartItems!.forEach((element) {
      if (element.isSelect == 1) {
        list.add(element.isSelect);
      }
    });
    if (list.length == cartItems.length) {
      return !_anonymous;
    } else {
      return _anonymous;
    }
  }

  bool checkedAll() {
    var list1 = [];
    var count = 0;
    cartController.cartListModel.value.carts!.forEach((key, value) {
      count += value.length;
      value!.forEach((element) {
        if (element.isSelect == 1) {
          list1.add(element.isSelect);
        }
      });
    });
    // print('list len ${list1.length} == Count $count');
    // print('list $list1');
    if (list1.length == count) {
      return !_cart;
    } else {
      return _cart;
    }
  }

  double totalPrice() {
    var count = 0.0;
    cartController.cartListModel.value.carts!.forEach((key, value) {
      value!.forEach((element) {
        if (element.isSelect == 1) {
          count +=
              element.totalPrice! * currencyController.conversionRate.value;
        }
      });
    });
    // print(count);
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: widget.hasMargin! ? false : true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Obx(() {
          if (cartController.isLoading.value) {
            return Text(
              'Cart'.tr,
              style: AppStyles.appFont.copyWith(
                fontWeight: FontWeight.bold,
                color: AppStyles.blackColor,
                fontSize: 17,
              ),
            );
          }
          return Text(
            'My Cart'.tr + ' (${cartController.cartListSelectedCount.value})',
            style: AppStyles.appFont.copyWith(
              fontWeight: FontWeight.bold,
              color: AppStyles.blackColor,
              fontSize: 17,
            ),
          );
        }),
        actions: [],
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Obx(() {
            if (cartController.isLoading.value) {
              return Center(
                child: CustomLoadingWidget(),
              );
            } else {
              if (cartController.cartListModel.value.carts == null ||
                  cartController.cartListModel.value.carts!.length == 0) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                      ),
                      CircleAvatar(
                        foregroundColor: AppStyles.pinkColor,
                        backgroundColor: AppStyles.pinkColor,
                        radius: 30,
                        child: Container(
                          color: AppStyles.pinkColor,
                          child: Image.asset(
                            AppConfig.appLogo,
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Cart is Empty'.tr,
                        textAlign: TextAlign.center,
                        style: AppStyles.kFontPink15w5.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                );
              } else {
                return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cartController.cartListModel.value.carts!.length,
                    itemBuilder: (context, index) {
                      List<MyCart> cartItems = cartController
                          .cartListModel.value.carts!.values
                          .elementAt(index);
                      return Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                currencyController.vendorType.value != "single"
                                    ? Row(
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                print(cartItems[0].seller!.id);
                                                Get.to(() => StoreHome(
                                                      sellerId: cartItems[0]
                                                          .seller!
                                                          .id,
                                                    ));
                                              },
                                              child: Container(
                                                height: 40,
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "${cartItems[0].seller!.name}",
                                                        style: AppStyles.appFont
                                                            .copyWith(
                                                          color: AppStyles
                                                              .blackColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    SizedBox(
                                                      height: 70,
                                                      child: Icon(
                                                        Icons.arrow_forward_ios,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : SizedBox.shrink(),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Column(
                                    children: List.generate(cartItems.length,
                                        (prodIndex) {
                                      return Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Divider(
                                                  color: AppStyles
                                                      .appBackgroundColor,
                                                  thickness: 4,
                                                  height: 0,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      child: Container(
                                                        height: 65,
                                                        width: 65,
                                                        child: cartItems[
                                                                        prodIndex]
                                                                    .productType ==
                                                                ProductType
                                                                    .GIFT_CARD
                                                            ? FancyShimmerImage(
                                                                imageUrl: AppConfig
                                                                        .assetPath +
                                                                    '/' +
                                                                    cartItems[
                                                                            prodIndex]
                                                                        .giftCard!
                                                                        .thumbnailImage!,
                                                                boxFit: BoxFit
                                                                    .contain,
                                                                errorWidget:
                                                                    FancyShimmerImage(
                                                                  imageUrl:
                                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                                  boxFit: BoxFit
                                                                      .contain,
                                                                ),
                                                              )
                                                            : FancyShimmerImage(
                                                                imageUrl: AppConfig
                                                                        .assetPath +
                                                                    '/' +
                                                                    (cartItems[prodIndex].product!.sku!.variantImage! ==
                                                                            null
                                                                        ? cartItems[prodIndex]
                                                                            .product!
                                                                            .product!
                                                                            .product!
                                                                            .thumbnailImageSource!
                                                                        : cartItems[prodIndex]
                                                                            .product!
                                                                            .sku!
                                                                            .variantImage!),
                                                                boxFit: BoxFit
                                                                    .contain,
                                                                errorWidget:
                                                                    FancyShimmerImage(
                                                                  imageUrl:
                                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                                  boxFit: BoxFit
                                                                      .contain,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15,
                                                    ),
                                                    Expanded(
                                                      child: Container(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          20.0),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Expanded(
                                                                    child: Text(
                                                                      cartItems[prodIndex].productType ==
                                                                              ProductType
                                                                                  .GIFT_CARD
                                                                          ? cartItems[prodIndex]
                                                                              .giftCard!
                                                                              .name!
                                                                              .capitalizeFirst!
                                                                          : cartItems[prodIndex]
                                                                              .product!
                                                                              .product!
                                                                              .productName!
                                                                              .capitalizeFirst!,
                                                                      style: AppStyles
                                                                          .kFontBlack15w4
                                                                          .copyWith(
                                                                              fontWeight: FontWeight.normal),
                                                                    ),
                                                                  ),
                                                                  InkWell(
                                                                    onTap: () {
                                                                      String productName = cartItems[prodIndex].productType ==
                                                                              ProductType
                                                                                  .GIFT_CARD
                                                                          ? cartItems[prodIndex]
                                                                              .giftCard!
                                                                              .name!
                                                                              .capitalizeFirst!
                                                                          : cartItems[prodIndex]
                                                                              .product!
                                                                              .product!
                                                                              .productName!
                                                                              .capitalizeFirst!;

                                                                      Get.dialog(
                                                                        CustomDialogWidget(
                                                                          title:
                                                                              "Remove".tr,
                                                                          subtitle: 'Do you want to remove'.tr +
                                                                              ' $productName (${cartItems[prodIndex].qty}x) ' +
                                                                              'from the cart?'.tr,
                                                                          onCancel:
                                                                              () {
                                                                            Get.back();
                                                                          },
                                                                          onConfirm:
                                                                              () async {
                                                                            Get.back();
                                                                            Map data =
                                                                                {
                                                                              'id': cartItems[prodIndex].id,
                                                                            };
                                                                            await cartController.removeFromCart(data);
                                                                          },
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: AppStyles
                                                                          .greyColorLight,
                                                                      size: 20,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            //** DISCOUNT */
                                                            // cartItems[prodIndex]
                                                            //             .productType ==
                                                            //         ProductType
                                                            //             .PRODUCT
                                                            //     ? cartItems[prodIndex]
                                                            //                 .product
                                                            //                 .product
                                                            //                 .hasDeal !=
                                                            //             null
                                                            //         ? Padding(
                                                            //             padding:
                                                            //                 const EdgeInsets.symmetric(vertical: 4.0),
                                                            //             child:
                                                            //                 Row(
                                                            //               children: [
                                                            //                 Container(
                                                            //                   padding: EdgeInsets.all(4),
                                                            //                   decoration: BoxDecoration(
                                                            //                     color: AppStyles.pinkColor,
                                                            //                     borderRadius: BorderRadius.circular(2),
                                                            //                   ),
                                                            //                   child: Text(
                                                            //                     cartItems[prodIndex].product.product.hasDeal.discountType == 0 ? '-${cartItems[prodIndex].product.product.hasDeal.discount}%' : '-${double.parse((cartItems[prodIndex].product.product.hasDeal.discount * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                            //                     style: AppStyles.kFontWhite12w5,
                                                            //                   ),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           )
                                                            //         : cartItems[prodIndex].product.product.discount >
                                                            //                 0
                                                            //             ? Padding(
                                                            //                 padding:
                                                            //                     const EdgeInsets.symmetric(vertical: 4.0),
                                                            //                 child:
                                                            //                     Row(
                                                            //                   children: [
                                                            //                     Container(
                                                            //                       padding: EdgeInsets.all(4),
                                                            //                       decoration: BoxDecoration(
                                                            //                         color: AppStyles.pinkColor,
                                                            //                         borderRadius: BorderRadius.circular(2),
                                                            //                       ),
                                                            //                       child: Text(
                                                            //                         cartItems[prodIndex].product.product.discountType == "0" ? '-${cartItems[prodIndex].product.product.discount}%' : '-${double.parse((cartItems[prodIndex].product.product.discount * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                            //                         style: AppStyles.kFontWhite12w5,
                                                            //                       ),
                                                            //                     ),
                                                            //                   ],
                                                            //                 ),
                                                            //               )
                                                            //             : SizedBox()
                                                            //     : cartItems[prodIndex]
                                                            //                 .giftCard
                                                            //                 .discount >
                                                            //             0
                                                            //         ? Padding(
                                                            //             padding:
                                                            //                 const EdgeInsets.symmetric(vertical: 4.0),
                                                            //             child:
                                                            //                 Row(
                                                            //               children: [
                                                            //                 Container(
                                                            //                   padding: EdgeInsets.all(4),
                                                            //                   decoration: BoxDecoration(
                                                            //                     color: AppStyles.pinkColor,
                                                            //                     borderRadius: BorderRadius.circular(2),
                                                            //                   ),
                                                            //                   child: Text(
                                                            //                     cartItems[prodIndex].giftCard.discountType == "0" || cartItems[prodIndex].giftCard.discountType == 0 ? '-${cartItems[prodIndex].giftCard.discount}%' : '-${double.parse((cartItems[prodIndex].giftCard.discount * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                            //                     style: AppStyles.kFontWhite12w5,
                                                            //                   ),
                                                            //                 ),
                                                            //               ],
                                                            //             ),
                                                            //           )
                                                            //         : Container(),
                                                            //** VARIATIONS */
                                                            cartItems[prodIndex]
                                                                        .productType ==
                                                                    ProductType
                                                                        .GIFT_CARD
                                                                ? SizedBox
                                                                    .shrink()
                                                                : cartItems[prodIndex]
                                                                            .product!
                                                                            .productVariations!
                                                                            .length >
                                                                        0
                                                                    ? ListView
                                                                        .builder(
                                                                        shrinkWrap:
                                                                            true,
                                                                        physics:
                                                                            NeverScrollableScrollPhysics(),
                                                                        itemCount: cartItems[prodIndex]
                                                                            .product!
                                                                            .productVariations!
                                                                            .length,
                                                                        padding:
                                                                            EdgeInsets.symmetric(vertical: 8),
                                                                        itemBuilder:
                                                                            (BuildContext context,
                                                                                int variationIndex) {
                                                                          if (cartItems[prodIndex].product!.productVariations![variationIndex].attribute!.name ==
                                                                              'Color') {
                                                                            return Text(
                                                                              '${cartItems[prodIndex].product!.productVariations![variationIndex].attribute!.name}: ${cartItems[prodIndex].product!.productVariations![variationIndex].attributeValue!.color!.name}',
                                                                              style: AppStyles.kFontGrey12w5,
                                                                            );
                                                                          }
                                                                          return Text(
                                                                            '${cartItems[prodIndex].product!.productVariations![variationIndex].attribute!.name}: ${cartItems[prodIndex].product!.productVariations![variationIndex].attributeValue!.value}',
                                                                            style:
                                                                                AppStyles.kFontGrey12w5,
                                                                          );
                                                                        },
                                                                      )
                                                                    : SizedBox
                                                                        .shrink(),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                    currencyController
                                                                            .appCurrency
                                                                            .value +
                                                                        (cartItems[prodIndex].totalPrice! *
                                                                                currencyController.conversionRate.value)
                                                                            .toStringAsFixed(2),
                                                                    style: AppStyles
                                                                        .kFontPink15w5,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    cartItems[prodIndex].productType ==
                                                                            ProductType
                                                                                .PRODUCT
                                                                        ? cartItems[prodIndex].qty ==
                                                                                cartItems[prodIndex].product!.product!.product!.minimumOrderQty
                                                                            ? Icon(
                                                                                Icons.remove,
                                                                                color: AppStyles.lightGreyColor,
                                                                                size: 20,
                                                                              )
                                                                            : InkWell(
                                                                                child: Icon(
                                                                                  Icons.remove,
                                                                                  color: AppStyles.greyColorDark,
                                                                                  size: 20,
                                                                                ),
                                                                                onTap: () async {
                                                                                  var qty = cartItems[prodIndex].qty;
                                                                                  Map data = {
                                                                                    "id": cartItems[prodIndex].id,
                                                                                    "qty": qty - 1,
                                                                                    "p_id": cartItems[prodIndex].productId,
                                                                                  };
                                                                                  await cartController.updateCartQuantity(data);
                                                                                },
                                                                              )
                                                                        : InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              var qty = cartItems[prodIndex].qty;
                                                                              Map data = {
                                                                                "id": cartItems[prodIndex].id,
                                                                                "qty": qty - 1,
                                                                                "p_id": cartItems[prodIndex].productId,
                                                                              };
                                                                              await cartController.updateCartQuantity(data);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.remove,
                                                                              color: AppStyles.lightGreyColor,
                                                                              size: 20,
                                                                            ),
                                                                          ),
                                                                    Container(
                                                                      width: 30,
                                                                      height:
                                                                          30,
                                                                      margin: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              5),
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        color: AppStyles
                                                                            .lightBlueColorAlt,
                                                                        border:
                                                                            Border.all(
                                                                          color:
                                                                              AppStyles.greyBorder,
                                                                        ),
                                                                      ),
                                                                      child: Text(
                                                                          '${cartItems[prodIndex].qty.toString()}'),
                                                                    ),
                                                                    // if(stockmanage == 1){
                                                                    //   qty == totalstock
                                                                    //     noclick
                                                                    //   click
                                                                    // }else{
                                                                    //   qty == maxorderqty
                                                                    //     noclick
                                                                    //   click
                                                                    // },
                                                                    cartItems[prodIndex].productType ==
                                                                            ProductType
                                                                                .PRODUCT
                                                                        ? cartItems[prodIndex].product!.product!.stockManage ==
                                                                                1
                                                                            ? cartItems[prodIndex].qty == cartItems[prodIndex].product!.productStock
                                                                                ? Icon(
                                                                                    Icons.add,
                                                                                    color: AppStyles.greyColorLight,
                                                                                    size: 20,
                                                                                  )
                                                                                : InkWell(
                                                                                    child: Icon(
                                                                                      Icons.add,
                                                                                      color: AppStyles.greyColorDark,
                                                                                      size: 20,
                                                                                    ),
                                                                                    onTap: () async {
                                                                                      var qty = cartItems[prodIndex].qty;

                                                                                      Map data = {
                                                                                        "id": cartItems[prodIndex].id,
                                                                                        "qty": qty + 1,
                                                                                        "p_id": cartItems[prodIndex].productId,
                                                                                      };

                                                                                      await cartController.updateCartQuantity(data);
                                                                                    })
                                                                            : cartItems[prodIndex].qty == cartItems[prodIndex].product!.product!.product!.maxOrderQty
                                                                                ? Icon(
                                                                                    Icons.add,
                                                                                    color: AppStyles.greyColorLight,
                                                                                    size: 20,
                                                                                  )
                                                                                : InkWell(
                                                                                    child: Icon(
                                                                                      Icons.add,
                                                                                      color: AppStyles.greyColorDark,
                                                                                      size: 20,
                                                                                    ),
                                                                                    onTap: () async {
                                                                                      var qty = cartItems[prodIndex].qty;

                                                                                      Map data = {
                                                                                        "id": cartItems[prodIndex].id,
                                                                                        "qty": qty + 1,
                                                                                        "p_id": cartItems[prodIndex].productId,
                                                                                      };

                                                                                      await cartController.updateCartQuantity(data);
                                                                                    })
                                                                        : InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              var qty = cartItems[prodIndex].qty;

                                                                              Map data = {
                                                                                "id": cartItems[prodIndex].id,
                                                                                "qty": qty + 1,
                                                                                "p_id": cartItems[prodIndex].productId,
                                                                              };

                                                                              await cartController.updateCartQuantity(data);
                                                                            },
                                                                            child:
                                                                                Icon(
                                                                              Icons.add,
                                                                              color: AppStyles.greyColorLight,
                                                                              size: 20,
                                                                            ),
                                                                          ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      );
                    });
              }
            }
          }),
          SizedBox(
            height: 10,
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        margin: EdgeInsets.only(bottom: widget.hasMargin! ? 70 : 0),
        child: Row(
          children: [
            Expanded(
              child: Container(),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (cartController.isLoading.value) {
                    return Center(
                      child: CustomLoadingWidget(),
                    );
                  } else {
                    if (cartController.cartListModel.value.carts == null ||
                        cartController.cartListModel.value.carts!.length == 0) {
                      return Container();
                    }
                  }
                  return Row(
                    children: [
                      Text('Total'.tr + ": ",
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontBlack14w5
                              .copyWith(fontWeight: FontWeight.bold)),
                      Text(
                          '${double.parse((totalPrice() + (cartController.cartListModel.value.shippingCharge * currencyController.conversionRate.value)).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontDarkBlue14w5
                              .copyWith(fontWeight: FontWeight.bold)),
                    ],
                  );
                }),
                SizedBox(
                  height: 2,
                ),
                Obx(() {
                  if (cartController.isLoading.value) {
                    return Center(
                      child: CustomLoadingWidget(),
                    );
                  } else {
                    if (cartController.cartListModel.value.carts == null ||
                        cartController.cartListModel.value.carts!.length == 0) {
                      return Container();
                    }
                  }
                  return Row(
                    children: [
                      Text('Shipping'.tr + ": ",
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontBlack12w4),
                      Text('Calculated at next step'.tr,
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontBlack12w4),
                    ],
                  );
                }),
              ],
            ),
            SizedBox(
              width: 5,
            ),
            Obx(() {
              if (cartController.isLoading.value) {
                return Center(
                  child: CustomLoadingWidget(),
                );
              } else {
                if (cartController.cartListModel.value.carts == null ||
                    cartController.cartListModel.value.carts!.length == 0) {
                  return Container();
                }
              }
              return PinkButtonWidget(
                height: 40,
                btnText: 'Checkout'.tr,
                btnOnTap: () {
                  Get.to(() => CartCheckout());
                },
              );
            }),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }
}
