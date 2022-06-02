import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/seller_profile_controller.dart';
import 'package:amazcart/model/NewModel/Brand/BrandData.dart';

import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Category/SingleCategory.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Seller/SellerProfileModel.dart';

import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/products/brand/ProductsByBrands.dart';
import 'package:amazcart/view/products/category/ProductsByCategory.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/HomeTitlesWidget.dart';
import 'package:amazcart/widgets/HorizontalProductWidget.dart';
import 'package:amazcart/widgets/fa_icon_maker/fa_custom_icon.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'package:loading_more_list/loading_more_list.dart';

class StoreHomePage extends StatefulWidget {
  @override
  _StoreHomePageState createState() => _StoreHomePageState();
}

class _StoreHomePageState extends State<StoreHomePage> {
  final SellerProfileController controller = Get.put(SellerProfileController());

  final HomeController homeController = Get.put(HomeController());

  RecommendedProductsLoadMore? source;

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
    return LoadingMoreCustomScrollView(
      rebuildCustomScrollView: true,
      showGlowLeading: false,
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              SizedBox(
                height: 15,
              ),
              HomeTitlesWidget(
                title: 'New Arrival'.tr,
                btnOnTap: () {
                  controller.tabController!.animateTo(1);
                },
                showDeal: false,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 220,
                child: ListView.separated(
                    itemCount: controller.recentProductsList.take(5).length,
                    scrollDirection: Axis.horizontal,
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: 10,
                      );
                    },
                    itemBuilder: (context, topPickIndex) {
                      ProductModel prod =
                          controller.recentProductsList[topPickIndex];
                      return HorizontalProductWidget(
                        productModel: prod,
                      );
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              controller.seller.value.categoryList!.length > 0
                  ? HomeTitlesWidget(
                      title: 'Categories'.tr,
                      btnOnTap: () {
                        controller.tabController!.animateTo(1);
                      },
                      showDeal: false,
                    )
                  : SizedBox.shrink(),
              controller.seller.value.categoryList!.length > 0
                  ? SizedBox(
                      height: 10,
                    )
                  : SizedBox.shrink(),
              controller.seller.value.categoryList!.length > 0
                  ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        color: AppStyles.lightBlueColorAlt,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: Container(
                            height: 100,
                            child: ListView.separated(
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 10,
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount:
                                  controller.seller.value.categoryList!.length,
                              itemBuilder: (context, index) {
                                CategoryList category = controller
                                    .seller.value.categoryList![index];
                                return InkWell(
                                  onTap: () {
                                    homeController.categoryId.value =
                                        category.id;
                                    homeController.categoryIdBeforeFilter
                                        .value = category.id;
                                    homeController.allProds.clear();
                                    homeController.subCats.clear();
                                    homeController.lastPage.value = false;
                                    homeController.pageNumber.value = 1;
                                    homeController.category.value =
                                        CategoryData();
                                    homeController.catAllData.value =
                                        SingleCategory();
                                    homeController.getCategoryProducts();
                                    homeController.getCategoryFilterData();
                                    if (homeController.dataFilterCat.value
                                            .filterDataFromCat !=
                                        null) {
                                      homeController.dataFilterCat.value
                                          .filterDataFromCat!.filterType!
                                          .forEach((element) {
                                        if (element.filterTypeId == 'brand' ||
                                            element.filterTypeId == 'cat') {
                                          print(element.filterTypeId);
                                          element.filterTypeValue!.clear();
                                        }
                                      });
                                    }

                                    homeController.filterRating.value = 0.0;

                                    // Get.toNamed('/productsByCategory');
                                    Get.to(() => ProductsByCategory(
                                          categoryId: category.id,
                                        ));
                                  },
                                  child: Container(
                                    color: Colors.white,
                                    width: 80,
                                    child: Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: <Widget>[
                                          category.icon != null
                                              ? Container(
                                                  height: 50,
                                                  child: Icon(
                                                    FaCustomIcon
                                                        .getFontAwesomeIcon(
                                                            category.icon!),
                                                    size: 30,
                                                  ),
                                                )
                                              : Container(
                                                  height: 50,
                                                  child: Icon(
                                                    Icons.list_alt_outlined,
                                                    size: 30,
                                                  ),
                                                ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 5.0,
                                            ),
                                            child: Text(
                                              category.name!,
                                              textAlign: TextAlign.center,
                                              style: AppStyles.kFontBlack13w5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: 10,
              ),
              HomeTitlesWidget(
                title: 'Brands'.tr,
                btnOnTap: () {
                  controller.tabController!.animateTo(1);
                },
                showDeal: false,
              ),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Container(
                  color: AppStyles.lightBlueColorAlt,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      height: 100,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            width: 10,
                          );
                        },
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: controller.seller.value.brandList!.length,
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          BrandData brand =
                              controller.seller.value.brandList![index];
                          return InkWell(
                            onTap: () {
                              homeController.brandId.value = brand.id!;
                              homeController.allBrandProducts.clear();
                              homeController.subCatsInBrands.clear();
                              homeController.lastBrandPage.value = false;
                              homeController.brandPageNumber.value = 1;
                              homeController.getBrandProducts();
                              homeController.getBrandFilterData();

                              if (homeController
                                      .dataFilterCat.value.filterDataFromCat !=
                                  null) {
                                homeController.dataFilterCat.value
                                    .filterDataFromCat!.filterType!
                                    .forEach((element) {
                                  if (element.filterTypeId == 'brand' ||
                                      element.filterTypeId == 'cat') {
                                    print(element.filterTypeId);
                                    element.filterTypeValue!.clear();
                                  }
                                });
                              }
                              Get.to(() => ProductsByBrands(
                                    brandId: brand.id!,
                                  ));
                            },
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              clipBehavior: Clip.antiAlias,
                              child: Container(
                                color: Colors.white,
                                width: 80,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: brand.logo != null
                                              ? Container(
                                                  child: FancyShimmerImage(
                                                    imageUrl:
                                                        AppConfig.assetPath +
                                                                '/' +
                                                                brand.logo! ??
                                                            '',
                                                    boxFit: BoxFit.contain,
                                                    errorWidget:
                                                        FancyShimmerImage(
                                                      imageUrl:
                                                          "${AppConfig.assetPath}/backend/img/default.png",
                                                      boxFit: BoxFit.contain,
                                                      errorWidget:
                                                          FancyShimmerImage(
                                                        imageUrl:
                                                            "${AppConfig.assetPath}/backend/img/default.png",
                                                        boxFit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  child: Icon(Icons.list_alt)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: brand.name!.length < 10
                                                ? 1.0
                                                : 0.0,
                                            horizontal: 4),
                                        child: Text(
                                          brand.name!,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppStyles.kFontBlack12w4,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              'You might like'.tr,
              textAlign: TextAlign.center,
              style: AppStyles.appFont.copyWith(
                color: AppStyles.blackColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        LoadingMoreSliverList<ProductModel>(
          SliverListConfig<ProductModel>(
            padding: EdgeInsets.all(5.0),
            indicatorBuilder: BuildIndicatorBuilder(
              source: source,
              isSliver: true,
              name: 'Recommended Products'.tr,
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
          key: const Key('homePageLoadMoreKey'),
        ),
      ],
    );
  }
}
