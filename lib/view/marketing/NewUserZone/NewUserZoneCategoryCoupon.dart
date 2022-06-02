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

class NewUserZoneCategoryCoupon extends StatefulWidget {
  final String? itemType;
  final int? itemID;
  final int? parentID;
  final bool? isCategory;

  NewUserZoneCategoryCoupon(
      {this.itemType, this.itemID, this.parentID, this.isCategory});

  @override
  _NewUserZoneCategoryCouponState createState() =>
      _NewUserZoneCategoryCouponState();
}

class _NewUserZoneCategoryCouponState extends State<NewUserZoneCategoryCoupon> {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());

  NewUserZoneCategoryCouponLoadMore? source;

  @override
  void initState() {
    if (widget.isCategory!) {
      source = NewUserZoneCategoryCouponLoadMore(
          isCategory: true,
          itemID: widget.itemID!,
          itemType: widget.itemType!,
          parentID: widget.parentID!);
    } else {
      source = NewUserZoneCategoryCouponLoadMore(
          isCategory: false,
          itemID: widget.itemID!,
          itemType: widget.itemType!,
          parentID: widget.parentID!);
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
      color: Color(
        newUserZoneController.bgColor.value,
      ),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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

class NewUserZoneCategoryCouponLoadMore extends LoadingMoreBase<ProductModel> {
  final bool? isCategory;
  final String? itemType;
  final int? itemID;
  final int? parentID;

  NewUserZoneCategoryCouponLoadMore(
      {this.isCategory, this.itemType, this.itemID, this.parentID});

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
              URLs.fetchNewUserCategoryProducts(
                  newUserZoneController.newUserZoneSlug.value),
              queryParameters: {
                'item': itemType,
                'category': itemID,
                'parent_data': parentID,
              });
        } else {
          result = await _dio.get(
              URLs.fetchNewUserCategoryProducts(
                  newUserZoneController.newUserZoneSlug.value),
              queryParameters: {
                'item': itemType,
                'category': itemID,
                'parent_data': parentID,
                'page': pageindex,
              });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
      } else {
        if (this.length == 0) {
          result = await _dio.get(
              URLs.fetchNewUserCouponProducts(
                  newUserZoneController.newUserZoneSlug.value),
              queryParameters: {
                'item': itemType,
                'category': itemID,
                'parent_data': parentID,
              });
        } else {
          result = await _dio.get(
              URLs.fetchNewUserCouponProducts(
                  newUserZoneController.newUserZoneSlug.value),
              queryParameters: {
                'item': itemType,
                'category': itemID,
                'parent_data': parentID,
                'page': pageindex,
              });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
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
