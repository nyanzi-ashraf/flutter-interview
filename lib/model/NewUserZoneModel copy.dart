// To parse this JSON data, do
//
//     final newUserZoneModel = newUserZoneModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

NewUserZoneModel newUserZoneModelFromJson(String str) =>
    NewUserZoneModel.fromJson(json.decode(str));

String newUserZoneModelToJson(NewUserZoneModel data) =>
    json.encode(data.toJson());

class NewUserZoneModel {
  NewUserZoneModel({
    this.newUserZone,
    this.message,
  });

  NewUserZone? newUserZone;
  String? message;

  factory NewUserZoneModel.fromJson(Map<String, dynamic> json) =>
      NewUserZoneModel(
        newUserZone: NewUserZone.fromJson(json["new_user_zone"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "new_user_zone": newUserZone!.toJson(),
        "message": message,
      };
}

class NewUserZone {
  NewUserZone({
    this.id,
    this.title,
    this.backgroundColor,
    this.textColor,
    this.slug,
    this.bannerImage,
    this.productNavigationLabel,
    this.categoryNavigationLabel,
    this.couponNavigationLabel,
    this.productSlogan,
    this.categorySlogan,
    this.couponSlogan,
    this.status,
    this.isFeatured,
    this.createdBy,
    this.updatedBy,
    this.allProducts,
    this.categories,
    this.coupon,
    this.couponCategories,
  });

  dynamic id;
  String? title;
  String? backgroundColor;
  String? textColor;
  String? slug;
  String? bannerImage;
  String? productNavigationLabel;
  String? categoryNavigationLabel;
  String? couponNavigationLabel;
  String? productSlogan;
  String? categorySlogan;
  String? couponSlogan;
  dynamic status;
  dynamic isFeatured;
  dynamic createdBy;
  dynamic updatedBy;
  NewUserZoneAllProducts? allProducts;
  List<CategoryElement>? categories;
  NewUserZoneCoupon? coupon;
  List<CouponCategory>? couponCategories;

  factory NewUserZone.fromJson(Map<String, dynamic> json) => NewUserZone(
        id: json["id"],
        title: json["title"],
        backgroundColor: json["background_color"],
        textColor: json["text_color"],
        slug: json["slug"],
        bannerImage: json["banner_image"],
        productNavigationLabel: json["product_navigation_label"],
        categoryNavigationLabel: json["category_navigation_label"],
        couponNavigationLabel: json["coupon_navigation_label"],
        productSlogan: json["product_slogan"],
        categorySlogan: json["category_slogan"],
        couponSlogan: json["coupon_slogan"],
        status: json["status"],
        isFeatured: json["is_featured"],
        allProducts: json["AllProducts"] == null
            ? null
            : NewUserZoneAllProducts.fromJson(json["AllProducts"]),
        categories: json["categories"] == null
            ? null
            : List<CategoryElement>.from(
                json["categories"].map((x) => CategoryElement.fromJson(x))),
        coupon: json["coupon"] == null
            ? null
            : NewUserZoneCoupon.fromJson(json["coupon"]),
        couponCategories: json["coupon_categories"] == null
            ? null
            : List<CouponCategory>.from(json["coupon_categories"]
                .map((x) => CouponCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "background_color": backgroundColor,
        "text_color": textColor,
        "slug": slug,
        "banner_image": bannerImage,
        "product_navigation_label": productNavigationLabel,
        "category_navigation_label": categoryNavigationLabel,
        "coupon_navigation_label": couponNavigationLabel,
        "product_slogan": productSlogan,
        "category_slogan": categorySlogan,
        "coupon_slogan": couponSlogan,
        "status": status,
        "is_featured": isFeatured,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "AllProducts": allProducts!.toJson(),
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "coupon": coupon!.toJson(),
        "coupon_categories":
            List<dynamic>.from(couponCategories!.map((x) => x.toJson())),
      };
}

class NewUserZoneAllProducts {
  NewUserZoneAllProducts({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  dynamic currentPage;
  List<NewUserZoneDatum>? data;
  String? firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  dynamic nextPageUrl;
  String? path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory NewUserZoneAllProducts.fromJson(Map<String, dynamic> json) =>
      NewUserZoneAllProducts(
        currentPage: json["current_page"] == null ? null : json["current_page"],
        data: List<NewUserZoneDatum>.from(
            json["data"].map((x) => NewUserZoneDatum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        path: json["path"],
        perPage: json["per_page"],
        prevPageUrl: json["prev_page_url"],
        to: json["to"],
        total: json["total"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "first_page_url": firstPageUrl,
        "from": from,
        "last_page": lastPage,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class NewUserZoneDatum {
  NewUserZoneDatum({
    this.id,
    this.newUserZoneId,
    this.sellerProductId,
    this.status,
    this.product,
  });

  dynamic id;
  dynamic newUserZoneId;
  dynamic sellerProductId;
  dynamic status;
  ProductModel? product;

  factory NewUserZoneDatum.fromJson(Map<String, dynamic> json) =>
      NewUserZoneDatum(
        id: json["id"],
        newUserZoneId: json["new_user_zone_id"],
        sellerProductId: json["seller_product_id"],
        status: json["status"],
        product: ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "new_user_zone_id": newUserZoneId,
        "seller_product_id": sellerProductId,
        "status": status,
        "product": product!.toJson(),
      };
}

class CategoryElement {
  CategoryElement({
    this.id,
    this.newUserZoneId,
    this.categoryId,
    this.position,
    this.category,
  });

  dynamic id;
  dynamic newUserZoneId;
  dynamic categoryId;
  dynamic position;
  CategoryData? category;

  factory CategoryElement.fromJson(Map<String, dynamic> json) =>
      CategoryElement(
        id: json["id"],
        newUserZoneId: json["new_user_zone_id"],
        categoryId: json["category_id"],
        position: json["position"],
        category: CategoryData.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "new_user_zone_id": newUserZoneId,
        "category_id": categoryId,
        "position": position,
        "category": category!.toJson(),
      };
}

class NewUserZoneCoupon {
  NewUserZoneCoupon({
    this.id,
    this.newUserZoneId,
    this.couponId,
    this.coupon,
  });

  dynamic id;
  dynamic newUserZoneId;
  dynamic couponId;
  CouponCoupon? coupon;

  factory NewUserZoneCoupon.fromJson(Map<String, dynamic> json) =>
      NewUserZoneCoupon(
        id: json["id"],
        newUserZoneId: json["new_user_zone_id"],
        couponId: json["coupon_id"],
        coupon: CouponCoupon.fromJson(json["coupon"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "new_user_zone_id": newUserZoneId,
        "coupon_id": couponId,
        "coupon": coupon!.toJson(),
      };
}

class CouponCoupon {
  CouponCoupon({
    this.id,
    this.title,
    this.couponCode,
    this.couponType,
    this.startDate,
    this.endDate,
    this.discount,
    this.discountType,
    this.minimumShopping,
    this.maximumDiscount,
    this.createdBy,
    this.updatedBy,
    this.isExpire,
    this.isMultipleBuy,
  });

  dynamic id;
  String? title;
  String? couponCode;
  dynamic couponType;
  DateTime? startDate;
  DateTime? endDate;
  dynamic discount;
  dynamic discountType;
  dynamic minimumShopping;
  dynamic maximumDiscount;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic isExpire;
  dynamic isMultipleBuy;

  factory CouponCoupon.fromJson(Map<String, dynamic> json) => CouponCoupon(
        id: json["id"],
        title: json["title"],
        couponCode: json["coupon_code"],
        couponType: json["coupon_type"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        discount: json["discount"],
        discountType: json["discount_type"],
        minimumShopping: json["minimum_shopping"],
        maximumDiscount: json["maximum_discount"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        isExpire: json["is_expire"],
        isMultipleBuy: json["is_multiple_buy"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "coupon_code": couponCode,
        "coupon_type": couponType,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "discount": discount,
        "discount_type": discountType,
        "minimum_shopping": minimumShopping,
        "maximum_discount": maximumDiscount,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "is_expire": isExpire,
        "is_multiple_buy": isMultipleBuy,
      };
}

class CouponCategory {
  CouponCategory({
    this.id,
    this.newUserZoneId,
    this.categoryId,
    this.position,
    this.category,
  });

  dynamic id;
  dynamic newUserZoneId;
  dynamic categoryId;
  dynamic position;
  CategoryData? category;

  factory CouponCategory.fromJson(Map<String, dynamic> json) => CouponCategory(
        id: json["id"],
        newUserZoneId: json["new_user_zone_id"],
        categoryId: json["category_id"],
        position: json["position"],
        category: CategoryData.fromJson(json["category"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "new_user_zone_id": newUserZoneId,
        "category_id": categoryId,
        "position": position,
        "category": category!.toJson(),
      };
}
