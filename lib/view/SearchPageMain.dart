import 'dart:async';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/search_controller.dart';
import 'package:amazcart/model/NewModel/LiveSearchModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';
import 'package:amazcart/widgets/custom_input_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'dart:math' as math;

import 'products/tags/ProductsByTags.dart';

class SearchPageMain extends StatefulWidget {
  @override
  _SearchPageMainState createState() => _SearchPageMainState();
}

class _SearchPageMainState extends State<SearchPageMain> {
  final SearchController _searchController = Get.put(SearchController());

  Timer? debounce;

  final keywordFocus = FocusNode();

  RecommendedProductsLoadMore? source;

  onSearchChanged(String text) {
    print(text);
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 1000), () async {
      await _searchController.getData(
          keyword: _searchController.keywordCtrl.value.text, catId: "0");
    });
  }

  @override
  void initState() {
    source = RecommendedProductsLoadMore();
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
      body: GestureDetector(
        onTap: () {
          keywordFocus.unfocus();
        },
        child: LoadingMoreCustomScrollView(
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
              title: Container(
                child: TextField(
                  focusNode: keywordFocus,
                  autofocus: true,
                  textAlignVertical: TextAlignVertical.center,
                  controller: _searchController.keywordCtrl.value,
                  keyboardType: TextInputType.text,
                  decoration: CustomInputBorder()
                      .inputDecoration(
                        '${AppConfig.appName}',
                      )
                      .copyWith(
                        suffixIcon: IconButton(
                          onPressed: () {
                            _searchController.keywordCtrl.value.clear();
                            _searchController.liveSearchModel.value =
                                LiveSearchModel();
                          },
                          icon: Icon(
                            Icons.cancel,
                            size: 16,
                            color: AppStyles.lightGreyColor,
                          ),
                        ),
                      ),
                  onChanged: onSearchChanged,
                ),
              ),
            ),
            Obx(() {
              if (_searchController.isLoading.value) {
                return SliverToBoxAdapter(
                  child: Container(),
                );
              } else {
                if (_searchController.liveSearchModel.value.tags == null) {
                  return LoadingMoreSliverList<ProductModel>(
                    SliverListConfig<ProductModel>(
                      padding: EdgeInsets.symmetric(horizontal: 8),
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
                      itemBuilder:
                          (BuildContext c, ProductModel prod, int index) {
                        return GridViewProductWidget(
                          productModel: prod,
                        );
                      },
                      sourceList: source!,
                    ),
                    key: const Key('homePageLoadMoreKey'),
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: ListView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        _searchController.liveSearchModel.value.tags!.length > 0
                            ? ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                separatorBuilder: (context, index) {
                                  return Divider(
                                    color: AppStyles.lightGreyColor,
                                  );
                                },
                                itemCount: _searchController
                                    .liveSearchModel.value.tags!.length,
                                itemBuilder: (context, tagIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            // await _searchController
                                            //     .saveSearchHistory(
                                            //         _searchController
                                            //             .liveSearchModel
                                            //             .value
                                            //             .tags![tagIndex]
                                            //             .id,
                                            //         _searchController
                                            //             .liveSearchModel
                                            //             .value
                                            //             .tags![tagIndex]
                                            //             .name);

                                            Get.to(() => ProductsByTags(
                                                  tagName: _searchController
                                                      .liveSearchModel
                                                      .value
                                                      .tags![tagIndex]
                                                      .name!,
                                                  tagId: _searchController
                                                      .liveSearchModel
                                                      .value
                                                      .tags![tagIndex]
                                                      .id!,
                                                ));
                                          },
                                          child: RichText(
                                            text: TextSpan(
                                              children: _searchController
                                                  .highlightOccurrences(
                                                      _searchController
                                                          .liveSearchModel
                                                          .value
                                                          .tags![tagIndex]
                                                          .name!,
                                                      _searchController
                                                          .keywordCtrl
                                                          .value
                                                          .text),
                                              style: AppStyles.appFont.copyWith(
                                                fontSize: 14,
                                                color: AppStyles.greyColorLight,
                                              ),
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            _searchController
                                                    .keywordCtrl.value.text =
                                                _searchController
                                                    .liveSearchModel
                                                    .value
                                                    .tags![tagIndex]
                                                    .name!;

                                            await _searchController.getData(
                                                keyword: _searchController
                                                    .keywordCtrl.value.text,
                                                catId: "0");
                                          },
                                          child: Transform.rotate(
                                            angle: math.pi * 0.3,
                                            child: Icon(
                                              Icons.arrow_back,
                                              color: AppStyles.greyColorLight,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                })
                            : Container(),
                        Divider(
                          color: AppStyles.lightGreyColor,
                        ),
                      ],
                    ),
                  );
                }
              }
            }),
          ],
        ),
      ),
    );
  }
}
