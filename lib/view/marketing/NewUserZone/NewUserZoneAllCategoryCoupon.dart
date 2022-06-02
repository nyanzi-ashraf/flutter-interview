import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/new_user_zone_controller.dart';
import 'package:amazcart/model/NewModel/Product/AllProducts.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class NewUserZoneAllCategoryCoupon extends StatefulWidget {
  final bool? isCategory;

  NewUserZoneAllCategoryCoupon({this.isCategory});

  @override
  _NewUserZoneAllCategoryCouponState createState() =>
      _NewUserZoneAllCategoryCouponState();
}

class _NewUserZoneAllCategoryCouponState
    extends State<NewUserZoneAllCategoryCoupon> {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());

  NewUserZoneAllCategoryCouponLoadMore? source;

  @override
  void initState() {
    if (widget.isCategory!) {
      source = NewUserZoneAllCategoryCouponLoadMore(isCategory: true);
    } else {
      source = NewUserZoneAllCategoryCouponLoadMore(isCategory: false);
    }
    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      color: Color(
        newUserZoneController.bgColor.value,
      ),
      child: LoadingMoreList<ProductModel>(
        ListConfig<ProductModel>(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          indicatorBuilder: BuildIndicatorBuilder(
            source: source,
            isSliver: false,
            name: 'Products'.tr,
          ).buildIndicator,
          showGlowLeading: true,
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
    );
  }
}

class NewUserZoneAllCategoryCouponLoadMore
    extends LoadingMoreBase<ProductModel> {
  final bool? isCategory;

  NewUserZoneAllCategoryCouponLoadMore({this.isCategory});

  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());

  int pageindex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;

  @override
  bool get hasMore =>
      (_hasMore &&
          length <
              newUserZoneController
                  .newZone.value.newUserZone!.allProducts!.total) ||
      forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageindex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    final NewUserZoneController newUserZoneController =
        Get.put(NewUserZoneController());

    Dio _dio = Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      var result;
      var source;

      if (isCategory!) {
        if (this.length == 0) {
          result = await _dio.get(
              URLs.fetchNewUserCategoryAllProducts(
                  newUserZoneController.newUserZoneSlug.value),
              queryParameters: {
                'item': 'category',
              });
        } else {
          result = await _dio.get(
              URLs.fetchNewUserCategoryAllProducts(
                  newUserZoneController.newUserZoneSlug.value),
              queryParameters: {
                'item': 'category',
                'page': pageindex,
              });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data['allCategoryProducts']);
      } else {
        if (this.length == 0) {
          result = await _dio.get(
              URLs.fetchNewUserCouponAllProducts(
                  newUserZoneController.newUserZoneSlug.value),
              queryParameters: {
                'item': 'category',
              });
        } else {
          result = await _dio.get(
              URLs.fetchNewUserCouponAllProducts(
                  newUserZoneController.newUserZoneSlug.value),
              queryParameters: {
                'item': 'category',
                'page': pageindex,
              });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data['allCouponCategoryProducts']);
      }

      if (pageindex == 1) {
        this.clear();
      }
      for (var item in source.data) {
        this.add(item);
      }

      _hasMore = source.data.length != 0;
      pageindex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
