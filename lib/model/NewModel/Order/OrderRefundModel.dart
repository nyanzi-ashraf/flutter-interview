// To parse this JSON data, do
//
//     final orderRefundModel = orderRefundModelFromJson(jsonString);

import 'dart:convert';

import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariations.dart';
import 'package:amazcart/model/NewModel/Seller/SellerData.dart';

OrderRefundModel orderRefundModelFromJson(String str) =>
    OrderRefundModel.fromJson(json.decode(str));

String orderRefundModelToJson(OrderRefundModel data) =>
    json.encode(data.toJson());

class OrderRefundModel {
  OrderRefundModel({
    this.refundOrders,
    this.message,
  });

  List<RefundOrder>? refundOrders;
  String? message;

  factory OrderRefundModel.fromJson(Map<String, dynamic> json) =>
      OrderRefundModel(
        refundOrders: List<RefundOrder>.from(
            json["refundOrders"].map((x) => RefundOrder.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "refundOrders":
            List<dynamic>.from(refundOrders!.map((x) => x.toJson())),
        "message": message,
      };
}

class RefundOrder {
  RefundOrder({
    this.id,
    this.customerId,
    this.orderId,
    this.refundMethod,
    this.shippingMethod,
    this.shippingMethodId,
    this.pickUpAddressId,
    this.dropOffAddress,
    this.additionalInfo,
    this.totalReturnAmount,
    this.refundState,
    this.isConfirmed,
    this.isRefunded,
    this.isCompleted,
    this.createdAt,
    this.updatedAt,
    this.checkConfirmed,
    this.order,
    this.shippingGateway,
    this.pickUpAddressCustomer,
    this.refundDetails,
  });

  dynamic id;
  dynamic customerId;
  dynamic orderId;
  String? refundMethod;
  String? shippingMethod;
  dynamic shippingMethodId;
  dynamic pickUpAddressId;
  dynamic dropOffAddress;
  dynamic additionalInfo;
  dynamic totalReturnAmount;
  dynamic refundState;
  dynamic isConfirmed;
  dynamic isRefunded;
  dynamic isCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? checkConfirmed;
  Order? order;
  ShippingGateway? shippingGateway;
  PickUpAddressCustomer? pickUpAddressCustomer;
  List<RefundDetail>? refundDetails;

  factory RefundOrder.fromJson(Map<String, dynamic> json) => RefundOrder(
        id: json["id"],
        customerId: json["customer_id"],
        orderId: json["order_id"],
        refundMethod: json["refund_method"],
        shippingMethod: json["shipping_method"],
        shippingMethodId: json["shipping_method_id"],
        pickUpAddressId: json["pick_up_address_id"],
        dropOffAddress: json["drop_off_address"],
        additionalInfo: json["additional_info"],
        totalReturnAmount: json["total_return_amount"],
        refundState: json["refund_state"],
        isConfirmed: json["is_confirmed"],
        isRefunded: json["is_refunded"],
        isCompleted: json["is_completed"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        checkConfirmed: json["CheckConfirmed"],
        order: Order.fromJson(json["order"]),
        shippingGateway: json["shipping_gateway"] == null
            ? null
            : ShippingGateway.fromJson(json["shipping_gateway"]),
        pickUpAddressCustomer: json["pick_up_address_customer"] == null
            ? null
            : PickUpAddressCustomer.fromJson(json["pick_up_address_customer"]),
        refundDetails: json["refund_details"] == null
            ? null
            : List<RefundDetail>.from(
                json["refund_details"].map((x) => RefundDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "order_id": orderId,
        "refund_method": refundMethod,
        "shipping_method": shippingMethod,
        "shipping_method_id": shippingMethodId,
        "pick_up_address_id": pickUpAddressId,
        "drop_off_address": dropOffAddress,
        "additional_info": additionalInfo,
        "total_return_amount": totalReturnAmount,
        "refund_state": refundState,
        "is_confirmed": isConfirmed,
        "is_refunded": isRefunded,
        "is_completed": isCompleted,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "CheckConfirmed": checkConfirmed,
        "order": order!.toJson(),
        "shipping_gateway": shippingGateway!.toJson(),
        "pick_up_address_customer": pickUpAddressCustomer!.toJson(),
        "refund_details":
            List<dynamic>.from(refundDetails!.map((x) => x.toJson())),
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

class PickUpAddressCustomer {
  PickUpAddressCustomer({
    this.id,
    this.customerId,
    this.name,
    this.email,
    this.phone,
    this.address,
    this.city,
    this.state,
    this.country,
    this.postalCode,
    this.isShippingDefault,
    this.isBillingDefault,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic customerId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  dynamic isShippingDefault;
  dynamic isBillingDefault;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory PickUpAddressCustomer.fromJson(Map<String, dynamic> json) =>
      PickUpAddressCustomer(
        id: json["id"],
        customerId: json["customer_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        address: json["address"],
        city: json["city"],
        state: json["state"],
        country: json["country"],
        postalCode: json["postal_code"],
        isShippingDefault: json["is_shipping_default"],
        isBillingDefault: json["is_billing_default"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "customer_id": customerId,
        "name": name,
        "email": email,
        "phone": phone,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "postal_code": postalCode,
        "is_shipping_default": isShippingDefault,
        "is_billing_default": isBillingDefault,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}

class RefundDetail {
  RefundDetail({
    this.id,
    this.refundRequestId,
    this.orderPackageId,
    this.sellerId,
    this.processingState,
    this.createdAt,
    this.updatedAt,
    this.processState,
    this.orderPackage,
    this.seller,
    this.processRefund,
    this.refundProducts,
  });

  dynamic id;
  dynamic refundRequestId;
  dynamic orderPackageId;
  dynamic sellerId;
  dynamic processingState;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? processState;
  OrderPackage? orderPackage;
  SellerData? seller;
  dynamic processRefund;
  List<RefundProduct>? refundProducts;

  factory RefundDetail.fromJson(Map<String, dynamic> json) => RefundDetail(
        id: json["id"],
        refundRequestId: json["refund_request_id"],
        orderPackageId: json["order_package_id"],
        sellerId: json["seller_id"],
        processingState: json["processing_state"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        processState: json["ProcessState"],
        orderPackage: OrderPackage.fromJson(json["order_package"]),
        seller: SellerData.fromJson(json["seller"]),
        processRefund: json["process_refund"],
        refundProducts: List<RefundProduct>.from(
            json["refund_products"].map((x) => RefundProduct.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refund_request_id": refundRequestId,
        "order_package_id": orderPackageId,
        "seller_id": sellerId,
        "processing_state": processingState,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "ProcessState": processState,
        "order_package": orderPackage!.toJson(),
        "seller": seller!.toJson(),
        "process_refund": processRefund,
        "refund_products":
            List<dynamic>.from(refundProducts!.map((x) => x.toJson())),
      };
}

class OrderPackage {
  OrderPackage({
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
  List<Process>? processes;
  List<GstTax>? gstTaxes;

  factory OrderPackage.fromJson(Map<String, dynamic> json) => OrderPackage(
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
        deliveryStateName: json["deliveryStateName"],
        totalGst: json["totalGST"].toDouble(),
        processes: List<Process>.from(
            json["processes"].map((x) => Process.fromJson(x))),
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
        "processes": List<dynamic>.from(processes!.map((x) => x.toJson())),
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
  String? name;
  String? description;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic attributeValueId;

  factory Process.fromJson(Map<String, dynamic> json) => Process(
        id: json["id"],
        name: json["name"],
        description: json["description"] == null ? null : json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        attributeValueId: json["attribute_value_id"] == null
            ? null
            : json["attribute_value_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description == null ? null : description,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "attribute_value_id":
            attributeValueId == null ? null : attributeValueId,
      };
}

class RefundProduct {
  RefundProduct({
    this.id,
    this.refundRequestDetailId,
    this.sellerProductSkuId,
    this.refundReasonId,
    this.returnQty,
    this.returnAmount,
    this.createdAt,
    this.updatedAt,
    this.sellerProductSku,
  });

  dynamic id;
  dynamic refundRequestDetailId;
  dynamic sellerProductSkuId;
  dynamic refundReasonId;
  dynamic returnQty;
  dynamic returnAmount;
  DateTime? createdAt;
  DateTime? updatedAt;
  SellerProductSku? sellerProductSku;

  factory RefundProduct.fromJson(Map<String, dynamic> json) => RefundProduct(
        id: json["id"],
        refundRequestDetailId: json["refund_request_detail_id"],
        sellerProductSkuId: json["seller_product_sku_id"],
        refundReasonId: json["refund_reason_id"],
        returnQty: json["return_qty"],
        returnAmount: json["return_amount"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        sellerProductSku: SellerProductSku.fromJson(json["seller_product_sku"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "refund_request_detail_id": refundRequestDetailId,
        "seller_product_sku_id": sellerProductSkuId,
        "refund_reason_id": refundReasonId,
        "return_qty": returnQty,
        "return_amount": returnAmount,
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
    this.product,
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
  ProductModel? product;

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
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
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
        "product": product == null ? null : product!.toJson(),
      };
}

class ShippingGateway {
  ShippingGateway({
    this.id,
    this.methodName,
    this.logo,
    this.phone,
    this.shipmentTime,
    this.cost,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  String? methodName;
  dynamic logo;
  String? phone;
  String? shipmentTime;
  dynamic cost;
  dynamic isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ShippingGateway.fromJson(Map<String, dynamic> json) =>
      ShippingGateway(
        id: json["id"],
        methodName: json["method_name"],
        logo: json["logo"],
        phone: json["phone"],
        shipmentTime: json["shipment_time"],
        cost: json["cost"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method_name": methodName,
        "logo": logo,
        "phone": phone,
        "shipment_time": shipmentTime,
        "cost": cost,
        "is_active": isActive,
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
