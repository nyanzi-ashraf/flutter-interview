import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Product/CrossSaleProduct.dart';
import 'package:amazcart/model/NewModel/Product/RelatedProduct.dart';
import 'package:amazcart/model/NewModel/Product/UpSalesProduct.dart';
import 'package:amazcart/model/NewModel/ShippingMethod/ShippingMethodElement.dart';
import 'package:amazcart/model/NewModel/Tags/TagData.dart';

import 'GalleryImageData.dart';
import 'ProductSkus.dart';

class Product {
  Product({
    this.id,
    this.productName,
    this.productType,
    this.unitTypeId,
    this.brandId,
    this.categoryId,
    this.thumbnailImageSource,
    this.barcodeType,
    this.modelNumber,
    this.shippingType,
    this.shippingCost,
    this.discountType,
    this.discount,
    this.taxType,
    this.tax,
    this.pdf,
    this.videoProvider,
    this.videoLink,
    this.description,
    this.specification,
    this.minimumOrderQty,
    this.maxOrderQty,
    this.metaTitle,
    this.metaDescription,
    this.metaImage,
    this.isPhysical,
    this.isApproved,
    this.status,
    this.displayInDetails,
    this.requestedBy,
    this.createdBy,
    this.skus,
    this.brand,
    this.categories,
    this.tags,
    this.gallaryImages,
    this.shippingMethods,
    this.relatedProducts,
    this.upSalesProducts,
    this.crossSalesProducts,
  });

  dynamic id;
  String? productName;
  dynamic productType;
  dynamic unitTypeId;
  dynamic brandId;
  dynamic categoryId;
  String? thumbnailImageSource;
  String? barcodeType;
  String? modelNumber;
  dynamic shippingType;
  dynamic shippingCost;
  String? discountType;
  dynamic discount;
  String? taxType;
  double? tax;
  dynamic pdf;
  String? videoProvider;
  String? videoLink;
  String? description;
  String? specification;
  dynamic minimumOrderQty;
  dynamic maxOrderQty;
  String? metaTitle;
  String? metaDescription;
  dynamic metaImage;
  dynamic isPhysical;
  dynamic isApproved;
  dynamic status;
  dynamic displayInDetails;
  dynamic requestedBy;
  dynamic createdBy;
  List<ProductSku>? skus;
  BrandData? brand;
  List<CategoryData>? categories;
  List<TagData>? tags;
  List<GalleryImageData>? gallaryImages;
  List<ShippingMethodElement>? shippingMethods;
  List<RelatedProduct>? relatedProducts;
  List<UpSalesProduct>? upSalesProducts;
  List<CrossSalesProduct>? crossSalesProducts;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        productName: json["product_name"],
        productType: json["product_type"],
        unitTypeId: json["unit_type_id"],
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        categoryId: json["category_id"],
        thumbnailImageSource: json["thumbnail_image_source"],
        barcodeType: json["barcode_type"],
        modelNumber: json["model_number"] == null ? null : json["model_number"],
        shippingType: json["shipping_type"],
        shippingCost: json["shipping_cost"],
        discountType: json["discount_type"],
        discount: json["discount"],
        taxType: json["tax_type"],
        tax: json["tax"].toDouble(),
        pdf: json["pdf"] == null ? null : json["pdf"],
        videoProvider: json["video_provider"],
        videoLink: json["video_link"] == null ? null : json["video_link"],
        description: json["description"] == null ? null : json["description"],
        specification:
            json["specification"] == null ? null : json["specification"],
        minimumOrderQty: json["minimum_order_qty"],
        maxOrderQty:
            json["max_order_qty"] == null ? null : json["max_order_qty"],
        metaTitle: json["meta_title"] == null ? null : json["meta_title"],
        metaDescription:
            json["meta_description"] == null ? null : json["meta_description"],
        metaImage: json["meta_image"],
        isPhysical: json["is_physical"],
        isApproved: json["is_approved"],
        status: json["status"],
        displayInDetails: json["display_in_details"],
        requestedBy: json["requested_by"],
        createdBy: json["created_by"],
        skus: json["skus"] == null
            ? null
            : List<ProductSku>.from(
                json["skus"].map((x) => ProductSku.fromJson(x))),
        brand: json["brand"] == null
            ? null
            : json["brand"] is List
                ? null
                : BrandData.fromJson(json["brand"]),
        categories: json["categories"] == null
            ? null
            : List<CategoryData>.from(
                json["categories"].map((x) => CategoryData.fromJson(x))),
        tags: json["tags"] == null
            ? null
            : List<TagData>.from(json["tags"].map((x) => TagData.fromJson(x))),
        gallaryImages: json["gallary_images"] == null
            ? null
            : List<GalleryImageData>.from(json["gallary_images"]
                .map((x) => GalleryImageData.fromJson(x))),
        shippingMethods: json["shipping_methods"] == null
            ? null
            : List<ShippingMethodElement>.from(json["shipping_methods"]
                .map((x) => ShippingMethodElement.fromJson(x))),
        relatedProducts: json["related_products"] == null
            ? null
            : List<RelatedProduct>.from(json["related_products"]
                .map((x) => RelatedProduct.fromJson(x))),
        upSalesProducts: json["up_sales"] == null
            ? null
            : List<UpSalesProduct>.from(
                json["up_sales"].map((x) => UpSalesProduct.fromJson(x))),
        crossSalesProducts: json["cross_sales"] == null
            ? null
            : List<CrossSalesProduct>.from(
                json["cross_sales"].map((x) => CrossSalesProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_type": productType,
        "unit_type_id": unitTypeId,
        "brand_id": brandId == null ? null : brandId,
        "category_id": categoryId,
        "thumbnail_image_source": thumbnailImageSource,
        "barcode_type": barcodeType,
        "model_number": modelNumber == null ? null : modelNumber,
        "shipping_type": shippingType,
        "shipping_cost": shippingCost,
        "discount_type": discountType,
        "discount": discount,
        "tax_type": taxType,
        "tax": tax,
        "pdf": pdf,
        "video_provider": videoProvider,
        "video_link": videoLink == null ? null : videoLink,
        "description": description == null ? null : description,
        "specification": specification == null ? null : specification,
        "minimum_order_qty": minimumOrderQty,
        "max_order_qty": maxOrderQty == null ? null : maxOrderQty,
        "meta_title": metaTitle == null ? null : metaTitle,
        "meta_description": metaDescription == null ? null : metaDescription,
        "meta_image": metaImage,
        "is_physical": isPhysical,
        "is_approved": isApproved,
        "status": status,
        "display_in_details": displayInDetails,
        "requested_by": requestedBy,
        "created_by": createdBy,
        "brand": brand == null ? null : brand!.toJson(),
        "categories": categories == null
            ? null
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "tags": tags == null
            ? null
            : List<dynamic>.from(tags!.map((x) => x.toJson())),
        "gallary_images": gallaryImages == null
            ? null
            : List<dynamic>.from(gallaryImages!.map((x) => x.toJson())),
        "shipping_methods": shippingMethods == null
            ? null
            : List<dynamic>.from(shippingMethods!.map((x) => x.toJson())),
        "related_products": relatedProducts == null
            ? null
            : List<dynamic>.from(relatedProducts!.map((x) => x.toJson())),
      };
}
