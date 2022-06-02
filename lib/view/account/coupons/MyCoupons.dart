// import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/account_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/my_coupon_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/account/coupons/CouponDetails.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';

class MyCoupons extends StatefulWidget {
  @override
  _MyCouponsState createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCoupons> {
  final MyCouponController couponController = Get.put(MyCouponController());

  final AccountController accountController = Get.put(AccountController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final _formKey = GlobalKey<FormState>();

  final TextEditingController couponCodeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        actions: [
          CartIconWidget(),
        ],
        title: Obx(
          () {
            if (couponController.isLoading.value) {
              return Text(
                'My Coupons'.tr,
                style: AppStyles.appFont.copyWith(
                  color: AppStyles.blackColor,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              );
            } else {
              if (couponController.myCoupons.value.coupons != null) {
                return Text(
                  'My Coupons'.tr +
                      " (${couponController.myCoupons.value.coupons!.length})",
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                return Text(
                  'My Coupons'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            }
          },
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (couponController.isLoading.value) {
          return Center(
            child: CustomLoadingWidget(),
          );
        } else {
          if (couponController.myCoupons.value.coupons == null ||
              couponController.myCoupons.value.coupons!.length == 0) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                    'No Coupons found'.tr,
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
        }
        return Container(
          color: AppStyles.appBackgroundColor,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            itemCount: couponController.myCoupons.value.coupons!.length,
            separatorBuilder: (context, index) {
              return Divider(
                height: 20,
              );
            },
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    actions: <Widget>[
                      Stack(
                        fit: StackFit.expand,
                        children: [
                          IconSlideAction(
                            caption: 'Delete'.tr,
                            color: Colors.red,
                            icon: Icons.delete_forever,
                            onTap: () async {
                              await couponController
                                  .deleteCoupon(couponController
                                      .myCoupons.value.coupons![index].id)
                                  .then((value) {
                                if (value.keys.first) {
                                  SnackBars().snackBarSuccess(
                                      value.values.toString().capitalizeFirst);
                                  couponController.myCoupons.value.coupons!
                                      .remove(couponController
                                          .myCoupons.value.coupons![index]);
                                } else {
                                  SnackBars().snackBarError(
                                      value.values.toString().capitalizeFirst);
                                }
                              });
                              setState(() {});
                            },
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              lineThickness: 4.0,
                              dashLength: 4.0,
                              dashColor: Colors.white,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              lineThickness: 4.0,
                              dashLength: 4.0,
                              dashColor: Colors.white,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ],
                    secondaryActions: <Widget>[
                      Stack(
                        fit: StackFit.expand,
                        children: [
                          IconSlideAction(
                            caption: 'Delete'.tr,
                            color: Colors.red,
                            icon: Icons.delete_forever,
                            onTap: () async {
                              await couponController
                                  .deleteCoupon(couponController
                                      .myCoupons.value.coupons![index].id)
                                  .then((value) {
                                if (value.keys.first) {
                                  SnackBars().snackBarSuccess(
                                      value.values.toString().capitalizeFirst);
                                  couponController.myCoupons.value.coupons!
                                      .remove(couponController
                                          .myCoupons.value.coupons![index]);
                                } else {
                                  SnackBars().snackBarError(
                                      value.values.toString().capitalizeFirst);
                                }
                              });
                              setState(() {});
                            },
                          ),
                          Align(
                            alignment: Alignment.topCenter,
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              lineThickness: 4.0,
                              dashLength: 4.0,
                              dashColor: Colors.white,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: DottedLine(
                              direction: Axis.horizontal,
                              lineLength: double.infinity,
                              lineThickness: 4.0,
                              dashLength: 4.0,
                              dashColor: Colors.white,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                            ),
                          ),
                        ],
                      ),
                    ],
                    child: Container(
                      height: 100,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Positioned.fill(
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.asset(
                                  'assets/images/voucher_bg.png',
                                  fit: BoxFit.fill,
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 4.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.white,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: DottedLine(
                                    direction: Axis.horizontal,
                                    lineLength: double.infinity,
                                    lineThickness: 4.0,
                                    dashLength: 4.0,
                                    dashColor: Colors.white,
                                    dashGapLength: 4.0,
                                    dashGapColor: Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 15,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  couponController.myCoupons.value
                                      .coupons![index].coupon!.title!,
                                  style: AppStyles.appFont.copyWith(
                                    color: AppStyles.blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6.0),
                                          child: couponController
                                                      .myCoupons
                                                      .value
                                                      .coupons![index]
                                                      .coupon!
                                                      .discountType ==
                                                  0
                                              ? Text(
                                                  '%',
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: AppStyles.pinkColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )
                                              : Text(
                                                  '${currencyController.appCurrency.value}',
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: AppStyles.pinkColor,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                        ),
                                        couponController
                                                    .myCoupons
                                                    .value
                                                    .coupons![index]
                                                    .coupon!
                                                    .discountType ==
                                                0
                                            ? Text(
                                                '${couponController.myCoupons.value.coupons![index].coupon!.discount}',
                                                style:
                                                    AppStyles.appFont.copyWith(
                                                  color: AppStyles.pinkColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Text(
                                                double.parse((currencyController
                                                                .conversionRate
                                                                .value *
                                                            couponController
                                                                .myCoupons
                                                                .value
                                                                .coupons![index]
                                                                .coupon!
                                                                .discount)
                                                        .toString())
                                                    .toStringAsFixed(2),
                                                style:
                                                    AppStyles.appFont.copyWith(
                                                  color: AppStyles.pinkColor,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.only(bottom: 4.0, left: 2),
                                      child: Text(
                                        'OFF'.tr,
                                        style: AppStyles.appFont.copyWith(
                                          color: AppStyles.pinkColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 20,
                            bottom: 15,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        PinkButtonWidget(
                                          width: 83,
                                          height: 32,
                                          btnOnTap: () {
                                            Get.to(
                                              () => CouponDetails(
                                                coupon: couponController
                                                    .myCoupons
                                                    .value
                                                    .coupons![index]
                                                    .coupon,
                                              ),
                                            );
                                          },
                                          btnText: 'Details'.tr,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          'Validity'.tr +
                                              ': ${CustomDate().formattedDate(couponController.myCoupons.value.coupons![index].coupon!.startDate)} - ${CustomDate().formattedDate(couponController.myCoupons.value.coupons![index].coupon!.endDate)}',
                                          style: AppStyles.appFont.copyWith(
                                            color: AppStyles.blackColor,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  couponController.myCoupons.value.coupons![index].coupon!
                              .couponType ==
                          2
                      ? Column(
                          children: [
                            SizedBox(height: 5),
                            couponController.myCoupons.value.coupons![index]
                                        .coupon!.minimumShopping !=
                                    null
                                ? Text(
                                    'Spend'.tr +
                                        ' ${double.parse((currencyController.conversionRate.value * couponController.myCoupons.value.coupons![index].coupon!.minimumShopping).toString()).toStringAsFixed(2)} ' +
                                        'get up-to'.tr +
                                        ' ${double.parse((currencyController.conversionRate.value * couponController.myCoupons.value.coupons![index].coupon!.maximumDiscount).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value} off',
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.pinkColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                : Container(),
                          ],
                        )
                      : couponController.myCoupons.value.coupons![index].coupon!
                                  .couponType ==
                              3
                          ? couponController.myCoupons.value.coupons![index]
                                      .coupon!.maximumDiscount !=
                                  null
                              ? Text(
                                  'Free Shipping up-to'.tr +
                                      ' ${double.parse((currencyController.conversionRate.value * couponController.myCoupons.value.coupons![index].coupon!.maximumDiscount).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                  style: AppStyles.appFont.copyWith(
                                    color: AppStyles.pinkColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Container()
                          : SizedBox(
                              height: 5,
                            ),
                ],
              );
            },
          ),
        );
      }),
      bottomNavigationBar: Container(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Get.bottomSheet(
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            'Add Coupon'.tr,
                            style: AppStyles.appFont.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Coupon Code'.tr,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                color: Color(0xffF6FAFC),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: TextFormField(
                              controller: couponCodeCtrl,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
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
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.close),
                                  onPressed: () {
                                    couponCodeCtrl.clear();
                                  },
                                ),
                                hintText: 'Enter Coupon Code'.tr,
                                hintMaxLines: 4,
                                hintStyle: AppStyles.appFont.copyWith(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                              validator: (value) {
                                if (value!.length == 0) {
                                  return 'Type Coupon code'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ButtonWidget(
                            buttonText: 'Add'.tr,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                await couponController
                                    .addCoupon(couponCodeCtrl.text);
                              }
                            },
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 20),
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
                );
              },
              child: Container(
                alignment: Alignment.center,
                width: 140,
                height: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(color: AppStyles.pinkColor)),
                child: Text(
                  'Add coupon'.tr,
                  textAlign: TextAlign.center,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.pinkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
