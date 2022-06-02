import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/Settings/AddAddress.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'EditAddress.dart';

class AddressBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AddressController controller = Get.put(AddressController());
    return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        appBar: AppBarWidget(
          title: 'My Address'.tr,
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: ListView(
            children: [
              SizedBox(
                height: 40,
              ),
              InkWell(
                onTap: () {
                  Get.to(() => AddAddress());
                },
                child: DottedBorder(
                  color: AppStyles.lightBlueColor,
                  strokeWidth: 1,
                  borderType: BorderType.RRect,
                  radius: Radius.circular(12),
                  child: Container(
                    alignment: Alignment.center,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(0xffEDF3FA),
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline_rounded,
                          color: AppStyles.lightBlueColor,
                          size: 22,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Add Address'.tr,
                          textAlign: TextAlign.center,
                          style: AppStyles.appFont.copyWith(
                            color: AppStyles.lightBlueColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(),
              Obx(() {
                if (controller.isLoading.value) {
                  return Center(
                    child: Container(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                } else {
                  if (controller.address.value.addresses == null ||
                      controller.address.value.addresses!.length == 0) {
                    return Container();
                  } else {
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: controller.address.value.addresses!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(2),
                              child: Image.asset(
                                'assets/images/location_ico.png',
                                color: AppStyles.darkBlueColor,
                                width: 15,
                                height: 15,
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.address.value.addresses![index]!
                                        .name!.capitalizeFirst!,
                                    textAlign: TextAlign.left,
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Address'.tr + ': ',
                                          style: AppStyles.appFont.copyWith(
                                            color: AppStyles.darkBlueColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller.address.value
                                                  .addresses![index].address ??
                                              "",
                                          style: AppStyles.appFont.copyWith(
                                            color: AppStyles.greyColorDark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Region'.tr + ': ',
                                          style: AppStyles.appFont.copyWith(
                                            color: AppStyles.darkBlueColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller
                                                      .address
                                                      .value
                                                      .addresses![index]
                                                      .getCity !=
                                                  null
                                              ? "${controller.address.value.addresses![index].getCity!.name}, "
                                              : "",
                                          style: AppStyles.appFont.copyWith(
                                            color: AppStyles.greyColorDark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller
                                                      .address
                                                      .value
                                                      .addresses![index]
                                                      .getState !=
                                                  null
                                              ? "${controller.address.value.addresses![index].getState!.name}, "
                                              : "",
                                          style: AppStyles.appFont.copyWith(
                                            color: AppStyles.greyColorDark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: controller
                                                      .address
                                                      .value
                                                      .addresses![index]
                                                      .getCountry !=
                                                  null
                                              ? "${controller.address.value.addresses![index].getCountry!.name}"
                                              : "",
                                          style: AppStyles.appFont.copyWith(
                                            color: AppStyles.greyColorDark,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    'Phone'.tr +
                                            ": " +
                                            controller.address.value
                                                .addresses![index].phone! ??
                                        "",
                                    textAlign: TextAlign.left,
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: controller
                                                    .address
                                                    .value
                                                    .addresses![index]
                                                    .isBillingDefault ==
                                                1
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Default Billing'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  await controller
                                                      .setDefaultBilling(
                                                          controller
                                                              .address
                                                              .value
                                                              .addresses![index]
                                                              .id!)
                                                      .then((value) {
                                                    if (value) {
                                                      SnackBars().snackBarSuccess(
                                                          'Set to default billing address'
                                                              .tr);
                                                    } else {
                                                      SnackBars().snackBarError(
                                                          'Address not found'
                                                              .tr);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      border: Border.all(
                                                          color: AppStyles
                                                              .lightBlueColor)),
                                                  child: Text(
                                                    'Set Default Billing'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Expanded(
                                        child: controller
                                                    .address
                                                    .value
                                                    .addresses![index]
                                                    .isShippingDefault ==
                                                1
                                            ? Row(
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                    size: 15,
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    'Default Shipping'.tr,
                                                    textAlign: TextAlign.start,
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : GestureDetector(
                                                onTap: () async {
                                                  await controller
                                                      .setDefaultShipping(
                                                          controller
                                                              .address
                                                              .value
                                                              .addresses![index]
                                                              .id!)
                                                      .then((value) {
                                                    if (value) {
                                                      SnackBars().snackBarSuccess(
                                                          'Set to default Shipping address'
                                                              .tr);
                                                    } else {
                                                      SnackBars().snackBarError(
                                                          'Address not found'
                                                              .tr);
                                                    }
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      border: Border.all(
                                                          color: AppStyles
                                                              .lightBlueColor)),
                                                  child: Text(
                                                    'Set Default Shipping'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: InkWell(
                                onTap: () {
                                  Get.to(() => EditAddress(controller
                                      .address.value.addresses![index]));
                                },
                                child: Text(
                                  'Edit'.tr,
                                  textAlign: TextAlign.center,
                                  style: AppStyles.appFont.copyWith(
                                    color: AppStyles.pinkColor,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              }),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ));
  }
}
