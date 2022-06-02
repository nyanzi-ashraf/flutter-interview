import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

class RelatedProduct {
  RelatedProduct({
    this.id,
    this.productId,
    this.relatedSaleProductId,
    this.relatedSellerProducts,
  });

  int? id;
  int? productId;
  int? relatedSaleProductId;
  List<ProductModel>? relatedSellerProducts;

  factory RelatedProduct.fromJson(Map<String, dynamic> json) => RelatedProduct(
        id: json["id"],
        productId: json["product_id"],
        relatedSaleProductId: json["related_sale_product_id"],
        relatedSellerProducts: List<ProductModel>.from(
            json["related_seller_products"]
                .map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "related_sale_product_id": relatedSaleProductId,
        "related_seller_products":
            List<dynamic>.from(relatedSellerProducts!.map((x) => x.toJson())),
      };
}
