// To parse this JSON data, do
//
//     final waitingReviewModel = waitingReviewModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Product/ProductType.dart';

WaitingReviewModel waitingReviewModelFromJson(String str) =>
    WaitingReviewModel.fromJson(json.decode(str));

String waitingReviewModelToJson(WaitingReviewModel data) =>
    json.encode(data.toJson());

class WaitingReviewModel {
  WaitingReviewModel({
    this.packages,
    this.message,
  });

  List<Package>? packages;
  String? message;

  factory WaitingReviewModel.fromJson(Map<String, dynamic> json) =>
      WaitingReviewModel(
        packages: List<Package>.from(
            json["packages"].map((x) => Package.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "packages": List<Package>.from(packages!.map((x) => x.toJson())),
        "message": message,
      };
}

class Package {
  Package({
    this.id,
    this.orderId,
    this.sellerId,
    this.packageCode,
    this.numberOfProduct,
    this.shippingCost,
    this.shippingDate,
    this.shippingMethod,
    this.isCancelled,
    this.isReviewed,
    this.deliveryStatus,
    this.lastUpdatedBy,
    this.taxAmount,
    this.createdAt,
    this.updatedAt,
    this.deliveryStateName,
    this.totalGst,
    this.order,
    this.products,
    this.gstTaxes,
  });

  dynamic id;
  dynamic orderId;
  dynamic sellerId;
  String? packageCode;
  dynamic numberOfProduct;
  dynamic shippingCost;
  String? shippingDate;
  dynamic shippingMethod;
  dynamic isCancelled;
  dynamic isReviewed;
  dynamic deliveryStatus;
  dynamic lastUpdatedBy;
  double? taxAmount;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? deliveryStateName;
  double? totalGst;
  Order? order;
  List<ProductElement>? products;
  List<GstTax>? gstTaxes;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
        id: json["id"],
        orderId: json["order_id"],
        sellerId: json["seller_id"],
        packageCode: json["package_code"],
        numberOfProduct: json["number_of_product"],
        shippingCost: json["shipping_cost"],
        shippingDate: json["shipping_date"],
        shippingMethod: json["shipping_method"],
        isCancelled: json["is_cancelled"],
        isReviewed: json["is_reviewed"],
        deliveryStatus: json["delivery_status"],
        lastUpdatedBy: json["last_updated_by"],
        taxAmount: json["tax_amount"].toDouble(),
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        deliveryStateName: json["deliveryStateName"],
        totalGst: json["totalGST"].toDouble(),
        order: Order.fromJson(json["order"]),
        products: List<ProductElement>.from(
            json["products"].map((x) => ProductElement.fromJson(x))),
        gstTaxes:
            List<GstTax>.from(json["gst_taxes"].map((x) => GstTax.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "seller_id": sellerId,
        "package_code": packageCode,
        "number_of_product": numberOfProduct,
        "shipping_cost": shippingCost,
        "shipping_date": shippingDate,
        "shipping_method": shippingMethod,
        "is_cancelled": isCancelled,
        "is_reviewed": isReviewed,
        "delivery_status": deliveryStatus,
        "last_updated_by": lastUpdatedBy,
        "tax_amount": taxAmount,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "deliveryStateName": deliveryStateName,
        "totalGST": totalGst,
        "order": order!.toJson(),
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "gst_taxes": List<dynamic>.from(gstTaxes!.map((x) => x.toJson())),
      };
}

class GstTax {
  GstTax({
    this.id,
    this.packageId,
    this.gstId,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic packageId;
  dynamic gstId;
  double? amount;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GstTax.fromJson(Map<String, dynamic> json) => GstTax(
        id: json["id"],
        packageId: json["package_id"],
        gstId: json["gst_id"],
        amount: json["amount"].toDouble(),
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "gst_id": gstId,
        "amount": amount,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Order {
  Order({
    this.id,
    this.customerId,
    this.orderPaymentId,
    this.orderType,
    this.orderNumber,
    this.paymentType,
    this.isPaid,
    this.isConfirmed,
    this.isCompleted,
    this.isCancelled,
    this.customerEmail,
    this.customerPhone,
    this.customerShippingAddress,
    this.customerBillingAddress,
    this.numberOfPackage,
    this.grandTotal,
    this.subTotal,
    this.discountTotal,
    this.shippingTotal,
    this.numberOfItem,
    this.orderStatus,
    this.taxAmount,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic customerId;
  dynamic orderPaymentId;
  dynamic orderType;
  String? orderNumber;
  dynamic paymentType;
  dynamic isPaid;
  dynamic isConfirmed;
  dynamic isCompleted;
  dynamic isCancelled;
  String? customerEmail;
  String? customerPhone;
  dynamic customerShippingAddress;
  dynamic customerBillingAddress;
  dynamic numberOfPackage;
  double? grandTotal;
  dynamic subTotal;
  dynamic discountTotal;
  dynamic shippingTotal;
  dynamic numberOfItem;
  dynamic orderStatus;
  double? taxAmount;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        customerId: json["customer_id"],
        orderPaymentId: json["order_payment_id"],
        orderType: json["order_type"],
        orderNumber: json["order_number"],
        paymentType: json["payment_type"],
        isPaid: json["is_paid"],
        isConfirmed: json["is_confirmed"],
        isCompleted: json["is_completed"],
        isCancelled: json["is_cancelled"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        customerShippingAddress: json["customer_shipping_address"],
        customerBillingAddress: json["customer_billing_address"],
        numberOfPackage: json["number_of_package"],
        grandTotal: json["grand_total"].toDouble(),
        subTotal: json["sub_total"],
        discountTotal: json["discount_total"],
        shippingTotal: json["shipping_total"],
        numberOfItem: json["number_of_item"],
        orderStatus: json["order_status"],
        taxAmount: json["tax_amount"].toDouble(),
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "order_payment_id": orderPaymentId,
        "order_type": orderType,
        "order_number": orderNumber,
        "payment_type": paymentType,
        "is_paid": isPaid,
        "is_confirmed": isConfirmed,
        "is_completed": isCompleted,
        "is_cancelled": isCancelled,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "customer_shipping_address": customerShippingAddress,
        "customer_billing_address": customerBillingAddress,
        "number_of_package": numberOfPackage,
        "grand_total": grandTotal,
        "sub_total": subTotal,
        "discount_total": discountTotal,
        "shipping_total": shippingTotal,
        "number_of_item": numberOfItem,
        "order_status": orderStatus,
        "tax_amount": taxAmount,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class ProductElement {
  ProductElement({
    this.id,
    this.packageId,
    this.type,
    this.productSkuId,
    this.qty,
    this.price,
    this.totalPrice,
    this.taxAmount,
    this.createdAt,
    this.updatedAt,
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
  DateTime? createdAt;
  DateTime? updatedAt;
  SellerProductSku? sellerProductSku;
  GiftCard? giftCard;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        id: json["id"],
        packageId: json["package_id"],
        type: typeValues.map![json["type"]],
        productSkuId: json["product_sku_id"],
        qty: json["qty"],
        price: json["price"],
        totalPrice: json["total_price"],
        taxAmount: json["tax_amount"].toDouble(),
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        sellerProductSku: SellerProductSku.fromJson(json["seller_product_sku"]),
        giftCard: json["gift_card"] == null
            ? null
            : GiftCard.fromJson(json["gift_card"]),
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
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "seller_product_sku": sellerProductSku!.toJson(),
        "gift_card": giftCard == null ? null : giftCard!.toJson(),
      };
}

class GiftCard {
  GiftCard({
    this.id,
    this.name,
    this.sku,
    this.sellingPrice,
    this.thumbnailImage,
    this.discount,
    this.discountType,
    this.startDate,
    this.endDate,
    this.description,
    this.status,
    this.avgRating,
    this.createdBy,
    this.updatedBy,
    this.shippingId,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? name;
  String? sku;
  dynamic sellingPrice;
  String? thumbnailImage;
  dynamic discount;
  dynamic discountType;
  DateTime? startDate;
  DateTime? endDate;
  String? description;
  dynamic status;
  dynamic avgRating;
  dynamic createdBy;
  dynamic updatedBy;
  dynamic shippingId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
        id: json["id"],
        name: json["name"],
        sku: json["sku"],
        sellingPrice: json["selling_price"],
        thumbnailImage: json["thumbnail_image"],
        discount: json["discount"],
        discountType: json["discount_type"],
        startDate: DateTime?.parse(json["start_date"]),
        endDate: DateTime?.parse(json["end_date"]),
        description: json["description"],
        status: json["status"],
        avgRating: json["avg_rating"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        shippingId: json["shipping_id"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "sku": sku,
        "selling_price": sellingPrice,
        "thumbnail_image": thumbnailImage,
        "discount": discount,
        "discount_type": discountType,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "description": description,
        "status": status,
        "avg_rating": avgRating,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "shipping_id": shippingId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class SellerProductSkuProduct {
  SellerProductSkuProduct({
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
    this.recentView,
    this.createdAt,
    this.updatedAt,
    this.variantDetails,
    this.maxSellingPrice,
    this.hasDeal,
    this.rating,
    this.product,
    this.skus,
    this.reviews,
  });

  dynamic id;
  dynamic userId;
  dynamic productId;
  dynamic tax;
  String? taxType;
  dynamic discount;
  String? discountType;
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
  dynamic totalSale;
  dynamic avgRating;
  DateTime? recentView;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<VariantDetail>? variantDetails;
  dynamic maxSellingPrice;
  dynamic hasDeal;
  dynamic rating;
  ProductProduct? product;
  List<SellerProductSku>? skus;
  List<Review>? reviews;

  factory SellerProductSkuProduct.fromJson(Map<String, dynamic> json) =>
      SellerProductSkuProduct(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        tax: json["tax"],
        taxType: json["tax_type"],
        discount: json["discount"],
        discountType: json["discount_type"],
        discountStartDate: json["discount_start_date"],
        discountEndDate: json["discount_end_date"],
        productName: json["product_name"],
        slug: json["slug"],
        thumImg: json["thum_img"],
        status: json["status"],
        stockManage: json["stock_manage"],
        isApproved: json["is_approved"],
        minSellPrice: json["min_sell_price"],
        maxSellPrice: json["max_sell_price"],
        totalSale: json["total_sale"],
        avgRating: json["avg_rating"],
        recentView: DateTime?.parse(json["recent_view"]),
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        variantDetails: List<VariantDetail>.from(
            json["variantDetails"].map((x) => VariantDetail.fromJson(x))),
        maxSellingPrice: json["MaxSellingPrice"],
        hasDeal: json["hasDeal"],
        rating: json["rating"],
        product: ProductProduct.fromJson(json["product"]),
        skus: List<SellerProductSku>.from(
            json["skus"].map((x) => SellerProductSku.fromJson(x))),
        reviews: json["reviews"] == null
            ? null
            : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
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
        "recent_view": recentView!.toIso8601String(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "variantDetails":
            List<dynamic>.from(variantDetails!.map((x) => x.toJson())),
        "MaxSellingPrice": maxSellingPrice,
        "hasDeal": hasDeal,
        "rating": rating,
        "product": product!.toJson(),
        "skus": List<dynamic>.from(skus!.map((x) => x.toJson())),
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
      };
}

class SellerProductSku {
  SellerProductSku({
    this.id,
    this.userId,
    this.productId,
    this.productSkuId,
    this.productStock,
    this.purchasePrice,
    this.sellingPrice,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.productVariations,
  });

  dynamic id;
  dynamic userId;
  dynamic productId;
  String? productSkuId;
  dynamic productStock;
  dynamic purchasePrice;
  dynamic sellingPrice;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;
  SellerProductSkuProduct? product;
  List<ProductVariation>? productVariations;

  factory SellerProductSku.fromJson(Map<String, dynamic> json) =>
      SellerProductSku(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        productSkuId: json["product_sku_id"],
        productStock: json["product_stock"],
        purchasePrice: json["purchase_price"],
        sellingPrice: json["selling_price"],
        status: json["status"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        product: json["product"] == null
            ? null
            : SellerProductSkuProduct.fromJson(json["product"]),
        productVariations: List<ProductVariation>.from(
            json["product_variations"]
                .map((x) => ProductVariation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "product_sku_id": productSkuId,
        "product_stock": productStock,
        "purchase_price": purchasePrice,
        "selling_price": sellingPrice,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "product": product == null ? null : product!.toJson(),
        "product_variations":
            List<dynamic>.from(productVariations!.map((x) => x.toJson())),
      };
}

class ProductProduct {
  ProductProduct({
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
    this.displayInDetails,
    this.requestedBy,
    this.createdBy,
    this.slug,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
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
  dynamic tax;
  dynamic pdf;
  String? videoProvider;
  dynamic videoLink;
  String? description;
  String? specification;
  dynamic minimumOrderQty;
  dynamic maxOrderQty;
  dynamic metaTitle;
  dynamic metaDescription;
  dynamic metaImage;
  dynamic isPhysical;
  dynamic isApproved;
  dynamic displayInDetails;
  dynamic requestedBy;
  dynamic createdBy;
  String? slug;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
        id: json["id"],
        productName: json["product_name"],
        productType: json["product_type"],
        unitTypeId: json["unit_type_id"],
        brandId: json["brand_id"],
        categoryId: json["category_id"],
        thumbnailImageSource: json["thumbnail_image_source"],
        barcodeType: json["barcode_type"],
        modelNumber: json["model_number"],
        shippingType: json["shipping_type"],
        shippingCost: json["shipping_cost"],
        discountType: json["discount_type"],
        discount: json["discount"],
        taxType: json["tax_type"],
        tax: json["tax"],
        pdf: json["pdf"],
        videoProvider: json["video_provider"],
        videoLink: json["video_link"],
        description: json["description"],
        specification: json["specification"],
        minimumOrderQty: json["minimum_order_qty"],
        maxOrderQty: json["max_order_qty"],
        metaTitle: json["meta_title"],
        metaDescription: json["meta_description"],
        metaImage: json["meta_image"],
        isPhysical: json["is_physical"],
        isApproved: json["is_approved"],
        displayInDetails: json["display_in_details"],
        requestedBy: json["requested_by"],
        createdBy: json["created_by"],
        slug: json["slug"],
        updatedBy: json["updated_by"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_type": productType,
        "unit_type_id": unitTypeId,
        "brand_id": brandId,
        "category_id": categoryId,
        "thumbnail_image_source": thumbnailImageSource,
        "barcode_type": barcodeType,
        "model_number": modelNumber,
        "shipping_type": shippingType,
        "shipping_cost": shippingCost,
        "discount_type": discountType,
        "discount": discount,
        "tax_type": taxType,
        "tax": tax,
        "pdf": pdf,
        "video_provider": videoProvider,
        "video_link": videoLink,
        "description": description,
        "specification": specification,
        "minimum_order_qty": minimumOrderQty,
        "max_order_qty": maxOrderQty,
        "meta_title": metaTitle,
        "meta_description": metaDescription,
        "meta_image": metaImage,
        "is_physical": isPhysical,
        "is_approved": isApproved,
        "display_in_details": displayInDetails,
        "requested_by": requestedBy,
        "created_by": createdBy,
        "slug": slug,
        "updated_by": updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Review {
  Review({
    this.id,
    this.customerId,
    this.sellerId,
    this.productId,
    this.orderId,
    this.packageId,
    this.review,
    this.rating,
    this.isAnonymous,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic customerId;
  dynamic sellerId;
  dynamic productId;
  dynamic orderId;
  dynamic packageId;
  String? review;
  dynamic rating;
  dynamic isAnonymous;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json["id"],
        customerId: json["customer_id"],
        sellerId: json["seller_id"],
        productId: json["product_id"],
        orderId: json["order_id"],
        packageId: json["package_id"],
        review: json["review"],
        rating: json["rating"],
        isAnonymous: json["is_anonymous"],
        status: json["status"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "seller_id": sellerId,
        "product_id": productId,
        "order_id": orderId,
        "package_id": packageId,
        "review": review,
        "rating": rating,
        "is_anonymous": isAnonymous,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class VariantDetail {
  VariantDetail({
    this.value,
    this.code,
    this.attrValId,
    this.name,
    this.attrId,
  });

  List<String>? value;
  List<String>? code;
  List<dynamic>? attrValId;
  Name? name;
  dynamic attrId;

  factory VariantDetail.fromJson(Map<String, dynamic> json) => VariantDetail(
        value: List<String>.from(json["value"].map((x) => x)),
        code: List<String>.from(json["code"].map((x) => x)),
        attrValId: List<dynamic>.from(json["attr_val_id"].map((x) => x)),
        name: nameValues.map![json["name"]],
        attrId: json["attr_id"],
      );

  Map<String, dynamic> toJson() => {
        "value": List<dynamic>.from(value!.map((x) => x)),
        "code": List<dynamic>.from(code!.map((x) => x)),
        "attr_val_id": List<dynamic>.from(attrValId!.map((x) => x)),
        "name": nameValues.reverse[name],
        "attr_id": attrId,
      };
}

enum Name { STORAGE, COLOR }

final nameValues = EnumValues({"Color": Name.COLOR, "Storage": Name.STORAGE});

class ProductVariation {
  ProductVariation({
    this.id,
    this.productId,
    this.productSkuId,
    this.attributeId,
    this.attributeValueId,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.attributeValue,
    this.attribute,
  });

  dynamic id;
  dynamic productId;
  dynamic productSkuId;
  dynamic attributeId;
  dynamic attributeValueId;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  AttributeValue? attributeValue;
  Attribute? attribute;

  factory ProductVariation.fromJson(Map<String, dynamic> json) =>
      ProductVariation(
        id: json["id"],
        productId: json["product_id"],
        productSkuId: json["product_sku_id"],
        attributeId: json["attribute_id"],
        attributeValueId: json["attribute_value_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        attributeValue: AttributeValue.fromJson(json["attribute_value"]),
        attribute: Attribute.fromJson(json["attribute"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "product_sku_id": productSkuId,
        "attribute_id": attributeId,
        "attribute_value_id": attributeValueId,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "attribute_value": attributeValue!.toJson(),
        "attribute": attribute!.toJson(),
      };
}

class Attribute {
  Attribute({
    this.id,
    this.name,
    this.displayType,
    this.description,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? name;
  DisplayType? displayType;
  String? description;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        name: json["name"],
        displayType: displayTypeValues.map![json["display_type"]],
        description: json["description"] == null ? null : json["description"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "display_type": displayTypeValues.reverse[displayType],
        "description": description == null ? null : description,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

enum DisplayType { RADIO_BUTTON }

final displayTypeValues =
    EnumValues({"radio_button": DisplayType.RADIO_BUTTON});

class AttributeValue {
  AttributeValue({
    this.id,
    this.value,
    this.attributeId,
    this.createdAt,
    this.updatedAt,
    this.color,
  });

  dynamic id;
  String? value;
  dynamic attributeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  AttributeColor? color;

  factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
        id: json["id"],
        value: json["value"],
        attributeId: json["attribute_id"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime?.parse(json["updated_at"]),
        color: json["color"] == null
            ? null
            : AttributeColor.fromJson(json["color"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "value": value,
        "attribute_id": attributeId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
        "color": color == null ? null : color!.toJson(),
      };
}

class AttributeColor {
  AttributeColor({
    this.id,
    this.attributeValueId,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic attributeValueId;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory AttributeColor.fromJson(Map<String, dynamic> json) => AttributeColor(
        id: json["id"],
        attributeValueId: json["attribute_value_id"],
        name: json["name"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "attribute_value_id": attributeValueId,
        "name": name,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map!.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap!;
  }
}
