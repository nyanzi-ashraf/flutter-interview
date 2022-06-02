import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderData.dart';
import 'package:amazcart/model/NewModel/Order/OrderProductElement.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/account/orders/OrderCancelWidget.dart';
import 'package:amazcart/view/account/orders/RefundAndDisputes/OrderToReturn.dart';
import 'package:amazcart/view/account/reviews/WriteReview.dart';
import 'package:amazcart/view/account/orders/OrderTrack.dart';
import 'package:amazcart/view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/products/product/ProductDetails.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:get/get.dart';
import 'package:amazcart/model/DeliveryProcess.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';

class OrderDetails extends StatefulWidget {
  final OrderData? order;

  OrderDetails({this.order});

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final CurrencyController currencyController = Get.put(CurrencyController());

  String deliverStateName(Package package) {
    var deliveryStatus;
    package.processes!.forEach((element) {
      if (element.id == package.deliveryStatus) {
        deliveryStatus = element.name;
      } else if (package.deliveryStatus == 0) {
        deliveryStatus = "";
      }
    });
    return deliveryStatus;
  }

  bool checkReview(Package package) {
    // print(package.deliveryStates);
    if (package.deliveryStates!.length != 0) {
      // print('${package.processes.last.id} == ${package.deliveryStatus}');
      if (package.processes!.last.id == package.deliveryStatus) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  RecommendedProductsLoadMore? source;

  @override
  void initState() {
    source = RecommendedProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(title: 'Order Details'.tr),
      body: LoadingMoreCustomScrollView(
        rebuildCustomScrollView: true,
        showGlowLeading: false,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: 10,
                ),

                ///BILL TO
                widget.order!.shippingAddress != null &&
                        widget.order!.billingAddress != null
                    ? widget.order!.customerShippingAddress ==
                            widget.order!.customerShippingAddress
                        ? Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    'Ship and Bill to'.tr,
                                    style: AppStyles.kFontGrey12w5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${widget.order!.billingAddress!.name ?? ""}',
                                    style: AppStyles.kFontBlack14w5,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    '${widget.order!.billingAddress!.phone ?? ""}',
                                    style: AppStyles.kFontBlack12w4,
                                  ),
                                ),
                                Text(
                                  '${widget.order!.billingAddress!.address ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Bill to'.tr,
                                  style: AppStyles.kFontGrey12w5,
                                ),
                                Text(
                                  '${widget.order!.billingAddress!.name ?? ""}',
                                  style: AppStyles.kFontBlack14w5,
                                ),
                                Text(
                                  '${widget.order!.billingAddress!.email ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                Text(
                                  '${widget.order!.billingAddress!.phone ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                Text(
                                  '${widget.order!.billingAddress!.address ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                //SHIP TO
                                Text(
                                  'Ship to'.tr,
                                  style: AppStyles.kFontGrey12w5,
                                ),
                                Text(
                                  '${widget.order!.shippingAddress!.name ?? ""}',
                                  style: AppStyles.kFontBlack14w5,
                                ),
                                Text(
                                  '${widget.order!.shippingAddress!.email ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                Text(
                                  '${widget.order!.shippingAddress!.phone ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                                Text(
                                  '${widget.order!.shippingAddress!.address ?? ""}',
                                  style: AppStyles.kFontBlack12w4,
                                ),
                              ],
                            ),
                          )
                    : Container(),

                /// PACKAGE
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.order!.packages!.length,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.asset(
                                      'assets/images/icon_delivery-parcel.png',
                                      width: 17,
                                      height: 17,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Package'.tr +
                                              ': ' +
                                              widget
                                                  .order!
                                                  .packages![packageIndex]
                                                  .packageCode!,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        currencyController.vendorType.value ==
                                                "single"
                                            ? SizedBox.shrink()
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Sold by'.tr +
                                                        ': ' +
                                                        widget
                                                            .order!
                                                            .packages![
                                                                packageIndex]
                                                            .seller!
                                                            .firstName!,
                                                    style: AppStyles
                                                        .kFontBlack12w4,
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                ],
                                              ),
                                        Text(
                                          widget.order!.packages![packageIndex]
                                              .shippingDate!,
                                          style: AppStyles.kFontBlack12w4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      deliverStateName(widget
                                          .order!.packages![packageIndex]),
                                      textAlign: TextAlign.center,
                                      style: AppStyles.kFontDarkBlue12w5
                                          .copyWith(
                                              fontStyle: FontStyle.italic),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: widget.order!
                                      .packages![packageIndex].products!.length,
                                  itemBuilder: (context, productIndex) {
                                    if (widget.order!.packages![packageIndex]
                                            .products![productIndex].type ==
                                        ProductType.GIFT_CARD) {
                                      return Container(
                                        margin:
                                            EdgeInsets.only(left: 20, top: 5),
                                        decoration: BoxDecoration(
                                          color: AppStyles.appBackgroundColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                        ),
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
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
                                                              widget
                                                                  .order!
                                                                  .packages![
                                                                      packageIndex]
                                                                  .products![
                                                                      productIndex]
                                                                  .giftCard!
                                                                  .thumbnailImage!,
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
                                                            widget
                                                                .order!
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
                                                              Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    '${(widget.order!.packages![packageIndex].products![productIndex].price * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                                    style: AppStyles
                                                                        .kFontPink15w5,
                                                                  ),
                                                                ],
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
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(() => ProductDetails(
                                                productID: widget
                                                    .order!
                                                    .packages![packageIndex]
                                                    .products![productIndex]
                                                    .sellerProductSku!
                                                    .product!
                                                    .id!,
                                              ));
                                        },
                                        child: Container(
                                          margin:
                                              EdgeInsets.only(left: 20, top: 5),
                                          decoration: BoxDecoration(
                                            color: AppStyles.appBackgroundColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  5)),
                                                      child: Container(
                                                          height: 80,
                                                          width: 80,
                                                          child:
                                                              FancyShimmerImage(
                                                            imageUrl: widget
                                                                        .order!
                                                                        .packages![
                                                                            packageIndex]
                                                                        .products![
                                                                            productIndex]
                                                                        .sellerProductSku!
                                                                        .sku!
                                                                        .variantImage !=
                                                                    null
                                                                ? '${AppConfig.assetPath}/${widget.order!.packages![packageIndex].products![productIndex].sellerProductSku!.sku!.variantImage}'
                                                                : '${AppConfig.assetPath}/${widget.order!.packages![packageIndex].products![productIndex].sellerProductSku!.product!.product!.thumbnailImageSource}',
                                                            boxFit:
                                                                BoxFit.contain,
                                                            errorWidget:
                                                                FancyShimmerImage(
                                                              imageUrl:
                                                                  "${AppConfig.assetPath}/backend/img/default.png",
                                                              boxFit: BoxFit
                                                                  .contain,
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
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              widget
                                                                  .order!
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
                                                              itemCount: widget
                                                                  .order!
                                                                  .packages![
                                                                      packageIndex]
                                                                  .products![
                                                                      productIndex]
                                                                  .sellerProductSku!
                                                                  .productVariations!
                                                                  .length,
                                                              itemBuilder: (context,
                                                                  variantIndex) {
                                                                if (widget
                                                                        .order!
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
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            4.0),
                                                                    child: Text(
                                                                      'Color'.tr +
                                                                          ': ${widget.order!.packages![packageIndex].products![productIndex].sellerProductSku!.productVariations![variantIndex].attributeValue!.color!.name}',
                                                                      style: AppStyles
                                                                          .kFontBlack12w4,
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            4.0),
                                                                    child: Text(
                                                                      '${widget.order!.packages![packageIndex].products![productIndex].sellerProductSku!.productVariations![variantIndex].attribute!.name}'
                                                                              .tr +
                                                                          ': ${widget.order!.packages![packageIndex].products![productIndex].sellerProductSku!.productVariations![variantIndex].attributeValue!.value}',
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
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          '${currencyController.appCurrency.value} ${(widget.order!.packages![packageIndex].products![productIndex].price * currencyController.conversionRate.value).toStringAsFixed(2)}',
                                                                          style:
                                                                              AppStyles.kFontPink15w5,
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5,
                                                                        ),
                                                                        Text(
                                                                          '(${widget.order!.packages![packageIndex].products![productIndex].qty}x)',
                                                                          style:
                                                                              AppStyles.kFontBlack14w5,
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
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
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 15),
                                child: widget.order!.packages![packageIndex]
                                            .deliveryStatus ==
                                        0
                                    ? widget.order!.isCancelled == 0
                                        ? InkWell(
                                            onTap: () async {
                                              await Get.bottomSheet(
                                                OrderCancelWidget(
                                                  packageId: widget
                                                      .order!
                                                      .packages![packageIndex]
                                                      .id,
                                                  order: widget.order,
                                                ),
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                persistent: true,
                                              );
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 122,
                                              height: 32,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                  border: Border.all(
                                                      color: AppStyles
                                                          .greyColorDark)),
                                              child: Text('Cancel'.tr,
                                                  textAlign: TextAlign.center,
                                                  style:
                                                      AppStyles.kFontGrey14w5),
                                            ),
                                          )
                                        : Container(
                                            alignment: Alignment.center,
                                            width: 122,
                                            height: 32,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                border: Border.all(
                                                    color: AppStyles
                                                        .greyColorDark)),
                                            child: Text('Order Cancelled'.tr,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.kFontGrey14w5),
                                          )
                                    : Container(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    widget.order!.packages![packageIndex]
                                                .isReviewed ==
                                            0
                                        ? checkReview(widget
                                                .order!.packages![packageIndex])
                                            ? InkWell(
                                                onTap: () {
                                                  Get.to(() => WriteReview(
                                                        package: widget.order!
                                                                .packages![
                                                            packageIndex],
                                                        // productIds: prod,
                                                        sellerID: widget
                                                            .order!
                                                            .packages![
                                                                packageIndex]
                                                            .sellerId,
                                                        orderID: widget
                                                            .order!
                                                            .packages![
                                                                packageIndex]
                                                            .orderId,
                                                        packageID: widget
                                                            .order!
                                                            .packages![
                                                                packageIndex]
                                                            .id,
                                                      ));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  width: 122,
                                                  height: 32,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(5),
                                                      ),
                                                      border: Border.all(
                                                          color: AppStyles
                                                              .pinkColor)),
                                                  child: Text(
                                                    'Write a Review'.tr,
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        AppStyles.kFontPink15w5,
                                                  ),
                                                ),
                                              )
                                            : Container()
                                        : Container(),
                                  ],
                                ),
                              ),

                              ///Track
                              Container(
                                height: 30,
                                margin: EdgeInsets.only(top: 10),
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Get.to(() => OrderTrack(
                                              order: widget.order!,
                                              package: widget.order!
                                                  .packages![packageIndex],
                                              processes:
                                                  DeliveryProcess.delivery,
                                            ));
                                      },
                                      child: Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              'assets/images/icon_delivery-parcel_pink.png',
                                              width: 18,
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text('Track your order'.tr,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.kFontGrey14w5),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    // InkWell(
                                    //   onTap: () {},
                                    //   child: Row(
                                    //     children: [
                                    //       Image.asset(
                                    //         'assets/images/icon_chat_bot_pink.png',
                                    //         width: 18,
                                    //       ),
                                    //       SizedBox(
                                    //         width: 5,
                                    //       ),
                                    //       Text('Chat now'.tr,
                                    //           textAlign: TextAlign.center,
                                    //           style: AppStyles.kFontGrey14w5),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                ),

                SizedBox(
                  height: 10,
                ),

                ///ORDER DETAILS
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.order!.orderNumber!.capitalizeFirst!,
                        style: AppStyles.kFontDarkBlue14w5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        'Placed on'.tr +
                            ': ${CustomDate().formattedDateTime(widget.order!.createdAt)}',
                        style: AppStyles.kFontGrey12w5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      widget.order!.isConfirmed == 1
                          ? InkWell(
                              onTap: () async {
                                List<OrderProductElement> products = [];

                                widget.order!.packages!.forEach((element) {
                                  products.addAll(element.products!);
                                });
                                Get.to(() => OrderToReturn(
                                      products: products,
                                      orderId: widget.order!.id,
                                    ));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                width: 122,
                                height: 32,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    border: Border.all(
                                        color: AppStyles.greyColorDark)),
                                child: Text('Open Dispute'.tr,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.kFontGrey14w5),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Subtotal'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${currencyController.appCurrency.value} ${(widget.order!.subTotal * currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${currencyController.appCurrency.value} ${(widget.order!.shippingTotal * currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Saving'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${currencyController.appCurrency.value} ${(widget.order!.discountTotal * currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'TAX/GST Amount'.tr,
                              style: AppStyles.kFontGrey12w5,
                            ),
                            Text(
                              '${currencyController.appCurrency.value} ${(widget.order!.taxAmount! * currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontBlack14w5,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Grand total'.tr + ': ',
                              style: AppStyles.kFontBlack14w5.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '${currencyController.appCurrency.value} ${(widget.order!.grandTotal! * currencyController.conversionRate.value).toStringAsFixed(2)}',
                              style: AppStyles.kFontDarkBlue14w5.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Paid by'.tr,
                              style: AppStyles.kFontGrey12w5
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              '${getPaidBy(widget.order!)}',
                              style: AppStyles.kFontBlack12w4
                                  .copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Text(
                'You might like'.tr,
                textAlign: TextAlign.center,
                style: AppStyles.appFont.copyWith(
                  color: AppStyles.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          LoadingMoreSliverList<ProductModel>(
            SliverListConfig<ProductModel>(
              padding: EdgeInsets.symmetric(horizontal: 8),
              indicatorBuilder: BuildIndicatorBuilder(
                source: source,
                isSliver: true,
                name: 'Recommended Products'.tr,
              ).buildIndicator,
              extendedListDelegate:
                  SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (BuildContext c, ProductModel prod, int index) {
                return GridViewProductWidget(
                  productModel: prod,
                );
              },
              sourceList: source!,
            ),
            key: const Key('homePageLoadMoreKey'),
          ),
        ],
      ),
    );
  }

  calculateGST(List<Package> packages) {
    var gstAmount = 0.0;
    packages!.forEach((element) {
      gstAmount = gstAmount +
          element.totalGst! * currencyController.conversionRate.value;
    });
    return gstAmount.toStringAsFixed(2);
  }

  getPaidBy(OrderData order) {
    if (order.paymentType == 1) {
      return 'Cash On Delivery';
    } else if (order.paymentType == 2) {
      return 'Wallet';
    } else if (order.paymentType == 3) {
      return 'PayPal';
    } else if (order.paymentType == 4) {
      return 'Stripe';
    } else if (order.paymentType == 5) {
      return 'PayStack';
    } else if (order.paymentType == 6) {
      return 'Razorpay';
    } else if (order.paymentType == 7) {
      return 'Bank Payment';
    } else if (order.paymentType == 8) {
      return 'Instamojo';
    } else if (order.paymentType == 9) {
      return 'PayTM';
    } else if (order.paymentType == 10) {
      return 'Midtrans';
    } else if (order.paymentType == 11) {
      return 'PayUMoney';
    } else if (order.paymentType == 12) {
      return 'JazzCash';
    } else if (order.paymentType == 13) {
      return 'Google Pay';
    } else if (order.paymentType == 14) {
      return 'FlutterWave';
    }
  }
}
