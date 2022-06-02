// To parse this JSON data, do
//
//     final brand = brandFromJson(jsonString);

import 'dart:convert';

import 'BrandData.dart';

BrandsMain brandFromJson(String str) => BrandsMain.fromJson(json.decode(str));

String brandToJson(BrandsMain data) => json.encode(data.toJson());

class BrandsMain {
  BrandsMain({
    required this.data,
  });

  List<BrandData> data;

  factory BrandsMain.fromJson(Map<String, dynamic> json) => BrandsMain(
        data: List<BrandData>.from(
            json["data"].map((x) => BrandData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
