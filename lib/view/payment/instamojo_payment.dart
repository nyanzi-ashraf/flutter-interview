import 'dart:convert';

import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/controller/checkout_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class InstaMojoPayment extends StatefulWidget {
  final Function? onFinish;
  final Map? orderData;
  final Map? paymentData;

  InstaMojoPayment({this.onFinish, this.orderData, this.paymentData});

  @override
  _InstaMojoPaymentState createState() => _InstaMojoPaymentState();
}

class _InstaMojoPaymentState extends State<InstaMojoPayment> {
  final CheckoutController checkoutController = Get.put(CheckoutController());
  final AddressController addressController = Get.put(AddressController());

  var kAndroidUserAgent =
      "Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36";

  String? checkoutUrl;

  // final flutterWebviewPlugin = new FlutterWebviewPlugin();

  double progress = 0;
  String url = "";
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  Future createRequest() async {
    final amount = (widget.orderData!['grand_total']).toInt();

    print(addressController.shippingAddress.value.phone);
    Map<String, String> body = {
      "amount": amount.toString(), //amount to be paid
      "purpose": "Order",
      "buyer_name": addressController.shippingAddress.value.name!,
      "email": addressController.shippingAddress.value.email!,
      // "phone": '01676345200',
      "allow_repeated_payments": "true",
      "send_email": "false",
      "send_sms": "false",
      "redirect_url": "${URLs.HOST}/instamojo-payment/status",
    };

    final url = Uri.parse('$instaMojoApiUrl/payment-requests/');
    var resp = await http.post(url,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded",
          "X-Api-Key": instaMojoApiKey,
          "X-Auth-Token": instaMojoAuthToken
        },
        body: body);
    var jsonString = json.decode(resp.body);
    print('JSON STRING $jsonString');
    if (jsonString['success'] == true) {
      String selectedUrl =
          json.decode(resp.body)["payment_request"]['longurl'].toString() +
              "?embed=form";
      setState(() {
        checkoutUrl = selectedUrl;
      });
    } else {
      SnackBars().snackBarError(json.decode(resp.body)['message'].toString());
    }
  }

  @override
  void initState() {
    createRequest();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Instamojo Payment',
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
                          if (checkoutUrl!.contains(
                              '${URLs.HOST}/instamojo-payment/status')) {
                            Uri uri = Uri.parse(checkoutUrl!);
                            String paymentRequestId =
                                uri.queryParameters['payment_id']!;
                            await _checkPaymentStatus(paymentRequestId);
                          }
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
                          // print(consoleMessage);
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
    final url = Uri.parse('$instaMojoApiUrl/payments/$paymentRequestId/');

    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "X-Api-Key": instaMojoApiKey,
      "X-Auth-Token": instaMojoAuthToken
    });
    var realResponse = json.decode(response.body);
    print(realResponse);
    if (realResponse['success'] == true) {
      if (realResponse["payment"]['status'] == 'Credit') {
        widget.onFinish!(realResponse["payment"]['payment_id']);
        Get.back();
      } else {
        SnackBars()
            .snackBarError('Payment cancelled/failed. Please try again.');
        Get.back();
      }
    } else {
      SnackBars().snackBarError('PAYMENT STATUS FAILED');
      Get.back();
      print("PAYMENT STATUS FAILED");
    }
  }
}
