import 'dart:convert';

import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Filter/FilterAttributeElement.dart';

import '../Filter/FilterColor.dart';

SingleBrandModel singleBrandModelFromJson(String str) =>
    SingleBrandModel.fromJson(json.decode(str));

String singleBrandModelToJson(SingleBrandModel data) =>
    json.encode(data.toJson());

class SingleBrandModel {
  SingleBrandModel({
    this.data,
    this.attributes,
    this.color,
    this.categories,
    this.lowestPrice,
    this.heightPrice,
  });

  BrandData? data;
  List<FilterAttributeElement>? attributes;
  FilterColor? color;
  List<CategoryData>? categories;
  dynamic lowestPrice;
  dynamic heightPrice;

  factory SingleBrandModel.fromJson(Map<String, dynamic> json) =>
      SingleBrandModel(
        data: BrandData.fromJson(json["data"]),
        attributes: List<FilterAttributeElement>.from(
            json["attributes"].map((x) => FilterAttributeElement.fromJson(x))),
        color:
            json["color"] == null ? null : FilterColor.fromJson(json["color"]),
        categories: List<CategoryData>.from(
            json["categories"].map((x) => CategoryData.fromJson(x))),
        lowestPrice: json["lowest_price"] == null ? null : json["lowest_price"],
        heightPrice: json["height_price"] == null ? null : json["height_price"],
      );

  Map<String, dynamic> toJson() => {
        "data": data!.toJson(),
        "attributes": List<dynamic>.from(attributes!.map((x) => x.toJson())),
        "color": color!.toJson(),
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "lowest_price": lowestPrice,
        "height_price": heightPrice,
      };
}
