import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';
import 'package:get/get.dart';

class HomeTitlesWidget extends StatelessWidget {
  final VoidCallback? btnOnTap;
  final String? title;
  final bool? showDeal;
  final Duration? dealDuration;

  HomeTitlesWidget(
      {this.btnOnTap, this.title, this.showDeal, this.dealDuration});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 20),
      child: Column(
        children: [
          SizedBox(
            height: 2,
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: btnOnTap,
            child: Row(
              children: [
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: AppStyles.appFont.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                showDeal!
                    ? SlideCountdownClock(
                        duration: dealDuration,
                        slideDirection: SlideDirection.Up,
                        textStyle: AppStyles.appFont.copyWith(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Color(0xff64086C),
                          shape: BoxShape.rectangle,
                        ),
                        onDone: () {},
                        tightLabel: true,
                        shouldShowDays: true,
                      )
                    : SizedBox.shrink(),
                Spacer(),
                Row(
                  children: [
                    Text(
                      'Shop more'.tr.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppStyles.appFont
                          .copyWith(color: AppStyles.pinkColor, fontSize: 12),
                    ),
                    SizedBox(
                      width: 2,
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppStyles.pinkColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 2,
          ),
        ],
      ),
    );
  }
}
