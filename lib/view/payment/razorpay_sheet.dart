import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/controller/payment_gateway_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;

class RazorpaySheet extends StatefulWidget {
  final Map? orderData;

  RazorpaySheet({this.orderData});

  @override
  _RazorpaySheetState createState() => _RazorpaySheetState();
}

class _RazorpaySheetState extends State<RazorpaySheet> {
  final PaymentGatewayController controller =
      Get.put(PaymentGatewayController());
  bool paymentProcessing = false;
  final _formKey = GlobalKey<FormState>();

  Razorpay? _razorpay;
  var orderId = "";
  var amount;

  @override
  void initState() {
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  Future createOrder() async {
    String basicAuth =
        'Basic ' + base64Encode(utf8.encode('$razorPayKey:$razorPaySecret'));
    amount = (widget.orderData!['grand_total'] * 100).toInt();
    final receipt =
        'AMZ_${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}';

    Map<String, dynamic> bodyData = {
      "amount": amount,
      "currency": "INR",
      "receipt": receipt.toString(),
    };

    Uri orderCreate = Uri.parse('https://api.razorpay.com/v1/orders');
    var body = json.encode(bodyData);

    await http
        .post(
      orderCreate,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'authorization': basicAuth,
      },
      body: body,
    )
        .then((response) {
      var jsonString = jsonDecode(response.body);
      print('JSR $jsonString');
      setState(() {
        orderId = jsonString['id'];
      });
      return jsonString;
    }).catchError((err) => print('error : ' + err.toString()));
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log("SUCCESS PAYMENT ID: ${response.paymentId} ORDER ID: ${response.orderId} SIGNATURE: ${response.signature} ");

    ///
    Map payment = {
      'amount': widget.orderData!['grand_total'],
      'payment_method': widget.orderData!['payment_method'],
      'transection_id': response.orderId,
    };
    print(payment);
    await controller.paymentInfoStore(
      orderData: widget.orderData,
      paymentData: payment,
      transactionID: response.orderId,
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    log("ERROR CODE: ${response.code} ERROR MESSAGE: ${response.message.toString()}");
    SnackBars().snackBarError('ERROR ${response.message.toString()}');
    Future.delayed(Duration(milliseconds: 3500), () {
      Get.back();
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    log("External Wallet: walletName: ${response.walletName}");
    Get.snackbar(
      "ERROR",
      response.walletName.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xff8555F9),
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 10),
    );
  }

  @override
  void didChangeDependencies() async {
    await processRazorPay();
    super.didChangeDependencies();
  }

  Future processRazorPay() async {
    setState(() {
      paymentProcessing = true;
    });
    await createOrder().then((value) async {
      var options = {
        'key': razorPayKey,
        'amount': amount,
        'name': companyName,
        'description': orderId.toString(),
        'order_id': orderId.toString(),
      };
      try {
        _razorpay!.open(options);
      } catch (e) {
        debugPrint('Error: e');
        Get.back();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.4,
            maxChildSize: 1,
            builder: (_, scrollController2) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Form(
                      key: _formKey,
                      child: ListView(
                        controller: scrollController2,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Color(0xffDADADA),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
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
                              'RazorPay Payment',
                              style: AppStyles.kFontBlack15w4,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          paymentProcessing == true
                              ? Center(
                                  child: Column(
                                    children: [
                                      CupertinoActivityIndicator(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Text(
                                          'Payment Processing. Please don\'t close this until payment is complete',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack17w5,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    Center(
                                      child: Text(
                                        'You\'re about to pay ${widget.orderData!['grand_total']} INR',
                                        textAlign: TextAlign.center,
                                        style: AppStyles.kFontBlack17w5,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
