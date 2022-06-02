import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderData.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/account/orders/OrderDetails.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';

class OrderAllToPayListDataWidget extends StatelessWidget {
  OrderAllToPayListDataWidget({this.order});
  final OrderData? order;

  final CurrencyController currencyController = Get.put(CurrencyController());

  String deliverStateName(Package package) {
    var deliveryStatus;
    package.processes!.forEach((element) {
      if (package.deliveryStatus == element.id) {
        deliveryStatus = element.name;
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  String orderStatusGet(OrderData order) {
    var orderStatus;

    if (order!.isCancelled == 0 &&
        order!.isCompleted == 0 &&
        order!.isConfirmed == 0 &&
        order!.isPaid == 0) {
      orderStatus = 'Pending'.tr;
    } else {
      if (order!.isCancelled == 1) {
        orderStatus = "Cancelled".tr;
      }
      if (order!.isCompleted == 1) {
        orderStatus = 'Completed'.tr;
      }
      if (order!.isConfirmed == 1) {
        orderStatus = 'Confirmed'.tr;
      }
      if (order!.isPaid == 1) {
        orderStatus = 'Paid'.tr;
      }
    }
    return orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => OrderDetails(
              order: order!,
            ));
      },
      child: Container(
        color: context.theme.cardColor,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          order!.orderNumber!.capitalizeFirst!,
                          style: AppStyles.kFontBlack15w4,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: AppStyles.blackColor,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.2,
                    ),
                    Text(
                      'Placed on:'.tr +
                          ' ' +
                          CustomDate().formattedDateTime(order!.createdAt),
                      style: AppStyles.kFontBlack12w4,
                    ),
                    SizedBox(
                      height: 5.2,
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Text(
                  '${orderStatusGet(order!)}',
                  style: AppStyles.kFontBlack12w4,
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: order!.packages!.length,
                itemBuilder: (context, packageIndex) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/icon_delivery-parcel.png',
                                        width: 17,
                                        height: 17,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        order!.packages![packageIndex]
                                            .packageCode!,
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ],
                                  ),
                                  currencyController.vendorType.value ==
                                          "single"
                                      ? SizedBox.shrink()
                                      : Padding(
                                          padding: EdgeInsets.only(
                                              left: 26.0, top: 5),
                                          child: Text(
                                            'Sold by'.tr +
                                                ': ' +
                                                order!.packages![packageIndex]
                                                    .seller!.firstName!,
                                            style: AppStyles.kFontBlack14w5,
                                          ),
                                        ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 26.0, top: 5),
                                    child: Text(
                                      order!.packages![packageIndex]
                                          .shippingDate!,
                                      style: AppStyles.kFontBlack12w4,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              deliverStateName(order!.packages![packageIndex]),
                              textAlign: TextAlign.center,
                              style: AppStyles.kFontDarkBlue12w5
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: AppStyles.appBackgroundColor,
                                height: 2,
                                thickness: 2,
                              );
                            },
                            shrinkWrap: true,
                            padding: EdgeInsets.only(left: 26.0),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount:
                                order!.packages![packageIndex].products!.length,
                            itemBuilder: (context, productIndex) {
                              if (order!.packages![packageIndex]
                                      .products![productIndex].type ==
                                  ProductType.GIFT_CARD) {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Container(
                                            height: 80,
                                            width: 80,
                                            child: FancyShimmerImage(
                                              imageUrl: AppConfig.assetPath +
                                                  '/' +
                                                  order!
                                                      .packages![packageIndex]
                                                      .products![productIndex]
                                                      .giftCard!
                                                      .thumbnailImage!,
                                              boxFit: BoxFit.contain,
                                              errorWidget: FancyShimmerImage(
                                                imageUrl:
                                                    "${AppConfig.assetPath}/backend/img/default.png",
                                                boxFit: BoxFit.contain,
                                              ),
                                            )),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order!
                                                    .packages![packageIndex]
                                                    .products![productIndex]
                                                    .giftCard!
                                                    .name!,
                                                style: AppStyles.kFontBlack14w5,
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Obx(() {
                                                    return Text(
                                                      '${(order!.packages![packageIndex].products![productIndex].price * currencyController.conversionRate.value).toString()}${currencyController.appCurrency.value}',
                                                      style: AppStyles
                                                          .kFontPink15w5,
                                                    );
                                                  }),
                                                  Expanded(
                                                    child: Container(),
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
                                );
                              } else {
                                return Container(
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5)),
                                        child: Container(
                                            height: 80,
                                            width: 80,
                                            child: FancyShimmerImage(
                                              imageUrl: order!
                                                          .packages![
                                                              packageIndex]
                                                          .products![
                                                              productIndex]
                                                          .sellerProductSku!
                                                          .sku!
                                                          .variantImage! !=
                                                      null
                                                  ? '${AppConfig.assetPath}/${order!.packages![packageIndex].products![productIndex].sellerProductSku!.sku!.variantImage!}'
                                                  : '${AppConfig.assetPath}/${order!.packages![packageIndex].products![productIndex].sellerProductSku!.product!.product!.thumbnailImageSource!}',
                                              boxFit: BoxFit.contain,
                                            )),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        child: Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order!
                                                    .packages![packageIndex]
                                                    .products![productIndex]
                                                    .sellerProductSku!
                                                    .product!
                                                    .productName!,
                                                style: AppStyles.kFontBlack14w5,
                                              ),
                                              ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: order!
                                                    .packages![packageIndex]
                                                    .products![productIndex]
                                                    .sellerProductSku!
                                                    .productVariations!
                                                    .length,
                                                itemBuilder:
                                                    (context, variantIndex) {
                                                  if (order!
                                                          .packages![
                                                              packageIndex]
                                                          .products![
                                                              productIndex]
                                                          .sellerProductSku!
                                                          .productVariations![
                                                              variantIndex]
                                                          .attribute!
                                                          .name! ==
                                                      'Color') {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(
                                                        'Color: ${order!.packages![packageIndex].products![productIndex].sellerProductSku!.productVariations![variantIndex].attributeValue!.color!.name!}',
                                                        style: AppStyles
                                                            .kFontBlack12w4,
                                                      ),
                                                    );
                                                  } else {
                                                    return Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4.0),
                                                      child: Text(
                                                        '${order!.packages![packageIndex].products![productIndex].sellerProductSku!.productVariations![variantIndex].attribute!.name!}: ${order!.packages![packageIndex].products![productIndex].sellerProductSku!.productVariations![variantIndex].attributeValue!.value!}',
                                                        style: AppStyles
                                                            .kFontBlack12w4,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Obx(() {
                                                            return Text(
                                                              '${(order!.packages![packageIndex].products![productIndex].price * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                              style: AppStyles
                                                                  .kFontPink15w5,
                                                            );
                                                          }),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            '(${order!.packages![packageIndex].products![productIndex].qty}x)',
                                                            style: AppStyles
                                                                .kFontBlack14w5,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Expanded(
                                                    child: Container(),
                                                  ),
                                                  // Text(
                                                  //   '=\$${orderController.orderListModel.value.orders[index].packages![packageIndex].products![productIndex].totalPrice}',
                                                  //   style: AppStyles
                                                  //       .kFontBlack14w5,
                                                  // ),
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
                                );
                              }
                            }),
                      ],
                    ),
                  );
                }),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${order!.packages!.length} ' +
                      'Package'.tr +
                      ',' +
                      'Total'.tr +
                      ': ' +
                      (order!.grandTotal! *
                              currencyController.conversionRate.value)
                          .toStringAsFixed(2) +
                      '${currencyController.appCurrency.value}',
                  style: AppStyles.kFontBlack14w5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
