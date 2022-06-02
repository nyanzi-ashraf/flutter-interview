// To parse this JSON data, do
//
//     final paymentGatewayModel = paymentGatewayModelFromJson(jsonString);

import 'dart:convert';

PaymentGatewayModel paymentGatewayModelFromJson(String str) =>
    PaymentGatewayModel.fromJson(json.decode(str));

String paymentGatewayModelToJson(PaymentGatewayModel data) =>
    json.encode(data.toJson());

class PaymentGatewayModel {
  PaymentGatewayModel({
    this.data,
  });

  List<Gateway>? data;

  factory PaymentGatewayModel.fromJson(Map<String, dynamic> json) =>
      PaymentGatewayModel(
        data: List<Gateway>.from(json["data"].map((x) => Gateway.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Gateway {
  Gateway({
    this.id,
    this.method,
    this.type,
    this.activeStatus,
    this.moduleStatus,
    this.logo,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? method;
  String? type;
  int? activeStatus;
  int? moduleStatus;
  String? logo;
  int? createdBy;
  int? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Gateway.fromJson(Map<String, dynamic> json) => Gateway(
        id: json["id"],
        method: json["method"],
        type: json["type"],
        activeStatus: json["active_status"],
        moduleStatus: json["module_status"],
        logo: json["logo"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method": method,
        "type": type,
        "active_status": activeStatus,
        "module_status": moduleStatus,
        "logo": logo,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
