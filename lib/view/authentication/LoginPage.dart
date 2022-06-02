import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'RegistrationPage.dart';

class LoginPage extends GetView<LoginController> {
  final LoginController _loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return Container(
          height: Get.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppConfig.loginScreenBackgroundGradient1,
                AppConfig.loginScreenBackgroundGradient2,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10),
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ),
                  ],
                ),
                Image.asset(
                  AppConfig.appLogo,
                  width: 50,
                  height: 50,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  AppConfig.appName.toUpperCase(),
                  style: AppStyles.kFontWhite14w5.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Sign In',
                    style: AppStyles.kFontWhite14w5.copyWith(
                      fontSize: 20,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: TextFormField(
                    controller: _loginController.email,
                    decoration: InputDecoration(
                      hintText: 'Enter Your Email'.tr,
                      hintStyle: AppStyles.kFontWhite14w5,
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
                      suffixIcon: Icon(
                        Icons.mail_outline_rounded,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: AppStyles.kFontWhite14w5
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    validator: (value) {
                      if (value!.length == 0) {
                        return 'Please Type something'.tr + '...';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
                  child: TextFormField(
                    controller: _loginController.password,
                    obscureText: _loginController.obscrure.value,
                    decoration: InputDecoration(
                      hintText: 'Password'.tr,
                      hintStyle: AppStyles.kFontWhite14w5,
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
                      suffixIcon: GestureDetector(
                        onTap: () {
                          _loginController.obscrure.value =
                              !_loginController.obscrure.value;
                        },
                        child: Icon(
                          _loginController.obscrure.value
                              ? Icons.lock
                              : Icons.lock_open,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: AppStyles.kFontWhite14w5
                        .copyWith(fontWeight: FontWeight.bold),
                    maxLines: 1,
                    validator: (value) {
                      if (value!.length == 0) {
                        return 'Please Type something.' + '..';
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: _loginController.isLoading.value
                      ? Center(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: CupertinoActivityIndicator()))
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 5),
                          child: InkWell(
                            onTap: () async {
                              var jsonString = await _loginController
                                  .fetchUserLogin(
                                      email: _loginController.email.text,
                                      password: _loginController.password.text)
                                  .then((value) {
                                if (value == true) {
                                  Get.back();
                                }
                              });
                              print(jsonString);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: Get.width,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Sign In'.tr,
                                    textAlign: TextAlign.center,
                                    style: AppStyles.kFontPink15w5),
                              ),
                            ),
                          ),
                        ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Forget password'.tr + '?',
                    style: AppStyles.kFontWhite14w5,
                  ),
                ),
                SizedBox(
                  height: Get.height * 0.03,
                ),
                GestureDetector(
                  onTap: () {
                    Get.dialog(RegistrationPage(), useSafeArea: false);
                  },
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Don\'t have an account Yet?'.tr,
                              textAlign: TextAlign.center,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sign Up'.tr,
                              textAlign: TextAlign.center,
                              style: AppStyles.appFont.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     InkWell(
                //       onTap: () {
                //         print('off');
                //         Get.to(() => MainNavigation(
                //               navIndex: 0,
                //             ));
                //       },
                //       child: Image.asset('assets/images/facebook.png'),
                //     ),
                //     SizedBox(
                //       width: 20,
                //     ),
                //     Image.asset('assets/images/google.png'),
                //   ],
                // ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
