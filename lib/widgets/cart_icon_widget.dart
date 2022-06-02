import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/cart/CartMain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartIconWidget extends StatelessWidget {
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => CartMain(false));
      },
      child: Container(
        width: 60,
        height: 80,
        // color: Colors.blue,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/icon_cart_grey.png',
                width: 30,
                height: 30,
                color: Colors.black,
              ),
            ),
            Positioned(
              right: 4,
              top: 4,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: AppStyles.pinkColor,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Obx(() {
                    if (cartController.isLoading.value) {
                      return Container();
                    }
                    return Text(
                      '${cartController.cartListSelectedCount.value}',
                      textAlign: TextAlign.center,
                      style: AppStyles.kFontWhite12w5,
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
