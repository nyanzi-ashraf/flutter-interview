import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/account/SignInOrRegister.dart';
import 'package:amazcart/view/authentication/LoginPage.dart';
import 'package:amazcart/view/cart/CartMain.dart';
import 'package:amazcart/view/messages/MessageNotifications.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'Home.dart';
import 'account/Account.dart';

class MainNavigation extends StatefulWidget {
  final int? navIndex;
  final bool? hideNavBar;
  MainNavigation({this.navIndex, this.hideNavBar});

  @override
  _MainNavigationState createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  final CurrencyController currencyController = Get.put(CurrencyController());

  final LoginController loginController = Get.put(LoginController());

  // final CartController cartController = Get.put(CartController());

  PersistentTabController? _controller;
  // bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController(initialIndex: widget.navIndex!);
    // _hideNavBar = widget.hideNavBar == null ? false : true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(() {
        if (loginController.isLoading.value) {
          return Center(child: CupertinoActivityIndicator());
        } else {
          if (currencyController.isLoading.value) {
            return Scaffold(
              body: Center(
                child: CustomLoadingWidget(),
              ),
            );
          }
          return Scaffold(
            body: PersistentTabView(
              context,
              controller: _controller,
              screens: [
                Home(),
                loginController.loggedIn.value
                    ? MessageNotifications()
                    : LoginPage(),
                loginController.loggedIn.value ? CartMain(true) : LoginPage(),
                loginController.loggedIn.value ? Account() : SignInOrRegister(),
              ],
              confineInSafeArea: true,
              resizeToAvoidBottomInset: true,
              items: [
                PersistentBottomNavBarItem(
                  icon: Image.asset(
                    'assets/images/nav_icon_home.png',
                    color: AppStyles.pinkColor,
                  ),
                  inactiveIcon: Image.asset(
                    'assets/images/nav_icon_home.png',
                    color: AppStyles.greyColorLight,
                  ),
                  title: "Home",
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),
                PersistentBottomNavBarItem(
                  icon: Image.asset(
                    'assets/images/nav_icon_message.png',
                    color: AppStyles.pinkColor,
                  ),
                  inactiveIcon: Image.asset(
                    'assets/images/nav_icon_message.png',
                    color: AppStyles.greyColorLight,
                  ),
                  title: ("Notifications".tr),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),
                PersistentBottomNavBarItem(
                  icon: Container(
                    child: Image.asset(
                      'assets/images/nav_icon_cart.png',
                      color: AppStyles.pinkColor,
                    ),
                  ),
                  inactiveIcon: Container(
                    child: Image.asset(
                      'assets/images/nav_icon_cart.png',
                      color: AppStyles.greyColorLight,
                    ),
                  ),
                  title: ("Cart".tr),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),
                PersistentBottomNavBarItem(
                  icon: Image.asset(
                    'assets/images/nav_icon_account.png',
                    color: AppStyles.pinkColor,
                  ),
                  inactiveIcon: Image.asset(
                    'assets/images/nav_icon_account.png',
                    color: AppStyles.greyColorLight,
                  ),
                  title: ("Account".tr),
                  activeColorPrimary: AppStyles.pinkColor,
                  inactiveColorPrimary: AppStyles.greyColorLight,
                ),
              ],
              navBarStyle: NavBarStyle.style8,
              navBarHeight: 70,
              bottomScreenMargin: 0,
              handleAndroidBackButtonPress: true,
              stateManagement: true,
              margin: EdgeInsets.zero,
              screenTransitionAnimation: ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              onItemSelected: (index) async {
                if (index == 2) {
                  final CartController cartController =
                      Get.put(CartController());
                  await cartController.getCartList();
                }
              },
            ),
          );
        }
      }),
    );
  }
}
