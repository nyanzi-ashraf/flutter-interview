import 'package:amazcart/model/NewModel/Seller/SellerAccount.dart';
import 'package:amazcart/model/NewModel/Seller/SellerBusinessInformation.dart';
import 'package:amazcart/model/NewModel/Seller/SellerProductApi.dart';
import 'package:amazcart/model/NewModel/Seller/SellerReview.dart';

class SellerData {
  SellerData({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.photo,
    this.avatar,
    this.slug,
    this.phone,
    this.description,
    this.name,
    this.sellerProductsApi,
    this.sellerReviews,
    this.sellerAccount,
    this.sellerBusinessInformation,
  });

  int? id;
  String? firstName;
  dynamic lastName;
  String? username;
  String? photo;
  String? avatar;
  String? slug;
  dynamic phone;
  dynamic description;
  String? name;
  SellerProductsApi? sellerProductsApi;
  List<SellerReview>? sellerReviews;
  SellerAccount? sellerAccount;
  SellerBusinessInformation? sellerBusinessInformation;

  factory SellerData.fromJson(Map<String, dynamic> json) => SellerData(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        photo: json["photo"] ?? "",
        avatar: json["avatar"] ?? "",
        slug: json["slug"],
        phone: json["phone"],
        description: json["description"],
        name: json["name"],
        sellerProductsApi: json["SellerProductsAPI"] == null
            ? null
            : SellerProductsApi.fromJson(json["SellerProductsAPI"]),
        sellerReviews: json["seller_reviews"] == null
            ? null
            : List<SellerReview>.from(
                json["seller_reviews"].map((x) => SellerReview.fromJson(x))),
        sellerAccount: json["seller_account"] == null
            ? null
            : SellerAccount.fromJson(json["seller_account"]),
        sellerBusinessInformation: json["seller_business_information"] == null
            ? null
            : SellerBusinessInformation.fromJson(
                json["seller_business_information"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "photo": photo,
        "avatar": avatar,
        "slug": slug,
        "phone": phone,
        "description": description,
        "name": name,
        "SellerProductsAPI": sellerProductsApi!.toJson(),
        "seller_reviews":
            List<dynamic>.from(sellerReviews!.map((x) => x.toJson())),
        "seller_account": sellerAccount!.toJson(),
        "seller_business_information": sellerBusinessInformation!.toJson(),
      };
}
