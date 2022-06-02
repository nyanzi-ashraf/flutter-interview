// To parse this JSON data, do
//
//     final shippingMethodModel = shippingMethodModelFromJson(jsonString);

import 'dart:convert';

ShippingMethodModel shippingMethodModelFromJson(String str) =>
    ShippingMethodModel.fromJson(json.decode(str));

String shippingMethodModelToJson(ShippingMethodModel data) =>
    json.encode(data.toJson());

class ShippingMethodModel {
  ShippingMethodModel({
    this.shippings,
    this.msg,
  });

  List<Shipping>? shippings;
  String? msg;

  factory ShippingMethodModel.fromJson(Map<String, dynamic> json) =>
      ShippingMethodModel(
        shippings: List<Shipping>.from(
            json["shippings"].map((x) => Shipping.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "shippings": List<dynamic>.from(shippings!.map((x) => x.toJson())),
        "msg": msg,
      };
}

class Shipping {
  Shipping({
    this.id,
    this.methodName,
    this.carrierId,
    this.costBasedOn,
    this.logo,
    this.phone,
    this.shipmentTime,
    this.cost,
    this.isActive,
    this.requestByUser,
    this.isApproved,
    this.createdAt,
    this.updatedAt,
    this.carrier,
  });

  int? id;
  String? methodName;
  int? carrierId;
  String? costBasedOn;
  dynamic logo;
  String? phone;
  String? shipmentTime;
  double? cost;
  int? isActive;
  int? requestByUser;
  int? isApproved;
  DateTime? createdAt;
  DateTime? updatedAt;
  Carrier? carrier;

  factory Shipping.fromJson(Map<String, dynamic> json) => Shipping(
        id: json["id"],
        methodName: json["method_name"],
        carrierId: json["carrier_id"],
        costBasedOn: json["cost_based_on"],
        logo: json["logo"],
        phone: json["phone"] == null ? null : json["phone"],
        shipmentTime: json["shipment_time"],
        cost: json["cost"].toDouble(),
        isActive: json["is_active"],
        requestByUser: json["request_by_user"],
        isApproved: json["is_approved"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        carrier: Carrier.fromJson(json["carrier"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method_name": methodName,
        "carrier_id": carrierId,
        "cost_based_on": costBasedOn,
        "logo": logo,
        "phone": phone == null ? null : phone,
        "shipment_time": shipmentTime,
        "cost": cost,
        "is_active": isActive,
        "request_by_user": requestByUser,
        "is_approved": isApproved,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "carrier": carrier!.toJson(),
      };
}

class Carrier {
  Carrier({
    this.id,
    this.name,
    this.logo,
    this.type,
    this.slug,
    this.trackingUrl,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  dynamic logo;
  String? type;
  String? slug;
  dynamic trackingUrl;
  int? status;
  dynamic createdAt;
  dynamic updatedAt;

  factory Carrier.fromJson(Map<String, dynamic> json) => Carrier(
        id: json["id"],
        name: json["name"],
        logo: json["logo"],
        type: json["type"],
        slug: json["slug"],
        trackingUrl: json["tracking_url"],
        status: json["status"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "logo": logo,
        "type": type,
        "slug": slug,
        "tracking_url": trackingUrl,
        "status": status,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
