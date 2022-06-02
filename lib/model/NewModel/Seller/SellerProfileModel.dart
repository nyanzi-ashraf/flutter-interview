// To parse this JSON data, do
//
//     final sellerProfileModel = sellerProfileModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Category/ParentCategory.dart';
import 'package:amazcart/model/NewModel/Seller/SellerData.dart';
import 'package:amazcart/model/NewModel/Seller/SellerProductApi.dart';

SellerProfileModel sellerProfileModelFromJson(String str) =>
    SellerProfileModel.fromJson(json.decode(str));

String sellerProfileModelToJson(SellerProfileModel data) =>
    json.encode(data.toJson());

class SellerProfileModel {
  SellerProfileModel({
    this.seller,
    this.categoryList,
    this.brandList,
    this.lowestPrice,
    this.heightPrice,
    this.message,
  });

  SellerData? seller;
  List<CategoryList>? categoryList;
  List<BrandData>? brandList;
  dynamic lowestPrice;
  dynamic heightPrice;
  String? message;

  factory SellerProfileModel.fromJson(Map<String, dynamic> json) =>
      SellerProfileModel(
        seller: SellerData.fromJson(json["seller"]),
        categoryList: List<CategoryList>.from(
            json["categoryList"].map((x) => CategoryList.fromJson(x))),
        brandList: List<BrandData>.from(
            json["brandList"].map((x) => BrandData.fromJson(x))),
        lowestPrice: json["lowestPrice"],
        heightPrice: json["heightPrice"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "seller": seller!.toJson(),
        "categoryList":
            List<dynamic>.from(categoryList!.map((x) => x.toJson())),
        "brandList": List<dynamic>.from(brandList!.map((x) => x.toJson())),
        "lowestPrice": lowestPrice,
        "heightPrice": heightPrice,
        "message": message,
      };
}

class CategoryList {
  CategoryList({
    this.id,
    this.name,
    this.slug,
    this.parentId,
    this.depthLevel,
    this.icon,
    this.searchable,
    this.status,
    this.totalSale,
    this.avgRating,
    this.commissionRate,
    this.createdAt,
    this.updatedAt,
    this.allProducts,
    this.parentCategory,
  });

  dynamic id;
  String? name;
  String? slug;
  dynamic parentId;
  dynamic depthLevel;
  String? icon;
  dynamic searchable;
  dynamic status;
  dynamic totalSale;
  dynamic avgRating;
  dynamic commissionRate;
  DateTime? createdAt;
  DateTime? updatedAt;
  SellerProductsApi? allProducts;
  ParentCategory? parentCategory;

  factory CategoryList.fromJson(Map<String, dynamic> json) => CategoryList(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        parentId: json["parent_id"],
        depthLevel: json["depth_level"],
        icon: json["icon"],
        searchable: json["searchable"],
        status: json["status"],
        totalSale: json["total_sale"],
        avgRating: json["avg_rating"],
        commissionRate: json["commission_rate"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        allProducts: SellerProductsApi.fromJson(json["AllProducts"]),
        parentCategory: json["parent_category"] == null
            ? null
            : ParentCategory.fromJson(json["parent_category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "parent_id": parentId,
        "depth_level": depthLevel,
        "icon": icon,
        "searchable": searchable,
        "status": status,
        "total_sale": totalSale,
        "avg_rating": avgRating,
        "commission_rate": commissionRate,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "AllProducts": allProducts!.toJson(),
        "parent_category":
            parentCategory == null ? null : parentCategory!.toJson(),
      };
}
