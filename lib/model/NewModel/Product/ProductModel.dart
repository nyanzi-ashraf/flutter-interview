import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariantDetail.dart';
import 'package:amazcart/model/NewModel/Seller/SellerData.dart';

import 'HasDeal.dart';
import 'ProductData.dart';
import 'Review.dart';
import 'Skus.dart';

class ProductModel {
  ProductModel({
    this.id,
    this.userId,
    this.productId,
    this.tax,
    this.taxType,
    this.discount,
    this.discountType,
    this.discountStartDate,
    this.discountEndDate,
    this.productName,
    this.slug,
    this.thumImg,
    this.status,
    this.stockManage,
    this.isApproved,
    this.minSellPrice,
    this.maxSellPrice,
    this.totalSale,
    this.avgRating,
    this.maxSellingPrice,
    this.rating,
    this.hasDeal,
    this.hasDiscount,
    this.product,
    this.skus,
    this.reviews,
    this.variantDetails,
    this.flashDeal,
    this.seller,
    this.productType,
    this.giftCardSellingPrice,
    this.giftCardThumbnailImage,
    this.giftCardStartDate,
    this.giftCardEndDate,
    this.giftCardSku,
    this.giftCardName,
  });

  dynamic id;
  dynamic userId;
  dynamic productId;
  dynamic tax;
  String? taxType;
  double? discount;
  dynamic discountType;
  dynamic discountStartDate;
  dynamic discountEndDate;
  String? productName;
  String? slug;
  dynamic thumImg;
  dynamic status;
  dynamic stockManage;
  dynamic isApproved;
  dynamic minSellPrice;
  dynamic maxSellPrice;
  int? totalSale;
  dynamic avgRating;
  double? maxSellingPrice;
  dynamic rating;
  HasDeal? hasDeal;
  String? hasDiscount;
  Product? product;
  List<Skus>? skus;
  List<Review>? reviews;
  List<ProductVariantDetail>? variantDetails;
  HasDeal? flashDeal;
  SellerData? seller;
  ProductType? productType;
  double? giftCardSellingPrice;
  String? giftCardThumbnailImage;
  DateTime? giftCardStartDate;
  DateTime? giftCardEndDate;
  String? giftCardSku;
  String? giftCardName;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        tax: json["tax"],
        taxType: json["tax_type"],
        discount: json["discount"] == null ? null : json["discount"].toDouble(),
        discountType: json["discount_type"].toString(),
        discountStartDate: json["discount_start_date"],
        discountEndDate: json["discount_end_date"],
        productName: json["product_name"],
        slug: json["slug"],
        thumImg: json["thum_img"],
        status: json["status"],
        stockManage: json["stock_manage"],
        isApproved: json["is_approved"],
        minSellPrice: json["min_sell_price"] == null
            ? null
            : json["min_sell_price"].toDouble(),
        maxSellPrice: json["max_sell_price"] == null
            ? null
            : json["max_sell_price"].toDouble(),
        totalSale: json["total_sale"],
        avgRating: json["avg_rating"],
        variantDetails: json["variantDetails"] == null
            ? null
            : List<ProductVariantDetail>.from(json["variantDetails"]
                .map((x) => ProductVariantDetail.fromJson(x))),
        maxSellingPrice: json["MaxSellingPrice"] == null
            ? null
            : double.parse(json["MaxSellingPrice"].toString()).toDouble(),
        hasDeal: json["hasDeal"] == 0 || json["hasDeal"] == null
            ? null
            : HasDeal.fromJson(json["hasDeal"]),
        rating: json["rating"] == null ? null : json["rating"],
        hasDiscount: json['hasDiscount'],
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        seller:
            json["seller"] == null ? null : SellerData.fromJson(json["seller"]),
        reviews: json["reviews"] == null
            ? null
            : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
        skus: json["skus"] == null
            ? null
            : List<Skus>.from(json["skus"].map((x) => Skus.fromJson(x))),
        productType: typeValues.map![json["ProductType"]],
        giftCardSellingPrice: json["selling_price"] == null
            ? null
            : json["selling_price"].toDouble(),
        giftCardThumbnailImage:
            json["thumbnail_image"] == null ? null : json["thumbnail_image"],
        giftCardStartDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        giftCardEndDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        giftCardSku: json['sku'] == null ? null : json['sku'],
        giftCardName: json['name'] == null ? null : json['name'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "tax": tax,
        "tax_type": taxType,
        "discount": discount,
        "discount_type": discountType,
        "discount_start_date": discountStartDate,
        "discount_end_date": discountEndDate,
        "product_name": productName,
        "slug": slug,
        "thum_img": thumImg,
        "status": status,
        "stock_manage": stockManage,
        "is_approved": isApproved,
        "min_sell_price": minSellPrice,
        "max_sell_price": maxSellPrice,
        "total_sale": totalSale,
        "avg_rating": avgRating,
        "MaxSellingPrice": maxSellingPrice,
        "rating": rating,
        "hasDiscount": hasDiscount,
        "hasDeal": hasDeal == null ? null : hasDeal!.toJson(),
        "flash_deal": flashDeal == null ? null : flashDeal!.toJson(),
        "product": product == null ? null : product!.toJson(),
        "seller": seller == null ? null : seller!.toJson(),
        "skus": skus == null
            ? null
            : List<dynamic>.from(skus!.map((x) => x.toJson())),
        "reviews": reviews == null
            ? null
            : List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "start_date": giftCardStartDate == null
            ? null
            : "${giftCardStartDate!.year.toString().padLeft(4, '0')}-${giftCardStartDate!.month.toString().padLeft(2, '0')}-${giftCardStartDate!.day.toString().padLeft(2, '0')}",
        "end_date": giftCardEndDate == null
            ? null
            : "${giftCardEndDate!.year.toString().padLeft(4, '0')}-${giftCardEndDate!.month.toString().padLeft(2, '0')}-${giftCardEndDate!.day.toString().padLeft(2, '0')}",
        "sku": giftCardSku == null ? null : giftCardSku,
        "name": giftCardName == null ? null : giftCardName,
      };
}
