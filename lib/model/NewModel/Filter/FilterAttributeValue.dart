class FilterAttributeValue {
  FilterAttributeValue({
    this.id,
    this.value,
    this.attributeId,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? value;
  dynamic attributeId;
  DateTime? createdAt;
  dynamic updatedAt;

  factory FilterAttributeValue.fromJson(Map<String, dynamic> json) =>
      FilterAttributeValue(
        id: json["id"],
        value: json["value"],
        attributeId: json["attribute_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "attribute_id": attributeId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt,
      };
}
