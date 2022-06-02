import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsListTileWidget extends StatelessWidget {
  SettingsListTileWidget({this.titleText, this.subtitleText, this.changeOnTap});

  final String? titleText;
  final String? subtitleText;
  final VoidCallback? changeOnTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      title: Text(
        titleText!,
        style: AppStyles.appFont.copyWith(
          color: Colors.black,
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
      subtitle: Text(
        subtitleText!,
        style: AppStyles.appFont.copyWith(
          color: Colors.black,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: SizedBox(
        height: 70,
        child: InkWell(
          onTap: changeOnTap,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              'Change'.tr,
              textAlign: TextAlign.center,
              style: AppStyles.appFont.copyWith(
                color: AppStyles.lightBlueColor,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
