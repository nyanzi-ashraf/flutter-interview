import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomInputBorder {
  InputDecoration inputDecoration(String hintText) {
    return InputDecoration(
      contentPadding: EdgeInsets.symmetric(horizontal: 10),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.textFieldFillColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.textFieldFillColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppStyles.textFieldFillColor,
        ),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      hintText: 'Search in'.tr + " " + '$hintText' + '...',
      hintMaxLines: 1,
      hintStyle: AppStyles.appFont.copyWith(
        fontSize: 12,
        color: AppStyles.greyColorDark,
      ),
    );
  }
}
