// import 'dart:convert';
// import 'dart:io';

// import 'package:amazcart/AppConfig/api_keys.dart';
// import 'package:amazcart/controller/payment_gateway_controller.dart';
// import 'package:amazcart/widgets/AppBarWidget.dart';
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:get/get.dart';

// class PayTmPaymentScreen extends StatefulWidget {
//   final String amount;
//   final Map orderData;
//   final Map paymentData;

//   PayTmPaymentScreen({this.amount, this.orderData, this.paymentData});

//   @override
//   _PayTmPaymentScreenState createState() => _PayTmPaymentScreenState();
// }

// class _PayTmPaymentScreenState extends State<PayTmPaymentScreen> {
//   WebViewController _webController;
//   bool _loadingPayment = true;
//   String _responseStatus = STATUS_LOADING;
//   final PaymentGatewayController paymentGatewayController =
//       Get.put(PaymentGatewayController());

//   String _loadHTML() {
//     return "<html> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$payTmPaymentUrl'>"
//             "<input type='hidden' name='orderID' value='PayTM_${DateTime.now().millisecondsSinceEpoch}'/>" +
//         "<input  type='hidden' name='custID' value='${widget.paymentData["custID"]}' />" +
//         "<input  type='hidden' name='amount' value='${widget.amount}' />" +
//         "<input type='hidden' name='custEmail' value='${widget.paymentData["custEmail"]}' />" +
//         "<input type='hidden' name='custPhone' value='${widget.paymentData["custPhone"]}' />" +
//         "</form> </body> </html>";
//   }

//   void getData() {
//     _webController
//         .evaluateJavascript("document.body.innerText")
//         .then((data) async {
//       var decodedJSON = jsonDecode(data);
//       Map<String, dynamic> responseJSON =
//           Platform.isIOS ? decodedJSON : jsonDecode(decodedJSON);
//       print('responseJSON $responseJSON}');
//       final checksumResult = responseJSON["status"];
//       final paytmResponse = responseJSON["data"];
//       if (paytmResponse["STATUS"] == "TXN_SUCCESS") {
//         if (checksumResult == 0) {
//           _responseStatus = STATUS_SUCCESSFUL;
//           print('JSON RESP :$responseJSON');

//           //TODO:: MAKE PAYMENT

//           widget.paymentData.addAll({
//             'transection_id': paytmResponse['ORDERID'],
//           });

//           await paymentGatewayController.paymentInfoStore(
//             paymentData: widget.paymentData,
//             orderData: widget.orderData,
//           );
//         } else {
//           _responseStatus = STATUS_CHECKSUM_FAILED;
//         }
//       } else if (paytmResponse["STATUS"] == "TXN_FAILURE") {
//         _responseStatus = STATUS_FAILED;
//       }
//       this.setState(() {});
//     });
//   }

//   Widget getResponseScreen() {
//     switch (_responseStatus) {
//       case STATUS_SUCCESSFUL:
//         return PaymentSuccessfulScreen();
//       case STATUS_CHECKSUM_FAILED:
//         return CheckSumFailedScreen();
//       case STATUS_FAILED:
//         return PaymentFailedScreen();
//     }
//     return PaymentSuccessfulScreen();
//   }

//   @override
//   void dispose() {
//     _webController = null;
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           appBar: AppBarWidget(
//             title: 'PayTM Payment',
//           ),
//           body: Stack(
//             children: <Widget>[
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height,
//                 child: WebView(
//                   debuggingEnabled: false,
//                   javascriptMode: JavascriptMode.unrestricted,
//                   onWebViewCreated: (controller) {
//                     _webController = controller;
//                     _webController.loadUrl(new Uri.dataFromString(_loadHTML(),
//                             mimeType: 'text/html')
//                         .toString());
//                   },
//                   onPageFinished: (page) {
//                     if (page.contains("/process")) {
//                       if (_loadingPayment) {
//                         this.setState(() {
//                           _loadingPayment = false;
//                         });
//                       }
//                     }
//                     if (page.contains("/paymentReceipt")) {
//                       getData();
//                     }
//                   },
//                 ),
//               ),
//               (_loadingPayment)
//                   ? Center(
//                       child: CircularProgressIndicator(),
//                     )
//                   : Center(),
//               (_responseStatus != STATUS_LOADING)
//                   ? Center(child: getResponseScreen())
//                   : Center()
//             ],
//           )),
//     );
//   }
// }

// class PaymentSuccessfulScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Great!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Thank you for making the payment!",
//                 style: TextStyle(fontSize: 30),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               MaterialButton(
//                   color: Colors.black,
//                   child: Text(
//                     "Close",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Get.until(ModalRoute.withName("/"));
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PaymentFailedScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "OOPS!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Payment was not successful, Please try again Later!",
//                 style: TextStyle(fontSize: 30),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               MaterialButton(
//                   color: Colors.black,
//                   child: Text(
//                     "Close",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Get.back();
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class CheckSumFailedScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       height: MediaQuery.of(context).size.height,
//       width: MediaQuery.of(context).size.width,
//       child: Padding(
//         padding: const EdgeInsets.all(15.0),
//         child: Center(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   "Oh Snap!",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.black,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 25),
//                 ),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               Text(
//                 "Problem Verifying Payment, If you balance is deducted please contact our customer support and get your payment verified!",
//                 style: TextStyle(fontSize: 30),
//               ),
//               SizedBox(
//                 height: 10,
//               ),
//               MaterialButton(
//                   color: Colors.black,
//                   child: Text(
//                     "Close",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   onPressed: () {
//                     Get.back();
//                   })
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
