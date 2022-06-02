import 'package:amazcart/model/NewModel/Customer/CustomerData.dart';
import 'package:amazcart/model/NewModel/Customer/CustomerShippingAddress.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';

class OrderData {
  OrderData({
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
    this.customer,
    this.packages,
    this.shippingAddress,
    this.billingAddress,
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
  CustomerData? customer;
  List<Package>? packages;
  CustomerShippingAddress? shippingAddress;
  CustomerShippingAddress? billingAddress;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory OrderData.fromJson(Map<String, dynamic> json) => OrderData(
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
        taxAmount: json["tax_amount"].toDouble(),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customer: json["customer"] == null
            ? null
            : CustomerData.fromJson(json["customer"]),
        packages: json["packages"] == null
            ? null
            : List<Package>.from(
                json["packages"].map((x) => Package.fromJson(x))),
        shippingAddress: json["shipping_address"] == null
            ? null
            : CustomerShippingAddress.fromJson(json["shipping_address"]),
        billingAddress: json["billing_address"] == null
            ? null
            : CustomerShippingAddress.fromJson(json["billing_address"]),
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
        "tax_amount": taxAmount,
        "customer": customer!.toJson(),
        "packages": List<dynamic>.from(packages!.map((x) => x.toJson())),
        "shipping_address": shippingAddress!.toJson(),
        "billing_address": billingAddress!.toJson(),
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
