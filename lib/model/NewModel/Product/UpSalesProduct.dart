import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

class UpSalesProduct {
  UpSalesProduct({
    this.id,
    this.productId,
    this.upSalesProductId,
    this.upSaleProducts,
  });

  int? id;
  int? productId;
  int? upSalesProductId;
  List<ProductModel>? upSaleProducts;

  factory UpSalesProduct.fromJson(Map<String, dynamic> json) => UpSalesProduct(
        id: json["id"],
        productId: json["product_id"],
        upSalesProductId: json["up_sale_product_id"],
        upSaleProducts: List<ProductModel>.from(
            json["up_seller_products"].map((x) => ProductModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "up_sale_product_id": upSalesProductId,
        "up_seller_products":
            List<dynamic>.from(upSaleProducts!.map((x) => x.toJson())),
      };
}
