import 'dart:convert';
import 'dart:developer';

import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/payment_gateway_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:paytm_allinonesdk/paytm_allinonesdk.dart';

class PayTmService {
  final CurrencyController currencyController = Get.put(CurrencyController());

  String result = "";
  Future payTmPayment({
    Map? trxData,
    String? orderId,
    String? token,
    String? orderAmount,
    Map? orderData,
  }) async {
    try {
      var response = await http.post(
        Uri.parse(initiatePayTmTransaction),
        body: jsonEncode(trxData),
        headers: {'Accept': '*/*', 'Content-Type': 'application/json'},
      );
      var jsonString = jsonDecode(response.body);
      final transactionToken = payTmTransactionDataFromJson(
          jsonString['returnJson']['body']['response']);
      print(transactionToken.body!.txnToken!);

      var response2 = AllInOneSdk.startTransaction(
          payTMmid,
          trxData!['orderId'],
          trxData!['amount'].toString(),
          transactionToken.body!.txnToken!,
          trxData!['callbackUrl'],
          true,
          false);
      response2.then((value) async {
        log(value.toString());

        if (value!['STATUS'] == "TXN_SUCCESS") {
          trxData!.addAll({'transection_id': value!['TXNID']});

          final PaymentGatewayController controller =
              Get.put(PaymentGatewayController());
          await controller.paymentInfoStore(
              paymentData: trxData,
              orderData: orderData,
              transactionID: value!['TXNID']);
        }

        // print(value.toString());

        // result = value.toString();
        // print(result.toString());
      }).catchError((onError) {
        if (onError is PlatformException) {
          log("PLatform error ${onError.message! + " \n  " + onError.details.toString()}");
        } else {
          log("ERROR => ${onError.toString()}");
        }
      });
    } catch (err) {
      // result = err.message;
      // log("CATCH -> ${err.message}");
    }
  }

  Future initPayTmTransaction(
      {String? orderId,
      String? amount,
      String? txnToken,
      String? callBackUrl}) async {
    try {} catch (e) {
      log(e.toString());
    }
  }
}

// To parse this JSON data, do
//
//     final payTmTransactionData = payTmTransactionDataFromJson(jsonString);

PayTmTransactionData payTmTransactionDataFromJson(String str) =>
    PayTmTransactionData.fromJson(json.decode(str));

String payTmTransactionDataToJson(PayTmTransactionData data) =>
    json.encode(data.toJson());

class PayTmTransactionData {
  PayTmTransactionData({
    this.head,
    this.body,
  });

  Head? head;
  Body? body;

  factory PayTmTransactionData.fromJson(Map<String, dynamic> json) =>
      PayTmTransactionData(
        head: Head.fromJson(json["head"]),
        body: Body.fromJson(json["body"]),
      );

  Map<String, dynamic> toJson() => {
        "head": head!.toJson(),
        "body": body!.toJson(),
      };
}

class Body {
  Body({
    this.resultInfo,
    this.txnToken,
    this.isPromoCodeValid,
    this.authenticated,
  });

  ResultInfo? resultInfo;
  String? txnToken;
  bool? isPromoCodeValid;
  bool? authenticated;

  factory Body.fromJson(Map<String, dynamic> json) => Body(
        resultInfo: ResultInfo.fromJson(json["resultInfo"]),
        txnToken: json["txnToken"],
        isPromoCodeValid: json["isPromoCodeValid"],
        authenticated: json["authenticated"],
      );

  Map<String, dynamic> toJson() => {
        "resultInfo": resultInfo!.toJson(),
        "txnToken": txnToken,
        "isPromoCodeValid": isPromoCodeValid,
        "authenticated": authenticated,
      };
}

class ResultInfo {
  ResultInfo({
    this.resultStatus,
    this.resultCode,
    this.resultMsg,
  });

  String? resultStatus;
  String? resultCode;
  String? resultMsg;

  factory ResultInfo.fromJson(Map<String, dynamic> json) => ResultInfo(
        resultStatus: json["resultStatus"],
        resultCode: json["resultCode"],
        resultMsg: json["resultMsg"],
      );

  Map<String, dynamic> toJson() => {
        "resultStatus": resultStatus,
        "resultCode": resultCode,
        "resultMsg": resultMsg,
      };
}

class Head {
  Head({
    this.responseTimestamp,
    this.version,
    this.signature,
  });

  String? responseTimestamp;
  String? version;
  String? signature;

  factory Head.fromJson(Map<String, dynamic> json) => Head(
        responseTimestamp: json["responseTimestamp"],
        version: json["version"],
        signature: json["signature"],
      );

  Map<String, dynamic> toJson() => {
        "responseTimestamp": responseTimestamp,
        "version": version,
        "signature": signature,
      };
}
