import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/order_refund_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderRefundModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'RefundDetails.dart';

class MyRefundsAndDisputes extends StatefulWidget {
  @override
  _MyRefundsAndDisputesState createState() => _MyRefundsAndDisputesState();
}

class _MyRefundsAndDisputesState extends State<MyRefundsAndDisputes> {
  final OrderRefundController orderRefundController =
      Get.put(OrderRefundController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  String refundOrderstatusGet(Order order) {
    var refundOrderstatus;

    if (order.isCancelled == 0 &&
        order.isCompleted == 0 &&
        order.isConfirmed == 0 &&
        order.isPaid == 0) {
      refundOrderstatus = 'Pending';
    } else {
      if (order.isCancelled == 1) {
        refundOrderstatus = "Cancelled";
      } else if (order.isCompleted == 1) {
        refundOrderstatus = 'Completed';
      } else if (order.isConfirmed == 1) {
        refundOrderstatus = 'Confirmed';
      } else if (order.isPaid == 1) {
        refundOrderstatus = 'Paid';
      }
    }
    return refundOrderstatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(title: 'Refunds and Disputes'.tr),
      body: Obx(
        () {
          if (orderRefundController.isAllOrderLoading.value) {
            return Center(
              child: CustomLoadingWidget(),
            );
          } else {
            if (orderRefundController.refundOrderListModel.value.refundOrders ==
                    null ||
                orderRefundController
                        .refundOrderListModel.value.refundOrders!.length ==
                    0) {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.exclamation,
                      color: AppStyles.pinkColor,
                      size: 25,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'No Refund Orders'.tr,
                      textAlign: TextAlign.center,
                      style: AppStyles.kFontPink15w5.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return Divider(
                    color: AppStyles.appBackgroundColor,
                    height: 5,
                    thickness: 5,
                  );
                },
                itemCount: orderRefundController
                    .refundOrderListModel.value.refundOrders!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Get.to(() => RefundDetails(
                            refundOrder: orderRefundController
                                .refundOrderListModel
                                .value
                                .refundOrders![index],
                          ));
                    },
                    child: Container(
                      color: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                                        orderRefundController
                                            .refundOrderListModel
                                            .value
                                            .refundOrders![index]
                                            .order!
                                            .orderNumber!
                                            .capitalizeFirst!,
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
                                    'Refund Requested on'.tr +
                                        ': ' +
                                        CustomDate().formattedDateTime(
                                            orderRefundController
                                                .refundOrderListModel
                                                .value
                                                .refundOrders![index]
                                                .createdAt),
                                    style: AppStyles.kFontBlack12w4,
                                  ),
                                  SizedBox(
                                    height: 5.2,
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                '${orderRefundController.refundOrderListModel.value.refundOrders![index].checkConfirmed}',
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
                              itemCount: orderRefundController
                                  .refundOrderListModel
                                  .value
                                  .refundOrders![index]
                                  .refundDetails!
                                  .length,
                              itemBuilder: (context, packageIndex) {
                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                                      orderRefundController
                                                          .refundOrderListModel
                                                          .value
                                                          .refundOrders![index]
                                                          .refundDetails![
                                                              packageIndex]
                                                          .orderPackage!
                                                          .packageCode!,
                                                      style: AppStyles
                                                          .kFontBlack14w5,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 26.0, top: 5),
                                                  child: Text(
                                                    'Sold by'.tr +
                                                        ': ' +
                                                        orderRefundController
                                                            .refundOrderListModel
                                                            .value
                                                            .refundOrders![
                                                                index]
                                                            .refundDetails![
                                                                packageIndex]
                                                            .seller!
                                                            .firstName!,
                                                    style: AppStyles
                                                        .kFontBlack14w5,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 26.0, top: 5),
                                                  child: Text(
                                                    orderRefundController
                                                        .refundOrderListModel
                                                        .value
                                                        .refundOrders![index]
                                                        .refundDetails![
                                                            packageIndex]
                                                        .orderPackage!
                                                        .shippingDate!,
                                                    style: AppStyles
                                                        .kFontBlack12w4,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              color:
                                                  AppStyles.appBackgroundColor,
                                              height: 2,
                                              thickness: 2,
                                            );
                                          },
                                          shrinkWrap: true,
                                          padding: EdgeInsets.only(left: 26.0),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: orderRefundController
                                              .refundOrderListModel
                                              .value
                                              .refundOrders![index]
                                              .refundDetails![packageIndex]
                                              .refundProducts!
                                              .length,
                                          itemBuilder: (context, productIndex) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 10),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(5)),
                                                    child: Container(
                                                        height: 80,
                                                        width: 80,
                                                        child: Image.network(
                                                          AppConfig.assetPath +
                                                              '/' +
                                                              orderRefundController
                                                                  .refundOrderListModel
                                                                  .value
                                                                  .refundOrders![
                                                                      index]
                                                                  .refundDetails![
                                                                      packageIndex]
                                                                  .refundProducts![
                                                                      productIndex]
                                                                  .sellerProductSku!
                                                                  .product!
                                                                  .product!
                                                                  .thumbnailImageSource!,
                                                          fit: BoxFit.contain,
                                                        )),
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
                                                          Text(
                                                            orderRefundController
                                                                .refundOrderListModel
                                                                .value
                                                                .refundOrders![
                                                                    index]
                                                                .refundDetails![
                                                                    packageIndex]
                                                                .refundProducts![
                                                                    productIndex]
                                                                .sellerProductSku!
                                                                .product!
                                                                .productName!,
                                                            style: AppStyles
                                                                .kFontBlack14w5,
                                                          ),
                                                          ListView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            itemCount: orderRefundController
                                                                .refundOrderListModel
                                                                .value
                                                                .refundOrders![
                                                                    index]
                                                                .refundDetails![
                                                                    packageIndex]
                                                                .refundProducts![
                                                                    productIndex]
                                                                .sellerProductSku!
                                                                .productVariations!
                                                                .length,
                                                            itemBuilder: (context,
                                                                variantIndex) {
                                                              if (orderRefundController
                                                                      .refundOrderListModel
                                                                      .value
                                                                      .refundOrders![
                                                                          index]
                                                                      .refundDetails![
                                                                          packageIndex]
                                                                      .refundProducts![
                                                                          productIndex]
                                                                      .sellerProductSku!
                                                                      .productVariations![
                                                                          variantIndex]
                                                                      .attribute!
                                                                      .name ==
                                                                  'Color') {
                                                                return Text(
                                                                  'Color'.tr +
                                                                      ': ${orderRefundController.refundOrderListModel.value.refundOrders![index].refundDetails![packageIndex].refundProducts![productIndex].sellerProductSku!.productVariations![variantIndex].attributeValue!.color!.name}',
                                                                  style: AppStyles
                                                                      .kFontBlack12w4,
                                                                );
                                                              } else {
                                                                return Text(
                                                                  '${orderRefundController.refundOrderListModel.value.refundOrders![index].refundDetails![packageIndex].refundProducts![productIndex].sellerProductSku!.productVariations![variantIndex].attribute!.name}'
                                                                          .tr +
                                                                      ': ${orderRefundController.refundOrderListModel.value.refundOrders![index].refundDetails![packageIndex].refundProducts![productIndex].sellerProductSku!.productVariations![variantIndex].attributeValue!.value}',
                                                                  style: AppStyles
                                                                      .kFontBlack12w4,
                                                                );
                                                              }
                                                            },
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                '${(orderRefundController.refundOrderListModel.value.refundOrders![index].refundDetails![packageIndex].refundProducts![productIndex].returnAmount * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                style: AppStyles
                                                                    .kFontPink15w5,
                                                              ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                '(${orderRefundController.refundOrderListModel.value.refundOrders![index].refundDetails![packageIndex].refundProducts![productIndex].returnQty}x)',
                                                                style: AppStyles
                                                                    .kFontBlack14w5,
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(
                                                            height: 5,
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
                              // Text(
                              //   '${orderRefundController.refundOrderListModel.value.refundOrders![index].packages.length} Package, Total : \$' +
                              //       orderRefundController.refundOrderListModel.value
                              //           .refundOrders![index].grandTotal
                              //           .toStringAsFixed(2),
                              //   style: AppStyles.kFontBlack14w5,
                              // ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
