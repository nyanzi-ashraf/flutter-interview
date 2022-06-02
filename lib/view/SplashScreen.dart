import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/widgets/custom_splash_screen.dart';
import 'package:flutter/material.dart';

import 'MainNavigation.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomSplash(
      imagePath: '${AppConfig.appLogo}',
      animationEffect: 'elastic-in',
      logoSize: 100,
      home: MainNavigation(
        navIndex: 0,
      ),
      duration: 1500,
      bgPath: AppConfig.loginBackgroundImage,
      type: CustomSplashType.StaticDuration,
    );
  }
}
