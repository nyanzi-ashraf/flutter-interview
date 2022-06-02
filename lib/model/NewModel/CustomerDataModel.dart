// To parse this JSON data, do
//
//     final customerDataModel = customerDataModelFromJson(jsonString);

import 'dart:convert';

CustomerDataModel customerDataModelFromJson(String str) =>
    CustomerDataModel.fromJson(json.decode(str));

String customerDataModelToJson(CustomerDataModel data) =>
    json.encode(data.toJson());

class CustomerDataModel {
  CustomerDataModel({
    this.walletRunningBalance,
    this.walletPendingBalance,
    this.totalCoupon,
    this.totalWishlist,
    this.message,
  });

  double? walletRunningBalance;
  int? walletPendingBalance;
  int? totalCoupon;
  int? totalWishlist;
  String? message;

  factory CustomerDataModel.fromJson(Map<String, dynamic> json) =>
      CustomerDataModel(
        walletRunningBalance: json["wallet_running_balance"] == null
            ? 0.0
            : json["wallet_running_balance"].toDouble(),
        walletPendingBalance: json["wallet_pending_balance"],
        totalCoupon: json["total_coupon"],
        totalWishlist: json["total_wishlist"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "wallet_running_balance": walletRunningBalance,
        "wallet_pending_balance": walletPendingBalance,
        "total_coupon": totalCoupon,
        "total_wishlist": totalWishlist,
        "message": message,
      };
}
