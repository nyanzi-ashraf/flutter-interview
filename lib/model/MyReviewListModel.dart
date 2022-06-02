// To parse this JSON data, do
//
//     final myReviewListModel = myReviewListModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Product/ProductType.dart';

MyReviewListModel myReviewListModelFromJson(String str) =>
    MyReviewListModel.fromJson(json.decode(str));

String myReviewListModelToJson(MyReviewListModel data) =>
    json.encode(data.toJson());

class MyReviewListModel {
  MyReviewListModel({
    this.reviews,
    this.message,
  });

  List<MyReviewListModelReview>? reviews;
  String? message;

  factory MyReviewListModel.fromJson(Map<String, dynamic> json) =>
      MyReviewListModel(
        reviews: List<MyReviewListModelReview>.from(
            json["reviews"].map((x) => MyReviewListModelReview.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "message": message,
      };
}

class MyReviewListModelReview {
  MyReviewListModelReview({
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
    this.processes,
    this.order,
    this.reviews,
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
  DeliveryStateNameEnum? deliveryStateName;
  double? totalGst;
  List<Process>? processes;
  Order? order;
  List<ReviewReview>? reviews;
  List<ProductElement>? products;
  List<GstTax>? gstTaxes;

  factory MyReviewListModelReview.fromJson(Map<String, dynamic> json) =>
      MyReviewListModelReview(
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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deliveryStateName:
            deliveryStateNameEnumValues.map![json["deliveryStateName"]],
        totalGst: json["totalGST"].toDouble(),
        processes: List<Process>.from(
            json["processes"].map((x) => Process.fromJson(x))),
        order: Order.fromJson(json["order"]),
        reviews: List<ReviewReview>.from(
            json["reviews"].map((x) => ReviewReview.fromJson(x))),
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
        "deliveryStateName":
            deliveryStateNameEnumValues.reverse[deliveryStateName],
        "totalGST": totalGst,
        "processes": List<dynamic>.from(processes!.map((x) => x.toJson())),
        "order": order!.toJson(),
        "reviews": List<dynamic>.from(reviews!.map((x) => x.toJson())),
        "products": List<dynamic>.from(products!.map((x) => x.toJson())),
        "gst_taxes": List<dynamic>.from(gstTaxes!.map((x) => x.toJson())),
      };
}

enum DeliveryStateNameEnum {
  DELIVERED,
  PENDING,
  PROCESSING,
  SHIPPED,
  RECIEVED,
  RED,
  BLACK,
  GOLD
}

final deliveryStateNameEnumValues = EnumValues({
  "Black": DeliveryStateNameEnum.BLACK,
  "Delivered": DeliveryStateNameEnum.DELIVERED,
  "Gold": DeliveryStateNameEnum.GOLD,
  "Pending": DeliveryStateNameEnum.PENDING,
  "Processing": DeliveryStateNameEnum.PROCESSING,
  "Recieved": DeliveryStateNameEnum.RECIEVED,
  "Red": DeliveryStateNameEnum.RED,
  "Shipped": DeliveryStateNameEnum.SHIPPED
});

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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
    this.cancelReasonId,
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
  dynamic cancelReasonId;
  double? taxAmount;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        id: json["id"],
        customerId: json["customer_id"],
        orderPaymentId:
            json["order_payment_id"] == null ? null : json["order_payment_id"],
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
        cancelReasonId: json["cancel_reason_id"],
        taxAmount: json["tax_amount"].toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "order_payment_id": orderPaymentId == null ? null : orderPaymentId,
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
        "cancel_reason_id": cancelReasonId,
        "tax_amount": taxAmount,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class Process {
  Process({
    this.id,
    this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.attributeValueId,
  });

  dynamic id;
  DeliveryStateNameEnum? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic attributeValueId;

  factory Process.fromJson(Map<String, dynamic> json) => Process(
        id: json["id"],
        name: deliveryStateNameEnumValues.map![json["name"]],
        description: json["description"] == null ? null : json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        attributeValueId: json["attribute_value_id"] == null
            ? null
            : json["attribute_value_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": deliveryStateNameEnumValues.reverse[name],
        "description": description == null ? null : description,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "attribute_value_id":
            attributeValueId == null ? null : attributeValueId,
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

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
        id: json["id"],
        packageId: json["package_id"],
        type: typeValues.map![json["type"]],
        productSkuId: json["product_sku_id"],
        qty: json["qty"],
        price: json["price"],
        totalPrice: json["total_price"],
        taxAmount: json["tax_amount"].toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sellerProductSku: SellerProductSku.fromJson(json["seller_product_sku"]),
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
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "product_variations":
            List<dynamic>.from(productVariations!.map((x) => x.toJson())),
      };
}

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
    this.attribute,
    this.attributeValue,
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
  Attribute? attribute;
  AttributeValue? attributeValue;

  factory ProductVariation.fromJson(Map<String, dynamic> json) =>
      ProductVariation(
        id: json["id"],
        productId: json["product_id"],
        productSkuId: json["product_sku_id"],
        attributeId: json["attribute_id"],
        attributeValueId: json["attribute_value_id"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        attribute: Attribute.fromJson(json["attribute"]),
        attributeValue: AttributeValue.fromJson(json["attribute_value"]),
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
        "attribute": attribute!.toJson(),
        "attribute_value": attributeValue!.toJson(),
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
  AttributeName? name;
  String? displayType;
  String? description;
  dynamic status;
  dynamic createdBy;
  dynamic updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Attribute.fromJson(Map<String, dynamic> json) => Attribute(
        id: json["id"],
        name: attributeNameValues.map![json["name"]],
        displayType: json["display_type"],
        description: json["description"] == null ? null : json["description"],
        status: json["status"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": attributeNameValues.reverse[name],
        "display_type": displayType,
        "description": description == null ? null : description,
        "status": status,
        "created_by": createdBy,
        "updated_by": updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

enum AttributeName { STORAGE, COLOR }

final attributeNameValues = EnumValues(
    {"Color": AttributeName.COLOR, "Storage": AttributeName.STORAGE});

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
  Process? color;

  factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
        id: json["id"],
        value: json["value"],
        attributeId: json["attribute_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        color: json["color"] == null ? null : Process.fromJson(json["color"]),
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

class ReviewReview {
  ReviewReview({
    this.id,
    this.customerId,
    this.sellerId,
    this.productId,
    this.orderId,
    this.packageId,
    this.type,
    this.review,
    this.rating,
    this.isAnonymous,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.giftcard,
    this.product,
    this.reply,
    this.seller,
    this.images,
  });

  dynamic id;
  dynamic customerId;
  dynamic sellerId;
  dynamic productId;
  dynamic orderId;
  dynamic packageId;
  ProductType? type;
  String? review;
  dynamic rating;
  dynamic isAnonymous;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;
  Giftcard? giftcard;
  PurpleProduct? product;
  dynamic? reply;
  Seller? seller;
  List<ReviewImage>? images;

  factory ReviewReview.fromJson(Map<String, dynamic> json) => ReviewReview(
        id: json["id"],
        customerId: json["customer_id"],
        sellerId: json["seller_id"],
        productId: json["product_id"],
        orderId: json["order_id"],
        packageId: json["package_id"],
        type: typeValues.map![json["type"]],
        review: json["review"],
        rating: json["rating"],
        isAnonymous: json["is_anonymous"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        giftcard: json["giftcard"] == null
            ? null
            : Giftcard.fromJson(json["giftcard"]),
        product: PurpleProduct.fromJson(json["product"]),
        reply: json["reply"],
        seller: Seller.fromJson(json["seller"]),
        images: List<ReviewImage>.from(
            json["images"].map((x) => ReviewImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "seller_id": sellerId,
        "product_id": productId,
        "order_id": orderId,
        "package_id": packageId,
        "type": typeValues.reverse[type],
        "review": review,
        "rating": rating,
        "is_anonymous": isAnonymous,
        "status": status,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "giftcard": giftcard == null ? null : giftcard!.toJson(),
        "product": product!.toJson(),
        "reply": reply,
        "seller": seller!.toJson(),
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class Giftcard {
  Giftcard({
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

  factory Giftcard.fromJson(Map<String, dynamic> json) => Giftcard(
        id: json["id"],
        name: json["name"],
        sku: json["sku"],
        sellingPrice: json["selling_price"],
        thumbnailImage: json["thumbnail_image"],
        discount: json["discount"],
        discountType: json["discount_type"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        description: json["description"],
        status: json["status"],
        avgRating: json["avg_rating"],
        createdBy: json["created_by"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        shippingId: json["shipping_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "updated_by": updatedBy == null ? null : updatedBy,
        "shipping_id": shippingId,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class ReviewImage {
  ReviewImage({
    this.id,
    this.reviewId,
    this.productId,
    this.type,
    this.image,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic reviewId;
  dynamic productId;
  ProductType? type;
  String? image;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ReviewImage.fromJson(Map<String, dynamic> json) => ReviewImage(
        id: json["id"],
        reviewId: json["review_id"],
        productId: json["product_id"],
        type: typeValues.map![json["type"]],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "review_id": reviewId,
        "product_id": productId,
        "type": typeValues.reverse[type],
        "image": image,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class PurpleProduct {
  PurpleProduct({
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
  String? discountStartDate;
  String? discountEndDate;
  String? productName;
  String? slug;
  dynamic thumImg;
  dynamic status;
  dynamic stockManage;
  dynamic isApproved;
  dynamic minSellPrice;
  dynamic maxSellPrice;
  dynamic totalSale;
  double? avgRating;
  DateTime? recentView;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<VariantDetail>? variantDetails;
  dynamic maxSellingPrice;
  dynamic hasDeal;
  double? rating;
  ProductProduct? product;
  List<SellerProductSku>? skus;
  List<ProductReview>? reviews;

  factory PurpleProduct.fromJson(Map<String, dynamic> json) => PurpleProduct(
        id: json["id"],
        userId: json["user_id"],
        productId: json["product_id"],
        tax: json["tax"],
        taxType: json["tax_type"],
        discount: json["discount"],
        discountType: json["discount_type"],
        discountStartDate: json["discount_start_date"] == null
            ? null
            : json["discount_start_date"],
        discountEndDate: json["discount_end_date"] == null
            ? null
            : json["discount_end_date"],
        productName: json["product_name"],
        slug: json["slug"],
        thumImg: json["thum_img"],
        status: json["status"],
        stockManage: json["stock_manage"],
        isApproved: json["is_approved"],
        minSellPrice: json["min_sell_price"],
        maxSellPrice: json["max_sell_price"],
        totalSale: json["total_sale"],
        avgRating: json["avg_rating"].toDouble(),
        recentView: DateTime.parse(json["recent_view"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        variantDetails: List<VariantDetail>.from(
            json["variantDetails"].map((x) => VariantDetail.fromJson(x))),
        maxSellingPrice: json["MaxSellingPrice"],
        hasDeal: json["hasDeal"],
        rating: json["rating"].toDouble(),
        product: ProductProduct.fromJson(json["product"]),
        skus: List<SellerProductSku>.from(
            json["skus"].map((x) => SellerProductSku.fromJson(x))),
        reviews: List<ProductReview>.from(
            json["reviews"].map((x) => ProductReview.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "product_id": productId,
        "tax": tax,
        "tax_type": taxType,
        "discount": discount,
        "discount_type": discountType,
        "discount_start_date":
            discountStartDate == null ? null : discountStartDate,
        "discount_end_date": discountEndDate == null ? null : discountEndDate,
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
  BarcodeType? barcodeType;
  String? modelNumber;
  dynamic shippingType;
  dynamic shippingCost;
  String? discountType;
  dynamic discount;
  String? taxType;
  dynamic tax;
  dynamic pdf;
  VideoProvider? videoProvider;
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
        brandId: json["brand_id"] == null ? null : json["brand_id"],
        categoryId: json["category_id"],
        thumbnailImageSource: json["thumbnail_image_source"],
        barcodeType: barcodeTypeValues.map![json["barcode_type"]],
        modelNumber: json["model_number"] == null ? null : json["model_number"],
        shippingType: json["shipping_type"],
        shippingCost: json["shipping_cost"],
        discountType: json["discount_type"],
        discount: json["discount"],
        taxType: json["tax_type"],
        tax: json["tax"],
        pdf: json["pdf"],
        videoProvider: videoProviderValues.map![json["video_provider"]],
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
        displayInDetails: json["display_in_details"],
        requestedBy: json["requested_by"],
        createdBy: json["created_by"],
        slug: json["slug"],
        updatedBy: json["updated_by"] == null ? null : json["updated_by"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_name": productName,
        "product_type": productType,
        "unit_type_id": unitTypeId,
        "brand_id": brandId == null ? null : brandId,
        "category_id": categoryId,
        "thumbnail_image_source": thumbnailImageSource,
        "barcode_type": barcodeTypeValues.reverse[barcodeType],
        "model_number": modelNumber == null ? null : modelNumber,
        "shipping_type": shippingType,
        "shipping_cost": shippingCost,
        "discount_type": discountType,
        "discount": discount,
        "tax_type": taxType,
        "tax": tax,
        "pdf": pdf,
        "video_provider": videoProviderValues.reverse[videoProvider],
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
        "display_in_details": displayInDetails,
        "requested_by": requestedBy,
        "created_by": createdBy,
        "slug": slug,
        "updated_by": updatedBy == null ? null : updatedBy,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

enum BarcodeType { C39 }

final barcodeTypeValues = EnumValues({"C39": BarcodeType.C39});

enum VideoProvider { YOUTUBE }

final videoProviderValues = EnumValues({"youtube": VideoProvider.YOUTUBE});

class ProductReview {
  ProductReview({
    this.id,
    this.customerId,
    this.sellerId,
    this.productId,
    this.orderId,
    this.packageId,
    this.type,
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
  ProductType? type;
  String? review;
  dynamic rating;
  dynamic isAnonymous;
  dynamic status;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ProductReview.fromJson(Map<String, dynamic> json) => ProductReview(
        id: json["id"],
        customerId: json["customer_id"],
        sellerId: json["seller_id"],
        productId: json["product_id"],
        orderId: json["order_id"],
        packageId: json["package_id"],
        type: typeValues.map![json["type"]],
        review: json["review"],
        rating: json["rating"],
        isAnonymous: json["is_anonymous"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "seller_id": sellerId,
        "product_id": productId,
        "order_id": orderId,
        "package_id": packageId,
        "type": typeValues.reverse[type],
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
  String? name;
  dynamic attrId;

  factory VariantDetail.fromJson(Map<String, dynamic> json) => VariantDetail(
        value: List<String>.from(json["value"].map((x) => x)),
        code: List<String>.from(json["code"].map((x) => x)),
        attrValId: List<dynamic>.from(json["attr_val_id"].map((x) => x)),
        name: json["name"],
        attrId: json["attr_id"],
      );

  Map<String, dynamic> toJson() => {
        "value": List<dynamic>.from(value!.map((x) => x)),
        "code": List<dynamic>.from(code!.map((x) => x)),
        "attr_val_id": List<dynamic>.from(attrValId!.map((x) => x)),
        "name": attributeNameValues.reverse[name],
        "attr_id": attrId,
      };
}

class Seller {
  Seller({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.photo,
    this.roleId,
    this.mobileVerifiedAt,
    this.email,
    this.isVerified,
    this.verifyCode,
    this.emailVerifiedAt,
    this.notificationPreference,
    this.isActive,
    this.avatar,
    this.phone,
    this.dateOfBirth,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? firstName;
  dynamic lastName;
  String? username;
  dynamic photo;
  dynamic roleId;
  dynamic mobileVerifiedAt;
  String? email;
  dynamic isVerified;
  String? verifyCode;
  dynamic emailVerifiedAt;
  String? notificationPreference;
  dynamic isActive;
  dynamic avatar;
  dynamic phone;
  dynamic dateOfBirth;
  dynamic description;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Seller.fromJson(Map<String, dynamic> json) => Seller(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        username: json["username"],
        photo: json["photo"],
        roleId: json["role_id"],
        mobileVerifiedAt: json["mobile_verified_at"],
        email: json["email"],
        isVerified: json["is_verified"],
        verifyCode: json["verify_code"],
        emailVerifiedAt: json["email_verified_at"],
        notificationPreference: json["notification_preference"],
        isActive: json["is_active"],
        avatar: json["avatar"],
        phone: json["phone"],
        dateOfBirth: json["date_of_birth"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "photo": photo,
        "role_id": roleId,
        "mobile_verified_at": mobileVerifiedAt,
        "email": email,
        "is_verified": isVerified,
        "verify_code": verifyCode,
        "email_verified_at": emailVerifiedAt,
        "notification_preference": notificationPreference,
        "is_active": isActive,
        "avatar": avatar,
        "phone": phone,
        "date_of_birth": dateOfBirth,
        "description": description,
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
