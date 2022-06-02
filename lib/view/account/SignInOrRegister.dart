import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/Settings/SettingsPage.dart';
import 'package:amazcart/view/authentication/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SignInOrRegister extends StatefulWidget {
  @override
  _SignInOrRegisterState createState() => _SignInOrRegisterState();
}

class _SignInOrRegisterState extends State<SignInOrRegister> {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/images/account_appbar_bg.svg',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        child: Icon(
                          Icons.person,
                          color: AppStyles.pinkColor,
                          size: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Hello, Welcome to ${AppConfig.appName}!",
                        style: AppStyles.kFontWhite14w5,
                      ),
                      Expanded(child: Container()),
                      IconButton(
                        onPressed: () {
                          Get.to(() => SettingsPage());
                        },
                        icon: Icon(
                          Icons.settings_outlined,
                          color: Colors.white.withOpacity(0.9),
                          size: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.dialog(LoginPage(), useSafeArea: false);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Sign in or Register'.tr,
                        textAlign: TextAlign.center,
                        style: AppStyles.appFont.copyWith(
                          color: AppStyles.pinkColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Text(
                  'My Orders'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.greyColorLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  'assets/images/icon_all_orders.svg',
                ),
                title: Text(
                  'All Orders'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  'assets/images/icon_cancellations.svg',
                ),
                title: Text(
                  'My Cancellations'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  'assets/images/icon_returns.svg',
                ),
                title: Text(
                  'My Returns'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Text(
                  'My Services'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.greyColorLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  'assets/images/icon_my_reviews.svg',
                ),
                title: Text(
                  'My Review'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              ListTile(
                onTap: () {
                  Get.dialog(LoginPage(), useSafeArea: false);
                },
                tileColor: Colors.white,
                leading: SvgPicture.asset(
                  'assets/images/icon_need_help.svg',
                ),
                title: Text(
                  'Need Help?'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                trailing: SizedBox(
                  height: 70,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
