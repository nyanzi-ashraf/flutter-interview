import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:amazcart/widgets/SettingsListTileWidget.dart';
import 'package:amazcart/widgets/SettingsModalWidget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AccountInformation extends StatefulWidget {
  @override
  _AccountInformationState createState() => _AccountInformationState();
}

class _AccountInformationState extends State<AccountInformation> {
  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  String maxDateTime = '2099-12-31';
  String initDateTime = '1900-01-01';
  String _format = 'yyyy-MMMM-dd';
  DateTime? _dateTime;
  String? toDate;
  DateTimePickerLocale _locale = DateTimePickerLocale.en_us;

  final _formKey = GlobalKey<FormState>();

  final LoginController loginController = Get.put(LoginController());

  final TextEditingController firstNameCtrl = TextEditingController();
  final TextEditingController lastNameCtrl = TextEditingController();
  final TextEditingController dobCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController phoneNumberCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  String getAbsoluteDate(int date) {
    return date < 10 ? '0$date' : '$date';
  }

  Future updateProfile(Map data) async {
    EasyLoading.show(
        maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.UPDATE_USER_PROFILE);
    var body = json.encode(data);
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      EasyLoading.dismiss();
      return true;
    } else {
      EasyLoading.dismiss();
      if (response.statusCode == 401) {
        SnackBars().snackBarWarning('Invalid Access token. Please re-login.');
        return false;
      } else {
        SnackBars().snackBarError(jsonString['message']);
        return false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        appBar: AppBarWidget(
          title: 'Account Information'.tr,
        ),
        body: Obx(() {
          return Container(
            child: ListView(
              children: [
                SizedBox(
                  height: 5,
                ),
                SettingsListTileWidget(
                  titleText: 'Name'.tr,
                  subtitleText:
                      '${loginController.profileData.value.firstName} ${loginController.profileData.value.lastName}',
                  changeOnTap: () {
                    firstNameCtrl.text =
                        loginController.profileData.value.firstName!;
                    lastNameCtrl.text =
                        loginController.profileData.value.lastName;
                    Get.bottomSheet(
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Color(0xffDADADA),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Change Name'.tr,
                                style: AppStyles.appFont.copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'First Name'.tr,
                                      style: AppStyles.appFont.copyWith(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF6FAFC),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: TextFormField(
                                      controller: firstNameCtrl,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
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
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            firstNameCtrl.clear();
                                          },
                                        ),
                                        hintText: 'First Name'.tr,
                                        hintMaxLines: 4,
                                        hintStyle: AppStyles.appFont.copyWith(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: AppStyles.appFont.copyWith(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return 'Type First name'.tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'Last Name'.tr,
                                      style: AppStyles.appFont.copyWith(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF6FAFC),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: TextFormField(
                                      controller: lastNameCtrl,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
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
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            lastNameCtrl.clear();
                                          },
                                        ),
                                        hintText: 'Last Name'.tr,
                                        hintMaxLines: 4,
                                        hintStyle: AppStyles.appFont.copyWith(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: AppStyles.appFont.copyWith(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return 'Type Last name'.tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              ButtonWidget(
                                buttonText: 'Save'.tr,
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Map data = {
                                      "first_name": firstNameCtrl.text,
                                      "last_name": lastNameCtrl.text,
                                      "email": loginController
                                          .profileData.value.email,
                                      "phone": loginController
                                          .profileData.value.phone,
                                      "date_of_birth": loginController
                                          .profileData.value.dateOfBirth,
                                      "description": loginController
                                          .profileData.value.description,
                                    };
                                    await updateProfile(data)
                                        .then((value) async {
                                      if (value) {
                                        SnackBars().snackBarSuccess(
                                            'profile updated successfully');
                                        await loginController
                                            .getProfileData()
                                            .then((value) {
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Get.back();
                                          });
                                        });
                                      }
                                    });
                                  }
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                ),
                Divider(
                  color: Color(0xffE1EBF1),
                  height: 1,
                ),
                SettingsListTileWidget(
                  titleText: 'Mobile Number'.tr,
                  subtitleText:
                      '${loginController.profileData.value.phone ?? ""}',
                  changeOnTap: () {
                    phoneNumberCtrl.text =
                        loginController.profileData.value.phone;
                    Get.bottomSheet(
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Color(0xffDADADA),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Change Mobile Number'.tr,
                                style: AppStyles.appFont.copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'Mobile Number'.tr,
                                      style: AppStyles.appFont.copyWith(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF6FAFC),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: TextFormField(
                                      controller: phoneNumberCtrl,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
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
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            firstNameCtrl.clear();
                                          },
                                        ),
                                        hintText: 'Phone'.tr,
                                        hintMaxLines: 4,
                                        hintStyle: AppStyles.appFont.copyWith(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: AppStyles.appFont.copyWith(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return 'Type Phone Number'.tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              ButtonWidget(
                                buttonText: 'Save'.tr,
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Map data = {
                                      "first_name": loginController
                                          .profileData.value.firstName,
                                      "last_name": loginController
                                          .profileData.value.lastName,
                                      "email": loginController
                                          .profileData.value.email,
                                      "phone": phoneNumberCtrl.text,
                                      "date_of_birth": loginController
                                          .profileData.value.dateOfBirth,
                                      "description": loginController
                                          .profileData.value.description,
                                    };
                                    await updateProfile(data)
                                        .then((value) async {
                                      if (value) {
                                        SnackBars().snackBarSuccess(
                                            'profile updated successfully');
                                        await loginController
                                            .getProfileData()
                                            .then((value) {
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Get.back();
                                          });
                                        });
                                      }
                                    });
                                  }
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                ),
                Divider(
                  color: Color(0xffE1EBF1),
                  height: 1,
                ),
                SettingsListTileWidget(
                  titleText: 'Email Address'.tr,
                  subtitleText: '${loginController.profileData.value.email}',
                  changeOnTap: () {
                    emailCtrl.text = loginController.profileData.value.email!;
                    Get.bottomSheet(
                      Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Color(0xffDADADA),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Change Email Address'.tr,
                                style: AppStyles.appFont.copyWith(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Column(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(
                                      'Email Address'.tr,
                                      style: AppStyles.appFont.copyWith(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(
                                        color: Color(0xffF6FAFC),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4))),
                                    child: TextFormField(
                                      controller: emailCtrl,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
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
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.close),
                                          onPressed: () {
                                            firstNameCtrl.clear();
                                          },
                                        ),
                                        hintText: 'Email'.tr,
                                        hintMaxLines: 4,
                                        hintStyle: AppStyles.appFont.copyWith(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      keyboardType: TextInputType.text,
                                      style: AppStyles.appFont.copyWith(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      validator: (value) {
                                        if (value!.length == 0) {
                                          return 'Type Email Address'.tr;
                                        } else {
                                          return null;
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                              ButtonWidget(
                                buttonText: 'Save'.tr,
                                onTap: () async {
                                  if (_formKey.currentState!.validate()) {
                                    Map data = {
                                      "first_name": loginController
                                          .profileData.value.firstName,
                                      "last_name": loginController
                                          .profileData.value.lastName,
                                      "email": emailCtrl.text,
                                      "phone": loginController
                                          .profileData.value.phone,
                                      "date_of_birth": loginController
                                          .profileData.value.dateOfBirth,
                                      "description": loginController
                                          .profileData.value.description,
                                    };
                                    await updateProfile(data)
                                        .then((value) async {
                                      if (value) {
                                        SnackBars().snackBarSuccess(
                                            'profile updated successfully');
                                        await loginController
                                            .getProfileData()
                                            .then((value) {
                                          Future.delayed(Duration(seconds: 3),
                                              () {
                                            Get.back();
                                          });
                                        });
                                      }
                                    });
                                  }
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20),
                              ),
                            ],
                          ),
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                ),
                Divider(
                  color: Color(0xffE1EBF1),
                  height: 1,
                ),
                SettingsListTileWidget(
                  titleText: 'Date of Birth'.tr,
                  subtitleText:
                      loginController.profileData.value.dateOfBirth ?? "",
                  changeOnTap: () {
                    var splitted;
                    if (loginController.profileData.value.dateOfBirth != "" &&
                        loginController.profileData.value.dateOfBirth != null) {
                      splitted = loginController.profileData.value.dateOfBirth
                          .toString()
                          .split('-');
                    } else {
                      splitted = '31/12/2000'.toString().split('/');
                    }

                    print(splitted);
                    final dob = '${splitted[0]}-${splitted[1]}-${splitted[2]}';
                    DatePicker.showDatePicker(
                      context,
                      pickerTheme: DateTimePickerTheme(
                        confirm: Text(
                          'Update'.tr,
                          style: AppStyles.kFontPink15w5,
                        ),
                        cancel: Text(
                          'Cancel'.tr,
                          style: AppStyles.kFontBlack14w5,
                        ),
                      ),
                      minDateTime: DateTime.parse(initDateTime),
                      maxDateTime: DateTime.parse(maxDateTime),
                      initialDateTime: DateTime.parse(dob),
                      dateFormat: _format,
                      locale: _locale,
                      onClose: () => print("----- onClose -----"),
                      onCancel: () => print('onCancel'),
                      onChange: (dateTime, List<int> index) {
                        setState(() {
                          _dateTime = dateTime;
                        });
                      },
                      onConfirm: (dateTime, List<int> index) async {
                        setState(() {
                          _dateTime = dateTime;
                          toDate =
                              '${_dateTime!.year}-${getAbsoluteDate(_dateTime!.month)}-${getAbsoluteDate(_dateTime!.day)}';
                          print(toDate);
                        });

                        Map data = {
                          "first_name":
                              loginController.profileData.value.firstName,
                          "last_name":
                              loginController.profileData.value.lastName,
                          "email": loginController.profileData.value.email,
                          "phone": loginController.profileData.value.phone,
                          "date_of_birth": toDate,
                          "description":
                              loginController.profileData.value.description,
                        };
                        print(data);
                        // return;
                        await updateProfile(data).then((value) async {
                          if (value) {
                            SnackBars().snackBarSuccess(
                                'Profile updated successfully'.tr);
                            await loginController.getProfileData();
                          }
                        });
                      },
                    );
                  },
                ),
                Divider(
                  color: Color(0xffE1EBF1),
                  height: 1,
                ),
                SettingsListTileWidget(
                  titleText: 'Description'.tr,
                  subtitleText:
                      loginController.profileData.value.description ?? "",
                  changeOnTap: () {
                    descriptionCtrl.text =
                        loginController.profileData.value.description;
                    Get.bottomSheet(
                      Form(
                        key: _formKey,
                        child: SettingsModalWidget(
                          buttonOnTap: () async {
                            if (_formKey.currentState!.validate()) {
                              Map data = {
                                "first_name":
                                    loginController.profileData.value.firstName,
                                "last_name":
                                    loginController.profileData.value.lastName,
                                "email":
                                    loginController.profileData.value.email,
                                "phone":
                                    loginController.profileData.value.phone,
                                "date_of_birth": loginController
                                    .profileData.value.dateOfBirth,
                                "description": descriptionCtrl.text,
                              };
                              await updateProfile(data).then((value) async {
                                if (value) {
                                  SnackBars().snackBarSuccess(
                                      'Profile updated successfully'.tr);
                                  await loginController
                                      .getProfileData()
                                      .then((value) {
                                    Future.delayed(Duration(seconds: 3), () {
                                      Get.back();
                                    });
                                  });
                                }
                              });
                            }
                          },
                          modalTitle: 'Update Profile Description'.tr,
                          textFieldTitle: 'Description'.tr,
                          errorMsg: 'Please Enter description',
                          textFieldHint: 'Description'.tr,
                          textEditingController: descriptionCtrl,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      backgroundColor: Colors.white,
                    );
                  },
                ),
              ],
            ),
          );
        }));
  }
}
