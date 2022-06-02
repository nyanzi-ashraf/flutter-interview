// To parse this JSON data, do
//
//     final generalSettingsModel = generalSettingsModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Currency.dart';

GeneralSettingsModel generalSettingsModelFromJson(String str) =>
    GeneralSettingsModel.fromJson(json.decode(str));

String generalSettingsModelToJson(GeneralSettingsModel data) =>
    json.encode(data.toJson());

class GeneralSettingsModel {
  GeneralSettingsModel({
    this.settings,
    this.currencies,
    this.vendorType,
    this.msg,
  });

  Setting? settings;
  List<Currency>? currencies;
  String? vendorType;
  String? msg;

  factory GeneralSettingsModel.fromJson(Map<String, dynamic> json) =>
      GeneralSettingsModel(
        settings: Setting.fromJson(json['settings']),
        currencies: List<Currency>.from(
            json["currencies"].map((x) => Currency.fromJson(x))),
        vendorType: json["vendorType"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "settings": settings!.toJson(),
        "currencies": List<dynamic>.from(currencies!.map((x) => x.toJson())),
        "vendorType": vendorType,
        "msg": msg,
      };
}

class Setting {
  Setting({
    this.siteTitle,
    this.companyName,
    this.countryName,
    this.zipCode,
    this.address,
    this.phone,
    this.email,
    this.currencySymbol,
    this.logo,
    this.favicon,
    this.currencyCode,
    this.copyrightText,
    this.languageCode,
    this.cityId,
    this.countryId,
    this.stateId,
  });

  String? siteTitle;
  String? companyName;
  String? countryName;
  String? zipCode;
  String? address;
  String? phone;
  String? email;
  String? currencySymbol;
  String? logo;
  String? favicon;
  String? currencyCode;
  String? copyrightText;
  String? languageCode;
  int? countryId;
  int? stateId;
  int? cityId;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        siteTitle: json["site_title"],
        companyName: json["company_name"],
        countryName: json["country_name"],
        zipCode: json["zip_code"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        currencySymbol: json["currency_symbol"],
        logo: json["logo"],
        favicon: json["favicon"],
        currencyCode: json["currency_code"],
        copyrightText: json["copyright_text"],
        languageCode: json["language_code"],
        countryId: json["country_id"],
        stateId: json["state_id"],
        cityId: json["city_id"],
      );

  Map<String, dynamic> toJson() => {
        "site_title": siteTitle,
        "company_name": companyName,
        "country_name": countryName,
        "zip_code": zipCode,
        "address": address,
        "phone": phone,
        "email": email,
        "currency_symbol": currencySymbol,
        "logo": logo,
        "favicon": favicon,
        "currency_code": currencyCode,
        "copyright_text": copyrightText,
        "language_code": languageCode,
        "country_id": countryId,
        "state_id": stateId,
        "city_id": cityId,
      };
}
