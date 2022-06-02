class GalleryImageData {
  GalleryImageData({
    this.id,
    this.productId,
    this.imagesSource,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? productId;
  String? imagesSource;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GalleryImageData.fromJson(Map<String, dynamic> json) =>
      GalleryImageData(
        id: json["id"],
        productId: json["product_id"],
        imagesSource: json["images_source"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "images_source": imagesSource,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
