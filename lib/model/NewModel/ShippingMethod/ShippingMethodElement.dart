import 'ShippingMethodData.dart';

class ShippingMethodElement {
  ShippingMethodElement({
    this.id,
    this.productId,
    this.shippingMethodId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.shippingMethod,
  });

  int? id;
  int? productId;
  int? shippingMethodId;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  ShippingMethodData? shippingMethod;

  factory ShippingMethodElement.fromJson(Map<String, dynamic> json) =>
      ShippingMethodElement(
        id: json["id"],
        productId: json["product_id"],
        shippingMethodId: json["shipping_method_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        shippingMethod: ShippingMethodData.fromJson(json["shipping_method"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "shipping_method_id": shippingMethodId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "shipping_method": shippingMethod!.toJson(),
      };
}
