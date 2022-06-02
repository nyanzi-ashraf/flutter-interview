import 'dart:core';
import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/controller/checkout_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/payment/paypal/paypal_service.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  final Function? onFinish;

  PaypalPayment({this.onFinish});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState();
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? checkoutUrl;
  String? executeUrl;
  String? accessToken;
  PaypalServices? services = PaypalServices();

  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "$paypalCurrency ",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": paypalCurrency
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services!.getAccessToken();

        final transactions = getOrderParams();
        final res =
            await services!.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  Map<String, dynamic> getOrderParams() {
    final CheckoutController checkoutController = Get.put(CheckoutController());
    final AddressController addressController = Get.put(AddressController());
    List items = checkoutController.checkoutProducts;

    var sub = 0.0;
    items.forEach((element) {
      sub += element['price'] * element['quantity'];
    });

    var taxAmount =
        checkoutController.taxTotal.value + checkoutController.gstTotal.value;

    // checkout invoice details
    String taxTotal = taxAmount.toStringAsFixed(2);
    String totalAmount = (sub + checkoutController.shipping.value + taxAmount)
        .toStringAsFixed(2);
    String subTotalAmount = sub.toStringAsFixed(2);
    String shippingCost = checkoutController.shipping.value.toStringAsFixed(2);
    String userFirstName = addressController.shippingAddress.value.name!;
    String addressCity = addressController.shippingAddress.value.getCity!.name!;
    String addressStreet = addressController.shippingAddress.value.address!;
    String addressZipCode = addressController.shippingAddress.value.postalCode!;
    String addressCountry =
        addressController.shippingAddress.value.getCountry!.code!;
    String addressState =
        addressController.shippingAddress.value.getState!.name!;
    String addressPhoneNumber = addressController.shippingAddress.value.phone!;

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": totalAmount,
            "currency": defaultCurrency["currency"],
            "details": {
              "subtotal": subTotalAmount,
              "tax": taxTotal,
              "shipping": shippingCost,
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items,
            "shipping_address": {
              "recipient_name": userFirstName,
              "line1": addressStreet,
              "line2": "",
              "city": addressCity,
              "country_code": addressCountry,
              "postal_code": addressZipCode,
              "phone": addressPhoneNumber,
              "state": addressState
            },
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    print('Checkout url $checkoutUrl');

    if (checkoutUrl != null) {
      return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        // appBar: AppBar(
        //   backgroundColor: AppStyles.appBackgroundColor,
        //   title: Text('Paypal Payment', style: AppStyles.kFontBlack14w5,),
        //   leading: GestureDetector(
        //     child: Icon(Icons.arrow_back_ios,color: Colors.black,),
        //     onTap: () => Get.back(),
        //   ),
        // ),
        appBar: AppBarWidget(
          title: 'Paypal Payment',
        ),
        body: WebView(
          initialUrl: checkoutUrl,
          javascriptMode: JavascriptMode.unrestricted,
          navigationDelegate: (NavigationRequest request) {
            if (request.url.contains(returnURL)) {
              final uri = Uri.parse(request.url);
              final payerID = uri.queryParameters['PayerID'];
              if (payerID != null) {
                services!
                    .executePayment(executeUrl, payerID, accessToken)
                    .then((id) {
                  widget.onFinish!(id);
                  Get.back();
                });
              } else {
                Get.back();
              }
            }
            if (request.url.contains(cancelURL)) {
              Get.back();
            }
            return NavigationDecision.navigate;
          },
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Get.back();
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
