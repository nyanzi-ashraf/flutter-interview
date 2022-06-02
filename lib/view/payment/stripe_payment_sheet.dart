// import 'dart:convert';

// import 'package:amazcart/AppConfig/api_keys.dart';
// import 'package:amazcart/controller/payment_gateway_controller.dart';
// import 'package:amazcart/utils/styles.dart';
// import 'package:amazcart/widgets/BlueButtonWidget.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:stripe_payment/stripe_payment.dart';

// class StripePaymentSheet extends StatefulWidget {
//   final Map orderData;
//   final Map paymentData;

//   StripePaymentSheet({this.orderData, this.paymentData});

//   @override
//   _StripePaymentSheetState createState() => _StripePaymentSheetState();
// }

// class _StripePaymentSheetState extends State<StripePaymentSheet> {
//   bool error = false;
//   String _pubKey;
//   PaymentMethod _paymentMethod;
//   String _paymentIntentClientSecret;
//   PaymentIntentResult _paymentIntent;
//   bool loadingPayment = false;
//   bool paymentDone = false;
//   String returnString = '';
//   var errorString = '';
//   bool cardDetailsDone = false;

//   Future getPubKey() async {
//     try {
//       setState(() {
//         loadingPayment = true;
//         returnString = 'Generating Stripe Payment. Please don\'t close this...';
//       });
//       final keyUrl = "$stripeURL/pub_key";
//       final http.Response response = await http.post(
//         Uri.parse(keyUrl),
//       );
//       final responseData = jsonDecode(response.body);
//       final String pubKey = responseData['publishable_key'];
//       setState(() {
//         _pubKey = pubKey;
//         returnString = 'Processing payment...';
//       });
//     } catch (e) {
//       setState(() {
//         error = true;
//       });
//     }
//     print(_pubKey);
//     StripePayment.setOptions(
//       StripeOptions(
//         publishableKey: _pubKey,
//         androidPayMode: 'test',
//         merchantId: stripeMerchantID,
//       ),
//     );
//   }

//   void setError(dynamic errorString) {
//     setState(() {
//       errorString = errorString.toString();
//       cardDetailsDone = false;
//       loadingPayment = false;
//       returnString = 'Payment cancelled';
//     });
//     Future.delayed(Duration(seconds: 4), () {
//       Get.back();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void didChangeDependencies() async {

//     await getPubKey().then((value) {
//       StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
//           .then((paymentMethod) {
//         setState(() {
//           _paymentMethod = paymentMethod;
//           cardDetailsDone = true;
//           loadingPayment = false;
//           returnString =
//               'Credit Card details confirmed. Please proceed with Payment...';
//         });
//       }).catchError(setError);
//     });
//     super.didChangeDependencies();
//   }

//   Future generateToken() async {
//     final String cpiUrl = '$stripeURL/create_payment_intent';
//     final finalAmount = (widget.orderData['grand_total'] * 100).toInt();
//     final String finalUrl = '$cpiUrl?amount=$finalAmount&currency=$stripeCurrency';
//     final http.Response response = await http.post(
//       Uri.parse(finalUrl),
//     );
//     final responseData = jsonDecode(response.body);
//     final String pics = responseData['clientSecret'];
//     setState(() {
//       _paymentIntentClientSecret = pics;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Get.back();
//       },
//       child: Container(
//         child: Container(
//           color: Color.fromRGBO(0, 0, 0, 0.001),
//           child: DraggableScrollableSheet(
//             initialChildSize: 0.4,
//             minChildSize: 0.4,
//             maxChildSize: 1,
//             builder: (_, scrollController2) {
//               return GestureDetector(
//                 onTap: () {},
//                 child: Container(
//                   padding:
//                       EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: const Radius.circular(25.0),
//                       topRight: const Radius.circular(25.0),
//                     ),
//                   ),
//                   child: Scaffold(
//                     backgroundColor: Colors.white,
//                     body: ListView(
//                       controller: scrollController2,
//                       children: [
//                         SizedBox(
//                           height: 10.h,
//                         ),
//                         Center(
//                           child: InkWell(
//                             onTap: () {
//                               Get.back();
//                             },
//                             child: Container(
//                               width: 40.w,
//                               height: 5.h,
//                               decoration: BoxDecoration(
//                                 color: Color(0xffDADADA),
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(30),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 10.h,
//                         ),
//                         Center(
//                           child: Text(
//                             'Stripe Payment',
//                             style: AppStyles.kFontBlack15w4,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20.h,
//                         ),
//                         loadingPayment == true
//                             ? Center(child: CupertinoActivityIndicator())
//                             : Container(),
//                         paymentDone == true
//                             ? Center(child: Icon(Icons.done))
//                             : Container(),
//                         SizedBox(
//                           height: 20.h,
//                         ),
//                         Center(
//                           child: Text(
//                             returnString,
//                             textAlign: TextAlign.center,
//                             style: AppStyles.kFontBlack17w5,
//                           ),
//                         ),
//                         SizedBox(
//                           height: 20.h,
//                         ),
//                         cardDetailsDone == true
//                             ? Center(child: cardDetailsWidget())
//                             : Container(),
//                         SizedBox(
//                           height: 20.h,
//                         ),
//                         paymentDone == true
//                             ? Center(
//                                 child: Text(
//                                   "Payment ID: ${_paymentMethod.id.toString()}",
//                                   textAlign: TextAlign.center,
//                                   style: AppStyles.kFontBlack13w4,
//                                 ),
//                               )
//                             : cardDetailsDone == true
//                                 ? loadingPayment == false
//                                     ? Center(
//                                         child: BlueButtonWidget(
//                                           height: 40.h,
//                                           width: Get.width * 0.4,
//                                           btnText: 'Confirm Payment',
//                                           btnOnTap: () async {
//                                             setState(() {
//                                               loadingPayment = true;
//                                               returnString =
//                                                   'Generating payment intent';
//                                             });
//                                             await generateToken()
//                                                 .then((value) async {
//                                               print(_paymentIntentClientSecret);
//                                               setState(() {
//                                                 returnString =
//                                                     'Confirming payment...';
//                                               });
//                                               await StripePayment
//                                                   .confirmPaymentIntent(
//                                                       PaymentIntent(
//                                                 clientSecret:
//                                                     _paymentIntentClientSecret,
//                                                 paymentMethodId:
//                                                     _paymentMethod.id,
//                                               )).then((paymentIntent) {
//                                                 print(
//                                                     _paymentIntentClientSecret);
//                                                 setState(() {
//                                                   _paymentIntent =
//                                                       paymentIntent;
//                                                   setState(() {
//                                                     loadingPayment = false;
//                                                     returnString =
//                                                         'Payment ${_paymentIntent.status}';
//                                                     paymentDone = true;
//                                                     loadingPayment = false;
//                                                   });
//                                                 });
//                                                 if (_paymentIntent.status ==
//                                                     'succeeded') {
//                                                   Future.delayed(
//                                                       Duration(seconds: 2), () {
//                                                     final PaymentGatewayController
//                                                         controller = Get.put(
//                                                             PaymentGatewayController());
//                                                     final Map payment = {
//                                                       'amount':
//                                                           widget.orderData[
//                                                               'grand_total'],
//                                                       'payment_method':
//                                                           widget.paymentData[
//                                                               'payment_method'],
//                                                       'transection_id':
//                                                           _paymentMethod.id,
//                                                     };
//                                                     controller.paymentInfoStore(
//                                                         paymentData: payment,
//                                                         orderData:
//                                                             widget.orderData);
//                                                     Get.back();
//                                                   });
//                                                 } else {
//                                                   returnString =
//                                                       'Payment ${_paymentIntent.status}';
//                                                 }
//                                               }).catchError(setError);
//                                             }).catchError(setError);
//                                           },
//                                         ),
//                                       )
//                                     : Container()
//                                 : Container(),
//                         SizedBox(
//                           height: 20.h,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   Widget cardDetailsWidget() {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         Text('**** **** **** ${_paymentMethod.card.last4}'),
//         SizedBox(
//           height: 10.h,
//         ),
//         Text(
//             '${_paymentMethod.card.expMonth.toString()} / ${_paymentMethod.card.expYear.toString()}'),
//       ],
//     );
//   }
// }
