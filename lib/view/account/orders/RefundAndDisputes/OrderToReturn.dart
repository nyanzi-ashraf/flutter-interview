import 'dart:convert';

import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderProductElement.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/controller/order_refund_list_controller.dart';
import 'package:amazcart/model/CustomerAddress.dart';
import 'package:amazcart/model/NewModel/Order/OrderModelRefundReason.dart';
import 'package:amazcart/model/NewModel/ShippingMethodModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/settings/AddAddress.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:amazcart/widgets/CustomInputDecoration.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class OrderToReturn extends StatefulWidget {
  final List<OrderProductElement>? products;
  final int? orderId;

  OrderToReturn({this.products, this.orderId});

  @override
  _OrderToReturnState createState() => _OrderToReturnState();
}

class _OrderToReturnState extends State<OrderToReturn> {
  final OrderRefundListController controller =
      Get.put(OrderRefundListController());

  final AddressController addressController = Get.put(AddressController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final _formKey = GlobalKey<FormState>();
  // bool _isRadioSelected = false;
  // bool _isRadioSelected2 = false;

  // List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
  //   List<DropdownMenuItem<ListItem>> items = [];
  //   for (ListItem listItem in listItems) {
  //     items.add(
  //       DropdownMenuItem(
  //         child: Text(listItem.name),
  //         value: listItem,
  //       ),
  //     );
  //   }
  //   return items;
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        appBar: AppBarWidget(title: 'Return Request'),
        body: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Text(
                'Select Products you want to return',
                style: AppStyles.kFontGrey14w5,
              ),
            ),
            //SHIP TO
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
              child: Container(
                // padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xffDADADA),
                  ),
                  shape: BoxShape.rectangle,
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: 2,
                          );
                        },
                        itemCount: widget.products!.length,
                        itemBuilder: (context, productIndex) {
                          OrderProductElement product =
                              widget.products![productIndex];
                          if (widget.products![productIndex].type ==
                              ProductType.GIFT_CARD) {
                            return GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.only(left: 20, top: 5),
                                decoration: BoxDecoration(
                                  color: AppStyles.appBackgroundColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
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
                                                child: Image.network(
                                                  AppConfig.assetPath +
                                                      '/' +
                                                      product.giftCard!
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
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    product.giftCard!.name!,
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
                                                                .start,
                                                        children: [
                                                          Text(
                                                            '${(product!.price * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                                            style: AppStyles
                                                                .kFontPink15w5,
                                                          ),
                                                        ],
                                                      ),
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
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return ProductsCheckBox(
                              index: productIndex,
                              product: product,
                              orderId: widget.orderId!,
                              packageId: product!.packageId,
                            );
                          }
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    ListView(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        /// COMMENTS
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Comments (Optional)',
                            style: AppStyles.kFontGrey12w5,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffF6FAFC),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: TextFormField(
                              controller: controller.refundCommentController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                hintText: 'Write your comment....',
                                hintMaxLines: 3,
                                hintStyle: AppStyles.kFontBlack14w5,
                              ),
                              keyboardType: TextInputType.text,
                              style: AppStyles.kFontBlack14w5,
                              maxLines: 4,
                              validator: (value) {
                                if (value!.length == 0) {
                                  return 'Please Type something...';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),

                        /// Select Shipping
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: Text(
                            'Select a Shipment Method',
                            style: AppStyles.kFontGrey12w5,
                          ),
                        ),
                        Obx(() {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    controller.isCourier(true);
                                    controller.isSelectedShipping(true);
                                    controller.shippingWay.value = 'courier';
                                  },
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: controller.isCourier.value == true
                                          ? AppStyles.lightPinkColor
                                          : AppStyles.appBackgroundColor,
                                      border: Border.all(
                                        color: AppStyles.textFieldFillColor,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Courier Pick Up',
                                          style: AppStyles.kFontBlack15w4,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Select Pickup Address',
                                          style: AppStyles.kFontGrey12w5,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Pickup Method',
                                          style: AppStyles.kFontGrey12w5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(child: Container()),
                                InkWell(
                                  onTap: () {
                                    controller.isCourier(false);
                                    controller.isSelectedShipping(true);
                                    controller.shippingWay.value = 'drop_off';
                                  },
                                  child: Container(
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: controller.isCourier.value == false
                                          ? AppStyles.lightPinkColor
                                          : AppStyles.appBackgroundColor,
                                      border: Border.all(
                                        color: AppStyles.textFieldFillColor,
                                      ),
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Drop off',
                                          style: AppStyles.kFontBlack15w4,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Type in Drop off Address',
                                          style: AppStyles.kFontGrey12w5,
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        Text(
                                          'Select Drop off',
                                          style: AppStyles.kFontGrey12w5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                        SizedBox(
                          height: 15,
                        ),

                        ///Pickup or Drop off Address
                        Obx(() {
                          return controller.isCourier.value
                              ? Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Obx(() {
                                    if (addressController.isLoading.value) {
                                      return CupertinoActivityIndicator();
                                    } else {
                                      if (addressController.addressCount.value >
                                          0) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            color: controller.isCourier.value ==
                                                    false
                                                ? AppStyles.lightPinkColor
                                                : AppStyles.appBackgroundColor,
                                            border: Border.all(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Pickup Address'.tr,
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              DropdownButton<Address>(
                                                elevation: 1,
                                                isExpanded: true,
                                                underline: Container(),
                                                value: addressController
                                                    .shippingAddress.value,
                                                items: addressController
                                                    .address.value!.addresses!
                                                    .map((e) {
                                                  return DropdownMenuItem<
                                                      Address>(
                                                    child: Text(
                                                      '${e.address} - (${e.phone})',
                                                      maxLines: 2,
                                                    ),
                                                    value: e,
                                                  );
                                                }).toList(),
                                                onChanged: (Address? value) {
                                                  addressController
                                                      .shippingAddress
                                                      .value = value!;
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                        // return Container(
                                        //   padding: EdgeInsets.symmetric(
                                        //       horizontal: 10),
                                        //   child: Column(
                                        //     children: [
                                        //       ListTile(
                                        //         contentPadding: EdgeInsets.zero,
                                        //         dense: true,
                                        //         title: Column(
                                        //           crossAxisAlignment:
                                        //               CrossAxisAlignment.start,
                                        //           children: [
                                        //             Text(
                                        //               'Pickup Address'
                                        //                   .tr
                                        //                   .toUpperCase(),
                                        //               style: AppStyles
                                        //                   .kFontBlack14w5
                                        //                   .copyWith(
                                        //                 fontWeight:
                                        //                     FontWeight.w500,
                                        //               ),
                                        //             ),
                                        //             SizedBox(
                                        //               height: 2,
                                        //             ),
                                        //             RichText(
                                        //               text: TextSpan(
                                        //                 text:
                                        //                     'Address'.tr + ': ',
                                        //                 style: AppStyles
                                        //                     .kFontGrey14w5
                                        //                     .copyWith(
                                        //                   color: AppStyles
                                        //                       .darkBlueColor,
                                        //                   fontSize: ScreenUtil()
                                        //                       .setSp(13),
                                        //                 ),
                                        //                 children: <TextSpan>[
                                        //                   TextSpan(
                                        //                     text:
                                        //                         '${addressController.shippingAddress.value!.address}',
                                        //                     style: AppStyles
                                        //                         .kFontGrey14w5
                                        //                         .copyWith(
                                        //                       fontSize:
                                        //                           ScreenUtil()
                                        //                               .setSp(
                                        //                                   13),
                                        //                     ),
                                        //                   ),
                                        //                 ],
                                        //               ),
                                        //             ),
                                        //           ],
                                        //         ),
                                        //         trailing: InkWell(
                                        //           onTap: () {
                                        //             Get.to(() => AddressBook());
                                        //           },
                                        //           child: Container(
                                        //             child: Text('Change'.tr,
                                        //                 style: AppStyles
                                        //                     .kFontPink15w5),
                                        //           ),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // );
                                      } else {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: InkWell(
                                            onTap: () {
                                              Get.to(() => AddAddress());
                                            },
                                            child: DottedBorder(
                                              color: AppStyles.lightBlueColor,
                                              strokeWidth: 1,
                                              borderType: BorderType.RRect,
                                              radius: Radius.circular(5),
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Color(0xffEDF3FA),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(12),
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .add_circle_outline_rounded,
                                                      color: AppStyles
                                                          .lightBlueColor,
                                                      size: 22,
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      'Add Address'.tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: AppStyles.appFont
                                                          .copyWith(
                                                        color: AppStyles
                                                            .lightBlueColor,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  }),
                                )
                              : Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Color(0xffF6FAFC),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    child: TextFormField(
                                      controller:
                                          controller.dropOffAddressController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppStyles.textFieldFillColor,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppStyles.textFieldFillColor,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: AppStyles.textFieldFillColor,
                                          ),
                                        ),
                                        hintText: 'Drop off Address...',
                                        hintMaxLines: 2,
                                        hintStyle: AppStyles.kFontBlack14w5,
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: AppStyles.kFontBlack14w5,
                                      maxLines: 2,
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return 'Please Type something...';
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                );
                        }),
                        SizedBox(
                          height: 10,
                        ),

                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Obx(() {
                            return controller.isCourier.value
                                ? Text(
                                    'Select Courier Pick Up Information',
                                    style: AppStyles.kFontGrey12w5,
                                  )
                                : Text(
                                    'Select Drop Off Information',
                                    style: AppStyles.kFontGrey12w5,
                                  );
                          }),
                        ),

                        ///COURIER INFO
                        // Obx(() {
                        //   return Column(
                        //     children: [
                        //       RadioListTile(
                        //         dense: true,
                        //         contentPadding: EdgeInsets.zero,
                        //         activeColor: AppStyles.pinkColor,
                        //         title: Text(
                        //           'FREE SHIPPING',
                        //           style: AppStyles.kFontGrey12w4,
                        //         ),
                        //         value: SelectCourierOption.three,
                        //         groupValue: controller.selectedCourier.value,
                        //         onChanged: (SelectCourierOption value) {
                        //           if (controller.isCourier.value == true) {
                        //             controller.couriers.value = 3;
                        //           } else {
                        //             controller.dropOffCouriers.value = 3;
                        //           }
                        //           controller.selectedCourier.value = value;
                        //           print({
                        //             'couriers': controller.couriers.value,
                        //             'drop_off_couriers':
                        //                 controller.dropOffCouriers.value,
                        //           });
                        //         },
                        //       ),
                        //       RadioListTile(
                        //         dense: true,
                        //         activeColor: AppStyles.pinkColor,
                        //         contentPadding: EdgeInsets.zero,
                        //         title: Text(
                        //           'EMAIL DELIVERY (WITHIN 24 HOURS)',
                        //           style: AppStyles.kFontGrey12w4,
                        //         ),
                        //         value: SelectCourierOption.one,
                        //         groupValue: controller.selectedCourier.value,
                        //         onChanged: (SelectCourierOption value) {
                        //           if (controller.isCourier.value == true) {
                        //             controller.couriers.value = 1;
                        //           } else {
                        //             controller.dropOffCouriers.value = 1;
                        //           }
                        //           controller.selectedCourier.value = value;
                        //           print({
                        //             'couriers': controller.couriers.value,
                        //             'drop_off_couriers':
                        //                 controller.dropOffCouriers.value,
                        //           });
                        //         },
                        //       ),
                        //       RadioListTile(
                        //         dense: true,
                        //         activeColor: AppStyles.pinkColor,
                        //         contentPadding: EdgeInsets.zero,
                        //         title: Text(
                        //           'FLAT RATE',
                        //           style: AppStyles.kFontGrey12w4,
                        //         ),
                        //         value: SelectCourierOption.two,
                        //         groupValue: controller.selectedCourier.value,
                        //         onChanged: (SelectCourierOption value) {
                        //           if (controller.isCourier.value == true) {
                        //             controller.couriers.value = 2;
                        //           } else {
                        //             controller.dropOffCouriers.value = 2;
                        //           }
                        //           controller.selectedCourier.value = value;
                        //
                        //           print({
                        //             'couriers': controller.couriers.value,
                        //             'drop_off_couriers':
                        //                 controller.dropOffCouriers.value,
                        //           });
                        //         },
                        //       ),
                        //     ],
                        //   );
                        // }),

                        Obx(() {
                          if (controller.isLoading.value) {
                            return Container();
                          }
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: controller.shippingMethods
                                .map((x) => RadioListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      activeColor: AppStyles.pinkColor,
                                      value: x,
                                      groupValue:
                                          controller.shippingFirst.value,
                                      onChanged: (Shipping? ind) {
                                        if (controller.isCourier.value ==
                                            true) {
                                          controller.couriers.value = ind!.id!;
                                        } else {
                                          controller.dropOffCouriers.value =
                                              ind!.id!;
                                        }
                                        controller.shippingFirst.value = ind;
                                        print({
                                          'couriers': controller.couriers.value,
                                          'drop_off_couriers':
                                              controller.dropOffCouriers.value,
                                        });
                                      },
                                      title: new Text(
                                        x.methodName!,
                                      ),
                                    ))
                                .toList(),
                          );
                        }),

                        SizedBox(
                          height: 10,
                        ),

                        ///REFUND TO
                        InkWell(
                          onTap: () {
                            Get.bottomSheet(
                              SingleChildScrollView(
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        width: 40,
                                        height: 5,
                                        decoration: BoxDecoration(
                                          color: Color(0xffDADADA),
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Refund Method',
                                        style: AppStyles.kFontBlack15w4,
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.moneyGetMethod.value =
                                              'Bank Transfer';
                                          Get.back();
                                          Get.bottomSheet(
                                            Container(
                                              child: Container(
                                                color: Color.fromRGBO(
                                                    0, 0, 0, 0.001),
                                                child: DraggableScrollableSheet(
                                                  initialChildSize: 0.7,
                                                  minChildSize: 0.6,
                                                  maxChildSize: 1,
                                                  builder:
                                                      (_, scrollController2) {
                                                    return GestureDetector(
                                                      onTap: () {},
                                                      child: Container(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 10,
                                                                vertical: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.only(
                                                            topLeft: const Radius
                                                                .circular(25.0),
                                                            topRight: const Radius
                                                                .circular(25.0),
                                                          ),
                                                        ),
                                                        child: Form(
                                                          key: _formKey,
                                                          child: ListView(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        15),
                                                            controller:
                                                                scrollController2,
                                                            children: [
                                                              Center(
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    width: 40,
                                                                    height: 5,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Color(
                                                                          0xffDADADA),
                                                                      borderRadius:
                                                                          BorderRadius
                                                                              .all(
                                                                        Radius.circular(
                                                                            30),
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
                                                                  'Bank Transfer',
                                                                  style: AppStyles
                                                                      .kFontBlack15w4,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                              Obx(() {
                                                                return Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      'Bank Name',
                                                                      style: AppStyles
                                                                          .kFontGrey12w5,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffF6FAFC),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15))),
                                                                      child:
                                                                          TextFormField(
                                                                        controller: controller
                                                                            .bankNameController
                                                                            .value,
                                                                        decoration:
                                                                            CustomInputDecoration.customInput,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        style: AppStyles
                                                                            .kFontBlack14w5,
                                                                        maxLines:
                                                                            1,
                                                                        validator:
                                                                            (value) {
                                                                          if (value!.length ==
                                                                              0) {
                                                                            return 'Please Type Bank name';
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      'Branch Name',
                                                                      style: AppStyles
                                                                          .kFontGrey12w5,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffF6FAFC),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15))),
                                                                      child:
                                                                          TextFormField(
                                                                        controller: controller
                                                                            .branchNameController
                                                                            .value,
                                                                        decoration:
                                                                            CustomInputDecoration.customInput,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        style: AppStyles
                                                                            .kFontBlack14w5,
                                                                        maxLines:
                                                                            1,
                                                                        validator:
                                                                            (value) {
                                                                          if (value!.length ==
                                                                              0) {
                                                                            return 'Please Type Branch Name';
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      'Account Holder Name',
                                                                      style: AppStyles
                                                                          .kFontGrey12w5,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffF6FAFC),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15))),
                                                                      child:
                                                                          TextFormField(
                                                                        controller: controller
                                                                            .accountNameController
                                                                            .value,
                                                                        decoration:
                                                                            CustomInputDecoration.customInput,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        style: AppStyles
                                                                            .kFontBlack14w5,
                                                                        maxLines:
                                                                            1,
                                                                        validator:
                                                                            (value) {
                                                                          if (value!.length ==
                                                                              0) {
                                                                            return 'Please Type Account holder name';
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Text(
                                                                      'Account Number',
                                                                      style: AppStyles
                                                                          .kFontGrey12w5,
                                                                    ),
                                                                    SizedBox(
                                                                      height: 2,
                                                                    ),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Color(
                                                                              0xffF6FAFC),
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(15))),
                                                                      child:
                                                                          TextFormField(
                                                                        controller: controller
                                                                            .accountNumberController
                                                                            .value,
                                                                        decoration:
                                                                            CustomInputDecoration.customInput,
                                                                        keyboardType:
                                                                            TextInputType.text,
                                                                        style: AppStyles
                                                                            .kFontBlack14w5,
                                                                        maxLines:
                                                                            1,
                                                                        validator:
                                                                            (value) {
                                                                          if (value!.length ==
                                                                              0) {
                                                                            return 'Please Type Account Number';
                                                                          } else {
                                                                            return null;
                                                                          }
                                                                        },
                                                                      ),
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              ButtonWidget(
                                                                buttonText:
                                                                    'Confirm',
                                                                onTap: () {
                                                                  if (_formKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    Get.back();
                                                                    controller
                                                                        .bankNameController
                                                                        .refresh();
                                                                    controller
                                                                        .branchNameController
                                                                        .refresh();
                                                                    controller
                                                                        .accountNameController
                                                                        .refresh();
                                                                    controller
                                                                        .accountNumberController
                                                                        .refresh();
                                                                  }
                                                                },
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            30,
                                                                        vertical:
                                                                            20),
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
                                            isScrollControlled: true,
                                            backgroundColor: Colors.transparent,
                                            persistent: true,
                                            isDismissible: false,
                                          );
                                        },
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.comment_bank,
                                            color: AppStyles.pinkColor,
                                          ),
                                          title: Text(
                                            'Bank Transfer',
                                            style: AppStyles.kFontBlack14w5,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.moneyGetMethod.value =
                                              'Wallet';
                                          controller.bankNameController.value
                                              .clear();
                                          controller.branchNameController.value
                                              .clear();
                                          controller.accountNameController.value
                                              .clear();
                                          controller
                                              .accountNumberController.value
                                              .clear();
                                          Get.back();
                                        },
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.account_balance_wallet,
                                            color: AppStyles.pinkColor,
                                          ),
                                          title: Text(
                                            'Wallet',
                                            style: AppStyles.kFontBlack14w5,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                              ),
                              backgroundColor: Colors.white,
                              isDismissible: false,
                            );
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Refund to',
                                  style: AppStyles.kFontGrey12w5,
                                ),
                                Obx(() {
                                  return Row(
                                    children: [
                                      Text(
                                        '${controller.moneyGetMethod.value}',
                                        style: AppStyles.kFontPink15w5,
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14,
                                        color: AppStyles.pinkColor,
                                      )
                                    ],
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),

                        Obx(() {
                          return controller.moneyGetMethod.value ==
                                  'Bank Transfer'
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Bank Name: ',
                                              style: AppStyles.kFontBlack12w4,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${controller.bankNameController.value!.text}',
                                              style: AppStyles.kFontGrey12w5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Branch Name: ',
                                              style: AppStyles.kFontBlack12w4,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${controller.branchNameController.value!.text}',
                                              style: AppStyles.kFontGrey12w5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Account Holder Name: ',
                                              style: AppStyles.kFontBlack12w4,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${controller.accountNameController.value!.text}',
                                              style: AppStyles.kFontGrey12w5,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Account Number: ',
                                              style: AppStyles.kFontBlack12w4,
                                            ),
                                            TextSpan(
                                              text:
                                                  '${controller.accountNumberController.value!.text}',
                                              style: AppStyles.kFontGrey12w5,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container();
                        }),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text:
                                        'By submitting this form, I accept the ',
                                    style: AppStyles.kFontGrey12w5),
                                TextSpan(
                                  text: 'Return Policy',
                                  style: AppStyles.kFontGrey12w5.copyWith(
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () async {
                                      if (!await launch(
                                          AppConfig.privacyPolicyUrl))
                                        throw 'Could not launch ${AppConfig.privacyPolicyUrl}';
                                    },
                                ),
                                TextSpan(
                                  text: ' of Amazcart',
                                  style: AppStyles.kFontGrey12w5,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: PinkButtonWidget(
                            height: 50,
                            btnOnTap: () {
                              if (!controller.isCourier.value) {
                                if (controller.dropOffAddressController.text ==
                                        "" ||
                                    controller.dropOffAddressController.text ==
                                        null) {
                                  SnackBars().snackBarWarning(
                                      'Type in Drop off Address');
                                } else {
                                  if (controller.moneyGetMethod.value ==
                                      'Bank Transfer') {
                                    if (controller.bankNameController.value
                                                .text ==
                                            '' ||
                                        controller
                                                .branchNameController.value!.text ==
                                            '' ||
                                        controller.accountNameController.value
                                                .text ==
                                            '' ||
                                        controller.accountNumberController.value
                                                .text ==
                                            '') {
                                      SnackBars().snackBarWarning(
                                          'Please type in your complete Bank Account Information');
                                    } else {
                                      controller.saveData();
                                    }
                                  } else {
                                    controller.moneyGetMethod.value = 'Wallet';
                                    controller.saveData();
                                  }
                                }
                              } else {
                                if (controller.moneyGetMethod.value ==
                                    'Bank Transfer') {
                                  if (controller.bankNameController.value!.text == '' ||
                                      controller.branchNameController.value!
                                              .text ==
                                          '' ||
                                      controller.accountNameController.value
                                              .text ==
                                          '' ||
                                      controller.accountNumberController.value
                                              .text ==
                                          '') {
                                    SnackBars().snackBarWarning(
                                        'Please type in your complete Bank Account Information');
                                  } else {
                                    controller.saveData();
                                  }
                                } else {
                                  controller.moneyGetMethod.value = 'Wallet';
                                  controller.saveData();
                                  controller.saveData();
                                }
                              }
                            },
                            btnText: 'Submit',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

class ProductsCheckBox extends StatefulWidget {
  final int? packageId;
  final int? index;
  final int? orderId;
  final OrderProductElement? product;

  ProductsCheckBox({this.product, this.packageId, this.index, this.orderId});

  @override
  _ProductsCheckBoxState createState() => _ProductsCheckBoxState();
}

class _ProductsCheckBoxState extends State<ProductsCheckBox> {
  final OrderRefundListController controller =
      Get.put(OrderRefundListController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  bool _isChecked = false;
  int quantity = 1;

  void initState() {
    super.initState();
  }

  Future<OrderRefundReasonModel> fetchRefundReasons() async {
    var jsonString;
    try {
      Uri userData = Uri.parse(URLs.REFUND_REASONS_LIST);
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      jsonString = jsonDecode(response.body);
    } catch (e) {
      print(e);
    }
    return OrderRefundReasonModel.fromJson(jsonString);
  }

  int firstReasonId = 0;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      checkColor: Colors.white,
      activeColor: AppStyles.pinkColor,
      tileColor: Colors.white,
      dense: true,
      isThreeLine: true,
      selectedTileColor: Colors.black,
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                child: Container(
                    height: 80,
                    width: 80,
                    child: Image.network(
                      widget.product!.sellerProductSku!.sku!.variantImage !=
                              null
                          ? '${AppConfig.assetPath}/${widget.product!.sellerProductSku!.sku!.variantImage}'
                          : '${AppConfig.assetPath}/${widget.product!.sellerProductSku!.product!.product!.thumbnailImageSource}',
                      fit: BoxFit.contain,
                    )),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product!.sellerProductSku!.product!.product!
                            .productName!,
                        style: AppStyles.kFontBlack14w5,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    '${currencyController.appCurrency.value} ${(widget.product!.price * currencyController.conversionRate.value).toStringAsFixed(2)}',
                                    style: AppStyles.kFontPink15w5,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    '(${widget.product!.qty}x)',
                                    style: AppStyles.kFontBlack14w5,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      _isChecked
                          ? Row(
                              children: [
                                InkWell(
                                    child: Icon(
                                      Icons.remove,
                                      color: AppStyles.greyColorDark,
                                      size: 20,
                                    ),
                                    onTap: () async {
                                      print('minus');

                                      if (_isChecked) {
                                        if (quantity <= widget.product!.qty) {
                                          SnackBars().snackBarError(
                                              'Can\'t remove anymore');
                                        } else {
                                          setState(() {
                                            quantity--;
                                          });
                                        }
                                      } else {
                                        SnackBars().snackBarWarning(
                                            'Please select the product first!');
                                      }
                                    }),
                                Container(
                                  width: 40,
                                  height: 30,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: AppStyles.lightBlueColorAlt,
                                    border: Border.all(
                                      color: AppStyles.greyBorder,
                                    ),
                                  ),
                                  child: Text('${quantity.toString()}'),
                                ),
                                InkWell(
                                    child: Icon(
                                      Icons.add,
                                      color: AppStyles.greyColorDark,
                                      size: 20,
                                    ),
                                    onTap: () async {
                                      print('plus');
                                      if (_isChecked) {
                                        if (quantity >= widget.product!.qty) {
                                          SnackBars().snackBarWarning(
                                              'Can\'t add anymore');
                                        } else {
                                          setState(() {
                                            quantity++;
                                          });
                                        }
                                      } else {
                                        SnackBars().snackBarWarning(
                                            'Please select the product first!');
                                      }
                                    }),
                              ],
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      subtitle: _isChecked
          ? ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Text(
                    'Select a reason for returning ${widget.product!.sellerProductSku!.product!.product!.productName}',
                    style: AppStyles.kFontGrey12w5,
                  ),
                ),
                FutureBuilder<OrderRefundReasonModel>(
                  future: fetchRefundReasons(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: AppStyles.appBackgroundColor,
                              border: Border.all(
                                  color: AppStyles.textFieldFillColor)),
                          child: RefundDropDown(
                            reasons: snapshot.data!.reasons!,
                            reasonValue: snapshot.data!.reasons!.last,
                            reasonIdForMap:
                                'reason_${widget.product!.productSkuId}',
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: AppStyles.appBackgroundColor,
                              border: Border.all(
                                  color: AppStyles.textFieldFillColor)),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text('Loading...'),
                          ),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          : Container(),
      value: _isChecked,
      tristate: false,
      onChanged: (val) {
        setState(() {
          _isChecked = val!;
        });
        if (_isChecked == true) {
          print('selected');
          // print({
          //   'package_id': widget.packageId,
          //   'product_id': widget.product!.productSkuId,
          //   'seller_id': widget.product!.sellerProductSku!.userId,
          //   'amount': widget.product!.price
          // });
          // print(
          //     '${widget.packageId}-${widget.product!.productSkuId}-${widget.product!.sellerProductSku!.userId}-${widget.product!.price}');

          controller.addValueToMap(controller.dataMap,
              'qty_${widget.product!.productSkuId}', '$quantity');

          controller.addValueToMap(
              controller.dataMap, 'reason_${widget.product!.productSkuId}', 1);

          controller.addValueToMap(
              controller.dataMap, 'order_id', '${widget.orderId}');

          controller.productIds.add(
              '${widget.packageId}-${widget.product!.productSkuId}-${widget.product!.sellerProductSku!.userId}-${widget.product!.price}');

          // controller.addValueToMap(
          //     controller.dataMap,
          //     'product_ids[${widget.index}]',
          //     '${widget.packageId}-${widget.product!.productSkuId}-${widget.product!.sellerProductSku!.userId}-${widget.product!.price}');

          // print('ADD ${controller.dataMap}');
        } else {
          print('not selected');

          controller.removeValueToMap(
              controller.dataMap, 'qty_${widget.product!.productSkuId}');

          // controller.removeValueToMap(
          //     controller.dataMap, 'product_ids[${widget.index}]');

          controller.productIds.remove(
              '${widget.packageId}-${widget.product!.productSkuId}-${widget.product!.sellerProductSku!.userId}-${widget.product!.price}');

          controller.removeValueToMap(
              controller.dataMap, 'reason_${widget.product!.productSkuId}');

          // controller.removeValueToMap(controller.dataMap, 'order_id');

          // print('REMOVE ${controller.dataMap}');
        }
        print(_isChecked);
      },
    );
  }
}

// ignore: must_be_immutable
class RefundDropDown extends StatefulWidget {
  RefundReason? reasonValue;
  final String? reasonIdForMap;
  final List<RefundReason>? reasons;

  RefundDropDown({this.reasonValue, this.reasons, this.reasonIdForMap});

  @override
  _RefundDropDownState createState() => _RefundDropDownState();
}

class _RefundDropDownState extends State<RefundDropDown> {
  final OrderRefundListController controller =
      Get.put(OrderRefundListController());

  @override
  Widget build(BuildContext context) {
    return DropdownButton<RefundReason>(
      elevation: 1,
      isExpanded: true,
      underline: Container(),
      value: widget.reasonValue,
      items: widget.reasons!.map((e) {
        // reasonValue = widget.reasonValue;
        return DropdownMenuItem<RefundReason>(
          child: Text('${e.reason}'),
          value: e,
        );
      }).toList(),
      onChanged: (RefundReason? value) {
        setState(() {
          widget.reasonValue = value;
        });
        controller.addValueToMap(
            controller.dataMap, '${widget.reasonIdForMap}', '${value!.id}');
        print(controller.dataMap);
      },
    );
  }
}

class ListItem {
  int value;
  String name;

  ListItem(this.value, this.name);
}

class LabeledRadio extends StatelessWidget {
  const LabeledRadio({
    Key? key,
    @required this.label,
    @required this.padding,
    @required this.groupValue,
    @required this.value,
    @required this.onChanged,
    this.image,
    this.hasImage,
  }) : super(key: key);

  final String? label;
  final EdgeInsets? padding;
  final bool? groupValue;
  final bool? value;
  final Function? onChanged;
  final Widget? image;
  final bool? hasImage;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged!(value);
        }
      },
      child: Padding(
        padding: padding!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Radio<bool>(
              groupValue: groupValue,
              value: value!,
              onChanged: (bool? newValue) {
                onChanged!(newValue);
              },
              activeColor: AppStyles.darkBlueColor,
            ),
            Text(label!),
            Expanded(
              child: Container(),
            ),
            hasImage! ? image! : Container(),
          ],
        ),
      ),
    );
  }
}
