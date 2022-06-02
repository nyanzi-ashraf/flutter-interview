import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/home_controller.dart';

import 'package:amazcart/model/NewModel/Category/CategoryData.dart';

import 'package:amazcart/model/NewModel/Category/SingleCategory.dart';

import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/fa_icon_maker/fa_custom_icon.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'category/ProductsByCategory.dart';

class AllCategorySubCategory extends StatefulWidget {
  @override
  State<AllCategorySubCategory> createState() => _AllCategorySubCategoryState();
}

class _AllCategorySubCategoryState extends State<AllCategorySubCategory> {
  final HomeController controller = Get.put(HomeController());

  final CartController cartController = Get.put(CartController());

  int _selectedIndex = 0;

  List<bool> isSelected = [];

  getAll() async {
    Future.delayed(Duration(seconds: 0), () async {
      await controller.getCategories();
    });
    controller.allCategoryList.forEach((element) {
      isSelected.add(false);
    });
  }

  @override
  void didChangeDependencies() async {
    await getAll();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        appBar: AppBarWidget(
          title: "Browse Products".tr,
        ),
        body: Obx(() {
          if (controller.isAllCategoryLoading.value) {
            return Center(child: CustomLoadingWidget());
          } else {
            return Row(
              children: <Widget>[
                Flexible(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: controller.allCategoryList.length,
                      itemBuilder: (context, index) {
                        CategoryData category =
                            controller.allCategoryList[index];
                        return Container(
                          color: _selectedIndex == index
                              ? AppStyles.appBackgroundColor
                              : Colors.white,
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              await controller.getSubCategories(
                                  categoryId: category.id);
                              setState(() {
                                _selectedIndex = index;
                              });
                            },
                            child: Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    category.icon != null
                                        ? Container(
                                            height: 50,
                                            child: Icon(
                                              FaCustomIcon.getFontAwesomeIcon(
                                                  category.icon!),
                                              size: 30,
                                              color: _selectedIndex == index
                                                  ? AppStyles.pinkColor
                                                  : Colors.black,
                                            ),
                                          )
                                        : Container(
                                            height: 50,
                                            child: Icon(
                                              Icons.list_alt_outlined,
                                              size: 30,
                                              color: _selectedIndex == index
                                                  ? AppStyles.pinkColor
                                                  : Colors.black,
                                            ),
                                          ),
                                    Container(
                                      width: 75,
                                      child: Text(
                                        category.name!,
                                        style: AppStyles.kFontBlack14w5
                                            .copyWith(
                                                color: _selectedIndex == index
                                                    ? Colors.pink
                                                    : Colors.black),
                                        textAlign: TextAlign.center,
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
                Flexible(
                  flex: 3,
                  child: Obx(
                    () {
                      if (controller.isSubCategoryLoading.value) {
                        return Center(
                            child: Container(
                                // child: CupertinoActivityIndicator(),
                                ));
                      } else {
                        if (controller.singleCat.value.data == null) {
                          return Container();
                        } else {
                          return ListView(
                            physics: BouncingScrollPhysics(),
                            children: [
                              SizedBox(
                                height: 5,
                              ),
                              controller.singleCat.value.data!.categoryImage!
                                          .image !=
                                      null
                                  ? Padding(
                                      padding: EdgeInsets.all(4),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: AppStyles
                                                      .lightBlueColorAlt)),
                                          child: FancyShimmerImage(
                                            imageUrl: AppConfig.assetPath +
                                                '/' +
                                                controller.singleCat.value.data!
                                                    .categoryImage!.image!,
                                            height: 80,
                                            boxFit: BoxFit.cover,
                                            errorWidget: FancyShimmerImage(
                                              imageUrl:
                                                  "${AppConfig.assetPath}/backend/img/default.png",
                                              boxFit: BoxFit.contain,
                                              errorWidget: FancyShimmerImage(
                                                imageUrl:
                                                    "${AppConfig.assetPath}/backend/img/default.png",
                                                boxFit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                height: 10,
                              ),
                              ListTile(
                                onTap: () {
                                  print(controller.singleCat.value.data);
                                  openCategory(controller.singleCat.value.data);
                                },
                                leading:
                                    controller.singleCat.value.data!.icon !=
                                            null
                                        ? Container(
                                            height: 50,
                                            child: Icon(
                                              FaCustomIcon.getFontAwesomeIcon(
                                                  controller.singleCat.value
                                                      .data!.icon!),
                                              size: 30,
                                              color: AppStyles.blackColor,
                                            ),
                                          )
                                        : Container(
                                            height: 50,
                                            child: Icon(
                                              Icons.list_alt_outlined,
                                              size: 30,
                                              color: AppStyles.blackColor,
                                            ),
                                          ),
                                title: Text(
                                  controller.singleCat.value.data!.name!,
                                  style: AppStyles.kFontBlack14w5,
                                ),
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: controller.singleCat.value.data!
                                      .subCategories!.length,
                                  itemBuilder: (context, subCatIndex) {
                                    if (controller
                                            .singleCat
                                            .value
                                            .data!
                                            .subCategories![subCatIndex]
                                            .subCategories!
                                            .length >
                                        0) {
                                      return ExpansionTile(
                                          title: ListTile(
                                            onTap: () async {
                                              openCategory(controller
                                                  .singleCat
                                                  .value
                                                  .data!
                                                  .subCategories![subCatIndex]);
                                            },
                                            contentPadding: EdgeInsets.zero,
                                            leading: controller
                                                        .singleCat
                                                        .value
                                                        .data!
                                                        .subCategories![
                                                            subCatIndex]
                                                        .icon !=
                                                    null
                                                ? Container(
                                                    height: 50,
                                                    child: Icon(
                                                      FaCustomIcon
                                                          .getFontAwesomeIcon(
                                                              controller
                                                                  .singleCat
                                                                  .value
                                                                  .data!
                                                                  .subCategories![
                                                                      subCatIndex]
                                                                  .icon),
                                                      size: 30,
                                                      color:
                                                          AppStyles.blackColor,
                                                    ),
                                                  )
                                                : Container(
                                                    height: 50,
                                                    child: Icon(
                                                      Icons.list_alt_outlined,
                                                      size: 30,
                                                      color:
                                                          AppStyles.blackColor,
                                                    ),
                                                  ),
                                            title: Text(
                                                controller
                                                    .singleCat
                                                    .value
                                                    .data!
                                                    .subCategories![subCatIndex]
                                                    .name!,
                                                style:
                                                    AppStyles.kFontBlack14w5),
                                          ),
                                          children: List.generate(
                                              controller
                                                  .singleCat
                                                  .value
                                                  .data!
                                                  .subCategories![subCatIndex]
                                                  .subCategories!
                                                  .length, (expansionIndex) {
                                            return ListTile(
                                              onTap: () {
                                                openCategory(
                                                    controller
                                                            .singleCat
                                                            .value
                                                            .data!
                                                            .subCategories![
                                                                subCatIndex]
                                                            .subCategories![
                                                        expansionIndex]);
                                              },
                                              leading: controller
                                                          .singleCat
                                                          .value
                                                          .data!
                                                          .subCategories![
                                                              subCatIndex]
                                                          .subCategories![
                                                              expansionIndex]
                                                          .icon !=
                                                      null
                                                  ? Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: Icon(
                                                        FaCustomIcon.getFontAwesomeIcon(
                                                            controller
                                                                .singleCat
                                                                .value
                                                                .data!
                                                                .subCategories![
                                                                    subCatIndex]
                                                                .subCategories![
                                                                    expansionIndex]
                                                                .icon),
                                                        color: AppStyles
                                                            .blackColor,
                                                      ),
                                                    )
                                                  : Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: Icon(
                                                        Icons.list_alt_outlined,
                                                        color: AppStyles
                                                            .blackColor,
                                                      ),
                                                    ),
                                              title: Text(
                                                controller
                                                    .singleCat
                                                    .value
                                                    .data!
                                                    .subCategories![subCatIndex]
                                                    .subCategories![
                                                        expansionIndex]
                                                    .name!,
                                                style: AppStyles.kFontBlack14w5,
                                              ),
                                            );
                                          }));
                                    }
                                    return ListTile(
                                      onTap: () {
                                        openCategory(controller.singleCat.value
                                            .data!.subCategories![subCatIndex]);
                                      },
                                      leading: controller
                                                  .singleCat
                                                  .value
                                                  .data!
                                                  .subCategories![subCatIndex]
                                                  .icon !=
                                              null
                                          ? Container(
                                              height: 50,
                                              width: 50,
                                              child: Icon(
                                                FaCustomIcon.getFontAwesomeIcon(
                                                    controller
                                                        .singleCat
                                                        .value
                                                        .data!
                                                        .subCategories![
                                                            subCatIndex]
                                                        .icon),
                                                color: AppStyles.blackColor,
                                              ),
                                            )
                                          : Container(
                                              height: 50,
                                              width: 50,
                                              child: Icon(
                                                Icons.list_alt_outlined,
                                                color: AppStyles.blackColor,
                                              ),
                                            ),
                                      title: Text(
                                        controller.singleCat.value.data!
                                            .subCategories![subCatIndex].name!,
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    );
                                  }),
                            ],
                          );
                        }
                      }
                    },
                  ),
                ),
              ],
            );
          }
        }));
  }

  void openCategory(dynamic category) {
    print('CAT $category');
    controller.categoryId.value = category.id;
    controller.categoryIdBeforeFilter.value = category.id;
    controller.allProds.clear();
    controller.subCats.clear();
    controller.lastPage.value = false;
    controller.pageNumber.value = 1;
    controller.category.value = CategoryData();
    controller.catAllData.value = SingleCategory();
    // controller.dataFilter.value =
    //     FilterFromCatModel();
    controller.getCategoryProducts();
    controller.getCategoryFilterData();
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

    // Get.toNamed('/productsByCategory');
    Get.to(() => ProductsByCategory(
          categoryId: category.id,
        ));
  }
}
