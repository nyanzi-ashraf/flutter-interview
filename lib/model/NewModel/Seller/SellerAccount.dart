class SellerAccount {
  SellerAccount({
    this.id,
    this.userId,
    this.sellerCommissionId,
    this.commissionRate,
    this.sellerId,
    this.banner,
    this.subscriptionType,
    this.sellerPhone,
    this.sellerShopDisplayName,
    this.holidayMode,
    this.holidayType,
    this.holidayDate,
    this.holidayDateStart,
    this.holidayDateEnd,
    this.isTrusted,
    this.totalSaleQty,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic userId;
  dynamic sellerCommissionId;
  dynamic commissionRate;
  String? sellerId;
  dynamic banner;
  String? subscriptionType;
  dynamic sellerPhone;
  dynamic sellerShopDisplayName;
  dynamic holidayMode;
  dynamic holidayType;
  dynamic holidayDate;
  dynamic holidayDateStart;
  dynamic holidayDateEnd;
  dynamic isTrusted;
  dynamic totalSaleQty;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SellerAccount.fromJson(Map<String, dynamic> json) => SellerAccount(
        id: json["id"],
        userId: json["user_id"],
        sellerCommissionId: json["seller_commission_id"],
        commissionRate: json["commission_rate"],
        sellerId: json["seller_id"],
        banner: json["banner"],
        subscriptionType: json["subscription_type"],
        sellerPhone: json["seller_phone"],
        sellerShopDisplayName: json["seller_shop_display_name"],
        holidayMode: json["holiday_mode"],
        holidayType: json["holiday_type"],
        holidayDate: json["holiday_date"],
        holidayDateStart: json["holiday_date_start"],
        holidayDateEnd: json["holiday_date_end"],
        isTrusted: json["is_trusted"],
        totalSaleQty: json["total_sale_qty"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "seller_commission_id": sellerCommissionId,
        "commission_rate": commissionRate,
        "seller_id": sellerId,
        "banner": banner,
        "subscription_type": subscriptionType,
        "seller_phone": sellerPhone,
        "seller_shop_display_name": sellerShopDisplayName,
        "holiday_mode": holidayMode,
        "holiday_type": holidayType,
        "holiday_date": holidayDate,
        "holiday_date_start": holidayDateStart,
        "holiday_date_end": holidayDateEnd,
        "is_trusted": isTrusted,
        "total_sale_qty": totalSaleQty,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
