import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SnackBars {
  SnackbarController snackBarSuccess(message) {
    return Get.snackbar(
      'Success',
      message.toString().capitalizeFirst!,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 2),
    );
  }

  SnackbarController snackBarSuccessBottom(message) {
    return Get.snackbar(
      'Success',
      message.toString().capitalizeFirst!,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 2),
    );
  }

  SnackbarController snackBarError(message) {
    return Get.snackbar(
      'Error',
      message.toString().capitalizeFirst!,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 2),
    );
  }

  SnackbarController snackBarWarning(message) {
    return Get.snackbar(
      'Warning',
      message.toString().capitalizeFirst!,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Color(0xffF89406),
      colorText: Colors.white,
      borderRadius: 5,
      duration: Duration(seconds: 2),
    );
  }
}
