import 'Attribute.dart';
import 'AttributeValue.dart';

class ProductVariation {
  ProductVariation({
    this.id,
    this.productId,
    this.productSkuId,
    this.attributeId,
    this.attributeValueId,
    this.attributeValue,
    this.attribute,
  });

  int? id;
  int? productId;
  int? productSkuId;
  int? attributeId;
  int? attributeValueId;
  AttributeValue? attributeValue;
  Attribute? attribute;

  factory ProductVariation.fromJson(Map<String, dynamic> json) =>
      ProductVariation(
        id: json["id"],
        productId: json["product_id"],
        productSkuId: json["product_sku_id"],
        attributeId: json["attribute_id"],
        attributeValueId: json["attribute_value_id"],
        attributeValue: AttributeValue.fromJson(json["attribute_value"]),
        attribute: Attribute.fromJson(json["attribute"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "product_sku_id": productSkuId,
        "attribute_id": attributeId,
        "attribute_value_id": attributeValueId,
        "attribute_value": attributeValue!.toJson(),
        "attribute": attribute!.toJson(),
      };
}
