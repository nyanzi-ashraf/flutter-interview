// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';
import 'package:amazcart/model/NewModel/Order/OrderData.dart';

OrderListModel orderListModelFromJson(String str) =>
    OrderListModel.fromJson(json.decode(str));

String orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  OrderListModel({
    this.orders,
    this.message,
  });

  List<OrderData>? orders;
  String? message;

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        orders: List<OrderData>.from(
            json["orders"].map((x) => OrderData.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
        "message": message,
      };
}
