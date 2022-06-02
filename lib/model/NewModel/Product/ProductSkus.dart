class ProductSku {
  ProductSku({
    this.id,
    this.productId,
    this.sku,
    this.purchasePrice,
    this.sellingPrice,
    this.additionalShipping,
    this.variantImage,
    this.status,
    this.productStock,
    this.trackSku,
    this.weight,
    this.length,
    this.breadth,
    this.height,
  });

  dynamic id;
  dynamic productId;
  String? sku;
  dynamic purchasePrice;
  double? sellingPrice;
  dynamic additionalShipping;
  String? variantImage;
  dynamic status;
  dynamic productStock;
  String? trackSku;
  String? weight;
  String? length;
  String? breadth;
  String? height;

  factory ProductSku.fromJson(Map<String, dynamic> json) => ProductSku(
        id: json["id"],
        productId: json["product_id"],
        sku: json["sku"],
        purchasePrice: json["purchase_price"],
        sellingPrice: json["selling_price"] == null
            ? null
            : json["selling_price"].toDouble(),
        additionalShipping: json["additional_shipping"],
        variantImage:
            json["variant_image"] == null ? null : json["variant_image"],
        status: json["status"],
        productStock: json['product_stock'],
        trackSku: json["track_sku"],
        weight: json["weight"],
        length: json["length"],
        breadth: json["breadth"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "sku": sku,
        "purchase_price": purchasePrice,
        "selling_price": sellingPrice,
        "additional_shipping": additionalShipping,
        "variant_image": variantImage == null ? null : variantImage,
        "status": status,
        "product_stock": productStock,
        "track_sku": trackSku,
        "weight": weight,
        "length": length,
        "breadth": breadth,
        "height": height,
      };
}
