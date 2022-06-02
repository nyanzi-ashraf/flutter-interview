import 'FlashDeal.dart';

class HasDeal {
  HasDeal({
    this.id,
    this.flashDealId,
    this.sellerProductId,
    this.discount,
    this.discountType,
    this.status,
    this.flashDeal,
  });

  int? id;
  int? flashDealId;
  int? sellerProductId;
  double? discount;
  int? discountType;
  int? status;
  FlashDeal? flashDeal;

  factory HasDeal.fromJson(Map<String, dynamic> json) => HasDeal(
        id: json["id"],
        flashDealId: json["flash_deal_id"],
        sellerProductId: json["seller_product_id"],
        discount: json["discount"].toDouble(),
        discountType: json["discount_type"],
        status: json["status"],
        flashDeal: json["flash_deal"] == null
            ? null
            : FlashDeal.fromJson(json["flash_deal"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "flash_deal_id": flashDealId,
        "seller_product_id": sellerProductId,
        "discount": discount,
        "discount_type": discountType,
        "status": status,
        "flash_deal": flashDeal == null ? null : flashDeal!.toJson(),
      };
}
