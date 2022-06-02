import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cancelled_order_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderData.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/account/orders/OrderDetails.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';

class MyCancellations extends StatefulWidget {
  @override
  _MyCancellationsState createState() => _MyCancellationsState();
}

class _MyCancellationsState extends State<MyCancellations> {
  final CancelledOrderController cancelledController =
      Get.put(CancelledOrderController());

  final CurrencyController _currencyController = Get.put(CurrencyController());

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

    if (order.isCancelled == 0 &&
        order.isCompleted == 0 &&
        order.isConfirmed == 0 &&
        order.isPaid == 0) {
      orderStatus = 'Pending';
    } else {
      if (order.isCancelled == 1) {
        orderStatus = "Cancelled";
      } else if (order.isCompleted == 1) {
        orderStatus = 'Completed';
      } else if (order.isConfirmed == 1) {
        orderStatus = 'Confirmed';
      } else if (order.isPaid == 1) {
        orderStatus = 'Paid';
      }
    }
    return orderStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(title: 'Cancelled Orders'.tr),
      body: Obx(
        () {
          if (cancelledController.isAllOrderLoading.value) {
            return Center(
              child: CustomLoadingWidget(),
            );
          } else {
            if (cancelledController.cancelledOrderListModel.value.orders ==
                    null ||
                cancelledController
                        .cancelledOrderListModel.value.orders!.length ==
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
                      'No Cancelled Orders'.tr,
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
                itemCount: cancelledController
                    .cancelledOrderListModel.value.orders!.length,
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Get.to(() => OrderDetails(
                                  order: cancelledController
                                      .cancelledOrderListModel
                                      .value
                                      .orders![index],
                                ));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        cancelledController
                                            .cancelledOrderListModel
                                            .value
                                            .orders![index]
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
                                    'Placed on'.tr +
                                        ': ' +
                                        cancelledController
                                            .cancelledOrderListModel
                                            .value
                                            .orders![index]
                                            .createdAt!
                                            .toLocal()
                                            .toString(),
                                    style: AppStyles.kFontBlack12w4,
                                  ),
                                  SizedBox(
                                    height: 5.2,
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              Text(
                                '${orderStatusGet(cancelledController.cancelledOrderListModel.value.orders![index])}',
                                style: AppStyles.kFontBlack12w4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: cancelledController
                                .cancelledOrderListModel
                                .value
                                .orders![index]
                                .packages!
                                .length,
                            itemBuilder: (context, packageIndex) {
                              return Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                    cancelledController
                                                        .cancelledOrderListModel
                                                        .value
                                                        .orders![index]
                                                        .packages![packageIndex]
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
                                                      cancelledController
                                                          .cancelledOrderListModel
                                                          .value
                                                          .orders![index]
                                                          .packages![
                                                              packageIndex]
                                                          .seller!
                                                          .firstName!,
                                                  style:
                                                      AppStyles.kFontBlack14w5,
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 26.0, top: 5),
                                                child: Text(
                                                  cancelledController
                                                      .cancelledOrderListModel
                                                      .value
                                                      .orders![index]
                                                      .packages![packageIndex]
                                                      .shippingDate!,
                                                  style:
                                                      AppStyles.kFontBlack12w4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          deliverStateName(cancelledController
                                              .cancelledOrderListModel
                                              .value
                                              .orders![index]
                                              .packages![packageIndex]),
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontDarkBlue12w5
                                              .copyWith(
                                                  fontStyle: FontStyle.italic),
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
                                        itemCount: cancelledController
                                            .cancelledOrderListModel
                                            .value
                                            .orders![index]
                                            .packages![packageIndex]
                                            .products!
                                            .length,
                                        itemBuilder: (context, productIndex) {
                                          if (cancelledController
                                                  .cancelledOrderListModel
                                                  .value
                                                  .orders![index]
                                                  .packages![packageIndex]
                                                  .products![productIndex]
                                                  .type ==
                                              ProductType.GIFT_CARD) {
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
                                                              cancelledController
                                                                  .cancelledOrderListModel
                                                                  .value
                                                                  .orders![
                                                                      index]
                                                                  .packages![
                                                                      packageIndex]
                                                                  .products![
                                                                      productIndex]
                                                                  .giftCard!
                                                                  .thumbnailImage!,
                                                          fit: BoxFit.cover,
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
                                                            cancelledController
                                                                .cancelledOrderListModel
                                                                .value
                                                                .orders![index]
                                                                .packages![
                                                                    packageIndex]
                                                                .products![
                                                                    productIndex]
                                                                .giftCard!
                                                                .name!,
                                                            style: AppStyles
                                                                .kFontBlack14w5,
                                                          ),
                                                          SizedBox(
                                                            height: 5,
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                '${(cancelledController.cancelledOrderListModel.value.orders![index].packages![packageIndex].products![productIndex].giftCard!.sellingPrice! * _currencyController.conversionRate.value).toString()}${_currencyController.appCurrency.value}',
                                                                style: AppStyles
                                                                    .kFontPink15w5,
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(),
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
                                                              cancelledController
                                                                  .cancelledOrderListModel
                                                                  .value
                                                                  .orders![
                                                                      index]
                                                                  .packages![
                                                                      packageIndex]
                                                                  .products![
                                                                      productIndex]
                                                                  .sellerProductSku!
                                                                  .product!
                                                                  .product!
                                                                  .thumbnailImageSource!,
                                                          fit: BoxFit.cover,
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
                                                            cancelledController
                                                                .cancelledOrderListModel
                                                                .value
                                                                .orders![index]
                                                                .packages![
                                                                    packageIndex]
                                                                .products![
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
                                                            itemCount: cancelledController
                                                                .cancelledOrderListModel
                                                                .value
                                                                .orders![index]
                                                                .packages![
                                                                    packageIndex]
                                                                .products![
                                                                    productIndex]
                                                                .sellerProductSku!
                                                                .productVariations!
                                                                .length,
                                                            itemBuilder: (context,
                                                                variantIndex) {
                                                              if (cancelledController
                                                                      .cancelledOrderListModel
                                                                      .value
                                                                      .orders![
                                                                          index]
                                                                      .packages![
                                                                          packageIndex]
                                                                      .products![
                                                                          productIndex]
                                                                      .sellerProductSku!
                                                                      .productVariations![
                                                                          variantIndex]
                                                                      .attribute!
                                                                      .name ==
                                                                  'Color') {
                                                                return Text(
                                                                  'Color'.tr +
                                                                      ': ${cancelledController.cancelledOrderListModel.value.orders![index].packages![packageIndex].products![productIndex].sellerProductSku!.productVariations![variantIndex].attributeValue!.color!.name}',
                                                                  style: AppStyles
                                                                      .kFontBlack12w4,
                                                                );
                                                              } else {
                                                                return Text(
                                                                  'Storage'.tr +
                                                                      ': ${cancelledController.cancelledOrderListModel.value.orders![index].packages![packageIndex].products![productIndex].sellerProductSku!.productVariations![variantIndex].attributeValue!.value}',
                                                                  style: AppStyles
                                                                      .kFontBlack12w4,
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
                                                                    MainAxisAlignment
                                                                        .start,
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
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        '${_currencyController.appCurrency.value}${(cancelledController.cancelledOrderListModel.value.orders![index].packages![packageIndex].products![productIndex].price * _currencyController.conversionRate.value).toStringAsFixed(2)}',
                                                                        style: AppStyles
                                                                            .kFontPink15w5,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5,
                                                                      ),
                                                                      Text(
                                                                        '(${cancelledController.cancelledOrderListModel.value.orders![index].packages![packageIndex].products![productIndex].qty}x)',
                                                                        style: AppStyles
                                                                            .kFontBlack14w5,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Expanded(
                                                                child:
                                                                    Container(),
                                                              ),
                                                              // Text(
                                                              //   '=\$${orderController.orderListModel.value.orders![index].packages![packageIndex].products![productIndex].totalPrice}',
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
                              '${cancelledController.cancelledOrderListModel.value.orders![index].packages!.length} ' +
                                  'Package'.tr +
                                  ',' +
                                  'Total'.tr +
                                  ':' +
                                  '${_currencyController.appCurrency.value}' +
                                  (cancelledController
                                              .cancelledOrderListModel
                                              .value
                                              .orders![index]
                                              .grandTotal! *
                                          _currencyController
                                              .conversionRate.value)
                                      .toStringAsFixed(2),
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ],
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
