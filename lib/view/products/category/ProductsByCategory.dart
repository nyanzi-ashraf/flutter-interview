import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/home_controller.dart';

import 'package:amazcart/model/NewModel/FilterFromCatModel.dart';
import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Product/AllProducts.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';

import 'package:amazcart/model/SortingModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/SearchPageMain.dart';

import 'package:amazcart/view/products/category/CategoryFilterDrawer.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';

import 'package:amazcart/widgets/custom_input_border.dart';
import 'package:dio/dio.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

// ignore: must_be_immutable
class ProductsByCategory extends StatefulWidget {
  final int? categoryId;

  ProductsByCategory({this.categoryId});

  @override
  _ProductsByCategoryState createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  final HomeController controller = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());
  final CurrencyController currencyController = Get.put(CurrencyController());

  var _scaffoldKey = GlobalKey<ScaffoldState>();

  Sorting? _selectedSort;

  bool filterSelected = false;

  Future<void> onRefresh() async {
    controller.allProds.clear();
    controller.pageNumber.value = 1;
    controller.lastPage.value = false;
    await controller.getCategoryProducts();
  }

  CategoryProductsLoadMore? source;

  final ScrollController scrollController = ScrollController();

  bool isScrolling = false;

  @override
  void initState() {
    source = CategoryProductsLoadMore(widget.categoryId);
    source!.isSorted = false;
    source!.isFilter = false;

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
      endDrawer: CategoryFilterDrawer(
        categoryID: controller.categoryId.value,
        scaffoldKey: _scaffoldKey,
        source: source!,
      ),
      backgroundColor: AppStyles.appBackgroundColor,
      floatingActionButton: isScrolling
          ? FloatingActionButton(
              backgroundColor: AppStyles.pinkColor,
              onPressed: () {
                scrollController.animateTo(0,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
              },
              child: Icon(
                Icons.arrow_upward_sharp,
              ),
            )
          : Container(),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            FocusScope.of(context).unfocus();
            if (scrollController.offset > 0) {
              setState(() {
                isScrolling = true;
              });
            } else {
              setState(() {
                isScrolling = false;
              });
            }
            return false;
          },
          child: LoadingMoreCustomScrollView(
            physics: const BouncingScrollPhysics(),
            controller: scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                stretch: false,
                pinned: true,
                floating: false,
                forceElevated: false,
                elevation: 0,
                expandedHeight: 55,
                actions: [
                  CartIconWidget(),
                ],
                centerTitle: true,
                titleSpacing: 0,
                leading: Container(
                  child: InkWell(
                    customBorder: CircleBorder(),
                    onTap: () {
                      Get.back();
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppStyles.blackColor,
                    ),
                  ),
                ),
                title: Obx(() {
                  if (controller.isProductsLoading.value) {
                    return Container();
                  }
                  if (controller.categoryTitle.value == null) {
                    return Container();
                  }
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => SearchPageMain());
                    },
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        autofocus: true,
                        enabled: false,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.text,
                        style: AppStyles.kFontBlack12w4,
                        decoration: CustomInputBorder()
                            .inputDecoration(
                              '${AppConfig.appName}',
                            )
                            .copyWith(
                              hintStyle: AppStyles.kFontBlack12w4,
                            ),
                      ),
                    ),
                  );
                }),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                sliver: Obx(() {
                  if (controller.isProductsLoading.value) {
                    return SliverToBoxAdapter(child: Container());
                  } else {
                    if (controller.allProds.length == 0) {
                      return SliverToBoxAdapter(child: Container());
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
                                          items:
                                              Sorting.sortingData.map((sort) {
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
                                          items:
                                              Sorting.sortingData.map((sort) {
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
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
              SliverToBoxAdapter(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  children: [
                    Obx(() {
                      if (controller.allProds.length <= 0) {
                        if (controller.isProductsLoading.value) {
                          return Container();
                        }
                        return Container();
                      } else {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15,
                          ),
                          child: Obx(() {
                            if (controller.catAllData.value.brands != null &&
                                controller.catAllData.value.brands!.length >
                                    0) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                    color: AppStyles.textFieldFillColor,
                                  ),
                                ),
                                child: Wrap(
                                  runSpacing: 10,
                                  alignment: WrapAlignment.start,
                                  children: List.generate(
                                      controller.catAllData.value.brands!
                                          .length, (index) {
                                    BrandData brand = controller
                                        .catAllData.value.brands![index];
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          filterSelected = true;
                                          _selectedSort =
                                              Sorting.sortingData.first;
                                        });

                                        if (controller.selectedBrands
                                            .contains(brand)) {
                                          controller.selectedBrands
                                              .remove(brand);
                                          controller.brandFilter.value
                                              .filterTypeValue!
                                              .remove(brand.id.toString());
                                          controller.dataFilterCat.value
                                              .filterDataFromCat!.filterType!
                                              .where((element) =>
                                                  element.filterTypeId ==
                                                  'brand')
                                              .toList()
                                              .remove(
                                                  controller.brandFilter.value);
                                        } else {
                                          controller.selectedBrands.add(brand);
                                          controller.brandFilter.value
                                              .filterTypeValue!
                                              .add(brand.id.toString());
                                          controller.dataFilterCat.value
                                              .filterDataFromCat!.filterType!
                                              .add(
                                                  controller.brandFilter.value);
                                        }

                                        controller.dataFilterCat.value
                                            .filterDataFromCat!.filterType!
                                            .forEach((element) {
                                          if (element.filterTypeId ==
                                              'price_range') {
                                            element.filterTypeValue!.clear();
                                            element.filterTypeValue!.add([
                                              controller.lowRangeCatCtrl.text,
                                              controller.highRangeCatCtrl.text,
                                            ]);
                                          }
                                        });

                                        controller.dataFilterCat.value
                                            .filterDataFromCat!.filterType!
                                            .forEach((element) {
                                          if (element.filterTypeId ==
                                              'rating') {
                                            element.filterTypeValue!.clear();
                                            element.filterTypeValue!.add(
                                                controller.filterRating.value
                                                    .toInt()
                                                    .toString());
                                          }
                                        });

                                        controller.filterSortKey.value = 'new';

                                        source!.isFilter = true;
                                        source!.isSorted = true;
                                        source!.refresh(true);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 5),
                                        padding: EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: controller.selectedBrands
                                                        .contains(brand)
                                                    ? Colors.red
                                                    : Colors.white)),
                                        child: FancyShimmerImage(
                                          imageUrl:
                                              '${AppConfig.assetPath}/${brand.logo}',
                                          width: 50,
                                          height: 50,
                                          boxFit: BoxFit.contain,
                                          errorWidget: FancyShimmerImage(
                                            imageUrl:
                                                "${AppConfig.assetPath}/backend/img/default.png",
                                            boxFit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              );
                            } else {
                              return Container(
                                color: AppStyles.appBackgroundColor,
                              );
                            }
                          }),
                        );
                      }
                    }),
                  ],
                ),
              ),
              LoadingMoreSliverList<ProductModel>(
                SliverListConfig<ProductModel>(
                  indicatorBuilder: BuildIndicatorBuilder(
                    source: source!,
                    isSliver: true,
                    name: 'Products'.tr,
                  ).buildIndicator,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
        ),
      ),
    );
  }
}

class CategoryProductsLoadMore extends LoadingMoreBase<ProductModel> {
  final int? categoryId;

  CategoryProductsLoadMore(this.categoryId);

  bool? isSorted;
  String? sortKey = 'new';
  bool? isFilter;

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
      var source;

      if (!isSorted!! && !isFilter!) {
        if (this.length == 0) {
          result = await _dio.get(URLs.ALL_CATEGORY + '/$categoryId');
        } else {
          result = await _dio
              .get(URLs.ALL_CATEGORY + '/$categoryId', queryParameters: {
            'page': pageIndex,
          });
        }
        print('URI IS ${result.realUri}');
        final data = new Map<String, dynamic>.from(result.data);
        source = CategoryData.fromJson(data['data']);
        productsLength = source!.allProducts.total;
        print('INITIALIZED PRODUCT LENGTH $productsLength');
      }
      if (isSorted! && !isFilter!) {
        if (this.length == 0) {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': categoryId,
            'requestItemType': 'category',
          });
        } else {
          result = await _dio.get(URLs.SORT_PRODUCTS, queryParameters: {
            'sort_by': sortKey,
            'paginate': 9,
            'requestItem': categoryId,
            'requestItemType': 'category',
            'page': pageIndex,
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllProducts.fromJson(data);
        productsLength = data['meta']['total'];
        print('SORT BY PRODUCT LENGTH $productsLength');
      }
      if (isFilter! && isSorted!) {
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
        for (var item in source!.allProducts.data) {
          this.add(item);
        }
        // if (source!.subCategories.length != 0) {
        //   for (var item in source!.subCategories) {
        //     item.allProducts.data.forEach((element) {
        //       this.add(element);
        //     });
        //     if (item.subCategories.length != 0) {
        //       for (var item2 in item.subCategories) {
        //         item2.allProducts.data.forEach((element) {
        //           this.add(element);
        //         });
        //       }
        //     }
        //   }
        // }
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
        _hasMore = source!.allProducts.total != 0;
      }
      if (isSorted! && !isFilter!) {
        _hasMore = source!.total != 0;
      }
      if (isFilter! && isSorted!) {
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
