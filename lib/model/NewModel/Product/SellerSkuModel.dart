// To parse this JSON data, do
//
//     final sellerSkuModel = sellerSkuModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Product/ProductSkus.dart';

SellerSkuModel sellerSkuModelFromJson(String str) =>
    SellerSkuModel.fromJson(json.decode(str));

String sellerSkuModelToJson(SellerSkuModel data) => json.encode(data.toJson());

class SellerSkuModel {
  SellerSkuModel({
    this.data,
  });

  SkuData? data;

  factory SellerSkuModel.fromJson(Map<String, dynamic> json) => SellerSkuModel(
        data: SkuData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
      };
}

class SkuData {
  SkuData({
    this.id,
    this.userId,
    this.productId,
    this.productSkuId,
    this.productStock,
    this.purchasePrice,
    this.sellingPrice,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.sku,
  });

  dynamic id;
  dynamic userId;
  dynamic productId;
  String? productSkuId;
  dynamic productStock;
  dynamic purchasePrice;
  dynamic sellingPrice;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductSku? sku;

  factory SkuData.fromJson(Map<String, dynamic> json) => SkuData(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productSkuId: json["product_sku_id"],
        productStock: json["product_stock"],
        purchasePrice: json["purchase_price"],
        sellingPrice: json["selling_price"] == null
            ? 0
            : json["selling_price"].toDouble(),
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sku: ProductSku.fromJson(json["sku"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "product_sku_id": productSkuId,
        "product_stock": productStock,
        "purchase_price": purchasePrice,
        "selling_price": sellingPrice,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "sku": sku!.toJson(),
      };
}
