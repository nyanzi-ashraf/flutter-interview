// To parse this JSON data, do
//
//     final orderCancelReasonModel = orderCancelReasonModelFromJson(jsonString);

import 'dart:convert';

OrderCancelReasonModel orderCancelReasonModelFromJson(String str) =>
    OrderCancelReasonModel.fromJson(json.decode(str));

String orderCancelReasonModelToJson(OrderCancelReasonModel data) =>
    json.encode(data.toJson());

class OrderCancelReasonModel {
  OrderCancelReasonModel({
    this.reasons,
    this.message,
  });

  List<CancelReason>? reasons;
  String? message;

  factory OrderCancelReasonModel.fromJson(Map<String, dynamic> json) =>
      OrderCancelReasonModel(
        reasons: List<CancelReason>.from(
            json["reasons"].map((x) => CancelReason.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "reasons": List<dynamic>.from(reasons!.map((x) => x.toJson())),
        "message": message,
      };
}

class CancelReason {
  CancelReason({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CancelReason.fromJson(Map<String, dynamic> json) => CancelReason(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
