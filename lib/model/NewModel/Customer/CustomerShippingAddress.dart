class CustomerShippingAddress {
  CustomerShippingAddress({
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
  });

  int? id;
  int? customerId;
  String? name;
  String? email;
  String? phone;
  String? address;
  String? city;
  String? state;
  String? country;
  String? postalCode;
  int? isShippingDefault;
  int? isBillingDefault;

  factory CustomerShippingAddress.fromJson(Map<String, dynamic> json) =>
      CustomerShippingAddress(
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
      };
}
