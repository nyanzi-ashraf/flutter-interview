class SellerBusinessInformation {
  SellerBusinessInformation({
    this.id,
    this.userId,
    this.businessOwnerName,
    this.businessAddress1,
    this.businessAddress2,
    this.businessCountry,
    this.businessState,
    this.businessCity,
    this.businessPostcode,
    this.businessPersonInChargeName,
    this.businessRegistrationNumber,
    this.businessDocument,
    this.businessSellerTin,
    this.createdAt,
    this.updatedAt,
    this.claimGst,
  });

  dynamic id;
  dynamic userId;
  dynamic businessOwnerName;
  dynamic businessAddress1;
  dynamic businessAddress2;
  dynamic businessCountry;
  dynamic businessState;
  dynamic businessCity;
  dynamic businessPostcode;
  dynamic businessPersonInChargeName;
  dynamic businessRegistrationNumber;
  dynamic businessDocument;
  dynamic businessSellerTin;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic claimGst;

  factory SellerBusinessInformation.fromJson(Map<String, dynamic> json) =>
      SellerBusinessInformation(
        id: json["id"],
        userId: json["user_id"],
        businessOwnerName: json["business_owner_name"],
        businessAddress1: json["business_address1"],
        businessAddress2: json["business_address2"],
        businessCountry: json["business_country"],
        businessState: json["business_state"],
        businessCity: json["business_city"],
        businessPostcode: json["business_postcode"],
        businessPersonInChargeName: json["business_person_in_charge_name"],
        businessRegistrationNumber: json["business_registration_number"],
        businessDocument: json["business_document"],
        businessSellerTin: json["business_seller_tin"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        claimGst: json["claim_gst"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "business_owner_name": businessOwnerName,
        "business_address1": businessAddress1,
        "business_address2": businessAddress2,
        "business_country": businessCountry,
        "business_state": businessState,
        "business_city": businessCity,
        "business_postcode": businessPostcode,
        "business_person_in_charge_name": businessPersonInChargeName,
        "business_registration_number": businessRegistrationNumber,
        "business_document": businessDocument,
        "business_seller_tin": businessSellerTin,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "claim_gst": claimGst,
      };
}
