// To parse this JSON data, do
//
//     final sliderModel = sliderModelFromJson(jsonString);

import 'dart:convert';

SliderModel sliderModelFromJson(String str) =>
    SliderModel.fromJson(json.decode(str));

String sliderModelToJson(SliderModel data) => json.encode(data.toJson());

class SliderModel {
  SliderModel({
    this.sliderData,
  });

  List<SliderData>? sliderData;

  factory SliderModel.fromJson(Map<String, dynamic> json) => SliderModel(
        sliderData: List<SliderData>.from(
            json["data"].map((x) => SliderData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(sliderData!.map((x) => x.toJson())),
      };
}

class SliderData {
  SliderData({
    this.id,
    this.name,
    this.url,
    this.dataType,
    this.dataId,
    this.sliderImage,
    this.status,
    this.isNewtab,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.tag,
  });

  dynamic id;
  String? name;
  dynamic url;
  SliderDataType? dataType;
  dynamic dataId;
  String? sliderImage;
  dynamic status;
  dynamic isNewtab;
  dynamic position;
  DateTime? createdAt;
  DateTime? updatedAt;
  Tag? tag;

  factory SliderData.fromJson(Map<String, dynamic> json) => SliderData(
        id: json["id"],
        name: json["name"],
        url: json["url"],
        dataType: nameValues.map![json["data_type"]],
        dataId: json["data_id"],
        sliderImage: json["slider_image"],
        status: json["status"],
        isNewtab: json["is_newtab"],
        position: json["position"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        tag: json["tag"] == null ? null : Tag.fromJson(json["tag"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
        "data_type": nameValues.reverse[dataType],
        "data_id": dataId,
        "slider_image": sliderImage,
        "status": status,
        "is_newtab": isNewtab,
        "position": position,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Tag {
  Tag({
    this.id,
    this.productId,
    this.tag,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? productId;
  String? tag;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
        id: json["id"],
        productId: json["product_id"],
        tag: json["tag"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "tag": tag,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

enum SliderDataType { PRODUCT, CATEGORY, BRAND, TAG }

final nameValues = EnumValues({
  "product": SliderDataType.PRODUCT,
  "category": SliderDataType.CATEGORY,
  "brand": SliderDataType.BRAND,
  "tag": SliderDataType.TAG,
});

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
