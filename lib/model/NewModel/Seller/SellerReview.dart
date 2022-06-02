class SellerReview {
  SellerReview({
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
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic customerId;
  dynamic sellerId;
  dynamic productId;
  dynamic orderId;
  dynamic packageId;
  String? type;
  String? review;
  dynamic rating;
  dynamic isAnonymous;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SellerReview.fromJson(Map<String, dynamic> json) => SellerReview(
        id: json["id"],
        customerId: json["customer_id"],
        sellerId: json["seller_id"],
        productId: json["product_id"] == null ? null : json["product_id"],
        orderId: json["order_id"],
        packageId: json["package_id"] == null ? null : json["package_id"],
        type: json["type"] == null ? null : json["type"],
        review: json["review"],
        rating: json["rating"],
        isAnonymous: json["is_anonymous"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "seller_id": sellerId,
        "product_id": productId == null ? null : productId,
        "order_id": orderId,
        "package_id": packageId == null ? null : packageId,
        "type": type == null ? null : type,
        "review": review,
        "rating": rating,
        "is_anonymous": isAnonymous,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
