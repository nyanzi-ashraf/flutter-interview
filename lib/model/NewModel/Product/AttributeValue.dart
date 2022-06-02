import 'AttributeColor.dart';

class AttributeValue {
  AttributeValue({
    this.id,
    this.value,
    this.attributeId,
    this.createdAt,
    this.updatedAt,
    this.color,
  });

  int? id;
  String? value;
  int? attributeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  AttributeColor? color;

  factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
        id: json["id"],
        value: json["value"],
        attributeId: json["attribute_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        color: json["color"] == null
            ? null
            : AttributeColor.fromJson(json["color"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "attribute_id": attributeId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt! == null ? null : updatedAt!.toIso8601String(),
        "color": color == null ? null : color!.toJson(),
      };
}
