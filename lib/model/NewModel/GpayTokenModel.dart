// To parse this JSON data, do
//
//     final gpayTokenModel = gpayTokenModelFromJson(jsonString);

import 'dart:convert';

GpayTokenModel gpayTokenModelFromJson(String str) =>
    GpayTokenModel.fromJson(json.decode(str));

String gpayTokenModelToJson(GpayTokenModel data) => json.encode(data.toJson());

class GpayTokenModel {
  GpayTokenModel({
    this.apiVersionMinor,
    this.apiVersion,
    this.paymentMethodData,
  });

  int? apiVersionMinor;
  int? apiVersion;
  PaymentMethodData? paymentMethodData;

  factory GpayTokenModel.fromJson(Map<String, dynamic> json) => GpayTokenModel(
        apiVersionMinor: json["apiVersionMinor"],
        apiVersion: json["apiVersion"],
        paymentMethodData:
            PaymentMethodData.fromJson(json["paymentMethodData"]),
      );

  Map<String, dynamic> toJson() => {
        "apiVersionMinor": apiVersionMinor,
        "apiVersion": apiVersion,
        "paymentMethodData": paymentMethodData!.toJson(),
      };
}

class PaymentMethodData {
  PaymentMethodData({
    this.description,
    this.tokenizationData,
    this.type,
    this.info,
  });

  String? description;
  TokenizationData? tokenizationData;
  String? type;
  Info? info;

  factory PaymentMethodData.fromJson(Map<String, dynamic> json) =>
      PaymentMethodData(
        description: json["description"],
        tokenizationData: TokenizationData.fromJson(json["tokenizationData"]),
        type: json["type"],
        info: Info.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "tokenizationData": tokenizationData!.toJson(),
        "type": type,
        "info": info!.toJson(),
      };
}

class Info {
  Info({
    this.cardNetwork,
    this.cardDetails,
  });

  String? cardNetwork;
  String? cardDetails;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        cardNetwork: json["cardNetwork"],
        cardDetails: json["cardDetails"],
      );

  Map<String, dynamic> toJson() => {
        "cardNetwork": cardNetwork,
        "cardDetails": cardDetails,
      };
}

class TokenizationData {
  TokenizationData({
    this.type,
    this.token,
  });

  String? type;
  String? token;

  factory TokenizationData.fromJson(Map<String, dynamic> json) =>
      TokenizationData(
        type: json["type"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "token": token,
      };
}

Token tokenFromJson(String str) => Token.fromJson(json.decode(str));

String tokenToJson(Token data) => json.encode(data.toJson());

class Token {
  Token({
    this.id,
    this.object,
    this.card,
    this.clientIp,
    this.created,
    this.livemode,
    this.type,
    this.used,
  });

  String? id;
  String? object;
  Card? card;
  String? clientIp;
  int? created;
  bool? livemode;
  String? type;
  bool? used;

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        id: json["id"],
        object: json["object"],
        card: Card.fromJson(json["card"]),
        clientIp: json["client_ip"],
        created: json["created"],
        livemode: json["livemode"],
        type: json["type"],
        used: json["used"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "card": card!.toJson(),
        "client_ip": clientIp,
        "created": created,
        "livemode": livemode,
        "type": type,
        "used": used,
      };
}

class Card {
  Card({
    this.id,
    this.object,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.brand,
    this.country,
    this.cvcCheck,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.funding,
    this.last4,
    this.metadata,
    this.name,
    this.tokenizationMethod,
  });

  String? id;
  String? object;
  dynamic addressCity;
  dynamic addressCountry;
  dynamic addressLine1;
  dynamic addressLine1Check;
  dynamic addressLine2;
  dynamic addressState;
  dynamic addressZip;
  dynamic addressZipCheck;
  String? brand;
  String? country;
  dynamic cvcCheck;
  String? dynamicLast4;
  int? expMonth;
  int? expYear;
  String? funding;
  String? last4;
  Metadata? metadata;
  String? name;
  String? tokenizationMethod;

  factory Card.fromJson(Map<String, dynamic> json) => Card(
        id: json["id"],
        object: json["object"],
        addressCity: json["address_city"],
        addressCountry: json["address_country"],
        addressLine1: json["address_line1"],
        addressLine1Check: json["address_line1_check"],
        addressLine2: json["address_line2"],
        addressState: json["address_state"],
        addressZip: json["address_zip"],
        addressZipCheck: json["address_zip_check"],
        brand: json["brand"],
        country: json["country"],
        cvcCheck: json["cvc_check"],
        dynamicLast4: json["dynamic_last4"],
        expMonth: json["exp_month"],
        expYear: json["exp_year"],
        funding: json["funding"],
        last4: json["last4"],
        metadata: Metadata.fromJson(json["metadata"]),
        name: json["name"],
        tokenizationMethod: json["tokenization_method"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "address_city": addressCity,
        "address_country": addressCountry,
        "address_line1": addressLine1,
        "address_line1_check": addressLine1Check,
        "address_line2": addressLine2,
        "address_state": addressState,
        "address_zip": addressZip,
        "address_zip_check": addressZipCheck,
        "brand": brand,
        "country": country,
        "cvc_check": cvcCheck,
        "dynamic_last4": dynamicLast4,
        "exp_month": expMonth,
        "exp_year": expYear,
        "funding": funding,
        "last4": last4,
        "metadata": metadata!.toJson(),
        "name": name,
        "tokenization_method": tokenizationMethod,
      };
}

class Metadata {
  Metadata();

  factory Metadata.fromJson(Map<String, dynamic> json) => Metadata();

  Map<String, dynamic> toJson() => {};
}
