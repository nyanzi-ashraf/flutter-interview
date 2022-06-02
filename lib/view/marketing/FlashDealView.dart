import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';

import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:amazcart/model/NewModel/FlashDeals/FlashDealModel.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:slide_countdown_clock/slide_countdown_clock.dart';

// ignore: must_be_immutable
class FlashDealView extends StatefulWidget {
  @override
  _FlashDealViewState createState() => _FlashDealViewState();
}

class _FlashDealViewState extends State<FlashDealView> {
  final HomeController controller = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());

  Future<void> onRefresh() async {
    controller.flashProductData.clear();
    controller.flashPageNumber.value = 1;
    controller.lastFlashDealPage.value = false;
    await controller.getFlashDealsData();
  }

  FlashDealProductsLoadMore? source;

  @override
  void initState() {
    source = FlashDealProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
        controller.bgColor.value,
      ),
      appBar: AppBar(
        backgroundColor: Color(
          controller.bgColor.value,
        ),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(controller.textColor.value),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Obx(() {
          return Text(
            controller.flashDealTitle.value.toUpperCase() ?? "",
            style: AppStyles.kFontBlack17w5.copyWith(
                color: Color(controller.textColor.value),
                fontWeight: FontWeight.normal),
          );
        }),
        actions: [
          CartIconWidget(),
        ],
      ),
      body: LoadingMoreCustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: [
                SizedBox(
                  height: 5,
                ),
                Obx(() {
                  if (controller.flashProductData.length <= 0) {
                    if (controller.isFlashDealProductsLoading.value) {
                      return Container();
                    }
                    return Container();
                  } else {
                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        controller.flashDealImage.value == null
                            ? Container()
                            : FancyShimmerImage(
                                height: 150,
                                imageUrl: AppConfig.assetPath +
                                    "/" +
                                    controller.flashDealImage.value,
                                boxFit: BoxFit.cover,
                                errorWidget: FancyShimmerImage(
                                  imageUrl:
                                      "${AppConfig.assetPath}/backend/img/default.png",
                                  boxFit: BoxFit.contain,
                                ),
                              ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                          child: Row(
                            children: [
                              Text(
                                controller.dealsText.value.toUpperCase(),
                                style: AppStyles.kFontWhite14w5.copyWith(
                                  color: Color(
                                    controller.textColor.value,
                                  ),
                                  fontSize: 18,
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              SlideCountdownClock(
                                duration: controller.dealDuration.value,
                                slideDirection: SlideDirection.Up,
                                textStyle: AppStyles.kFontWhite14w5.copyWith(
                                  fontSize: 18,
                                ),
                                padding: EdgeInsets.all(0),
                                decoration: BoxDecoration(
                                  color: Color(0xff64086C),
                                  shape: BoxShape.rectangle,
                                ),
                                onDone: () {},
                                tightLabel: true,
                                shouldShowDays: true,
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                }),
              ],
            ),
          ),
          LoadingMoreSliverList<ProductModel>(
            SliverListConfig<ProductModel>(
              padding: EdgeInsets.all(8.0),
              indicatorBuilder: BuildIndicatorBuilder(
                source: source,
                isSliver: true,
                name: 'Products'.tr,
              ).buildIndicator,
              extendedListDelegate:
                  SliverWaterfallFlowDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
              ),
              itemBuilder: (BuildContext c, ProductModel prod, int index) {
                return GridViewProductWidget(
                  productModel: prod,
                );
              },
              sourceList: source!,
            ),
          ),
        ],
      ),
    );
  }
}

class FlashDealProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final HomeController controller = Get.put(HomeController());

  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;

  @override
  bool get hasMore => (_hasMore && length < productsLength) || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    Dio _dio = Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      var result;
      FlashDealModel source;

      if (this.length == 0) {
        result = await _dio.get(
          URLs.FLASH_DEALS,
        );
      } else {
        result = await _dio.get(URLs.FLASH_DEALS, queryParameters: {
          'page': pageIndex,
        });
      }
      print(result.realUri);
      final data = new Map<String, dynamic>.from(result.data);
      source = FlashDealModel.fromJson(data);
      print(source.flashDeal!.allProducts!.toJson());
      productsLength = source.flashDeal!.allProducts!.total;

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.flashDeal!.allProducts!.data!) {
        this.add(item.product!);
      }

      _hasMore = source.flashDeal!.allProducts!.data!.length != 0;
      pageIndex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
