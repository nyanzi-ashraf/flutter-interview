// To parse this JSON data, do
//
//     final allGiftCardsModel = allGiftCardsModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

AllGiftCardsModel allGiftCardsModelFromJson(String str) =>
    AllGiftCardsModel.fromJson(json.decode(str));

String allGiftCardsModelToJson(AllGiftCardsModel data) =>
    json.encode(data.toJson());

class AllGiftCardsModel {
  AllGiftCardsModel({
    this.giftcards,
    this.seller,
    this.message,
  });

  Giftcards? giftcards;
  String? seller;
  String? message;

  factory AllGiftCardsModel.fromJson(Map<String, dynamic> json) =>
      AllGiftCardsModel(
        giftcards: Giftcards.fromJson(json["giftcards"]),
        seller: json["seller"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "giftcards": giftcards!.toJson(),
        "seller": seller,
        "message": message,
      };
}

class Giftcards {
  Giftcards({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  dynamic currentPage;
  List<ProductModel>? data;
  String? firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory Giftcards.fromJson(Map<String, dynamic> json) => Giftcards(
        currentPage: json["current_page"],
        data: List<ProductModel>.from(
            json["data"].map((x) => ProductModel.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"] == null ? null : json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"] == null ? null : json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from == null ? null : from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to == null ? null : to,
        "total": total,
      };
}
