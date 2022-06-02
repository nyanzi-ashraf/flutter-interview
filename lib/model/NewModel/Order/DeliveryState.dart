class DeliveryState {
  DeliveryState({
    this.id,
    this.orderPackageId,
    this.deliveryStatus,
    this.note,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  dynamic id;
  dynamic orderPackageId;
  dynamic deliveryStatus;
  String? note;
  DateTime? date;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DeliveryState.fromJson(Map<String, dynamic> json) => DeliveryState(
        id: json["id"],
        orderPackageId: json["order_package_id"],
        deliveryStatus: json["delivery_status"],
        note: json["note"] == null ? null : json["note"],
        date: DateTime.parse(json["date"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "order_package_id": orderPackageId,
        "delivery_status": deliveryStatus,
        "note": note == null ? null : note,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
