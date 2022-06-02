// To parse this JSON data, do
//
//     final userNotificationModel = userNotificationModelFromJson(jsonString);

import 'dart:convert';

UserNotificationModel userNotificationModelFromJson(String str) =>
    UserNotificationModel.fromJson(json.decode(str));

String userNotificationModelToJson(UserNotificationModel data) =>
    json.encode(data.toJson());

class UserNotificationModel {
  UserNotificationModel({
    this.notifications,
  });

  Notifications? notifications;

  factory UserNotificationModel.fromJson(Map<String, dynamic> json) =>
      UserNotificationModel(
        notifications: Notifications.fromJson(json["notifications"]),
      );

  Map<String, dynamic> toJson() => {
        "notifications": notifications!.toJson(),
      };
}

class Notifications {
  Notifications({
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

  int? currentPage;
  List<NotificationData>? data;
  String? firstPageUrl;
  int? from;
  int? lastPage;
  String? lastPageUrl;
  List<Link>? links;
  String? nextPageUrl;
  String? path;
  int? perPage;
  dynamic prevPageUrl;
  int? to;
  int? total;

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        currentPage: json["current_page"],
        data: List<NotificationData>.from(
            json["data"].map((x) => NotificationData.fromJson(x))),
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

class NotificationData {
  NotificationData({
    this.id,
    this.orderId,
    this.customerId,
    this.sellerId,
    this.title,
    this.description,
    this.readStatus,
    this.superAdminReadStatus,
    this.createdAt,
    this.updatedAt,
    this.order,
  });

  int? id;
  int? orderId;
  int? customerId;
  dynamic sellerId;
  String? title;
  dynamic description;
  int? readStatus;
  int? superAdminReadStatus;
  DateTime? createdAt;
  DateTime? updatedAt;
  Order? order;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"],
        orderId: json["order_id"],
        customerId: json["customer_id"],
        sellerId: json["seller_id"],
        title: json["title"],
        description: json["description"],
        readStatus: json["read_status"],
        superAdminReadStatus: json["super_admin_read_status"],
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
        order: json["order"] == null ? null : Order.fromJson(json["order"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_id": orderId,
        "customer_id": customerId,
        "seller_id": sellerId,
        "title": title,
        "description": description,
        "read_status": readStatus,
        "super_admin_read_status": superAdminReadStatus,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "order": order == null ? null : order!.toJson(),
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

  int? id;
  int? customerId;
  dynamic orderPaymentId;
  dynamic orderType;
  String? orderNumber;
  int? paymentType;
  int? isPaid;
  int? isConfirmed;
  int? isCompleted;
  int? isCancelled;
  dynamic cancelReasonId;
  String? customerEmail;
  String? customerPhone;
  int? customerShippingAddress;
  int? customerBillingAddress;
  int? numberOfPackage;
  double? grandTotal;
  int? subTotal;
  int? discountTotal;
  int? shippingTotal;
  int? numberOfItem;
  int? orderStatus;
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
        cancelReasonId: json["cancel_reason_id"],
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
