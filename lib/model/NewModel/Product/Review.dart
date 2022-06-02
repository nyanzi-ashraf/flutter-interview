import 'package:amazcart/model/NewModel/Customer/CustomerData.dart';

import 'ProductType.dart';

class Review {
  Review({
    this.id,
    this.customerId,
    this.sellerId,
    this.productId,
    this.orderId,
    this.packageId,
    this.type,
    this.review,
    this.rating,
    this.isAnonymous,
    this.status,
    this.customer,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? customerId;
  int? sellerId;
  int? productId;
  int? orderId;
  int? packageId;
  ProductType? type;
  String? review;
  int? rating;
  int? isAnonymous;
  int? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  CustomerData? customer;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        customerId: json["customer_id"],
        sellerId: json["seller_id"],
        productId: json["product_id"],
        orderId: json["order_id"],
        packageId: json["package_id"],
        type: typeValues.map![json["type"]],
        review: json["review"],
        rating: json["rating"],
        isAnonymous: json["is_anonymous"],
        status: json["status"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        customer: json["customer"] == null
            ? null
            : CustomerData.fromJson(json["customer"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "seller_id": sellerId,
        "product_id": productId,
        "order_id": orderId,
        "package_id": packageId,
        "type": typeValues.reverse[type],
        "review": review,
        "rating": rating,
        "is_anonymous": isAnonymous,
        "status": status,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": createdAt == null ? null : updatedAt!.toIso8601String(),
        "customer": customer == null ? null : customer!.toJson(),
      };
}
