import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/seller_profile_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/SortingModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'package:loading_more_list/loading_more_list.dart';

import 'StoreHome.dart';

class StoreAllProductsPage extends StatefulWidget {
  final int? sellerId;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  StoreAllProductsPage({this.sellerId, this.scaffoldKey});
  @override
  _StoreAllProductsPageState createState() => _StoreAllProductsPageState();
}

class _StoreAllProductsPageState extends State<StoreAllProductsPage> {
  final SellerProfileController controller = Get.put(SellerProfileController());

  final HomeController homeController = Get.put(HomeController());

  Sorting? _selectedSort;

  bool filterSelected = false;

  SellerProductsLoadMore? source;

  @override
  void initState() {
    source = SellerProductsLoadMore(widget.sellerId);
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
    return LoadingMoreCustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          sliver: Obx(() {
            if (controller.isLoading.value) {
              return SliverToBoxAdapter(child: Container());
            } else {
              if (controller
                      .seller.value.seller!.sellerProductsApi!.data!.length ==
                  0) {
                return SliverToBoxAdapter(child: Container());
              } else {
                return SliverAppBar(
                  backgroundColor: AppStyles.appBackgroundColor,
                  automaticallyImplyLeading: false,
                  centerTitle: false,
                  titleSpacing: 0,
                  toolbarHeight: 20,
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
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: !filterSelected
                                ? DropdownButton(
                                    isExpanded: false,
                                    hint: Text('Sort'.tr),
                                    underline: SizedBox(),
                                    value: _selectedSort,
                                    style: AppStyles.kFontBlack14w5,
                                    dropdownColor: AppStyles.appBackgroundColor,
                                    onChanged: (newValue) async {
                                      setState(() {
                                        _selectedSort = newValue as Sorting?;
                                        setState(() {
                                          source!.sortKey = newValue!.sortKey!;
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
                                    dropdownColor: AppStyles.appBackgroundColor,
                                    onChanged: (newValue) async {
                                      print('SORT AFTER FILTER');
                                      setState(() {
                                        _selectedSort = newValue as Sorting?;
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
                              widget.scaffoldKey!.currentState!.openEndDrawer();
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
            itemBuilder: (BuildContext c, ProductModel prod, int index) {
              return GridViewProductWidget(
                productModel: prod,
              );
            },
            sourceList: source!,
          ),
        ),
      ],
    );
  }
}
