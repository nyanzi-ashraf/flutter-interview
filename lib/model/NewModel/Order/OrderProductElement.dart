import 'package:amazcart/model/NewModel/Product/GiftCardData.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/SkuProduct.dart';

class OrderProductElement {
  OrderProductElement({
    this.id,
    this.packageId,
    this.type,
    this.productSkuId,
    this.qty,
    this.price,
    this.totalPrice,
    this.taxAmount,
    this.sellerProductSku,
    this.giftCard,
  });

  dynamic id;
  dynamic packageId;
  ProductType? type;
  dynamic productSkuId;
  dynamic qty;
  dynamic price;
  dynamic totalPrice;
  double? taxAmount;
  SkuProduct? sellerProductSku;
  GiftCardData? giftCard;

  factory OrderProductElement.fromJson(Map<String, dynamic> json) =>
      OrderProductElement(
        id: json["id"],
        packageId: json["package_id"],
        type: typeValues.map![json["type"]],
        productSkuId: json["product_sku_id"],
        qty: json["qty"],
        price: json["price"],
        totalPrice: json["total_price"],
        taxAmount: json["tax_amount"].toDouble(),
        sellerProductSku: json["seller_product_sku"] == null
            ? null
            : SkuProduct.fromJson(json["seller_product_sku"]),
        giftCard: json["gift_card"] == null
            ? null
            : GiftCardData.fromJson(json["gift_card"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "type": typeValues.reverse[type],
        "product_sku_id": productSkuId,
        "qty": qty,
        "price": price,
        "total_price": totalPrice,
        "tax_amount": taxAmount,
        "seller_product_sku": sellerProductSku!.toJson(),
        "gift_card": giftCard == null ? null : giftCard!.toJson(),
      };
}
