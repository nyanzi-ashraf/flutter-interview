class AttributeColor {
  AttributeColor({
    this.id,
    this.attributeValueId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? attributeValueId;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AttributeColor.fromJson(Map<String, dynamic> json) => AttributeColor(
        id: json["id"],
        attributeValueId: json["attribute_value_id"],
        name: json["name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attribute_value_id": attributeValueId,
        "name": name,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
