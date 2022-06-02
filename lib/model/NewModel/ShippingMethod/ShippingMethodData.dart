class ShippingMethodData {
  ShippingMethodData({
    this.id,
    this.methodName,
    this.logo,
    this.phone,
    this.shipmentTime,
    this.cost,
    this.isActive,
    this.requestByUser,
    this.isApproved,
  });

  int? id;
  String? methodName;
  dynamic logo;
  String? phone;
  String? shipmentTime;
  int? cost;
  int? isActive;
  dynamic requestByUser;
  int? isApproved;

  factory ShippingMethodData.fromJson(Map<String, dynamic> json) =>
      ShippingMethodData(
        id: json["id"],
        methodName: json["method_name"],
        logo: json["logo"],
        phone: json["phone"],
        shipmentTime: json["shipment_time"],
        cost: json["cost"],
        isActive: json["is_active"],
        requestByUser: json["request_by_user"],
        isApproved: json["is_approved"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "method_name": methodName,
        "logo": logo,
        "phone": phone,
        "shipment_time": shipmentTime,
        "cost": cost,
        "is_active": isActive,
        "request_by_user": requestByUser,
        "is_approved": isApproved,
      };
}
