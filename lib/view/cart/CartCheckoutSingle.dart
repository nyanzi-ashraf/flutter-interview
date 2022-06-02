// import 'package:amazcart/AppConfig/app_config.dart';
// import 'package:amazcart/controller/address_book_controller.dart';
// import 'package:amazcart/controller/checkout_controller.dart';
// import 'package:amazcart/controller/currency_controller.dart';
// import 'package:amazcart/model/NewModel/Cart/MyCheckoutModel.dart';
// import 'package:amazcart/model/NewModel/Cart/FlatGst.dart';
// import 'package:amazcart/model/NewModel/Product/ProductType.dart';
// import 'package:amazcart/utils/styles.dart';
// import 'package:amazcart/view/cart/GatewaySelection.dart';
// import 'package:amazcart/view/settings/AddAddress.dart';
// import 'package:amazcart/view/settings/AddressBook.dart';
// import 'package:amazcart/widgets/AppBarWidget.dart';
// import 'package:amazcart/widgets/PinkButtonWidget.dart';
// import 'package:amazcart/widgets/custom_loading_widget.dart';
// import 'package:amazcart/widgets/snackbars.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:get/get.dart';

// class CartCheckoutSingle extends StatefulWidget {
//   @override
//   _CartCheckoutSingleState createState() => _CartCheckoutSingleState();
// }

// class _CartCheckoutSingleState extends State<CartCheckoutSingle> {
//   CheckoutController checkoutController;
//   final AddressController addressController = Get.put(AddressController());

//   final TextEditingController customerPhoneCtrl = TextEditingController();
//   final TextEditingController customerEmailCtrl = TextEditingController();

//   final CurrencyController currencyController = Get.put(CurrencyController());

//   // bool _isConfirm = false;
//   ScrollController _scrollController = ScrollController();
//   Map data = {};

//   var gstId = 0;
//   var gstShow = '';
//   var gstShowList = [];

//   @override
//   void initState() {
//     checkoutController = Get.put(CheckoutController());

//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     checkoutController.calculateDiscount();
//     return Scaffold(
//       backgroundColor: AppStyles.appBackgroundColor,
//       appBar: AppBarWidget(
//         title: 'Checkout',
//       ),
//       body: Scrollbar(
//         controller: _scrollController,
//         isAlwaysShown: true,
//         child: ListView(
//           controller: _scrollController,
//           shrinkWrap: true,
//           physics: BouncingScrollPhysics(),
//           children: [
//             SizedBox(
//               height: 10,
//             ),

//             ///Delivery Info
//             Obx(() {
//               if (checkoutController.isLoading.value) {
//                 return Container();
//               } else {
//                 if (addressController.addressCount.value > 0) {
//                   customerEmailCtrl.text =
//                       addressController.shippingAddress.value.email;
//                   customerPhoneCtrl.text =
//                       addressController.shippingAddress.value.phone;
//                   return Container(
//                     color: Colors.white,
//                     padding: EdgeInsets.symmetric(horizontal: 15),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: 10,
//                         ),
//                         ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           dense: true,
//                           title: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Image.asset(
//                                 'assets/images/location_ico.png',
//                                 color: AppStyles.darkBlueColor,
//                                 width: 17,
//                                 height: 17,
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Flexible(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       addressController.shippingAddress.value
//                                           .name.capitalizeFirst,
//                                       style: AppStyles.kFontBlack14w5.copyWith(
//                                         fontWeight: FontWeight.w600,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     RichText(
//                                       text: TextSpan(
//                                         text: 'Address'.tr + ': ',
//                                         style: AppStyles.kFontGrey14w5.copyWith(
//                                           color: AppStyles.darkBlueColor,
//                                           fontSize: 13,
//                                         ),
//                                         children: <TextSpan>[
//                                           TextSpan(
//                                             text:
//                                                 '${addressController.shippingAddress.value.address}',
//                                             style: AppStyles.kFontGrey14w5
//                                                 .copyWith(
//                                               fontSize: 13,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                           trailing: InkWell(
//                             onTap: () {
//                               Get.to(() => AddressBook());
//                             },
//                             child: Container(
//                               child: Text(
//                                 'Change'.tr,
//                                 style: AppStyles.appFont.copyWith(
//                                   fontWeight: FontWeight.w400,
//                                   color: AppStyles.pinkColor,
//                                   fontSize: 13,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         addressController.billingAddress ==
//                                 addressController.shippingAddress
//                             ? ListTile(
//                                 contentPadding: EdgeInsets.zero,
//                                 dense: true,
//                                 title: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Image.asset(
//                                       'assets/images/icon_delivery-parcel.png',
//                                       color: AppStyles.darkBlueColor,
//                                       width: 17,
//                                       height: 17,
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Flexible(
//                                       child: Padding(
//                                         padding:
//                                             const EdgeInsets.only(top: 2.0),
//                                         child: Text(
//                                           'Bill to the Same Address'
//                                               .tr
//                                               .toUpperCase(),
//                                           style:
//                                               AppStyles.kFontBlack14w5.copyWith(
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: InkWell(
//                                   onTap: () {
//                                     Get.to(() => AddressBook());
//                                   },
//                                   child: Container(
//                                     child: Text(
//                                       'Change'.tr,
//                                       style: AppStyles.appFont.copyWith(
//                                         fontWeight: FontWeight.w400,
//                                         color: AppStyles.pinkColor,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             : ListTile(
//                                 contentPadding: EdgeInsets.zero,
//                                 dense: true,
//                                 title: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       padding: EdgeInsets.all(2),
//                                       child: Image.asset(
//                                         'assets/images/icon_delivery-parcel.png',
//                                         color: AppStyles.darkBlueColor,
//                                         width: 15,
//                                         height: 15,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 5,
//                                     ),
//                                     Flexible(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             addressController.billingAddress
//                                                 .value.name.capitalizeFirst,
//                                             style: AppStyles.kFontBlack14w5
//                                                 .copyWith(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           SizedBox(height: 8),
//                                           RichText(
//                                             text: TextSpan(
//                                               text: 'Address'.tr + ': ',
//                                               style: AppStyles.kFontGrey14w5
//                                                   .copyWith(
//                                                 color: AppStyles.darkBlueColor,
//                                                 fontSize: 13,
//                                               ),
//                                               children: <TextSpan>[
//                                                 TextSpan(
//                                                   text:
//                                                       '${addressController.billingAddress.value.address}',
//                                                   style: AppStyles.kFontGrey14w5
//                                                       .copyWith(
//                                                     fontSize: 13,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: InkWell(
//                                   onTap: () {
//                                     Get.to(() => AddressBook());
//                                   },
//                                   child: Container(
//                                     child: Text(
//                                       'Change'.tr,
//                                       style: AppStyles.appFont.copyWith(
//                                         fontWeight: FontWeight.w400,
//                                         color: AppStyles.pinkColor,
//                                         fontSize: 13,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                         SizedBox(height: 8),
//                         ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           dense: true,
//                           title: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 child: Icon(
//                                   Icons.phone,
//                                   size: 20,
//                                   color: AppStyles.darkBlueColor,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Flexible(
//                                 child: TextField(
//                                   autofocus: false,
//                                   controller: customerPhoneCtrl,
//                                   scrollPhysics:
//                                       AlwaysScrollableScrollPhysics(),
//                                   decoration: InputDecoration(
//                                     floatingLabelBehavior:
//                                         FloatingLabelBehavior.auto,
//                                     hintText: 'Phone number',
//                                     fillColor: AppStyles.appBackgroundColor,
//                                     isDense: true,
//                                     filled: true,
//                                     contentPadding: EdgeInsets.all(14),
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppStyles.textFieldFillColor,
//                                       ),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppStyles.textFieldFillColor,
//                                       ),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppStyles.textFieldFillColor,
//                                       ),
//                                     ),
//                                     hintStyle: AppStyles.appFont.copyWith(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.normal,
//                                       color: AppStyles.greyColorDark,
//                                     ),
//                                   ),
//                                   style: AppStyles.appFont.copyWith(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.normal,
//                                     color: AppStyles.blackColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         ListTile(
//                           contentPadding: EdgeInsets.zero,
//                           dense: true,
//                           title: Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Container(
//                                 child: Icon(
//                                   Icons.mail,
//                                   size: 20,
//                                   color: AppStyles.darkBlueColor,
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Flexible(
//                                 child: TextField(
//                                   autofocus: false,
//                                   controller: customerEmailCtrl,
//                                   scrollPhysics:
//                                       AlwaysScrollableScrollPhysics(),
//                                   decoration: InputDecoration(
//                                     floatingLabelBehavior:
//                                         FloatingLabelBehavior.auto,
//                                     hintText: 'Email Address',
//                                     fillColor: AppStyles.appBackgroundColor,
//                                     isDense: true,
//                                     filled: true,
//                                     contentPadding: EdgeInsets.all(14),
//                                     border: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppStyles.textFieldFillColor,
//                                       ),
//                                     ),
//                                     enabledBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppStyles.textFieldFillColor,
//                                       ),
//                                     ),
//                                     errorBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                     focusedBorder: OutlineInputBorder(
//                                       borderSide: BorderSide(
//                                         color: AppStyles.textFieldFillColor,
//                                       ),
//                                     ),
//                                     hintStyle: AppStyles.appFont.copyWith(
//                                       fontSize: 13,
//                                       fontWeight: FontWeight.normal,
//                                       color: AppStyles.greyColorDark,
//                                     ),
//                                   ),
//                                   style: AppStyles.appFont.copyWith(
//                                     fontSize: 13,
//                                     fontWeight: FontWeight.normal,
//                                     color: AppStyles.blackColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return Padding(
//                     padding: EdgeInsets.all(15),
//                     child: InkWell(
//                       onTap: () {
//                         Get.to(() => AddAddress());
//                       },
//                       child: DottedBorder(
//                         color: AppStyles.lightBlueColor,
//                         strokeWidth: 1,
//                         borderType: BorderType.RRect,
//                         radius: Radius.circular(12),
//                         child: Container(
//                           alignment: Alignment.center,
//                           height: 80,
//                           decoration: BoxDecoration(
//                             color: Color(0xffEDF3FA),
//                             borderRadius: BorderRadius.all(
//                               Radius.circular(12),
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.add_circle_outline_rounded,
//                                 color: AppStyles.lightBlueColor,
//                                 size: 22,
//                               ),
//                               SizedBox(
//                                 width: 5,
//                               ),
//                               Text(
//                                 'Add Address'.tr,
//                                 textAlign: TextAlign.center,
//                                 style: AppStyles.appFont.copyWith(
//                                   color: AppStyles.lightBlueColor,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//               }
//             }),
//             SizedBox(
//               height: 10,
//             ),

//             ///Products
//             Obx(() {
//               if (checkoutController.isLoading.value) {
//                 return Center(
//                   child: CustomLoadingWidget(),
//                 );
//               } else {
//                 if (checkoutController.checkoutModel.value.packages == null ||
//                     checkoutController.checkoutModel.value.packages.length ==
//                         0) {
//                   return Center(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         SizedBox(
//                           height: 50,
//                         ),
//                         Icon(
//                           FontAwesomeIcons.exclamation,
//                           color: AppStyles.pinkColor,
//                           size: 25,
//                         ),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Text(
//                           'No Products found'.tr,
//                           textAlign: TextAlign.center,
//                           style: AppStyles.kFontPink15w5.copyWith(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 50,
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   var packageInd = 0;
//                   var taxes = [];
//                   var pTaxes = [];
//                   return Container(
//                     color: Colors.white,
//                     child: ListView.builder(
//                         physics: NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         padding: EdgeInsets.symmetric(horizontal: 10),
//                         itemCount: checkoutController
//                             .checkoutModel.value.packages.length,
//                         itemBuilder: (context, index) {
//                           ///PACKAGES
//                           return Container(
//                             child: ListView.builder(
//                                 physics: NeverScrollableScrollPhysics(),
//                                 shrinkWrap: true,
//                                 padding: EdgeInsets.zero,
//                                 itemCount: checkoutController
//                                     .checkoutModel.value.packages.values
//                                     .elementAt(index).items
//                                     .length,
//                                 itemBuilder: (context, checkoutIndex) {
//                                   var packageTax = 0.0;
//                                   packageInd++;
//                                   var qty = 0;
//                                   var price = 0.0;
//                                   var additionalShipping = 0.0;

//                                   checkoutController
//                                       .checkoutModel.value.packages.values
//                                       .elementAt(index).items
//                                       .forEach((element) {
//                                     qty += element.qty;
//                                   });
//                                   checkoutController
//                                       .checkoutModel.value.packages.values
//                                       .elementAt(index)
//                                       .forEach((element) {
//                                     price += element.totalPrice;
//                                   });
//                                   checkoutController
//                                       .checkoutModel.value.packages.values
//                                       .elementAt(index)
//                                       .forEach((element) {
//                                     if (element.productType ==
//                                         ProductType.PRODUCT) {
//                                       additionalShipping += element
//                                           .product.sku.additionalShipping
//                                           .toDouble();
//                                     }
//                                   });

//                                   // String calculateArrival() {
//                                   //   var arr = checkoutController
//                                   //       .checkoutModel.value.items.values
//                                   //       .elementAt(index)
//                                   //       .first
//                                   //       .shippingMethod
//                                   //       .shipmentTime;
//                                   //   if (arr.contains('days')) {
//                                   //     arr = arr.replaceAll(' days', '');
//                                   //     arr = 'Est. Arrival Date: ' +
//                                   //         CustomDate().formattedDateOnly(
//                                   //             DateTime.now().add(Duration(
//                                   //                 days: int.parse(
//                                   //                     arr.split('-').first)))) +
//                                   //         '-' +
//                                   //         CustomDate().formattedDateOnly(
//                                   //             DateTime.now().add(Duration(
//                                   //                 days: int.parse(
//                                   //                     arr.split('-').last))));
//                                   //   } else {
//                                   //     arr = 'Est. Arrival Time: ' + arr;
//                                   //   }
//                                   //   return arr;
//                                   // }

//                                   var gst = 0.0;
//                                   var gstS = '';
//                                   var gstShowList = [];
//                                   var gstID = [];
//                                   var gstAmount = [];
//                                   if (checkoutController.checkoutModel.value
//                                           .isGstModuleEnable ==
//                                       1) {
//                                     checkoutController
//                                         .checkoutModel.value.packages.values
//                                         .elementAt(index)
//                                         .forEach((element) {
//                                       gstShowList.clear();
//                                       gstID.clear();
//                                       gstAmount.clear();

//                                       if (checkoutController.checkoutModel.value
//                                               .isGstEnable ==
//                                           1) {
//                                         if (currencyController.settingsModel
//                                                 .value.vendorType ==
//                                             "single") {
//                                           if (element
//                                                   .customer
//                                                   .customerShippingAddress
//                                                   .state ==
//                                               currencyController.settingsModel
//                                                   .value.settings.stateId
//                                                   .toString()) {
//                                             checkoutController.checkoutModel
//                                                 .value.sameStateGstList
//                                                 .forEach((same) {
//                                               gst = double.parse(((price *
//                                                               same.taxPercentage) /
//                                                           100)
//                                                       .toString())
//                                                   .toPrecision(2);
//                                               gstS =
//                                                   '${same.name}(${same.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
//                                               gstShowList.add(gstS);
//                                               gstID.add(same.id);
//                                               gstAmount.add(gst);
//                                             });

//                                             data.addAll({
//                                               'gst_package_$packageInd[]':
//                                                   gstID,
//                                               'gst_amounts_package_$packageInd[]':
//                                                   gstAmount,
//                                             });
//                                           } else {
//                                             checkoutController.checkoutModel
//                                                 .value.differantStateGstList
//                                                 .forEach((diff) {
//                                               gst = double.parse(((price *
//                                                               diff.taxPercentage) /
//                                                           100)
//                                                       .toString())
//                                                   .toPrecision(2);

//                                               gstS =
//                                                   '${diff.name}(${diff.taxPercentage} %) : $gst${currencyController.appCurrency.value} ';
//                                               gstShowList.add(gstS);
//                                               gstID.add(diff.id);
//                                               gstAmount.add(gst);
//                                             });
//                                             data.addAll({
//                                               'gst_package_$packageInd[]':
//                                                   gstID,
//                                               'gst_amounts_package_$packageInd[]':
//                                                   gstAmount,
//                                             });
//                                           }
//                                         } else {
//                                           if ((element.customer
//                                                           .customerShippingAddress !=
//                                                       null &&
//                                                   element.seller
//                                                           .sellerBusinessInformation !=
//                                                       null) &&
//                                               element
//                                                       .customer
//                                                       .customerShippingAddress
//                                                       .state ==
//                                                   element
//                                                       .seller
//                                                       .sellerBusinessInformation
//                                                       .businessState) {
//                                             checkoutController.checkoutModel
//                                                 .value.sameStateGstList
//                                                 .forEach((same) {
//                                               gst =
//                                                   (price * same.taxPercentage) /
//                                                       100;
//                                               gstS =
//                                                   '${same.name}(${same.taxPercentage} %) : $gst${currencyController.appCurrency.value} ';
//                                               gstShowList.add(gstS);
//                                               gstID.add(same.id);
//                                               gstAmount.add(gst);
//                                             });

//                                             data.addAll({
//                                               'gst_package_$packageInd[]':
//                                                   gstID,
//                                               'gst_amounts_package_$packageInd[]':
//                                                   gstAmount,
//                                             });
//                                           } else {
//                                             if (element.seller
//                                                     .sellerBusinessInformation ==
//                                                 null) {
//                                               gst = (price *
//                                                       checkoutController
//                                                           .checkoutModel
//                                                           .value
//                                                           .flatGst
//                                                           .taxPercentage) /
//                                                   100;

//                                               gstS =
//                                                   '${checkoutController.checkoutModel.value.flatGst.name}(${checkoutController.checkoutModel.value.flatGst.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
//                                               gstShowList.add(gstS);
//                                               gstAmount.add(gst);

//                                               data.addAll({
//                                                 'gst_package_$packageInd[]':
//                                                     gstID,
//                                                 'gst_amounts_package_$packageInd[]':
//                                                     gstAmount,
//                                               });
//                                             } else {
//                                               checkoutController.checkoutModel
//                                                   .value.differantStateGstList
//                                                   .forEach((diff) {
//                                                 gst = (price *
//                                                         diff.taxPercentage) /
//                                                     100;
//                                                 gstS =
//                                                     '${diff.name}(${diff.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
//                                                 gstShowList.add(gstS);
//                                                 gstID.add(diff.id);
//                                                 gstAmount.add(gst);
//                                               });
//                                               data.addAll({
//                                                 'gst_package_$packageInd[]':
//                                                     gstID,
//                                                 'gst_amounts_package_$packageInd[]':
//                                                     gstAmount,
//                                               });
//                                             }
//                                           }
//                                         }
//                                       } else {
//                                         ///
//                                         ///not enable gst
//                                         ///
//                                         FlatGst flatGST = checkoutController
//                                             .checkoutModel.value.flatGst;
//                                         gst = (price * flatGST.taxPercentage) /
//                                             100;
//                                         gstS =
//                                             '${flatGST.name}(${flatGST.taxPercentage} %) : $gst${currencyController.appCurrency.value}';
//                                         gstShowList.add(gstS);
//                                         gstID.add(flatGST.id);
//                                         gstAmount.add(gst);
//                                         data.addAll({
//                                           'gst_package_$packageInd[]': gstID,
//                                           'gst_amounts_package_$packageInd[]':
//                                               gstAmount,
//                                         });
//                                       }
//                                     });
//                                   }

//                                   // data.addAll({

//                                   //   'delivery_date[${packageInd - 1}]':
//                                   //       calculateArrival(),
//                                   // });

//                                   var taxAmount = 0.0;

//                                   calculateTax(CheckoutItem checkoutItem) {
//                                     if (checkoutItem.productType ==
//                                         ProductType.PRODUCT) {
//                                       if (checkoutItem.product.product.tax >
//                                           0) {
//                                         if (checkoutItem
//                                                 .product.product.taxType ==
//                                             "0") {
//                                           ///percent tax
//                                           taxAmount = (((checkoutItem
//                                                       .product.product.tax /
//                                                   100) *
//                                               checkoutItem.totalPrice));
//                                         } else {
//                                           taxAmount = double.parse((checkoutItem
//                                                       .product.product.tax *
//                                                   checkoutItem.qty)
//                                               .toString());
//                                         }
//                                       } else {
//                                         taxAmount = 0.0;
//                                       }

//                                       return taxAmount;
//                                     } else {
//                                       taxAmount = 0;
//                                     }
//                                   }

//                                   checkoutController
//                                       .checkoutModel.value.packages.values
//                                       .elementAt(index)
//                                       .forEach((element) {
//                                     if (element.productType ==
//                                         ProductType.PRODUCT) {
//                                       packageTax += calculateTax(element);
//                                     }
//                                   });
//                                   pTaxes.add(packageTax);
//                                   return Column(
//                                     children: [
//                                       Container(
//                                         padding: EdgeInsets.symmetric(
//                                             horizontal: 10, vertical: 10),
//                                         color: Colors.white,
//                                         child: Column(
//                                           children: [
//                                             ListTile(
//                                               dense: true,
//                                               contentPadding: EdgeInsets.zero,
//                                               title: Row(
//                                                 crossAxisAlignment:
//                                                     CrossAxisAlignment.start,
//                                                 children: [
//                                                   Image.asset(
//                                                     'assets/images/icon_delivery-parcel.png',
//                                                     width: 15,
//                                                     height: 15,
//                                                   ),
//                                                   SizedBox(
//                                                     width: 5,
//                                                   ),
//                                                   Expanded(
//                                                     child: Column(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .start,
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .start,
//                                                       children: [
//                                                         Text(
//                                                           'Package'.tr +
//                                                               ' $packageInd/${checkoutController.packageCount.value}',
//                                                           style: AppStyles
//                                                               .kFontBlack12w4,
//                                                         ),
//                                                         SizedBox(
//                                                           height: 5,
//                                                         ),

//                                                         // Text(
//                                                         //   '${calculateArrival()}',
//                                                         //   style: AppStyles
//                                                         //       .kFontBlack12w4,
//                                                         // ),
//                                                         // SizedBox(
//                                                         //   height: 5,
//                                                         // ),
//                                                         Column(
//                                                           crossAxisAlignment:
//                                                               CrossAxisAlignment
//                                                                   .start,
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .start,
//                                                           children: [
//                                                             SizedBox(
//                                                               height: 5,
//                                                             ),
//                                                             additionalShipping >
//                                                                     0.0
//                                                                 ? Text(
//                                                                     'Additional Shipping'
//                                                                             .tr +
//                                                                         ': ${(additionalShipping * currencyController.conversionRate.value)}${currencyController.appCurrency.value}',
//                                                                     style: AppStyles
//                                                                         .kFontGrey12w5,
//                                                                   )
//                                                                 : Container(),
//                                                           ],
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               trailing: currencyController
//                                                           .vendorType.value ==
//                                                       "single"
//                                                   ? SizedBox.shrink()
//                                                   : Text(
//                                                       'Sold by'.tr +
//                                                           ': ${checkoutController.checkoutModel.value.packages.values.elementAt(index).first.seller.firstName}',
//                                                       style: AppStyles
//                                                           .kFontGrey12w5,
//                                                     ),
//                                             ),
//                                             ListView.builder(
//                                                 physics:
//                                                     NeverScrollableScrollPhysics(),
//                                                 shrinkWrap: true,
//                                                 itemCount: checkoutController
//                                                     .checkoutModel
//                                                     .value
//                                                     .packages
//                                                     .values
//                                                     .elementAt(index)
//                                                     .length,
//                                                 itemBuilder:
//                                                     (context, productIndex) {
//                                                   List<CheckoutItem>
//                                                       checkoutItem =
//                                                       checkoutController
//                                                           .checkoutModel
//                                                           .value
//                                                           .packages
//                                                           .values
//                                                           .elementAt(index);
//                                                   var taxAmount = 0.0;
//                                                   calculateTax(
//                                                       CheckoutItem
//                                                           checkoutItem) {
//                                                     if (checkoutItem
//                                                             .productType ==
//                                                         ProductType.PRODUCT) {
//                                                       if (checkoutItem.product
//                                                               .product.tax >
//                                                           0) {
//                                                         if (checkoutItem
//                                                                 .product
//                                                                 .product
//                                                                 .taxType ==
//                                                             "0") {
//                                                           ///percent tax
//                                                           taxAmount = (((checkoutItem
//                                                                       .product
//                                                                       .product
//                                                                       .tax /
//                                                                   100) *
//                                                               checkoutItem
//                                                                   .totalPrice));
//                                                         } else {
//                                                           taxAmount = double
//                                                               .parse((checkoutItem
//                                                                           .product
//                                                                           .product
//                                                                           .tax *
//                                                                       checkoutItem
//                                                                           .qty)
//                                                                   .toString());
//                                                         }
//                                                       } else {
//                                                         taxAmount = 0.0;
//                                                       }
//                                                     }

//                                                     return taxAmount;
//                                                   }

//                                                   taxes.add(calculateTax(
//                                                       checkoutItem[
//                                                           productIndex]));
//                                                   data.addAll({
//                                                     'tax_amount[]': taxes,
//                                                     'packagewiseTax[]': pTaxes,
//                                                   });
//                                                   return Container(
//                                                     color: Colors.white,
//                                                     child: Column(
//                                                       children: [
//                                                         Container(
//                                                           color: Colors.white,
//                                                           padding: EdgeInsets
//                                                               .symmetric(
//                                                             horizontal: 18,
//                                                           ),
//                                                           child: Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//                                                               Row(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   ClipRRect(
//                                                                     borderRadius:
//                                                                         BorderRadius.all(
//                                                                             Radius.circular(5)),
//                                                                     clipBehavior:
//                                                                         Clip.antiAlias,
//                                                                     child:
//                                                                         Container(
//                                                                       height:
//                                                                           65,
//                                                                       width: 65,
//                                                                       child: checkoutItem[productIndex].productType ==
//                                                                               ProductType.PRODUCT
//                                                                           ? checkoutItem[productIndex].product.sku.variantImage != null
//                                                                               ? FancyShimmerImage(
//                                                                                   imageUrl: AppConfig.assetPath + '/' + checkoutItem[productIndex].product.sku.variantImage,
//                                                                                   boxFit: BoxFit.contain,
//                                                                                 )
//                                                                               : FancyShimmerImage(
//                                                                                   imageUrl: AppConfig.assetPath + '/' + checkoutItem[productIndex].product.product.product.thumbnailImageSource,
//                                                                                   boxFit: BoxFit.contain,
//                                                                                 )
//                                                                           : FancyShimmerImage(
//                                                                               imageUrl: AppConfig.assetPath + '/' + checkoutItem[productIndex].giftCard.thumbnailImage,
//                                                                               boxFit: BoxFit.contain,
//                                                                             ),
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width: 15,
//                                                                   ),
//                                                                   Expanded(
//                                                                     child:
//                                                                         Container(
//                                                                       child:
//                                                                           Row(
//                                                                         children: [
//                                                                           Expanded(
//                                                                             child:
//                                                                                 Column(
//                                                                               mainAxisAlignment: MainAxisAlignment.start,
//                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                               children: [
//                                                                                 checkoutItem[productIndex].productType == ProductType.PRODUCT
//                                                                                     ? Text(
//                                                                                         checkoutItem[productIndex].product.product.product.productName,
//                                                                                         style: AppStyles.kFontBlack13w4,
//                                                                                       )
//                                                                                     : Text(
//                                                                                         checkoutItem[productIndex].giftCard.name,
//                                                                                         style: AppStyles.kFontBlack13w4,
//                                                                                       ),
//                                                                                 checkoutItem[productIndex].productType == ProductType.PRODUCT
//                                                                                     ? ListView.builder(
//                                                                                         shrinkWrap: true,
//                                                                                         physics: NeverScrollableScrollPhysics(),
//                                                                                         padding: EdgeInsets.symmetric(vertical: 4),
//                                                                                         itemCount: checkoutItem[productIndex].product.productVariations.length,
//                                                                                         itemBuilder: (BuildContext context, int variationIndex) {
//                                                                                           if (checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name == 'Color') {
//                                                                                             return Text(
//                                                                                               '${checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name}: ${checkoutItem[productIndex].product.productVariations[variationIndex].attributeValue.color.name}',
//                                                                                               style: AppStyles.kFontGrey12w5,
//                                                                                             );
//                                                                                           }
//                                                                                           return Text(
//                                                                                             '${checkoutItem[productIndex].product.productVariations[variationIndex].attribute.name}: ${checkoutItem[productIndex].product.productVariations[variationIndex].attributeValue.value}',
//                                                                                             style: AppStyles.kFontGrey12w5,
//                                                                                           );
//                                                                                         },
//                                                                                       )
//                                                                                     : SizedBox.shrink(),
//                                                                                 Wrap(
//                                                                                   runSpacing: 2,
//                                                                                   children: [
//                                                                                     checkoutItem[productIndex].productType == ProductType.PRODUCT
//                                                                                         ? checkoutItem[productIndex].product.product.discount > 0
//                                                                                             ? Row(
//                                                                                                 children: [
//                                                                                                   Text(
//                                                                                                     '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                                     style: AppStyles.kFontPink15w5,
//                                                                                                   ),
//                                                                                                   SizedBox(width: 5),
//                                                                                                   Text(
//                                                                                                     '${double.parse((checkoutItem[productIndex].product.sellingPrice * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                                     style: AppStyles.kFontGrey12w5.copyWith(decoration: TextDecoration.lineThrough),
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               )
//                                                                                             : Text(
//                                                                                                 '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                                 style: AppStyles.kFontPink15w5,
//                                                                                               )
//                                                                                         : checkoutItem[productIndex].giftCard.discount > 0
//                                                                                             ? Row(
//                                                                                                 children: [
//                                                                                                   Text(
//                                                                                                     '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                                     style: AppStyles.kFontPink15w5,
//                                                                                                   ),
//                                                                                                   SizedBox(width: 5),
//                                                                                                   Text(
//                                                                                                     '${double.parse((checkoutItem[productIndex].giftCard.sellingPrice * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                                     style: AppStyles.kFontGrey12w5.copyWith(decoration: TextDecoration.lineThrough),
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               )
//                                                                                             : Text(
//                                                                                                 '${double.parse((checkoutItem[productIndex].price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                                 style: AppStyles.kFontPink15w5,
//                                                                                               ),
//                                                                                     SizedBox(
//                                                                                       width: 5,
//                                                                                     ),
//                                                                                     checkoutItem[productIndex].productType == ProductType.PRODUCT
//                                                                                         ? checkoutItem[productIndex].product.product.discount > 0
//                                                                                             ? Row(
//                                                                                                 children: [
//                                                                                                   Container(
//                                                                                                     padding: EdgeInsets.all(4),
//                                                                                                     decoration: BoxDecoration(
//                                                                                                       color: AppStyles.pinkColor,
//                                                                                                       borderRadius: BorderRadius.circular(2),
//                                                                                                     ),
//                                                                                                     child: Text(
//                                                                                                       checkoutItem[productIndex].product.product.discountType == "0" ? '-${checkoutItem[productIndex].product.product.discount}%' : '-${double.parse((checkoutItem[productIndex].product.product.discount * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                                       style: AppStyles.kFontWhite12w5,
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               )
//                                                                                             : Container()
//                                                                                         : checkoutItem[productIndex].giftCard.discount > 0
//                                                                                             ? Row(
//                                                                                                 children: [
//                                                                                                   Container(
//                                                                                                     padding: EdgeInsets.all(4),
//                                                                                                     decoration: BoxDecoration(
//                                                                                                       color: AppStyles.pinkColor,
//                                                                                                       borderRadius: BorderRadius.circular(2),
//                                                                                                     ),
//                                                                                                     child: Text(
//                                                                                                       checkoutItem[productIndex].giftCard.discountType == "0" || checkoutItem[productIndex].giftCard.discountType == 0 ? '-${checkoutItem[productIndex].giftCard.discount}%' : '-${double.parse((checkoutItem[productIndex].giftCard.discount * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                                       style: AppStyles.kFontWhite12w5,
//                                                                                                     ),
//                                                                                                   ),
//                                                                                                 ],
//                                                                                               )
//                                                                                             : Container(),
//                                                                                   ],
//                                                                                 ),
//                                                                                 SizedBox(
//                                                                                   height: 5,
//                                                                                 ),
//                                                                                 checkoutItem[productIndex].productType == ProductType.PRODUCT
//                                                                                     ? Column(
//                                                                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                                                                         children: [
//                                                                                           // Text(
//                                                                                           //   checkoutItem[productIndex].product.product.taxType == "0" ? 'Tax'.tr + ': ${checkoutItem[productIndex].product.product.tax}%' : 'Tax'.tr + ': ${double.parse((checkoutItem[productIndex].product.product.tax * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                           //   style: AppStyles.kFontGrey12w5,
//                                                                                           // ),
//                                                                                           Text(
//                                                                                             'Tax Amount'.tr + ': ${(calculateTax(checkoutItem[productIndex]) * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                                                             style: AppStyles.kFontGrey12w5,
//                                                                                           ),
//                                                                                         ],
//                                                                                       )
//                                                                                     : Container(),
//                                                                                 SizedBox(
//                                                                                   height: 5,
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           ),
//                                                                           Text(
//                                                                             'Qty'.tr +
//                                                                                 ': ${checkoutItem[productIndex].qty}',
//                                                                             style:
//                                                                                 AppStyles.kFontBlack12w4,
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                     ),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                               SizedBox(
//                                                                 height: 10,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                   );
//                                                 }),
//                                             Container(
//                                               color: Colors.white,
//                                               padding:
//                                                   const EdgeInsets.all(8.0),
//                                               child: Column(
//                                                 children: [
//                                                   Divider(
//                                                     color: AppStyles
//                                                         .lightBlueColorAlt,
//                                                     thickness: 2,
//                                                     height: 2,
//                                                   ),
//                                                   SizedBox(
//                                                     height: 5,
//                                                   ),
//                                                   Row(
//                                                     mainAxisAlignment:
//                                                         MainAxisAlignment
//                                                             .spaceBetween,
//                                                     children: [
//                                                       Column(
//                                                         mainAxisAlignment:
//                                                             MainAxisAlignment
//                                                                 .start,
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: List.generate(
//                                                           gstShowList.length,
//                                                           (gstIndex) => Padding(
//                                                             padding:
//                                                                 const EdgeInsets
//                                                                         .symmetric(
//                                                                     vertical:
//                                                                         4.0),
//                                                             child: Text(
//                                                               gstShowList[
//                                                                   gstIndex],
//                                                               style: AppStyles
//                                                                   .kFontBlack12w4
//                                                                   .copyWith(
//                                                                 color: AppStyles
//                                                                     .greyColorDark,
//                                                               ),
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: Text(
//                                                           '$qty ' +
//                                                               'Item(s), Total: '
//                                                                   .tr +
//                                                               '${double.parse((price * currencyController.conversionRate.value).toString()).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                                           style: AppStyles
//                                                               .kFontBlack12w4,
//                                                         ),
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Divider(
//                                         height: 15,
//                                         thickness: 10,
//                                         color: AppStyles.appBackgroundColor,
//                                       ),
//                                     ],
//                                   );
//                                 }),
//                           );
//                         }),
//                   );
//                 }
//               }
//             }),

//             ///Pricing Info
//             Obx(() {
//               if (checkoutController.isLoading.value) {
//                 return Center(
//                   child: Container(),
//                 );
//               } else {
//                 if (checkoutController.checkoutModel.value.packages == null ||
//                     checkoutController.checkoutModel.value.packages.length ==
//                         0) {
//                   return Container();
//                 } else {
//                   return Container(
//                     color: Colors.white,
//                     padding: EdgeInsets.symmetric(horizontal: 30),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Subtotal'.tr,
//                               style: AppStyles.kFontBlack12w4.copyWith(
//                                 color: AppStyles.greyColorDark,
//                               ),
//                             ),
//                             Text(
//                               '${(checkoutController.subTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                               style: AppStyles.kFontBlack14w5,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Shipping'.tr,
//                               style: AppStyles.kFontBlack12w4.copyWith(
//                                 color: AppStyles.greyColorDark,
//                               ),
//                             ),
//                             Text(
//                               '${(checkoutController.shipping.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                               style: AppStyles.kFontBlack14w5,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Total Saving'.tr,
//                               style: AppStyles.kFontBlack12w4.copyWith(
//                                 color: AppStyles.greyColorDark,
//                               ),
//                             ),
//                             Text(
//                               '-${(checkoutController.discountTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                               style: AppStyles.kFontBlack14w5,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Total TAX'.tr,
//                               style: AppStyles.kFontBlack12w4.copyWith(
//                                 color: AppStyles.greyColorDark,
//                               ),
//                             ),
//                             Text(
//                               '${(checkoutController.taxTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                               style: AppStyles.kFontBlack14w5,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         checkoutController
//                                     .checkoutModel.value.isGstModuleEnable ==
//                                 1
//                             ? Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       Text(
//                                         'Total GST'.tr,
//                                         style:
//                                             AppStyles.kFontBlack12w4.copyWith(
//                                           color: AppStyles.greyColorDark,
//                                         ),
//                                       ),
//                                       Text(
//                                         '${(checkoutController.gstTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                         style: AppStyles.kFontBlack14w5,
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                         SizedBox(
//                           height: 12,
//                         ),
//                         checkoutController.couponApplied.value
//                             ? Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   InkWell(
//                                     onTap: () {
//                                       checkoutController.removeCoupon();
//                                     },
//                                     child: Row(
//                                       children: [
//                                         Text(
//                                           'Coupon Discount'.tr,
//                                           style: AppStyles.kFontGrey12w5
//                                               .copyWith(color: Colors.green),
//                                         ),
//                                         SizedBox(
//                                           width: 5,
//                                         ),
//                                         Icon(
//                                           Icons.cancel_outlined,
//                                           color: Colors.red,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Text(
//                                     '${(checkoutController.couponDiscount.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                     style: AppStyles.kFontBlack14w5
//                                         .copyWith(color: Colors.green),
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                         SizedBox(
//                           height: 10,
//                         ),
//                         Divider(
//                           color: AppStyles.lightBlueColorAlt,
//                           thickness: 2,
//                           height: 2,
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             Text(
//                               '${checkoutController.totalQty} ' +
//                                   'Item(s), Grand Total:'.tr +
//                                   ' ' +
//                                   '${(checkoutController.grandTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                               style: AppStyles.kFontBlack14w5,
//                             ),
//                           ],
//                         ),
//                         SizedBox(
//                           height: 20,
//                         ),
//                         !checkoutController.couponApplied.value
//                             ? Row(
//                                 children: [
//                                   Flexible(
//                                     child: Container(
//                                       height: 45,
//                                       child: TextField(
//                                         autofocus: false,
//                                         scrollPhysics:
//                                             AlwaysScrollableScrollPhysics(),
//                                         controller: checkoutController
//                                             .couponCodeTextController,
//                                         decoration: InputDecoration(
//                                           floatingLabelBehavior:
//                                               FloatingLabelBehavior.auto,
//                                           hintText:
//                                               'Enter coupon/voucher code'.tr,
//                                           fillColor:
//                                               AppStyles.appBackgroundColor,
//                                           filled: true,
//                                           isDense: true,
//                                           border: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   AppStyles.textFieldFillColor,
//                                             ),
//                                           ),
//                                           enabledBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   AppStyles.textFieldFillColor,
//                                             ),
//                                           ),
//                                           errorBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color: Colors.red,
//                                             ),
//                                           ),
//                                           focusedBorder: OutlineInputBorder(
//                                             borderSide: BorderSide(
//                                               color:
//                                                   AppStyles.textFieldFillColor,
//                                             ),
//                                           ),
//                                           hintStyle: AppStyles.kFontGrey12w5
//                                               .copyWith(fontSize: 13),
//                                         ),
//                                         style: AppStyles.kFontBlack13w5,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     width: 10,
//                                   ),
//                                   InkWell(
//                                     onTap: () async {
//                                       checkoutController.applyCoupon();
//                                     },
//                                     child: Container(
//                                       alignment: Alignment.center,
//                                       width: 100,
//                                       height: 45,
//                                       decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(5),
//                                           ),
//                                           border: Border.all(
//                                               color: AppStyles.greyColorDark)),
//                                       child: Text(
//                                         'Apply'.tr,
//                                         textAlign: TextAlign.center,
//                                         style: AppStyles.appFont.copyWith(
//                                           color: AppStyles.greyColorDark,
//                                           fontSize: 14,
//                                           fontWeight: FontWeight.w500,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               )
//                             : Container(),
//                         SizedBox(
//                           height: 10,
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               }
//             }),
//             SizedBox(
//               height: 50,
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Material(
//         elevation: 20,
//         child: Container(
//           height: 70,
//           child: Row(
//             children: [
//               SizedBox(
//                 width: 20,
//               ),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Total: '.tr,
//                           textAlign: TextAlign.center,
//                           style: AppStyles.appFont.copyWith(
//                             fontSize: 17,
//                             color: AppStyles.blackColor,
//                           ),
//                         ),
//                         Obx(() {
//                           if (checkoutController.isLoading.value) {
//                             return Center(
//                               child: Container(),
//                             );
//                           } else {
//                             if (checkoutController
//                                         .checkoutModel.value.packages ==
//                                     null ||
//                                 checkoutController
//                                         .checkoutModel.value.packages.length ==
//                                     0) {
//                               return Container();
//                             } else {
//                               return Text(
//                                 '${(checkoutController.grandTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
//                                 textAlign: TextAlign.center,
//                                 style: AppStyles.appFont.copyWith(
//                                   fontSize: 17,
//                                   fontWeight: FontWeight.bold,
//                                   color: AppStyles.darkBlueColor,
//                                 ),
//                               );
//                             }
//                           }
//                         })
//                       ],
//                     ),
//                     Padding(
//                       padding:
//                           EdgeInsets.symmetric(vertical: 4.0, horizontal: 3),
//                       child: Text('VAT included, where applicable',
//                           style: AppStyles.kFontGrey12w5),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(width: 5),
//               PinkButtonWidget(
//                 height: 40,
//                 btnText: 'Proceed to Payment'.tr,
//                 btnOnTap: () {
//                   if (addressController.addressCount.value == 0) {
//                     SnackBars().snackBarWarning(
//                         'Please Add Shipping and Billing Address'.tr);
//                   } else {
//                     data.addAll({
//                       'customer_shipping_address':
//                           addressController.shippingAddress.value.id,
//                       'customer_billing_address':
//                           addressController.billingAddress.value.id,
//                       'customer_email': '${customerEmailCtrl.text}',
//                       'customer_phone': '${customerPhoneCtrl.text}',
//                       'number_of_item': checkoutController.totalQty.value,
//                       'number_of_package':
//                           checkoutController.packageCount.value,
//                       'sub_total': checkoutController.subTotal.value,
//                       'shipping_total': checkoutController.shipping.value,
//                       'discount_total': checkoutController.discountTotal.value,
//                       'tax_total': checkoutController.taxTotal.value,
//                       'grand_total': checkoutController.grandTotal.value,
//                       'gst_tax_total': checkoutController.gstTotal.value,
//                     });

//                     if (checkoutController.couponDiscount.value > 0) {
//                       data.addAll({
//                         'coupon_id': checkoutController.couponId.value,
//                         'coupon_amount':
//                             checkoutController.couponDiscount.value,
//                       });
//                     }
//                     print(data);
//                     Get.to(() => GatewaySelection(
//                           data: data,
//                         ));
//                   }
//                 },
//               ),
//               SizedBox(
//                 width: 10,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
