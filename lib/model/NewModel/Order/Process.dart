class Process {
  Process({
    this.id,
    this.name,
    this.description,
    this.attributeValueId,
  });

  dynamic? id;
  String? name;
  String? description;
  dynamic attributeValueId;

  factory Process.fromJson(Map<String, dynamic> json) => Process(
        id: json["id"],
        name: json["name"],
        description: json["description"] == null ? null : json["description"],
        attributeValueId: json["attribute_value_id"] == null
            ? null
            : json["attribute_value_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description == null ? null : description,
        "attribute_value_id":
            attributeValueId == null ? null : attributeValueId,
      };
}
