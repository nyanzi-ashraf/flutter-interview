import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class NoOrderPlacedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          FontAwesomeIcons.exclamation,
          color: AppStyles.pinkColor,
          size: 25,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          'No Orders placed yet!'.tr,
          textAlign: TextAlign.center,
          style: AppStyles.kFontPink15w5.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
