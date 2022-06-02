// To parse this JSON data, do
//
//     final bankInformationModel = bankInformationModelFromJson(jsonString);

import 'dart:convert';

BankInformationModel bankInformationModelFromJson(String str) =>
    BankInformationModel.fromJson(json.decode(str));

String bankInformationModelToJson(BankInformationModel data) =>
    json.encode(data.toJson());

class BankInformationModel {
  BankInformationModel({
    this.bankInfo,
    this.message,
  });

  BankInfo? bankInfo;
  String? message;

  factory BankInformationModel.fromJson(Map<String, dynamic> json) =>
      BankInformationModel(
        bankInfo: BankInfo.fromJson(json["bank_info"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "bank_info": bankInfo!.toJson(),
        "message": message,
      };
}

class BankInfo {
  BankInfo({
    this.bankName,
    this.branchName,
    this.accountNumber,
    this.accountHolder,
  });

  String? bankName;
  String? branchName;
  String? accountNumber;
  String? accountHolder;

  factory BankInfo.fromJson(Map<String, dynamic> json) => BankInfo(
        bankName: json["bank_name"],
        branchName: json["branch_name"],
        accountNumber: json["account_number"],
        accountHolder: json["account_holder"],
      );

  Map<String, dynamic> toJson() => {
        "bank_name": bankName,
        "branch_name": branchName,
        "account_number": accountNumber,
        "account_holder": accountHolder,
      };
}
