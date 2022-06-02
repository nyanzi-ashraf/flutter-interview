import 'package:amazcart/controller/cart_controller.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NavigationController extends GetxController {
  Rx<PersistentTabController> persistentTabController =
      PersistentTabController(initialIndex: 0).obs;
  Rx<bool> hideNavBar = false.obs;

  void changeTabIndex(int index) async {
    Get.focusScope!.unfocus();
    persistentTabController.value.index = index;
    if (index == 2) {
      final CartController cartController = Get.put(CartController());
      await cartController.getCartList();
      hideNavBar(true);
    } else {
      hideNavBar(false);
    }
  }
}
