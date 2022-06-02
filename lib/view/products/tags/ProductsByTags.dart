import 'dart:developer';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/tag_controller.dart';
import 'package:amazcart/model/NewModel/FilterFromCatModel.dart';
import 'package:amazcart/model/NewModel/Product/AllProducts.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

import 'package:amazcart/model/SortingModel.dart';
import 'package:amazcart/model/NewModel/Tags/TagProductsModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/products/tags/TagFilterDrawer.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

class ProductsByTags extends StatefulWidget {
  final String? tagName;
  final int? tagId;

  ProductsByTags({this.tagName, this.tagId});

  @override
  _ProductsByTagsState createState() => _ProductsByTagsState();
}

class _ProductsByTagsState extends State<ProductsByTags> {
  final HomeController controller = Get.put(HomeController());
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  final CartController cartController = Get.put(CartController());

  final TagController tagController = Get.put(TagController());

  Sorting? _selectedSort;

  bool filterSelected = false;

  TagProductsLoadMore? source;

  @override
  void initState() {
    getTagProducts();

    source = TagProductsLoadMore(widget.tagName!, widget.tagId!);
    source!.isSorted = false;
    source!.isFilter = false;

    super.initState();
  }

  Future getTagProducts() async {
    await tagController.getTagProducts(widget.tagId);
    if (controller.dataFilterCat.value.filterDataFromCat != null) {
      controller.dataFilterCat.value.filterDataFromCat!.filterType!
          .forEach((element) {
        if (element.filterTypeId == 'brand' || element.filterTypeId == 'cat') {
          print(element.filterTypeId);
          element.filterTypeValue!.clear();
        }
      });
    }

    controller.filterRating.value = 0.0;
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
        backgroundColor: AppStyles.appBackgroundColor,
        endDrawer: TagFilterDrawer(
          tagId: widget.tagId,
          scaffoldKey: _scaffoldKey,
          source: source,
        ),
        body: LoadingMoreCustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false,
              stretch: false,
              pinned: true,
              floating: true,
              stretchTriggerOffset: 150,
              elevation: 0,
              expandedHeight: 50,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              actions: [
                CartIconWidget(),
              ],
              centerTitle: false,
              title: Text(
                widget.tagName!.capitalizeFirst!,
                style: AppStyles.kFontBlack17w5,
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              sliver: Obx(() {
                if (tagController.isTagLoading.value) {
                  return SliverToBoxAdapter(child: Container());
                } else {
                  if (tagController.tagAllData.value.products!.total == 0) {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  } else {
                    return SliverAppBar(
                      backgroundColor: AppStyles.appBackgroundColor,
                      automaticallyImplyLeading: false,
                      centerTitle: false,
                      titleSpacing: 0,
                      toolbarHeight: 30,
                      expandedHeight: 0,
                      forceElevated: false,
                      elevation: 0,
                      primary: true,
                      pinned: true,
                      leading: Container(),
                      actions: [
                        Container(
                          width: 50,
                          alignment: Alignment.center,
                          child: Container(),
                        ),
                      ],
                      flexibleSpace: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: !filterSelected
                                    ? DropdownButton(
                                        isExpanded: false,
                                        hint: Text('Sort'.tr),
                                        underline: SizedBox(),
                                        value: _selectedSort,
                                        style: AppStyles.kFontBlack14w5,
                                        onChanged: (newValue) async {
                                          setState(() {
                                            _selectedSort =
                                                newValue as Sorting?;
                                            setState(() {
                                              source!.sortKey =
                                                  newValue!.sortKey!;
                                              source!.isSorted = true;
                                              source!.isFilter = false;
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
                                      )
                                    : DropdownButton(
                                        hint: Text('Sort'.tr),
                                        underline: Container(),
                                        value: _selectedSort,
                                        style: AppStyles.kFontBlack14w5,
                                        onChanged: (newValue) async {
                                          print('SORT AFTER FILTER');
                                          setState(() {
                                            _selectedSort =
                                                newValue as Sorting?;
                                            setState(() {
                                              source!.isSorted = true;
                                              source!.isFilter = true;
                                              controller.filterSortKey.value =
                                                  _selectedSort!.sortKey!;
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
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: VerticalDivider(
                                width: 1,
                                thickness: 1,
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    filterSelected = true;
                                    _selectedSort = Sorting.sortingData.first;
                                  });
                                  _scaffoldKey.currentState!.openEndDrawer();
                                },
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        Icons.filter_alt_outlined,
                                        size: 20,
                                      ),
                                      Text(
                                        'Filter'.tr,
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                }
              }),
            ),
            LoadingMoreSliverList<ProductModel>(
              SliverListConfig<ProductModel>(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                indicatorBuilder: BuildIndicatorBuilder(
                        source: source, isSliver: true, name: 'Products'.tr)
                    .buildIndicator,
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
        ));
  }
}

class TagProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final String? tagName;
  final int? tagId;

  TagProductsLoadMore(this.tagName, this.tagId);

  bool? isSorted;
  String sortKey = 'new';
  bool? isFilter;

  final TagController controller = Get.put(TagController());

  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;

  @override
  bool get hasMore => (_hasMore && (length < productsLength)) || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
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
      await Future.delayed(Duration(milliseconds: 500));
      var result;
      dynamic source;
      print(
          'TAG NAME $tagName -> URL : ${URLs.SINGLE_TAG_PRODUCTS + '/$tagId'}');
      if (!isSorted! && !isFilter!) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SINGLE_TAG_PRODUCTS + '/$tagId');
        } else {
          result = await _dio
              .get(URLs.SINGLE_TAG_PRODUCTS + '/$tagId', queryParameters: {
            'page': pageIndex,
          });
        }
        print(result.data);
        final data = new Map<String, dynamic>.from(result.data);
        source = TagProductsModel.fromJson(data);
        productsLength = source!.products.total;
      }

      if (isSorted! && !isFilter!) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'requestItem': tagName,
            'requestItemType': 'tag',
            'sort_by': sortKey,
          });
        } else {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'requestItem': tagName,
            'requestItemType': 'tag',
            'sort_by': sortKey,
            'page': pageIndex,
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
      }

      if (isSorted! && isFilter!) {
        controller.dataFilterCat.value.filterDataFromCat!.filterType!
            .removeWhere((element) =>
                element.filterTypeValue!.length == 0 &&
                element.filterTypeId != 'cat');

        controller.dataFilterCat.value.sortBy =
            controller.filterSortKey.value.toString();

        controller.dataFilterCat.value.page = pageIndex.toString();

        if (this.length == 0) {
          log(filterFromCatModelToJson(controller.dataFilterCat.value));
          result = await _dio.post(
            URLs.FILTER_ALL_PRODUCTS,
            data: filterFromCatModelToJson(controller.dataFilterCat.value),
          );
        } else {
          log(filterFromCatModelToJson(controller.dataFilterCat.value));
          result = await _dio.post(
            URLs.FILTER_ALL_PRODUCTS,
            data: filterFromCatModelToJson(controller.dataFilterCat.value),
          );
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
        print('FILTERED $productsLength');
      }

      if (pageIndex == 1) {
        this.clear();
      }
      if (!isSorted! && !isFilter!) {
        for (var item in source!.products.data) {
          this.add(item);
        }
      }
      if (isSorted! && !isFilter!) {
        for (var item in source!.data) {
          this.add(item);
        }
      }
      if (isFilter! && isSorted!) {
        for (var item in source!.data) {
          this.add(item);
        }
      }

      if (!isSorted! && !isFilter!) {
        _hasMore = source!.products.data.length != 0;
      }
      if (isSorted! && !isFilter!) {
        _hasMore = source!.total != 0;
      }
      if (isSorted! && isFilter!) {
        _hasMore = source!.total != 0;
      }
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
