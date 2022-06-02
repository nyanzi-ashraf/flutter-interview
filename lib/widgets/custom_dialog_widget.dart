import 'dart:ui';

import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/custom_clipper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomDialogWidget extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  CustomDialogWidget(
      {this.title, this.subtitle, this.onCancel, this.onConfirm});

  @override
  Widget build(BuildContext context) {
    final child = Center(
      child: Container(
        color: Colors.white,
        width: Get.width * 0.6,
        height: Get.height * 0.2,
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '$title',
                      textAlign: TextAlign.center,
                      style: AppStyles.kFontBlack14w5
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '$subtitle'.tr,
                      textAlign: TextAlign.center,
                      style: AppStyles.kFontBlack12w4,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: AppStyles.appBackgroundColor,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ClipPath(
                        clipper: SkewCutLeft(),
                        clipBehavior: Clip.antiAlias,
                        child: GestureDetector(
                          onTap: onCancel,
                          child: Container(
                            alignment: Alignment.center,
                            width: Get.width * 0.28,
                            decoration: BoxDecoration(
                              color: AppStyles.appBackgroundColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Cancel",
                                textAlign: TextAlign.center,
                                style: AppStyles.kFontBlack12w4,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ClipPath(
                        clipper: SkewCutRight(),
                        clipBehavior: Clip.hardEdge,
                        child: GestureDetector(
                          onTap: onConfirm,
                          child: Container(
                            alignment: Alignment.center,
                            width: Get.width * 0.32,
                            decoration: BoxDecoration(
                              color: AppStyles.pinkColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Confirm",
                                textAlign: TextAlign.center,
                                style: AppStyles.kFontWhite12w5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Get.back();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 10,
                  sigmaY: 10,
                ),
                child: Container(
                  color: Colors.black12,
                ),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubicEmphasized,
              builder: (context, val, child) => Transform.scale(
                scale: val,
                child: child,
              ),
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
