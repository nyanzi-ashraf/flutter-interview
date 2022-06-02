// To parse this JSON data, do
//
//     final couponApplyModel = couponApplyModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

CouponApplyModel couponApplyModelFromJson(String str) =>
    CouponApplyModel.fromJson(json.decode(str));

String couponApplyModelToJson(CouponApplyModel data) =>
    json.encode(data.toJson());

class CouponApplyModel {
  CouponApplyModel({
    this.coupon,
    this.message,
  });

  Coupon? coupon;
  String? message;

  factory CouponApplyModel.fromJson(Map<String, dynamic> json) =>
      CouponApplyModel(
        coupon: Coupon.fromJson(json["coupon"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "coupon": coupon!.toJson(),
        "message": message,
      };
}

class Coupon {
  Coupon({
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
    this.products,
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
  List<ProductElement>? products;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        id: json["id"],
        title: json["title"],
        couponCode: json["coupon_code"],
        couponType: json["coupon_type"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        discount: json["discount"],
        discountType: json["discount_type"],
        minimumShopping: json["minimum_shopping"],
        maximumDiscount: json["maximum_discount"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isExpire: json["is_expire"],
        isMultipleBuy: json["is_multiple_buy"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
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
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
      };
}

class ProductElement {
  ProductElement({
    this.id,
    this.couponId,
    this.couponCode,
    this.productId,
    this.createdAt,
    this.updatedAt,
    this.product,
  });

  dynamic id;
  dynamic couponId;
  String? couponCode;
  dynamic productId;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductModel? product;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        id: json["id"],
        couponId: json["coupon_id"],
        couponCode: json["coupon_code"],
        productId: json["product_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        product: ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "coupon_id": couponId,
        "coupon_code": couponCode,
        "product_id": productId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "product": product!.toJson(),
      };
}
