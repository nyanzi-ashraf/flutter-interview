import 'dart:convert';

import 'CategoryData.dart';

CategoryMain categoryFromJson(String str) =>
    CategoryMain.fromJson(json.decode(str));

String categoryToJson(CategoryMain data) => json.encode(data.toJson());

class CategoryMain {
  CategoryMain({
    this.data,
  });

  List<CategoryData>? data;

  factory CategoryMain.fromJson(Map<String, dynamic> json) => CategoryMain(
        data: List<CategoryData>.from(
            json["data"].map((x) => CategoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
