import 'package:amazcart/model/NewModel/Category/ParentCategory.dart';
import 'package:amazcart/model/NewModel/Product/AllProducts.dart';

import 'CategoryImage.dart';

class CategoryData {
  CategoryData({
    this.id,
    this.name,
    this.slug,
    this.parentId,
    this.depthLevel,
    this.icon,
    this.searchable,
    this.status,
    this.allProducts,
    this.categoryImage,
    this.parentCategory,
    this.subCategories,
  });

  int? id;
  String? name;
  String? slug;
  int? parentId;
  int? depthLevel;
  String? icon;
  int? searchable;
  int? status;
  AllProducts? allProducts;
  CategoryImage? categoryImage;
  ParentCategory? parentCategory;
  List<ParentCategory>? subCategories;

  factory CategoryData.fromJson(Map<String, dynamic> json) => CategoryData(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        parentId: json["parent_id"],
        depthLevel: json["depth_level"],
        icon: json["icon"] == null ? null : json["icon"],
        searchable: json["searchable"],
        status: json["status"],
        allProducts: json["AllProducts"] == null
            ? null
            : AllProducts.fromJson(json["AllProducts"]),
        categoryImage: json["category_image"] == null
            ? null
            : CategoryImage.fromJson(json["category_image"]),
        parentCategory: json["parent_category"] == null
            ? null
            : ParentCategory.fromJson(json["parent_category"]),
        subCategories: json["sub_categories"] == null
            ? null
            : List<ParentCategory>.from(
                json["sub_categories"].map((x) => ParentCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "parent_id": parentId,
        "depth_level": depthLevel,
        "icon": icon == null ? null : icon,
        "searchable": searchable,
        "status": status,
        "AllProducts": allProducts == null ? null : allProducts!.toJson(),
        "category_image":
            categoryImage == null ? null : categoryImage!.toJson(),
        "parent_category":
            parentCategory == null ? null : parentCategory!.toJson(),
        "sub_categories": subCategories == null
            ? null
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
      };
}
