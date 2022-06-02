import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/NotificationSettingsModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class NotificationSettings extends StatefulWidget {
  @override
  _NotificationSettingsState createState() => _NotificationSettingsState();
}

class _NotificationSettingsState extends State<NotificationSettings> {
  // bool _notification = false;
  // bool _promo = false;
  // bool _order = false;
  // bool _chat = false;
  // bool _messages = false;

  GetStorage userToken = GetStorage();
  var tokenKey = 'token';

  Future<NotificationSettingsModel> getNotificationSettings() async {
    var jsonString;
    try {
      String token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.NOTIFICATION_SETTINGS);
      print(userData);
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        jsonString = jsonDecode(response.body);
        // print('ticket data $jsonString');
      }
    } catch (e) {}
    return NotificationSettingsModel.fromJson(jsonString);
  }

  List<String> types = ['email', 'mobile', 'system', 'sms'];

  Future notificationSettingsUpdate(Map data) async {
    var jsonString;
    try {
      String token = await userToken.read(tokenKey);
      Uri url = Uri.parse(URLs.NOTIFICATION_SETTINGS_UPDATE);
      print(url);
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(data),
      );
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 202) {
        jsonString = jsonDecode(response.body);
        print('updated data $jsonString');
        setState(() {});
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Notification Settings'.tr,
      ),
      body: FutureBuilder<NotificationSettingsModel>(
          future: getNotificationSettings(),
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.notifications!.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        // List notificationTypes = snapshot.data!.notifications![index].notificationSetting!.type.toString().split(',').removeWhere((element) => element == "");
                        // print(notificationTypes.length);

                        var notificationTypes = snapshot.data!
                            .notifications![index].notificationSetting!.type
                            .toString()
                            .split(',');
                        notificationTypes.removeWhere((item) => item == "");
                        // print(notificationTypes);
                        // print(types);
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            '${snapshot.data!.notifications![index].notificationSetting!.event}',
                            style: AppStyles.appFont.copyWith(
                              color: AppStyles.blackColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${snapshot.data!.notifications![index].notificationSetting!.message}',
                                style: AppStyles.appFont.copyWith(
                                  color: AppStyles.greyColorDark,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 10,
                                children: List.generate(types.length, (tp) {
                                  // print(types.length);

                                  bool type = false;
                                  if (notificationTypes.contains(types[tp])) {
                                    type = true;
                                  }

                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('${types[tp]}'),
                                      Checkbox(
                                        value: type,
                                        onChanged: (bool? value) async {
                                          // setState(() {});

                                          Map data = {
                                            'id': snapshot
                                                .data!.notifications![index].id,
                                            'type': '${types[tp]}',
                                          };
                                          print(data);
                                          await notificationSettingsUpdate(
                                              data);
                                        },
                                      )
                                    ],
                                  );
                                }),
                              ),
                            ],
                          ),
                        );
                        // return SwitchListTile.adaptive(
                        //   value: _notification,
                        //   onChanged: (bool value) {
                        //     setState(() {
                        //       _notification = value;
                        //     });
                        //   },
                        //   activeColor: AppStyles.pinkColor,
                        //   contentPadding: EdgeInsets.zero,
                        //   title: Text(
                        //     '${snapshot.data!.notifications![index].notificationSetting!.event}',
                        //     style: AppStyles.appFont.copyWith(
                        //       color: AppStyles.blackColor,
                        //       fontSize: 14.sp,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        //   subtitle: Text(
                        //     '${snapshot.data!.notifications![index].notificationSetting!.message}',
                        //     style: AppStyles.appFont.copyWith(
                        //       color: AppStyles.greyColorDark,
                        //       fontSize: 12.sp,
                        //       fontWeight: FontWeight.w500,
                        //     ),
                        //   ),
                        // );
                      }),
                );
              }
            }
            // Displaying LoadingSpinner to indicate waiting state
            return Center(
              child: CustomLoadingWidget(),
            );
          }),
    );

    // return Scaffold(
    //   backgroundColor: AppStyles.appBackgroundColor,
    //   appBar: AppBarWidget(
    //     title: 'Messages Settings',
    //   ),
    //   body: SingleChildScrollView(
    //     child: Padding(
    //       padding: const EdgeInsets.only(top: 8.0),
    //       child: Container(
    //         padding: const EdgeInsets.only(left: 20.0, right: 20),
    //         color: Colors.white,
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.start,
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             SwitchListTile.adaptive(
    //               value: _notification,
    //               onChanged: (bool value) {
    //                 setState(() {
    //                   _notification = value;
    //                 });
    //               },
    //               activeColor: AppStyles.pinkColor,
    //               contentPadding: EdgeInsets.zero,
    //               title: Text(
    //                 'System Notification',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.blackColor,
    //                   fontSize: 14.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //               subtitle: Text(
    //                 'Receive wishlist & shopping cart updates',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.greyColorDark,
    //                   fontSize: 12.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //             SwitchListTile.adaptive(
    //               value: _promo,
    //               onChanged: (bool value) {
    //                 setState(() {
    //                   _promo = value;
    //                 });
    //               },
    //               activeColor: AppStyles.pinkColor,
    //               contentPadding: EdgeInsets.zero,
    //               title: Text(
    //                 'Promo Message',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.blackColor,
    //                   fontSize: 14.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //               subtitle: Text(
    //                 'Receive regular updates on great deals',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.greyColorDark,
    //                   fontSize: 12.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //             SwitchListTile.adaptive(
    //               value: _order,
    //               onChanged: (bool value) {
    //                 setState(() {
    //                   _order = value;
    //                 });
    //               },
    //               activeColor: AppStyles.pinkColor,
    //               contentPadding: EdgeInsets.zero,
    //               title: Text(
    //                 'Orders & Logistics',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.blackColor,
    //                   fontSize: 14.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //               subtitle: Text(
    //                 'Receive timely updates on your order',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.greyColorDark,
    //                   fontSize: 12.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //             SwitchListTile.adaptive(
    //               value: _chat,
    //               onChanged: (bool value) {
    //                 setState(() {
    //                   _chat = value;
    //                 });
    //               },
    //               activeColor: AppStyles.pinkColor,
    //               contentPadding: EdgeInsets.zero,
    //               title: Text(
    //                 'Chats',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.blackColor,
    //                   fontSize: 14.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //               subtitle: Text(
    //                 'Receive in-app message on your phone',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.greyColorDark,
    //                   fontSize: 12.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //             SwitchListTile.adaptive(
    //               value: _messages,
    //               onChanged: (bool value) {
    //                 setState(() {
    //                   _messages = value;
    //                 });
    //               },
    //               activeColor: AppStyles.pinkColor,
    //               contentPadding: EdgeInsets.zero,
    //               title: Text(
    //                 'Messages',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.blackColor,
    //                   fontSize: 14.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //               subtitle: Text(
    //                 'Receive exclusive offers',
    //                 style: AppStyles.appFont.copyWith(
    //                   color: AppStyles.greyColorDark,
    //                   fontSize: 12.sp,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }
}
