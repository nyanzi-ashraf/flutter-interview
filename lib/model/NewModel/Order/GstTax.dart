class GstTax {
  GstTax({
    this.id,
    this.packageId,
    this.gstId,
    this.amount,
  });

  dynamic id;
  dynamic packageId;
  dynamic gstId;
  double? amount;

  factory GstTax.fromJson(Map<String, dynamic> json) => GstTax(
        id: json["id"],
        packageId: json["package_id"],
        gstId: json["gst_id"],
        amount: json["amount"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "package_id": packageId,
        "gst_id": gstId,
        "amount": amount,
      };
}
