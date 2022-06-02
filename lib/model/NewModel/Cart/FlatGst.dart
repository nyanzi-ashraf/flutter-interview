class FlatGst {
  FlatGst({
    this.id,
    this.name,
    this.taxPercentage,
    this.isActive,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? name;
  dynamic taxPercentage;
  dynamic isActive;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory FlatGst.fromJson(Map<String, dynamic> json) => FlatGst(
        id: json["id"],
        name: json["name"],
        taxPercentage: json["tax_percentage"].toDouble(),
        isActive: json["is_active"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "tax_percentage": taxPercentage,
        "is_active": isActive,
        "created_by": createdBy,
        "updated_by": updatedBy == null ? null : updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
