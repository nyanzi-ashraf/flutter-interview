// To parse this JSON data, do
//
//     final bankPaymentResponse = bankPaymentResponseFromJson(jsonString);

import 'dart:convert';

BankPaymentResponse bankPaymentResponseFromJson(String str) =>
    BankPaymentResponse.fromJson(json.decode(str));

String bankPaymentResponseToJson(BankPaymentResponse data) =>
    json.encode(data.toJson());

class BankPaymentResponse {
  BankPaymentResponse({
    this.paymentInfo,
    this.bankDetails,
    this.message,
  });

  PaymentInfo? paymentInfo;
  BankDetails? bankDetails;
  String? message;

  factory BankPaymentResponse.fromJson(Map<String, dynamic> json) =>
      BankPaymentResponse(
        paymentInfo: PaymentInfo.fromJson(json["payment_info"]),
        bankDetails: BankDetails.fromJson(json["bank_details"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "payment_info": paymentInfo!.toJson(),
        "bank_details": bankDetails!.toJson(),
        "message": message,
      };
}

class BankDetails {
  BankDetails({
    this.bankName,
    this.branchName,
    this.accountNumber,
    this.accountHolder,
    this.imageSrc,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  String? bankName;
  String? branchName;
  String? accountNumber;
  String? accountHolder;
  dynamic imageSrc;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
        bankName: json["bank_name"],
        branchName: json["branch_name"],
        accountNumber: json["account_number"],
        accountHolder: json["account_holder"],
        imageSrc: json["image_src"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "branch_name": branchName,
        "account_number": accountNumber,
        "account_holder": accountHolder,
        "image_src": imageSrc,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "id": id,
      };
}

class PaymentInfo {
  PaymentInfo({
    this.userId,
    this.amount,
    this.paymentMethod,
    this.txnId,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  int? userId;
  String? amount;
  int? paymentMethod;
  String? txnId;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory PaymentInfo.fromJson(Map<String, dynamic> json) => PaymentInfo(
        userId: json["user_id"],
        amount: json["amount"],
        paymentMethod: json["payment_method"],
        txnId: json["txn_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "amount": amount,
        "payment_method": paymentMethod,
        "txn_id": txnId,
        "updated_at": updatedAt!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "id": id,
      };
}
