import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductSkus.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariations.dart';

class SkuProduct {
  SkuProduct({
    this.id,
    this.userId,
    this.productId,
    this.productSkuId,
    this.productStock,
    this.purchasePrice,
    this.sellingPrice,
    this.status,
    this.product,
    this.sku,
    this.productVariations,
  });

  dynamic id;
  dynamic userId;
  dynamic productId;
  String? productSkuId;
  dynamic productStock;
  dynamic purchasePrice;
  dynamic sellingPrice;
  dynamic status;
  ProductModel? product;
  ProductSku? sku;
  List<ProductVariation>? productVariations;

  factory SkuProduct.fromJson(Map<String, dynamic> json) => SkuProduct(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productSkuId: json["product_sku_id"],
        productStock: json["product_stock"],
        purchasePrice: json["purchase_price"],
        sellingPrice: json["selling_price"],
        status: json["status"],
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
        sku: ProductSku.fromJson(json["sku"]),
        productVariations: List<ProductVariation>.from(
            json["product_variations"]
                .map((x) => ProductVariation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "product_sku_id": productSkuId,
        "product_stock": productStock,
        "purchase_price": purchasePrice,
        "selling_price": sellingPrice,
        "status": status,
        "product": product!.toJson(),
        "sku": sku!.toJson(),
        "product_variations":
            List<dynamic>.from(productVariations!.map((x) => x.toJson())),
      };
}
