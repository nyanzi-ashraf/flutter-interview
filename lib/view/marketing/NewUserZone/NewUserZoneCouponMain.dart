import 'package:amazcart/controller/new_user_zone_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'NewUserZoneAllCategoryCoupon.dart';
import 'NewUserZoneCategoryCoupon.dart';

class NewUserZoneCouponMain extends StatefulWidget {
  @override
  _NewUserZoneCouponMainState createState() => _NewUserZoneCouponMainState();
}

class _NewUserZoneCouponMainState extends State<NewUserZoneCouponMain> {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(
        newUserZoneController.bgColor.value,
      ),
      child: Column(
        children: [
          Expanded(
            child: DefaultTabController(
              length: newUserZoneController
                      .newZone.value.newUserZone!.couponCategories!.length +
                  1,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(50),
                  child: new Container(
                    color: Color(
                      newUserZoneController.bgColor.value,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            newUserZoneController.newZone.value.newUserZone!
                                .couponSlogan!.capitalizeFirst!,
                            style: AppStyles.appFont.copyWith(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBar(
                            indicatorColor: AppStyles.pinkColor,
                            isScrollable: true,
                            physics: BouncingScrollPhysics(),
                            automaticIndicatorColorAdjustment: true,
                            padding: EdgeInsets.zero,
                            indicatorPadding: EdgeInsets.zero,
                            indicatorSize: TabBarIndicatorSize.label,
                            tabs: List.generate(
                                newUserZoneController.newZone.value.newUserZone!
                                        .couponCategories!.length +
                                    1, (index) {
                              if (index == 0) {
                                return Tab(
                                  child: Text('All'.tr,
                                      style: AppStyles.kFontBlack14w5),
                                );
                              }
                              return Tab(
                                child: Text(
                                    newUserZoneController
                                        .newZone
                                        .value
                                        .newUserZone!
                                        .couponCategories![index - 1]
                                        .category!
                                        .name!,
                                    style: AppStyles.kFontBlack14w5),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: List.generate(
                      newUserZoneController.newZone.value.newUserZone!
                              .couponCategories!.length +
                          1, (index) {
                    if (index == 0) {
                      return NewUserZoneAllCategoryCoupon(
                        isCategory: false,
                      );
                    }
                    return NewUserZoneCategoryCoupon(
                        isCategory: false,
                        itemID: newUserZoneController.newZone.value.newUserZone!
                            .couponCategories![index - 1].categoryId,
                        itemType: 'category',
                        parentID: newUserZoneController.newZone.value
                            .newUserZone!.couponCategories![index - 1].id);
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
