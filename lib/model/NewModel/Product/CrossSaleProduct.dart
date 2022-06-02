import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

class CrossSalesProduct {
  CrossSalesProduct({
    this.id,
    this.productId,
    this.crossSalesProductId,
    this.crossSaleProducts,
  });

  int? id;
  int? productId;
  int? crossSalesProductId;
  List<ProductModel>? crossSaleProducts;

  factory CrossSalesProduct.fromJson(Map<String, dynamic> json) =>
      CrossSalesProduct(
        id: json["id"],
        productId: json["product_id"],
        crossSalesProductId: json["cross_sale_product_id"],
        crossSaleProducts: List<ProductModel>.from(
            json["cross_seller_products"].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "cross_sale_product_id": crossSalesProductId,
        "cross_seller_products":
            List<dynamic>.from(crossSaleProducts!.map((x) => x.toJson())),
      };
}
