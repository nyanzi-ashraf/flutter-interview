// To parse this JSON data, do
//
//     final orderRefundReasonModel = orderRefundReasonModelFromJson(jsonString);

import 'dart:convert';

OrderRefundReasonModel orderRefundReasonModelFromJson(String str) =>
    OrderRefundReasonModel.fromJson(json.decode(str));

String orderRefundReasonModelToJson(OrderRefundReasonModel data) =>
    json.encode(data.toJson());

class OrderRefundReasonModel {
  OrderRefundReasonModel({
    this.reasons,
    this.measege,
  });

  List<RefundReason>? reasons;
  String? measege;

  factory OrderRefundReasonModel.fromJson(Map<String, dynamic> json) =>
      OrderRefundReasonModel(
        reasons: List<RefundReason>.from(
            json["reasons"].map((x) => RefundReason.fromJson(x))),
        measege: json["measege"],
      );

  Map<String, dynamic> toJson() => {
        "reasons": List<dynamic>.from(reasons!.map((x) => x.toJson())),
        "measege": measege,
      };
}

class RefundReason {
  RefundReason({
    this.id,
    this.reason,
  });

  int? id;
  String? reason;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory RefundReason.fromJson(Map<String, dynamic> json) => RefundReason(
        id: json["id"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "reason": reason,
      };
}
