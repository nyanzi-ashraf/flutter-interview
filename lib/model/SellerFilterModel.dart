// To parse this JSON data, do
//
//     final sellerFilterModel = sellerFilterModelFromJson(jsonString);

import 'dart:convert';

SellerFilterModel sellerFilterModelFromJson(String str) =>
    SellerFilterModel.fromJson(json.decode(str));

String sellerFilterModelToJson(SellerFilterModel data) =>
    json.encode(data.toJson());

class SellerFilterModel {
  SellerFilterModel({
    this.filterType,
    this.sellerId,
    this.paginate,
    this.sortBy,
    this.page,
  });

  List<FilterType>? filterType;
  int? sellerId;
  int? paginate;
  String? sortBy;
  int? page;

  factory SellerFilterModel.fromJson(Map<String, dynamic> json) =>
      SellerFilterModel(
        filterType: List<FilterType>.from(
            json["filterType"].map((x) => FilterType.fromJson(x))),
        sellerId: json["seller_id"],
        paginate: json["paginate"],
        sortBy: json["sort_by"],
        page: json["page"],
      );

  Map<String, dynamic> toJson() => {
        "filterType": List<dynamic>.from(filterType!.map((x) => x.toJson())),
        "seller_id": sellerId,
        "paginate": paginate,
        "sort_by": sortBy,
        "page": page,
      };
}

class FilterType {
  FilterType({
    this.filterTypeId,
    this.filterTypeValue,
  });

  String? filterTypeId;
  List<String>? filterTypeValue;

  factory FilterType.fromJson(Map<String, dynamic> json) => FilterType(
        filterTypeId: json["filterTypeId"],
        filterTypeValue:
            List<String>.from(json["filterTypeValue"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "filterTypeId": filterTypeId,
        "filterTypeValue": List<dynamic>.from(filterTypeValue!.map((x) => x)),
      };
}
