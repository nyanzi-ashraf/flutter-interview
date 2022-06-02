// To parse this JSON data, do
//
//     final myPurchasedGiftCards = myPurchasedGiftCardsFromJson(jsonString);

import 'dart:convert';

MyPurchasedGiftCards myPurchasedGiftCardsFromJson(String str) =>
    MyPurchasedGiftCards.fromJson(json.decode(str));

String myPurchasedGiftCardsToJson(MyPurchasedGiftCards data) =>
    json.encode(data.toJson());

class MyPurchasedGiftCards {
  MyPurchasedGiftCards({
    this.giftcards,
    this.message,
  });

  Giftcards? giftcards;
  String? message;

  factory MyPurchasedGiftCards.fromJson(Map<String, dynamic> json) =>
      MyPurchasedGiftCards(
        giftcards: Giftcards.fromJson(json["giftcards"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "giftcards": giftcards!.toJson(),
        "message": message,
      };
}

class Giftcards {
  Giftcards({
    this.currentPage,
    this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  dynamic currentPage;
  List<GiftCardDatum>? data;
  String? firstPageUrl;
  dynamic from;
  dynamic lastPage;
  String? lastPageUrl;
  List<Link>? links;
  dynamic nextPageUrl;
  String? path;
  dynamic perPage;
  dynamic prevPageUrl;
  dynamic to;
  dynamic total;

  factory Giftcards.fromJson(Map<String, dynamic> json) => Giftcards(
        currentPage: json["current_page"],
        data: List<GiftCardDatum>.from(
            json["data"].map((x) => GiftCardDatum.fromJson(x))),
        firstPageUrl: json["first_page_url"],
        from: json["from"],
        lastPage: json["last_page"],
        lastPageUrl: json["last_page_url"],
        links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
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
        "links": List<dynamic>.from(links!.map((x) => x.toJson())),
        "next_page_url": nextPageUrl,
        "path": path,
        "per_page": perPage,
        "prev_page_url": prevPageUrl,
        "to": to,
        "total": total,
      };
}

class GiftCardDatum {
  GiftCardDatum({
    this.id,
    this.giftCardId,
    this.qty,
    this.orderId,
    this.isUsed,
    this.secretCode,
    this.mailSentDate,
    this.isMailSent,
    this.createdAt,
    this.updatedAt,
    this.order,
    this.giftCard,
  });

  dynamic id;
  dynamic giftCardId;
  dynamic qty;
  dynamic orderId;
  dynamic isUsed;
  String? secretCode;
  DateTime? mailSentDate;
  dynamic isMailSent;
  DateTime? createdAt;
  DateTime? updatedAt;
  Order? order;
  GiftCard? giftCard;

  factory GiftCardDatum.fromJson(Map<String, dynamic> json) => GiftCardDatum(
        id: json["id"],
        giftCardId: json["gift_card_id"],
        qty: json["qty"],
        orderId: json["order_id"],
        isUsed: json["is_used"],
        secretCode: json["secret_code"],
        mailSentDate: DateTime.parse(json["mail_sent_date"]),
        isMailSent: json["is_mail_sent"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        order: Order.fromJson(json["order"]),
        giftCard: GiftCard.fromJson(json["gift_card"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "gift_card_id": giftCardId,
        "qty": qty,
        "order_id": orderId,
        "is_used": isUsed,
        "secret_code": secretCode,
        "mail_sent_date":
            "${mailSentDate!.year.toString().padLeft(4, '0')}-${mailSentDate!.month.toString().padLeft(2, '0')}-${mailSentDate!.day.toString().padLeft(2, '0')}",
        "is_mail_sent": isMailSent,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "order": order!.toJson(),
        "gift_card": giftCard!.toJson(),
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
    this.galaryImages,
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
  List<dynamic>? galaryImages;

  factory GiftCard.fromJson(Map<String, dynamic> json) => GiftCard(
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
        updatedBy: json["updated_by"],
        shippingId: json["shipping_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        galaryImages: List<dynamic>.from(json["galary_images"].map((x) => x)),
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
        "galary_images": List<dynamic>.from(galaryImages!.map((x) => x)),
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
    this.cancelReasonId,
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
  dynamic cancelReasonId;
  String? customerEmail;
  String? customerPhone;
  dynamic customerShippingAddress;
  dynamic customerBillingAddress;
  dynamic numberOfPackage;
  dynamic grandTotal;
  dynamic subTotal;
  dynamic discountTotal;
  dynamic shippingTotal;
  dynamic numberOfItem;
  dynamic orderStatus;
  dynamic taxAmount;
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
        cancelReasonId: json["cancel_reason_id"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        customerShippingAddress: json["customer_shipping_address"],
        customerBillingAddress: json["customer_billing_address"],
        numberOfPackage: json["number_of_package"],
        grandTotal: json["grand_total"],
        subTotal: json["sub_total"],
        discountTotal: json["discount_total"],
        shippingTotal: json["shipping_total"],
        numberOfItem: json["number_of_item"],
        orderStatus: json["order_status"],
        taxAmount: json["tax_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
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
        "cancel_reason_id": cancelReasonId,
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

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
  String? label;
  bool? active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
        url: json["url"] == null ? null : json["url"],
        label: json["label"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "url": url == null ? null : url,
        "label": label,
        "active": active,
      };
}
