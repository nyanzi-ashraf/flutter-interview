import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/seller_profile_controller.dart';
import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Seller/SellerProfileModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/BlueButtonWidget.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'StoreHome.dart';

class SellerProfileFilterDrawer extends StatefulWidget {
  final int? sellerId;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final SellerProductsLoadMore? source;

  SellerProfileFilterDrawer({this.sellerId, this.scaffoldKey, this.source});

  @override
  _SellerProfileFilterDrawerState createState() =>
      _SellerProfileFilterDrawerState();
}

class _SellerProfileFilterDrawerState extends State<SellerProfileFilterDrawer> {
  final SellerProfileController controller = Get.put(SellerProfileController());
  final CurrencyController _currencyController = Get.put(CurrencyController());

  RangeValues? _currentRangeValues;
  bool showRange = false;

  @override
  void initState() {
    if (controller.seller.value.lowestPrice != null &&
        (controller.seller.value.lowestPrice <
            controller.seller.value.heightPrice)) {
      showRange = true;
      _currentRangeValues = RangeValues(
          int.parse(controller.seller.value.lowestPrice.toString()).toDouble(),
          int.parse(controller.seller.value.heightPrice.toString()).toDouble());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height,
      width: Get.width * 0.7,
      child: Scaffold(
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Text(
                'Filter Seller Products',
                style: AppStyles.kFontBlack14w5
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),

            //Category
            SizedBox(
              height: 5,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppStyles.textFieldFillColor,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Child Category',
                style: AppStyles.kFontBlack12w4,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            controller.seller.value.categoryList!.length > 0
                ? Builder(
                    builder: (context) {
                      final _items = controller.seller.value.categoryList!
                          .map((category) => MultiSelectItem<CategoryList>(
                              category, category.name!))
                          .toList();
                      return MultiSelectChipField<CategoryList>(
                        items: _items,
                        scroll: false,
                        searchable: false,
                        showHeader: false,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white)),
                        itemBuilder: (item, state) {
                          return Card(
                            color:
                                controller.selectedSubCat.contains(item.value)
                                    ? AppStyles.darkBlueColor
                                    : Colors.white,
                            elevation:
                                controller.selectedSubCat.contains(item.value)
                                    ? 5
                                    : 3,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Container(
                              height: 30,
                              child: MaterialButton(
                                onPressed: () async {
                                  state.didChange(controller.selectedSubCat);

                                  if (controller.selectedSubCat
                                      .contains(item.value)) {
                                    controller.selectedSubCat
                                        .remove(item.value);

                                    controller
                                        .subCatFilter.value.filterTypeValue!
                                        .remove(item.value.id.toString());

                                    controller.sellerFilter.value.filterType!
                                        .where((element) =>
                                            element.filterTypeId == 'cat')
                                        .toList()
                                        .remove(controller.subCatFilter.value);

                                    await doFilter();
                                  } else {
                                    controller.selectedSubCat.add(item.value);
                                    controller
                                        .subCatFilter.value.filterTypeValue!
                                        .add(item.value.id.toString());

                                    controller.sellerFilter.value.filterType!
                                        .add(controller.subCatFilter.value);

                                    await doFilter();
                                  }
                                },
                                child: Text(item.value.name!,
                                    style: controller.selectedSubCat
                                            .contains(item.value)
                                        ? AppStyles.kFontWhite14w5
                                        : AppStyles.kFontBlack14w5),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Container(),

            SizedBox(
              height: 5,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppStyles.textFieldFillColor,
            ),

            SizedBox(
              height: 10,
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Brands',
                style: AppStyles.kFontBlack12w4,
              ),
            ),

            controller.seller.value.brandList!.length > 0
                ? Builder(
                    builder: (context) {
                      final _items = controller.seller.value.brandList!
                          .map((category) => MultiSelectItem<BrandData>(
                              category, category.name!))
                          .toList();
                      return MultiSelectChipField<BrandData>(
                        items: _items,
                        scroll: false,
                        searchable: false,
                        showHeader: false,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.white)),
                        itemBuilder: (item, state) {
                          return Card(
                            color: controller.selectedBrand.contains(item.value)
                                ? AppStyles.darkBlueColor
                                : Colors.white,
                            elevation:
                                controller.selectedBrand.contains(item.value)
                                    ? 5
                                    : 3,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Container(
                              height: 30,
                              child: MaterialButton(
                                onPressed: () async {
                                  state.didChange(controller.selectedBrand);

                                  if (controller.selectedBrand
                                      .contains(item.value)) {
                                    controller.selectedBrand.remove(item.value);

                                    controller
                                        .brandFilter.value.filterTypeValue!
                                        .remove(item.value.id.toString());

                                    controller.sellerFilter.value.filterType!
                                        .where((element) =>
                                            element.filterTypeId == 'brand')
                                        .toList()
                                        .remove(controller.brandFilter.value);

                                    await doFilter();
                                  } else {
                                    controller.selectedBrand.add(item.value);
                                    controller
                                        .brandFilter.value.filterTypeValue!
                                        .add(item.value.id.toString());

                                    controller.sellerFilter.value.filterType!
                                        .add(controller.brandFilter.value);

                                    await doFilter();
                                  }
                                },
                                child: Text(item.value.name!,
                                    style: controller.selectedBrand
                                            .contains(item.value)
                                        ? AppStyles.kFontWhite14w5
                                        : AppStyles.kFontBlack14w5),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                : Container(),

            //Price Range
            showRange
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: AppStyles.textFieldFillColor,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          'Price Range (${_currencyController.appCurrency.value})',
                          style: AppStyles.kFontBlack12w4,
                        ),
                      ),
                    ],
                  )
                : Container(),

            showRange
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: FlutterSlider(
                      values: [
                        double.parse(controller.lowRangeCatCtrl.text),
                        double.parse(controller.highRangeCatCtrl.text)
                      ],
                      rangeSlider: true,
                      handler: FlutterSliderHandler(
                        decoration: BoxDecoration(),
                        child: Material(
                          type: MaterialType.circle,
                          color: AppStyles.pinkColor,
                          elevation: 3,
                          child: Container(
                              child: Icon(
                            Icons.circle,
                            size: 25,
                            color: AppStyles.pinkColor,
                          )),
                        ),
                      ),
                      rightHandler: FlutterSliderHandler(
                        decoration: BoxDecoration(),
                        child: Material(
                          type: MaterialType.circle,
                          color: AppStyles.pinkColor,
                          elevation: 3,
                          child: Container(
                              child: Icon(
                            Icons.circle,
                            size: 25,
                            color: AppStyles.pinkColor,
                          )),
                        ),
                      ),
                      trackBar: FlutterSliderTrackBar(
                        inactiveTrackBar: BoxDecoration(
                          color: AppStyles.mediumPinkColor,
                          // border: Border.all(width: 3, color: Colors.blue),
                        ),
                        activeTrackBar: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: AppStyles.pinkColor,
                        ),
                      ),
                      hatchMark: FlutterSliderHatchMark(
                        disabled: true,
                      ),
                      min: int.parse(
                              controller.seller.value.lowestPrice.toString())
                          .toDouble(),
                      max: int.parse(
                              controller.seller.value.heightPrice.toString())
                          .toDouble(),
                      onDragCompleted:
                          (handlerIndex, lowerValue, upperValue) async {
                        controller.lowRangeCatCtrl.text = lowerValue.toString();
                        controller.highRangeCatCtrl.text =
                            upperValue.toString();
                        setState(() {});

                        controller.sellerFilter.value.filterType!
                            .forEach((element) {
                          if (element.filterTypeId == 'price_range') {
                            element.filterTypeValue!.clear();
                            element.filterTypeValue!.add(
                              int.parse(_currentRangeValues!.start
                                      .round()
                                      .toString())
                                  .toString(),
                            );
                            element.filterTypeValue!.add(int.parse(
                                    _currentRangeValues!.end.round().toString())
                                .toString());
                          }
                        });

                        await doFilter();
                      },
                    ),
                  )
                : Container(),

            showRange
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Row(children: [
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          controller: controller.lowRangeCatCtrl,
                          scrollPhysics: AlwaysScrollableScrollPhysics(),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            hintText:
                                '${_currentRangeValues!.start.round().toString()}',
                            fillColor: AppStyles.appBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            hintStyle:
                                AppStyles.kFontGrey12w5.copyWith(fontSize: 13),
                          ),
                          style: AppStyles.kFontBlack13w5,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        ' - ',
                        style: AppStyles.kFontBlack12w4,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: TextField(
                          autofocus: false,
                          controller: controller.highRangeCatCtrl,
                          scrollPhysics: AlwaysScrollableScrollPhysics(),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            hintText:
                                '${_currentRangeValues!.end.round().toString()}',
                            fillColor: AppStyles.appBackgroundColor,
                            filled: true,
                            isDense: true,
                            contentPadding: EdgeInsets.all(10),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: AppStyles.textFieldFillColor,
                              ),
                            ),
                            hintStyle:
                                AppStyles.kFontGrey12w5.copyWith(fontSize: 13),
                          ),
                          style: AppStyles.kFontBlack13w5,
                        ),
                      ),
                    ]),
                  )
                : Container(),

            SizedBox(
              height: 10,
            ),
            //Rating

            SizedBox(
              height: 5,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppStyles.textFieldFillColor,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                'Rating',
                style: AppStyles.kFontBlack12w4,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  RatingBar.builder(
                    initialRating: controller.filterRating.value,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    glow: false,
                    itemSize: 20,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: AppStyles.goldenYellowColor,
                      size: 10,
                    ),
                    onRatingUpdate: (rating) async {
                      print(rating);
                      controller.filterRating.value = rating;

                      controller.sellerFilter.value.filterType!
                          .forEach((element) {
                        if (element.filterTypeId == 'rating') {
                          element.filterTypeValue!.clear();
                          element.filterTypeValue!.add(rating.toString());
                        }
                      });

                      await doFilter();
                    },
                  ),
                  Obx(() {
                    return Text(
                      '${controller.filterRating.value.toString()} and Up',
                      style: AppStyles.kFontBlack12w4,
                    );
                  })
                ],
              ),
            ),

            //Button
            SizedBox(
              height: 10,
            ),
            Divider(
              height: 1,
              thickness: 1,
              color: AppStyles.textFieldFillColor,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            children: [
              Expanded(
                child: BlueButtonWidget(
                  height: 40,
                  btnText: 'Reset',
                  btnOnTap: () async {
                    // controller.categoryId.value =
                    //     controller.categoryIdBeforeFilter.value;
                    // controller.allProds.clear();
                    // controller.subCats.clear();
                    // controller.lastPage.value = false;
                    // controller.pageNumber.value = 1;
                    // if (controller.sellerFilter.value.filterDataFromCat != null) {
                    //   controller.sellerFilter.value.filterDataFromCat.filterType
                    //       .forEach((element) {
                    //     if (element.filterTypeId == 'brand' ||
                    //         element.filterTypeId == 'cat') {
                    //       print(element.filterTypeId);
                    //       element.filterTypeValue.clear();
                    //     }
                    //   });
                    // }
                    // controller.getCategoryFilterData();
                    // controller.getCategoryProducts();
                    //
                    // Get.toNamed('/productsByCategory');
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: PinkButtonWidget(
                  height: 40,
                  btnText: 'Apply Filter',
                  btnOnTap: doFilter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future doFilter() async {
    controller.sellerFilter.value.filterType!.forEach((element) {
      if (element.filterTypeId == 'price_range') {
        element.filterTypeValue!.clear();
        element.filterTypeValue!.addAll([
          controller.lowRangeCatCtrl.text,
          controller.highRangeCatCtrl.text
        ]);
      }
    });

    controller.sellerFilter.value.filterType!.forEach((element) {
      if (element.filterTypeId == 'rating') {
        element.filterTypeValue!.clear();
        element.filterTypeValue!
            .add(controller.filterRating.value.toInt().toString());
      }
    });
    controller.filterPageNumber.value = 1;
    controller.sellerId.value = widget.sellerId!;

    controller.filterSortKey.value = 'new';

    widget.source!.isFilter = true;
    widget.source!.isSorted = true;
    widget.source!.refresh(true);
  }
}
