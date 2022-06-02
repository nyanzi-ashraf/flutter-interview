class GiftCardData {
  GiftCardData({
    this.id,
    this.name,
    this.sku,
    this.sellingPrice,
    this.thumbnailImage,
    this.discount,
    this.discountType,
    this.startDate,
    this.endDate,
    this.description,
    this.status,
    this.avgRating,
    this.createdBy,
    this.updatedBy,
    this.shippingId,
  });

  dynamic id;
  String? name;
  String? sku;
  dynamic sellingPrice;
  String? thumbnailImage;
  dynamic discount;
  dynamic discountType;
  DateTime? startDate;
  DateTime? endDate;
  String? description;
  dynamic status;
  double? avgRating;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic shippingId;

  factory GiftCardData.fromJson(Map<String, dynamic> json) => GiftCardData(
        id: json["id"],
        name: json["name"],
        sku: json["sku"],
        sellingPrice: json["selling_price"],
        thumbnailImage: json["thumbnail_image"],
        discount: json["discount"],
        discountType: json["discount_type"].toString(),
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        description: json["description"],
        status: json["status"],
        avgRating: json["avg_rating"].toDouble(),
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        shippingId: json["shipping_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "selling_price": sellingPrice,
        "thumbnail_image": thumbnailImage,
        "discount": discount,
        "discount_type": discountType,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "description": description,
        "status": status,
        "avg_rating": avgRating,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "shipping_id": shippingId,
      };
}
