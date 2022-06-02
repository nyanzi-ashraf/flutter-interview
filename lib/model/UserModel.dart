// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    this.user,
    this.message,
  });

  UserClass? user;
  String? message;

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: UserClass.fromJson(json["user"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "user": user!.toJson(),
        "message": message,
      };
}

class UserClass {
  UserClass({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.photo,
    this.roleId,
    this.mobileVerifiedAt,
    this.email,
    this.isVerified,
    this.verifyCode,
    this.emailVerifiedAt,
    this.notificationPreference,
    this.isActive,
    this.avatar,
    this.phone,
    this.dateOfBirth,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.customerAddresses,
  });

  int? id;
  String? firstName;
  dynamic lastName;
  dynamic username;
  dynamic photo;
  int? roleId;
  dynamic mobileVerifiedAt;
  String? email;
  int? isVerified;
  dynamic verifyCode;
  dynamic emailVerifiedAt;
  String? notificationPreference;
  int? isActive;
  dynamic avatar;
  dynamic phone;
  dynamic dateOfBirth;
  dynamic description;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<CustomerAddress>? customerAddresses;

  factory UserClass.fromJson(Map<String, dynamic> json) => UserClass(
        id: json["id"],
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? "",
        username: json["username"] ?? "",
        photo: json["photo"] ?? "",
        roleId: json["role_id"] ?? "",
        mobileVerifiedAt: json["mobile_verified_at"] ?? "",
        email: json["email"] ?? "",
        isVerified: json["is_verified"],
        verifyCode: json["verify_code"],
        emailVerifiedAt: json["email_verified_at"],
        notificationPreference: json["notification_preference"],
        isActive: json["is_active"],
        avatar: json["avatar"],
        phone: json["phone"],
        dateOfBirth: json["date_of_birth"] != null ? json["date_of_birth"] : "",
        description: json["description"] != null ? json["description"] : "",
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        customerAddresses: List<CustomerAddress>.from(
            json["customer_addresses"].map((x) => CustomerAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "username": username,
        "photo": photo,
        "role_id": roleId,
        "mobile_verified_at": mobileVerifiedAt,
        "email": email,
        "is_verified": isVerified,
        "verify_code": verifyCode,
        "email_verified_at": emailVerifiedAt,
        "notification_preference": notificationPreference,
        "is_active": isActive,
        "avatar": avatar,
        "phone": phone,
        "date_of_birth": dateOfBirth,
        "description": description,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "customer_addresses":
            List<dynamic>.from(customerAddresses!.map((x) => x.toJson())),
      };
}

class CustomerAddress {
  CustomerAddress({
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
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CustomerAddress.fromJson(Map<String, dynamic> json) =>
      CustomerAddress(
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
        createdAt: DateTime?.parse(json["created_at"]),
        updatedAt: DateTime?.parse(json["updated_at"]),
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
