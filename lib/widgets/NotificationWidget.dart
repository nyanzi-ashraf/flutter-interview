import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';

class NotificationWidget extends StatelessWidget {
  final String? notificationTitle;
  final String? notificationBody;
  final String? notificationDate;
  NotificationWidget(
      {this.notificationBody, this.notificationDate, this.notificationTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 2,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          ListTile(
            dense: true,
            leading: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                ),
                shape: BoxShape.circle,
              ),
              child:
                  Image.asset('assets/images/icon_message_notifications.png'),
            ),
            title: Text(
              notificationTitle!,
              style: AppStyles.appFont.copyWith(
                color: AppStyles.blackColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              notificationDate!,
              style: AppStyles.appFont.copyWith(
                color: AppStyles.greyColorDark,
                fontSize: 12,
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 15, right: 15),
            dense: true,
            title: Container(
              color: AppStyles.appBackgroundColor,
              padding: EdgeInsets.all(10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                        height: 60,
                        width: 60,
                        child: Image.asset(
                          'assets/images/thumbnail.png',
                          fit: BoxFit.cover,
                        )),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: Container(
                      child: Column(
                        children: [
                          Text(
                            notificationBody!,
                            style: AppStyles.appFont.copyWith(
                              color: AppStyles.blackColor,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
