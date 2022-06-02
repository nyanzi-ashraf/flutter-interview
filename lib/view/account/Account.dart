import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/Settings/SettingsPage.dart';
import 'package:amazcart/view/account/MyGiftCardsPage.dart';
import 'package:amazcart/view/account/coupons/MyCoupons.dart';
import 'package:amazcart/view/account/orders/MyCancellations.dart';
import 'package:amazcart/view/account/orders/RefundAndDisputes/MyRefundsAndDisputes.dart';
import 'package:amazcart/view/support/SupportTicketsPage.dart';
import 'package:amazcart/widgets/dio_exception.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:amazcart/view/account/WishList.dart';
import 'package:amazcart/view/account/orders/OrderList/MyOrders.dart';
import 'package:amazcart/view/account/reviews/MyReviews.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final LoginController loginController = Get.put(LoginController());
  final CurrencyController currencyController = Get.put(CurrencyController());

  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();
  File? _file;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  final picker = ImagePicker();

  Future<bool> updatePhoto() async {
    String token = await userToken.read(tokenKey);

    final file = await DIO.MultipartFile.fromFile(_file!.path,
        filename: '${_file!.path}');

    final formData = DIO.FormData.fromMap({
      'avatar': file,
    });

    response = await dio.post(
      URLs.UPDATE_PROFILE_PHOTO,
      data: formData,
      options: DIO.Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ),
      onSendProgress: (received, total) {
        if (total != -1) {
          print((received / total * 100).toStringAsFixed(0) + '%');
        }
      },
    ).catchError((e) {
      print(e);
      final errorMessage = DioExceptions.fromDioError(e).toString();
      print(errorMessage);
    });

    print(response);
    if (response!.statusCode == 202) {
      return true;
    } else {
      if (response!.statusCode == 401) {
        SnackBars().snackBarWarning('Invalid Access token. Please re-login.');
        return false;
      } else {
        SnackBars().snackBarError(response!.data);
        return false;
      }
    }
  }

  Future<bool> pickDocument() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    print(pickedFile);
    if (pickedFile != null) {
      setState(() {
        _file = File(pickedFile.path);
      });
      return true;
    } else {
      SnackBars().snackBarWarning('Cancelled');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            backgroundColor: AppStyles.pinkColor,
            titleSpacing: 0,
            centerTitle: true,
            toolbarHeight: 100,
            flexibleSpace: FlexibleSpaceBar(
              background: SvgPicture.asset(
                'assets/images/account_appbar_bg.svg',
                fit: BoxFit.cover,
              ),
            ),
            title: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Obx(() {
                    if (loginController.loggedIn.value) {
                      if (loginController.profileData.value.avatar == null) {
                        return Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                              color: Colors.white, shape: BoxShape.circle),
                          child: Icon(
                            Icons.add,
                            color: AppStyles.pinkColor,
                            size: 20,
                          ),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            if (AppConfig.isDemo) {
                              SnackBars().snackBarWarning("Disabled in demo");
                            } else {
                              await pickDocument().then((value) async {
                                if (value) {
                                  await updatePhoto().then((up) async {
                                    if (up) {
                                      SnackBars().snackBarSuccess(
                                          'updated successfully');
                                      await loginController.getProfileData();
                                    }
                                  });
                                }
                              });
                            }
                          },
                          child: _file! != null
                              ? CircleAvatar(
                                  radius: 60,
                                  backgroundImage: FileImage(
                                    _file!,
                                  ),
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      '${AppConfig.assetPath}/${loginController.profileData.value.avatar}',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                        alignment: Alignment.center,
                                      ),
                                    ),
                                    width: 60,
                                    height: 60,
                                    alignment: Alignment.center,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      CachedNetworkImage(
                                    imageUrl:
                                        '${AppConfig.assetPath}/backend/img/default.png',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
                                        ),
                                      ),
                                      width: 60,
                                      height: 60,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  }),
                  SizedBox(
                    width: 10,
                  ),
                  Obx(
                    () => loginController.loggedIn.value
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${loginController.profileData.value.firstName} '
                                '${loginController.profileData.value.lastName}',
                                textAlign: TextAlign.left,
                                style: AppStyles.kFontWhite14w5.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  await loginController.accountController
                                      .getAccountDetails();
                                },
                                child: Container(
                                  height: 25,
                                  // color: Colors.blue,
                                  alignment: Alignment.center,
                                  child: loginController
                                              .accountController
                                              .customerData
                                              .value
                                              .walletRunningBalance! !=
                                          null
                                      ? Text(
                                          'Wallet: ${(loginController.accountController.customerData.value.walletRunningBalance! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                          textAlign: TextAlign.left,
                                          style: AppStyles.kFontWhite14w5,
                                        )
                                      : Container(),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: 30,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Text(
                              'Sign in or Register'.tr,
                              textAlign: TextAlign.center,
                              style: AppStyles.appFont.copyWith(
                                color: AppStyles.pinkColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                  ),
                  Expanded(child: Container()),
                  IconButton(
                    onPressed: () {
                      Get.to(() => SettingsPage());
                      // Get.to(() => NotificationSettings());
                    },
                    icon: Icon(
                      Icons.settings_outlined,
                      color: Colors.white.withOpacity(0.9),
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(() => WishList());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   '3',
                                  //   style: AppStyles.appFont.copyWith(
                                  //     color: AppStyles.pinkColor,
                                  //     fontSize: ScreenUtil().setSp(19),
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  Icon(
                                    Icons.widgets_sharp,
                                    color: AppStyles.pinkColor,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'My Wishlist',
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => MyGiftCardsPage());
                                // Get.to(() => StoreFollowed());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   '12',
                                  //   style: AppStyles.appFont.copyWith(
                                  //     color: AppStyles.pinkColor,
                                  //     fontSize: ScreenUtil().setSp(19),
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  Icon(
                                    Icons.card_giftcard,
                                    color: AppStyles.pinkColor,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Gift Cards',
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() => MyCoupons());
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Text(
                                  //   '2',
                                  //   style: AppStyles.appFont.copyWith(
                                  //     color: AppStyles.pinkColor,
                                  //     fontSize: ScreenUtil().setSp(19),
                                  //     fontWeight: FontWeight.w700,
                                  //   ),
                                  // ),
                                  Icon(
                                    Icons.credit_card,
                                    color: AppStyles.pinkColor,
                                  ),
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Text(
                                    'Coupons',
                                    style: AppStyles.appFont.copyWith(
                                      color: AppStyles.blackColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
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
                      Get.to(
                        () => MyOrders(0),
                      );
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
                      Get.to(() => MyCancellations());
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
                      Get.to(() => MyRefundsAndDisputes());
                    },
                    tileColor: Colors.white,
                    leading: SvgPicture.asset(
                      'assets/images/icon_returns.svg',
                    ),
                    title: Text(
                      'Refunds and Disputes'.tr,
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
                      Get.to(() => MyReviews(
                            tabIndex: 0,
                          ));
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
                    trailing: InkWell(
                      onTap: () {},
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
                      Get.to(() => SupportTicketsPage());
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
