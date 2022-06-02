import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';

class CustomInputDecoration {
  static InputDecoration customInput = InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppStyles.textFieldFillColor,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppStyles.textFieldFillColor,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppStyles.textFieldFillColor,
      ),
    ),
  );
}
