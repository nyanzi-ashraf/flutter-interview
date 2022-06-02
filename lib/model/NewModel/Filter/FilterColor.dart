class FilterColor {
  FilterColor({
    this.id,
    this.name,
    this.displayType,
    this.description,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.values,
  });

  dynamic id;
  String? name;
  String? displayType;
  String? description;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<FilterColorValue>? values;

  factory FilterColor.fromJson(Map<String, dynamic> json) => FilterColor(
        id: json["id"],
        name: json["name"],
        displayType: json["display_type"],
        description: json["description"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        values: List<FilterColorValue>.from(
            json["values"].map((x) => FilterColorValue.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "display_type": displayType,
        "description": description,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "values": List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class FilterColorValue {
  FilterColorValue({
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
  DateTime? updatedAt;

  factory FilterColorValue.fromJson(Map<String, dynamic> json) =>
      FilterColorValue(
        id: json["id"],
        value: json["value"],
        attributeId: json["attribute_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "attribute_id": attributeId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
