// To parse this JSON data, do
//
//     final notificationSettingsModel = notificationSettingsModelFromJson(jsonString);

import 'dart:convert';

NotificationSettingsModel notificationSettingsModelFromJson(String str) =>
    NotificationSettingsModel.fromJson(json.decode(str));

String notificationSettingsModelToJson(NotificationSettingsModel data) =>
    json.encode(data.toJson());

class NotificationSettingsModel {
  NotificationSettingsModel({
    this.notifications,
    this.msg,
  });

  List<NotificationData>? notifications;
  String? msg;

  factory NotificationSettingsModel.fromJson(Map<String, dynamic> json) =>
      NotificationSettingsModel(
        notifications: List<NotificationData>.from(
            json["notifications"].map((x) => NotificationData.fromJson(x))),
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "notifications":
            List<dynamic>.from(notifications!.map((x) => x.toJson())),
        "msg": msg,
      };
}

class NotificationData {
  NotificationData({
    this.id,
    this.userId,
    this.notificationSettingId,
    this.type,
    this.createdAt,
    this.updatedAt,
    this.notificationSetting,
  });

  int? id;
  int? userId;
  int? notificationSettingId;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
  NotificationSetting? notificationSetting;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        id: json["id"],
        userId: json["user_id"],
        notificationSettingId: json["notification_setting_id"],
        type: json["type"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        notificationSetting:
            NotificationSetting.fromJson(json["notification_setting"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "notification_setting_id": notificationSettingId,
        "type": type,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "notification_setting": notificationSetting!.toJson(),
      };
}

class NotificationSetting {
  NotificationSetting({
    this.id,
    this.event,
    this.deliveryProcessId,
    this.type,
    this.message,
    this.userAccessStatus,
    this.sellerAccessStatus,
    this.adminAccessStatus,
    this.staffAccessStatus,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? event;
  int? deliveryProcessId;
  String? type;
  String? message;
  int? userAccessStatus;
  int? sellerAccessStatus;
  int? adminAccessStatus;
  int? staffAccessStatus;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory NotificationSetting.fromJson(Map<String, dynamic> json) =>
      NotificationSetting(
        id: json["id"],
        event: json["event"],
        deliveryProcessId: json["delivery_process_id"] == null
            ? null
            : json["delivery_process_id"],
        type: json["type"],
        message: json["message"],
        userAccessStatus: json["user_access_status"],
        sellerAccessStatus: json["seller_access_status"],
        adminAccessStatus: json["admin_access_status"],
        staffAccessStatus: json["staff_access_status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event": event,
        "delivery_process_id":
            deliveryProcessId == null ? null : deliveryProcessId,
        "type": type,
        "message": message,
        "user_access_status": userAccessStatus,
        "seller_access_status": sellerAccessStatus,
        "admin_access_status": adminAccessStatus,
        "staff_access_status": staffAccessStatus,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
      };
}
