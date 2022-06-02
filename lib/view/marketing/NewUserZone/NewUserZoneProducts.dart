import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/new_user_zone_controller.dart';
import 'package:amazcart/model/NewUserZoneModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'package:loading_more_list/loading_more_list.dart';

class NewUserZoneProducts extends StatefulWidget {
  @override
  _NewUserZoneProductsState createState() => _NewUserZoneProductsState();
}

class _NewUserZoneProductsState extends State<NewUserZoneProducts> {
  final NewUserZoneController newUserZoneController =
      Get.put(NewUserZoneController());

  NewUserZoneAllProductsLoadMore? source;

  @override
  void initState() {
    source = NewUserZoneAllProductsLoadMore();
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
      child: Column(
        // controller: _scrollController,
        children: [
          Padding(
            padding:
                EdgeInsets.only(left: 10.0, bottom: 15.0, right: 10, top: 15),
            child: Text(
              newUserZoneController
                  .newZone.value.newUserZone!.productSlogan!.capitalizeFirst!,
              style: AppStyles.appFont.copyWith(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: LoadingMoreList<NewUserZoneDatum>(
              ListConfig<NewUserZoneDatum>(
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
                itemBuilder:
                    (BuildContext c, NewUserZoneDatum prod, int index) {
                  return GridViewProductWidget(productModel: prod.product);
                },
                sourceList: source!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NewUserZoneAllProductsLoadMore extends LoadingMoreBase<NewUserZoneDatum> {
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
                  .newZone.value.newUserZone!.allProducts!.total!) ||
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
      if (this.length == 0) {
        result = await _dio.get(
            URLs.fetchNewUserProductData(
                newUserZoneController.newUserZoneSlug.value),
            queryParameters: {
              'item': 'product',
            });
      } else {
        result = await _dio.get(
            URLs.fetchNewUserProductData(
                newUserZoneController.newUserZoneSlug.value),
            queryParameters: {
              'page': pageindex,
              'item': 'product',
            });
      }
      print(result.realUri);

      final data = new Map<String, dynamic>.from(result.data);
      var source = NewUserZoneAllProducts.fromJson(data);

      if (pageindex == 1) {
        this.clear();
      }
      for (var item in source.data!) {
        this.add(item);
      }

      _hasMore = source.data!.length != 0;
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
