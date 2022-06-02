// To parse this JSON data, do
//
//     final tagProductsModel = tagProductsModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Filter/FilterAttributeElement.dart';
import 'package:amazcart/model/NewModel/Filter/FilterColor.dart';
import 'package:amazcart/model/NewModel/Product/AllProducts.dart';
import 'package:amazcart/model/NewModel/Tags/TagData.dart';

TagProductsModel tagProductsModelFromJson(String str) =>
    TagProductsModel.fromJson(json.decode(str));

String tagProductsModelToJson(TagProductsModel data) =>
    json.encode(data.toJson());

class TagProductsModel {
  TagProductsModel({
    this.tag,
    this.products,
    this.message,
    this.categoryList,
    this.brandList,
    this.attributeLists,
    this.minPrice,
    this.maxPrice,
    this.color,
  });

  TagData? tag;
  String? message;
  AllProducts? products;
  List<CategoryData>? categoryList;
  List<BrandData>? brandList;
  List<FilterAttributeElement>? attributeLists;
  FilterColor? color;
  double? minPrice;
  double? maxPrice;

  factory TagProductsModel.fromJson(Map<String, dynamic> json) =>
      TagProductsModel(
        tag: TagData.fromJson(json["tag"]),
        products: AllProducts.fromJson(json["products"]),
        categoryList: List<CategoryData>.from(
            json["categoryList"].map((x) => CategoryData.fromJson(x))),
        brandList: List<BrandData>.from(
            json["brandList"].map((x) => BrandData.fromJson(x))),
        attributeLists: List<FilterAttributeElement>.from(json["attributeLists"]
            .map((x) => FilterAttributeElement.fromJson(x))),
        color:
            json["color"] == null ? null : FilterColor.fromJson(json["color"]),
        minPrice:
            json["min_price"] == null ? 0.0 : json["min_price"].toDouble(),
        maxPrice:
            json["max_price"] == null ? 0.0 : json["max_price"].toDouble(),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "tags": tag!.toJson(),
        "products": products!.toJson(),
        "categoryList":
            List<dynamic>.from(categoryList!.map((x) => x.toJson())),
        "brandList": List<dynamic>.from(brandList!.map((x) => x.toJson())),
        "attributeLists":
            List<dynamic>.from(attributeLists!.map((x) => x.toJson())),
        "color": color!.toJson(),
        "min_price": minPrice,
        "max_price": maxPrice,
        "message": message,
      };
}
