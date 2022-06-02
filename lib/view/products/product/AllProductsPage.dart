import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/product_controller.dart';
import 'package:amazcart/model/NewModel/Product/AllProducts.dart';

import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/SortingModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/products/category/CategoryFilterDrawer.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';
import 'package:amazcart/widgets/custom_grid_delegate.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

// ignore: must_be_immutable
class AllProductsPage extends StatefulWidget {
  @override
  _AllProductsPageState createState() => _AllProductsPageState();
}

class _AllProductsPageState extends State<AllProductsPage> {
  final ProductController controller = Get.put(ProductController());
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());

  Sorting? _selectedSort;

  bool freeSelected = false;

  Future<void> onRefresh() async {
    print('onref');
    controller.allProducts.clear();
    controller.productPageNumber.value = 1;
    controller.productLastPage.value = false;
    await controller.getAllProducts();
  }

  AllProductsLoadMore? source;

  @override
  void initState() {
    source = AllProductsLoadMore();

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
        key: _scaffoldKey,
        endDrawer: CategoryFilterDrawer(),
        backgroundColor: AppStyles.appBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          title: Text(
            "Browse Products".tr,
            style: AppStyles.kFontBlack15w4,
          ),
          actions: [
            CartIconWidget(),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              ListTile(
                tileColor: Colors.white,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownButton(
                      hint: Text('Sort'.tr),
                      underline: Container(),
                      value: _selectedSort,
                      style: AppStyles.kFontBlack14w5,
                      dropdownColor: AppStyles.appBackgroundColor,
                      onChanged: (newValue) async {
                        setState(() {
                          _selectedSort = newValue as Sorting?;
                          setState(() {
                            source!.sortKey = newValue!.sortKey!;
                            source!.isSorted = true;
                            source!.refresh(true);
                          });
                        });
                      },
                      items: Sorting.sortingData.map((sort) {
                        return DropdownMenuItem(
                          child: Text(sort.sortName!),
                          value: sort,
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(child: Obx(() {
                return LoadingMoreList<ProductModel>(
                  ListConfig<ProductModel>(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(0.0),
                    indicatorBuilder: BuildIndicatorBuilder(
                      source: source,
                      isSliver: false,
                      name: 'Products'.tr,
                    ).buildIndicator,
                    showGlowLeading: true,
                    gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                      crossAxisCount: 2,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      height: 220,
                    ),
                    itemBuilder:
                        (BuildContext c, ProductModel prod, int index) {
                      return GridViewProductWidget(
                        productModel: prod,
                      );
                    },
                    sourceList: source!,
                  ),
                );
              })),
            ],
          ),
        ));
  }
}

class AllProductsLoadMore extends LoadingMoreBase<ProductModel> {
  bool isSorted = false;
  String sortKey = 'new';

  final ProductController controller = Get.put(ProductController());

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
      var source;

      if (!isSorted) {
        if (this.length == 0) {
          result = await _dio.get(URLs.ALL_PRODUCTS);
        } else {
          result = await _dio.get(URLs.ALL_PRODUCTS, queryParameters: {
            'page': pageIndex,
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = source.meta.total;
      } else {
        if (this.length == 0) {
          result = await _dio.get(URLs.SORT_ALL_PRODUCTS, queryParameters: {
            'sort_by': sortKey,
          });
        } else {
          result = await _dio.get(URLs.SORT_ALL_PRODUCTS, queryParameters: {
            'sort_by': sortKey,
            'page': pageIndex,
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = source.meta.total;
      }

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.data) {
        this.add(item);
      }

      _hasMore = source.data.length != 0;
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
