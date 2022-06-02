import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/new_user_zone_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/marketing/NewUserZone/NewUserZoneCouponMain.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/SliverAppBarTitleWidget.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'NewUserZoneCategoryMain.dart';
import 'NewUserZoneProducts.dart';

class NewUserZonePage extends StatefulWidget {
  @override
  _NewUserZonePageState createState() => _NewUserZonePageState();
}

class _NewUserZonePageState extends State<NewUserZonePage>
    with SingleTickerProviderStateMixin {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());
  final CartController cartController = Get.put(CartController());

  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 3);
    newUserZoneController.newUserProducts.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return Obx(() {
      if (newUserZoneController.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CustomLoadingWidget(),
          ),
        );
      } else {
        if (newUserZoneController.newZone.value.newUserZone == null) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
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
                '- ' + 'No Products found'.tr + ' - ',
                style: AppStyles.kFontBlack17w5,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: PinkButtonWidget(
                  height: 32,
                  btnOnTap: () {
                    Get.back();
                  },
                  btnText: 'Continue Shopping'.tr,
                ),
              ),
            ],
          );
        }
        return Scaffold(
          backgroundColor: Color(
            newUserZoneController.bgColor.value,
          ),
          body: NestedScrollView(
            physics: NeverScrollableScrollPhysics(),
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 100,
                  floating: false,
                  pinned: false,
                  backgroundColor: Color(
                    newUserZoneController.bgColor.value,
                  ),
                  automaticallyImplyLeading: false,
                  actions: [
                    CartIconWidget(),
                  ],
                  titleSpacing: 0,
                  centerTitle: false,
                  title: SliverAppBarTitleWidget(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        InkWell(
                          customBorder: CircleBorder(),
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: Text(
                            newUserZoneController
                                .newZone.value.newUserZone!.title!,
                            style: AppStyles.kFontBlack14w5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: [
                        Positioned.fill(
                          child: Container(
                            child: FancyShimmerImage(
                              imageUrl:
                                  '${AppConfig.assetPath}/${newUserZoneController.newZone.value.newUserZone!.bannerImage}',
                              boxFit: BoxFit.cover,
                              errorWidget: FancyShimmerImage(
                                imageUrl:
                                    "${AppConfig.assetPath}/backend/img/default.png",
                                boxFit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              InkWell(
                                customBorder: CircleBorder(),
                                onTap: () {
                                  Get.back();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: Text(
                                  newUserZoneController
                                      .newZone.value.newUserZone!.title!,
                                  style: AppStyles.kFontWhite14w5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            // pinnedHeaderSliverHeightBuilder: () {
            //   return pinnedHeaderHeight;
            // },
            floatHeaderSlivers: false,
            body: Column(
              children: <Widget>[
                TabBar(
                  controller: _tabController,
                  indicatorColor: AppStyles.pinkColor,
                  isScrollable: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  automaticIndicatorColorAdjustment: true,
                  padding: EdgeInsets.zero,
                  indicatorPadding: EdgeInsets.zero,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Tab(
                      child: Text(
                          newUserZoneController.newZone.value.newUserZone!
                              .productNavigationLabel!,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontBlack14w5),
                    ),
                    Tab(
                      child: Text(
                          newUserZoneController.newZone.value.newUserZone!
                              .categoryNavigationLabel!,
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: AppStyles.kFontBlack14w5),
                    ),
                    Tab(
                      child: Text(
                        newUserZoneController
                            .newZone.value.newUserZone!.couponNavigationLabel!,
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: AppStyles.kFontBlack14w5,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _tabController,
                    children: <Widget>[
                      NewUserZoneProducts(),
                      NewUserZoneCategoryMain(),
                      NewUserZoneCouponMain(),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }
    });
  }
}
