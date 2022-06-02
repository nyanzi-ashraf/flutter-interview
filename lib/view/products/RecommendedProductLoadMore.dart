import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/model/NewModel/AllRecommendedModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class RecommendedProductsLoadMore extends LoadingMoreBase<ProductModel> {
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
      AllRecommendedModel source;

      if (this.length == 0) {
        result = await _dio.get(URLs.ALL_RECOMMENDED);
      } else {
        result = await _dio.get(URLs.ALL_RECOMMENDED, queryParameters: {
          'page': pageIndex,
        });
      }
      print(result.realUri);
      final data = new Map<String, dynamic>.from(result.data);
      source = AllRecommendedModel.fromJson(data);
      productsLength = source.meta!.total;

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.data!) {
        this.add(item);
      }

      _hasMore = source.data!.length != 0;
      pageIndex++;
      isSuccess = true;
    } catch (exception, _) {
      isSuccess = false;
      print(exception);
      print(_);
    }
    return isSuccess;
  }
}
