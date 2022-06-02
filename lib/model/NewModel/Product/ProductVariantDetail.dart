class ProductVariantDetail {
  ProductVariantDetail({
    this.value,
    this.code,
    this.attrValId,
    this.name,
    this.attrId,
  });

  List<String>? value;
  List<String>? code;
  List<int>? attrValId;
  String? name;
  int? attrId;

  factory ProductVariantDetail.fromJson(Map<String, dynamic> json) =>
      ProductVariantDetail(
        value: List<String>.from(json["value"].map((x) => x)),
        code: List<String>.from(json["code"].map((x) => x)),
        attrValId: List<int>.from(json["attr_val_id"].map((x) => x)),
        name: json["name"],
        attrId: json["attr_id"],
      );

  Map<String, dynamic> toJson() => {
        "value": List<dynamic>.from(value!.map((x) => x)),
        "code": List<dynamic>.from(code!.map((x) => x)),
        "attr_val_id": List<dynamic>.from(attrValId!.map((x) => x)),
        "name": name,
        "attr_id": attrId,
      };
}
