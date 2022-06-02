class CategoryImage {
  CategoryImage({
    this.categoryId,
    this.id,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  dynamic categoryId;
  dynamic id;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CategoryImage.fromJson(Map<String, dynamic> json) => CategoryImage(
        categoryId: json["category_id"],
        id: json["id"] == null ? null : json["id"],
        image: json["image"] == null ? null : json["image"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "id": id == null ? null : id,
        "image": image == null ? null : image,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
      };
}
