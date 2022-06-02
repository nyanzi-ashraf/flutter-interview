import 'package:amazcart/model/NewModel/Customer/CustomerShippingAddress.dart';

class CustomerData {
  CustomerData({
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
    this.customerShippingAddress,
  });

  dynamic id;
  String? firstName;
  String? lastName;
  dynamic username;
  dynamic photo;
  dynamic roleId;
  dynamic mobileVerifiedAt;
  String? email;
  dynamic isVerified;
  dynamic verifyCode;
  dynamic emailVerifiedAt;
  String? notificationPreference;
  dynamic isActive;
  String? avatar;
  dynamic phone;
  String? dateOfBirth;
  String? description;
  CustomerShippingAddress? customerShippingAddress;

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
        id: json["id"],
        firstName: json["first_name"] == null ? "" : json["first_name"],
        lastName: json["last_name"] == null ? "" : json["last_name"],
        username: json["username"],
        photo: json["photo"],
        roleId: json["role_id"],
        mobileVerifiedAt: json["mobile_verified_at"],
        email: json["email"],
        isVerified: json["is_verified"],
        verifyCode: json["verify_code"],
        emailVerifiedAt: json["email_verified_at"],
        notificationPreference: json["notification_preference"],
        isActive: json["is_active"],
        avatar: json["avatar"],
        phone: json["phone"],
        dateOfBirth: json["date_of_birth"],
        description: json["description"],
        customerShippingAddress: json["customer_shipping_address"] == null
            ? null
            : CustomerShippingAddress.fromJson(
                json["customer_shipping_address"]),
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
        "customer_shipping_address": customerShippingAddress == null
            ? null
            : customerShippingAddress!.toJson(),
      };
}
