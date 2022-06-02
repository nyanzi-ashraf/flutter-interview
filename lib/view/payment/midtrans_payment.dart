import 'dart:convert';

import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/controller/checkout_controller.dart';
import 'package:amazcart/controller/payment_gateway_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:math' as math;

import 'package:url_launcher/url_launcher.dart';

class MidTransPaymentPage extends StatefulWidget {
  final Map? orderData;
  final Function? onFinish;
  final Map? paymentData;

  MidTransPaymentPage({this.orderData, this.paymentData, this.onFinish});

  @override
  _MidTransPaymentPageState createState() => _MidTransPaymentPageState();
}

class _MidTransPaymentPageState extends State<MidTransPaymentPage> {
  final PaymentGatewayController controller =
      Get.put(PaymentGatewayController());
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final AddressController addressController = Get.put(AddressController());

  bool paymentProcessing = false;
  // final _formKey = GlobalKey<FormState>();
  String? orderID;
  String? checkoutUrl;

  double progress = 0;
  String url = "";
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      android: AndroidInAppWebViewOptions(
          useHybridComposition: true, useWideViewPort: true),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
        enableViewportScale: true,
      ));

  @override
  void initState() {
    _createPayment();
    super.initState();
  }

  Future _createPayment() async {
    var totalAmount = 0.0;

    var taxAmount =
        checkoutController.taxTotal.value + checkoutController.gstTotal.value;
    totalAmount = (checkoutController.sub.value +
        checkoutController.shipping.value +
        taxAmount);
    print('TOTAL $totalAmount');
    String userFirstName = addressController.shippingAddress.value.name!;
    String userEmail = addressController.shippingAddress.value.email!;
    String userPhone = addressController.shippingAddress.value.phone!;
    String userAddress = addressController.shippingAddress.value.address!;
    String addressCity = addressController.shippingAddress.value.getCity!.name!;
    String addressZipCode = addressController.shippingAddress.value.postalCode!;

    orderID =
        'MID_${math.Random().nextInt(100)}${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}';

    Map<String, dynamic> temp = {
      "transaction_details": {
        "order_id": orderID,
        "gross_amount": (totalAmount * 100).toInt()
      },
      "credit_card": {"secure": true},
      "item_details": [
        {
          "name": "${AppConfig.appName} Checkout",
          "quantity": 1,
          "price": (totalAmount * 100).toInt(),
        }
      ],
      "customer_details": {
        "first_name": userFirstName,
        "last_name": "",
        "email": userEmail,
        "phone": userPhone,
        "shipping_address": {
          "first_name": userFirstName,
          "last_name": " ",
          "email": userEmail,
          "phone": userPhone,
          "address": userAddress,
          "city": addressCity,
          "postal_code": addressZipCode,
        }
      }
    };

    print(jsonEncode(temp));

    final url = Uri.parse('$midTransServerUrl/create_midtrans_trxToken');

    var body = jsonEncode(temp);
    await http.post(url, body: body, headers: {
      'Accept': '*/*',
      'Content-Type': 'application/json'
    }).then((value) {
      print(value.body);
      var jsonString = json.decode(value.body);
      setState(() {
        checkoutUrl = jsonString['redirect_url'];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Midtrans Payment',
      ),
      body: checkoutUrl != null
          ? Column(
              children: [
                progress < 1.0
                    ? LinearProgressIndicator(value: progress)
                    : Container(),
                Expanded(
                  child: Stack(
                    children: [
                      InAppWebView(
                        key: webViewKey,
                        initialUrlRequest:
                            URLRequest(url: Uri.parse(checkoutUrl!)),
                        initialOptions: options,
                        onWebViewCreated: (controller) {
                          webViewController = controller;
                        },
                        onLoadStart: (controller, url) async {
                          print('URL $url');
                          setState(() {
                            this.url = url.toString();
                            checkoutUrl = this.url;
                          });
                          print('CHECKOUT URL $checkoutUrl');
                          // if (checkoutUrl.contains('transaction_status=capture') || checkoutUrl.contains('transaction_status=settlement')) {
                          //   Uri uri = Uri.parse(checkoutUrl);
                          //   String paymentRequestId =
                          //       uri.queryParameters['order_id'];
                          // }
                          await _checkPaymentStatus(orderID!);
                        },
                        androidOnPermissionRequest:
                            (controller, origin, resources) async {
                          return PermissionRequestResponse(
                              resources: resources,
                              action: PermissionRequestResponseAction.GRANT);
                        },
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          var uri = navigationAction.request.url;

                          if (![
                            "http",
                            "https",
                            "file",
                            "chrome",
                            "data",
                            "javascript",
                            "about"
                          ].contains(uri!.scheme)) {
                            if (await canLaunch(url)) {
                              // Launch the App
                              await launch(
                                url,
                              );
                              // and cancel the request
                              return NavigationActionPolicy.CANCEL;
                            }
                          }

                          return NavigationActionPolicy.ALLOW;
                        },
                        onLoadStop: (controller, url) async {
                          setState(() {
                            this.url = url.toString();
                            checkoutUrl = this.url;
                          });
                        },
                        onLoadError: (controller, url, code, message) {},
                        onProgressChanged: (controller, progress) {
                          if (progress == 100) {
                            // pullToRefreshController.endRefreshing();
                          }
                          setState(() {
                            this.progress = progress / 100;
                            checkoutUrl = this.url;
                          });
                        },
                        onUpdateVisitedHistory:
                            (controller, url, androidIsReload) {
                          setState(() {
                            this.url = url.toString();
                            checkoutUrl = this.url;
                          });
                        },
                        onConsoleMessage: (controller, consoleMessage) {
                          print(consoleMessage);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Center(child: Container(child: CustomLoadingWidget())),
    );
  }

  Future _checkPaymentStatus(String paymentRequestId) async {
    print('PAYMENT ID $paymentRequestId');
    final url = Uri.parse(
        '$midTransServerUrl/check_midtrans_transaction?trxID=$paymentRequestId');

    var response = await http.post(url);
    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["response"]['transaction_status'] == 'capture' ||
          realResponse["response"]['transaction_status'] == 'settlement') {
        print('FAD ${realResponse["response"]['fraud_status']}');

        if (realResponse["response"]['fraud_status'] != null) {
          if (realResponse["response"]['fraud_status'] == 'accept') {
            widget.onFinish!(realResponse["response"]['order_id']);
            Get.back();
          } else {
            SnackBars()
                .snackBarError('Payment cancelled/failed. Please try again.');
            Get.back();
          }
        } else {
          widget.onFinish!(realResponse["response"]['order_id']);
          Get.back();
        }
      } else {
        SnackBars()
            .snackBarError('Payment cancelled/failed. Please try again.');
        Get.back();
      }
    } else {
      SnackBars().snackBarError('PAYMENT FAILED');
      Get.back();
    }
  }
}
