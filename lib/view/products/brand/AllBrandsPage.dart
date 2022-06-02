import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/products/brand/ProductsByBrands.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';
import 'package:amazcart/widgets/custom_grid_delegate.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllBrandsPage extends StatefulWidget {
  @override
  _AllBrandsPageState createState() => _AllBrandsPageState();
}

class _AllBrandsPageState extends State<AllBrandsPage> {
  final HomeController _homeController = Get.put(HomeController());
  final CartController cartController = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
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
        title: Text(
          "Brands".tr,
          style: AppStyles.kFontBlack15w4,
        ),
        actions: [
          CartIconWidget(),
        ],
      ),
      body: Obx(() {
        if (_homeController.isBrandsLoading.value) {
          return Center(child: CupertinoActivityIndicator());
        } else {
          return GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              physics: BouncingScrollPhysics(),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 6,
                height: 130,
              ),
              itemCount: _homeController.allBrands.length,
              itemBuilder: (context, index) {
                BrandData brand = _homeController.allBrands[index];
                return GestureDetector(
                  onTap: () async {
                    _homeController.brandId.value = brand.id!;
                    _homeController.allBrandProducts.clear();
                    _homeController.lastBrandPage.value = false;
                    _homeController.brandPageNumber.value = 1;
                    _homeController.getBrandProducts();
                    _homeController.getBrandFilterData();
                    if (_homeController.dataFilterCat.value.filterDataFromCat !=
                        null) {
                      _homeController
                          .dataFilterCat.value.filterDataFromCat!.filterType!
                          .forEach((element) {
                        if (element.filterTypeId == 'brand' ||
                            element.filterTypeId == 'cat') {
                          print(element.filterTypeId);
                          element.filterTypeValue!.clear();
                        }
                      });
                    }
                    Get.to(() => ProductsByBrands(
                          brandId: brand.id,
                        ));
                  },
                  child: Container(
                    width: Get.width * 0.5,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Material(
                        elevation: 2,
                        shadowColor: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: brand.logo != null
                                      ? Container(
                                          child: FancyShimmerImage(
                                            imageUrl: AppConfig.assetPath +
                                                    '/' +
                                                    brand.logo! ??
                                                '',
                                            boxFit: BoxFit.contain,
                                            errorWidget: FancyShimmerImage(
                                              imageUrl:
                                                  "${AppConfig.assetPath}/backend/img/default.png",
                                              boxFit: BoxFit.contain,
                                            ),
                                          ),
                                        )
                                      : Container(
                                          child: Icon(
                                            Icons.list_alt,
                                            size: 50,
                                          ),
                                        ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                brand.name!,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppStyles.appFont.copyWith(
                                  color: AppStyles.blackColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
        }
      }),
    );
  }
}
