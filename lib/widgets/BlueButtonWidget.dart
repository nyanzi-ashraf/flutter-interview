import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';

class BlueButtonWidget extends StatelessWidget {
  final String? btnText;
  final double? width;
  final double? height;
  final VoidCallback? btnOnTap;

  BlueButtonWidget({this.width, this.height, this.btnOnTap, this.btnText});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: btnOnTap,
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        decoration: BoxDecoration(
            color: AppStyles.lightBlueColor,
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(btnText!,
              textAlign: TextAlign.center, style: AppStyles.kFontWhite14w5),
        ),
      ),
    );
  }
}
