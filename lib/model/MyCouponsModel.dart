// To parse this JSON data, do
//
//     final myCouponsModel = myCouponsModelFromJson(jsonString);

import 'dart:convert';

MyCouponsModel myCouponsModelFromJson(String str) =>
    MyCouponsModel.fromJson(json.decode(str));

String myCouponsModelToJson(MyCouponsModel data) => json.encode(data.toJson());

class MyCouponsModel {
  MyCouponsModel({
    this.coupons,
    this.message,
  });

  List<CouponElement>? coupons;
  String? message;

  factory MyCouponsModel.fromJson(Map<String, dynamic> json) => MyCouponsModel(
        coupons: List<CouponElement>.from(
            json["coupons"].map((x) => CouponElement.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "coupons": List<dynamic>.from(coupons!.map((x) => x.toJson())),
        "message": message,
      };
}

class CouponElement {
  CouponElement({
    this.id,
    this.customerId,
    this.couponId,
    this.createdAt,
    this.updatedAt,
    this.coupon,
  });

  dynamic id;
  dynamic customerId;
  dynamic couponId;
  DateTime? createdAt;
  DateTime? updatedAt;
  CouponCoupon? coupon;

  factory CouponElement.fromJson(Map<String, dynamic> json) => CouponElement(
        id: json["id"],
        customerId: json["customer_id"],
        couponId: json["coupon_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        coupon: CouponCoupon.fromJson(json["coupon"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "coupon_id": couponId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "coupon": coupon!.toJson(),
      };
}

class CouponCoupon {
  CouponCoupon({
    this.id,
    this.title,
    this.couponCode,
    this.couponType,
    this.startDate,
    this.endDate,
    this.discount,
    this.discountType,
    this.minimumShopping,
    this.maximumDiscount,
    this.createdBy,
    this.updatedBy,
    this.isExpire,
    this.isMultipleBuy,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? title;
  String? couponCode;
  dynamic couponType;
  DateTime? startDate;
  DateTime? endDate;
  dynamic discount;
  dynamic discountType;
  dynamic minimumShopping;
  dynamic maximumDiscount;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic isExpire;
  dynamic isMultipleBuy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CouponCoupon.fromJson(Map<String, dynamic> json) => CouponCoupon(
        id: json["id"],
        title: json["title"],
        couponCode: json["coupon_code"],
        couponType: json["coupon_type"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        discount: json["discount"].toDouble(),
        discountType: json["discount_type"],
        minimumShopping: json["minimum_shopping"],
        maximumDiscount: json["maximum_discount"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isExpire: json["is_expire"],
        isMultipleBuy: json["is_multiple_buy"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "coupon_code": couponCode,
        "coupon_type": couponType,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "discount": discount,
        "discount_type": discountType,
        "minimum_shopping": minimumShopping,
        "maximum_discount": maximumDiscount,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "is_expire": isExpire,
        "is_multiple_buy": isMultipleBuy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
