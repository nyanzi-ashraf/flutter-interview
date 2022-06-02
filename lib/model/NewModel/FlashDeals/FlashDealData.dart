import 'package:amazcart/model/NewModel/FlashDeals/FlashDealAllProducts.dart';

class FlashDealData {
  FlashDealData({
    this.id,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.startDate,
    this.endDate,
    this.slug,
    this.bannerImage,
    this.status,
    this.isFeatured,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.allProducts,
  });

  dynamic id;
  String? title;
  String? backgroundColor;
  String? textColor;
  DateTime? startDate;
  DateTime? endDate;
  String? slug;
  String? bannerImage;
  dynamic status;
  dynamic isFeatured;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  FlashDealAllProducts? allProducts;

  factory FlashDealData.fromJson(Map<String, dynamic> json) => FlashDealData(
        id: json["id"],
        title: json["title"],
        backgroundColor: json["background_color"],
        textColor: json["text_color"],
        startDate: json["start_date"] == null
            ? null
            : DateTime.parse(json["start_date"]),
        endDate:
            json["end_date"] == null ? null : DateTime.parse(json["end_date"]),
        slug: json["slug"],
        bannerImage: json["banner_image"],
        status: json["status"],
        isFeatured: json["is_featured"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        allProducts: json["AllProducts"] == null
            ? null
            : FlashDealAllProducts.fromJson(json["AllProducts"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "background_color": backgroundColor,
        "text_color": textColor,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "slug": slug,
        "banner_image": bannerImage,
        "status": status,
        "is_featured": isFeatured,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "AllProducts": allProducts == null ? null : allProducts!.toJson(),
      };
}
