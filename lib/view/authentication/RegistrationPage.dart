import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegistrationPage extends GetView<LoginController> {
  final LoginController _accountController = Get.put(LoginController());

  final _formKey = GlobalKey<FormState>();

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
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
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
                      'Register',
                      style: AppStyles.kFontWhite14w5.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 20, right: 4),
                            child: TextFormField(
                              controller: _accountController.firstName,
                              decoration: InputDecoration(
                                hintText: 'First Name'.tr,
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
                                    color: Colors.white,
                                  ),
                                ),
                                errorStyle: AppStyles.kFontWhite12w5.copyWith(
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: AppStyles.kFontWhite14w5
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              validator: (value) {
                                if (value!.length == 0) {
                                  return 'Please Type something'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(right: 20, left: 4),
                            child: TextFormField(
                              controller: _accountController.lastName,
                              decoration: InputDecoration(
                                hintText: 'Last Name'.tr,
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
                                    color: Colors.white,
                                  ),
                                ),
                                errorStyle: AppStyles.kFontWhite12w5.copyWith(
                                  color: Colors.white,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                              ),
                              keyboardType: TextInputType.text,
                              style: AppStyles.kFontWhite14w5
                                  .copyWith(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              validator: (value) {
                                if (value!.length == 0) {
                                  return 'Please Type something'.tr;
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerEmail,
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
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: AppStyles.kFontWhite12w5.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Please Type something'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerPassword,
                      obscureText: true,
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
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: AppStyles.kFontWhite12w5.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Please Type something'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.registerConfirmPassword,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm Password'.tr,
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
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: AppStyles.kFontWhite12w5.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Please Type something'.tr;
                        } else if (controller.registerPassword.text != value) {
                          return 'Password must be the same'.tr;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: TextFormField(
                      controller: _accountController.referralCode,
                      decoration: InputDecoration(
                        hintText: 'Referral code (optional)'.tr,
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
                            color: Colors.white,
                          ),
                        ),
                        errorStyle: AppStyles.kFontWhite12w5.copyWith(
                          color: Colors.white,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontWhite14w5
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: _accountController.isLoading.value
                        ? Center(
                            child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                                child: CupertinoActivityIndicator()))
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  Map registrationData = {
                                    "first_name": controller.firstName.text,
                                    "last_name": controller.lastName.text,
                                    "email": controller.registerEmail.text,
                                    "referral_code":
                                        controller.referralCode.text ?? '',
                                    "password":
                                        controller.registerPassword.text,
                                    "password_confirmation":
                                        controller.registerConfirmPassword.text,
                                    "user_type": "customer"
                                  };

                                  await _accountController
                                      .registerUser(registrationData);
                                }
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
                                  child: Text('Sign Up'.tr,
                                      textAlign: TextAlign.center,
                                      style: AppStyles.kFontPink15w5),
                                ),
                              ),
                            ),
                          ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Text(
                      'Forgot password'.tr + '?',
                      style: AppStyles.kFontWhite14w5,
                    ),
                  ),
                  SizedBox(
                    height: Get.height * 0.07,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
