import 'dart:async';
import 'dart:convert';

import 'package:amazcart/config/config.dart';
// import 'package:amazcart/model/AllBrandModel.dart' as AllBrandModel;
import 'package:amazcart/model/NewModel/AllRecommendedModel.dart';
import 'package:amazcart/model/NewModel/FilterFromCatModel.dart';
import 'package:amazcart/model/NewModel/FlashDeals/FlashDealData.dart';
import 'package:amazcart/model/NewModel/FlashDeals/FlashDealDataElement.dart';
import 'package:amazcart/model/NewModel/FlashDeals/FlashDealModel.dart';
import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Brand/SingleBrandModel.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Category/ParentCategory.dart';
import 'package:amazcart/model/NewModel/Category/SingleCategory.dart';
import 'package:amazcart/model/NewModel/Filter/FilterAttributeValue.dart';
import 'package:amazcart/model/NewModel/Filter/FilterColor.dart';
import 'package:amazcart/model/NewModel/Product/AllProducts.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewUserZoneModel.dart' as NewUser;
import 'package:amazcart/model/SliderModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:amazcart/model/NewModel/Category/CategoryMain.dart';
import 'package:amazcart/model/NewModel/Brand/BrandsMain.dart';

class HomeController extends GetxController {
  ScrollController scrollController = ScrollController();

  Rx<bool> forceR = false.obs;

  Dio _dio = Dio();

  ///Category vars
  var allCategory = <CategoryData>[].obs;

  var allCategoryList = <CategoryData>[].obs;

  // ignore: deprecated_member_use
  var category = CategoryData().obs;
  var catAllData = SingleCategory().obs;
  var dataFilterCat = FilterFromCatModel().obs;
  var dataFilterBrand = FilterFromCatModel().obs;
  var filterTypeList = <FilterType>[].obs;

  var allProds = <ProductModel>[].obs;
  var isLoading = false.obs;
  var isProductsLoading = false.obs;
  var categoryTitle = "".obs;
  var categoryId = 0.obs;
  var categoryImage = "".obs;
  var lastPage = false.obs;
  var pageNumber = 1.obs;
  var isMoreLoading = false.obs;
  var categoryIdBeforeFilter = 0.obs;

  ///Brand vars
  // ignore: deprecated_member_use
  var allBrands = <BrandData>[].obs;

  var allBrandProducts = <ProductModel>[].obs;
  var isBrandsLoading = false.obs;
  var isBrandsProductsLoading = false.obs;
  var brandTitle = "".obs;
  var brandId = 0.obs;
  var brandImage = "".obs;
  var lastBrandPage = false.obs;
  var brandPageNumber = 1.obs;
  var isMoreBrandLoading = false.obs;

  ///Slider
  var isSliderLoading = false.obs;

  // ignore: deprecated_member_use
  var allSliders = <SliderData>[].obs;

  ///Flash Deals
  var isFlashDealsLoading = false.obs;

  // ignore: deprecated_member_use
  var flashDealData = <FlashDealDataElement>[].obs;

  // ignore: deprecated_member_use
  var flashProductData = <FlashDealDataElement>[].obs;
  var dealDuration = Duration().obs;
  var hasDeal = false.obs;
  var flashDeals = FlashDealData().obs;
  var isFlashDealProductsLoading = false.obs;
  var lastFlashDealPage = false.obs;
  var flashPageNumber = 1.obs;
  var flashDealTitle = "".obs;
  var flashDealImage = "".obs;
  var bgColor = 0.obs;
  var textColor = 0.obs;
  DateTime? flashDealEndDate;

  final TextEditingController lowRangeCatCtrl = TextEditingController();
  final TextEditingController highRangeCatCtrl = TextEditingController();

  final TextEditingController lowRangeBrandCtrl = TextEditingController();
  final TextEditingController highRangeBrandCtrl = TextEditingController();

  var brandAllData = SingleBrandModel().obs;

  Future<void> getAllCategory() async {
    try {
      isLoading(true);
      await _dio
          .get(
        URLs.TOP_CATEGORY,
      )
          .then((value) {
        CategoryMain dat =
            CategoryMain.fromJson(Map<String, dynamic>.from(value.data));
        allCategory.value = dat.data!
            .where((element) => element.parentId == 0)
            .take(7)
            .toList();
        print('ALL CAT LEN ${allCategory.length}');
      });
    } catch (e) {
      isLoading(false);
      print(e.toString());
    } finally {
      isLoading(false);
    }
  }

  var isAllCategoryLoading = false.obs;

  Future<void> getCategories() async {
    try {
      isAllCategoryLoading(true);
      await _dio
          .get(
        URLs.ALL_CATEGORY,
      )
          .then((value) {
        var data = new Map<String, dynamic>.from(value.data);
        return CategoryMain.fromJson(data);
      }).then((data) async {
        allCategoryList.value =
            data.data!.where((element) => element.parentId == 0).toList();

        print('ALL CT LEN ${allCategoryList.length}');

        await getSubCategories(categoryId: allCategoryList.first.id);
      });
    } catch (e) {
      isAllCategoryLoading(false);
      print(e.toString());
    } finally {
      isAllCategoryLoading(false);
    }
  }

  var isSubCategoryLoading = false.obs;
  var singleCat = SingleCategory().obs;

  Future<void> getSubCategories({int? categoryId}) async {
    try {
      isSubCategoryLoading(true);
      await _dio
          .get(
        URLs.ALL_CATEGORY + '/$categoryId',
      )
          .then((value) {
        print(value.realUri);
        var data = new Map<String, dynamic>.from(value.data);
        return SingleCategory.fromJson(data);
      }).then((value) async {
        singleCat.value = value;
      });
    } catch (e) {
      isSubCategoryLoading(false);
      print(e.toString());
    } finally {
      isSubCategoryLoading(false);
    }
  }

  var chunkedBrands = [].obs;

  Future<void> getAllBrand() async {
    try {
      isBrandsLoading(true);
      await _dio
          .get(
        URLs.ALL_BRAND,
      )
          .then((value) {
        var data = new Map<String, dynamic>.from(value.data);
        return BrandsMain.fromJson(data);
      }).then((value) async {
        allBrands.value = value.data;
        chunkedBrands.addAll(allBrands);
      });
    } catch (e) {
      isBrandsLoading(false);
      print(e.toString());
    } finally {
      isBrandsLoading(false);
    }
  }

  Future<void> getAllSlider() async {
    try {
      isSliderLoading(true);
      await _dio
          .get(
        URLs.ALL_SLIDERS,
      )
          .then((value) {
        var data = new Map<String, dynamic>.from(value.data);
        return SliderModel.fromJson(data);
      }).then((value) async {
        allSliders.value = value.sliderData!.take(8).toList();
      });
    } catch (e) {
      isSliderLoading(false);
      print(e.toString());
    } finally {
      isSliderLoading(false);
    }
  }

  Future<void> getFlashDeals() async {
    try {
      isFlashDealsLoading(true);
      await http.get(Uri.parse(URLs.FLASH_DEALS)).then((value) {
        if (value.statusCode == 200) {
          hasDeal.value = true;
          var jsonString = jsonDecode(value.body);
          return FlashDealModel.fromJson(jsonString);
        } else {
          hasDeal.value = false;
          return null;
        }
      }).catchError((onError) {
        print('ERROR ${onError.stackTrace}');
      }).then((value) async {
        if (value is FlashDealModel) {
          flashDealData.value =
              value.flashDeal!.allProducts!.data!.take(10).toList();
          int now = DateTime.now().millisecondsSinceEpoch;
          if (value.flashDeal!.startDate!.millisecondsSinceEpoch > now) {
            dealDuration.value = Duration(
                milliseconds:
                    value.flashDeal!.startDate!.millisecondsSinceEpoch - now);
            dealsText.value = 'Deal Starts in';
            print('Deal Starts in ${dealDuration.value}');
          } else if (value.flashDeal!.endDate!.millisecondsSinceEpoch < now) {
            dealDuration.value = Duration(milliseconds: 0);
            dealsText.value = 'Deal Ended';
            print('Deal Ended ${dealDuration.value}');
          } else {
            dealDuration.value = Duration(
                milliseconds:
                    value.flashDeal!.endDate!.millisecondsSinceEpoch - now);
            print('Deal Ends in ${dealDuration.value}');
            dealsText.value = 'Deal Ends in';
          }
        }
      });
    } catch (e) {
      isFlashDealsLoading(false);
      print(e.toString());
    } finally {
      isFlashDealsLoading(false);
    }
  }

  var isNewUserZoneLoading = false.obs;
  var hasNewUserZone = false.obs;
  var newUserZoneProducts = <NewUser.NewUserZoneDatum>[].obs;
  var newUserZoneCoupon = NewUser.NewUserZoneCoupon().obs;

  Future<void> getNewUserZone() async {
    try {
      isNewUserZoneLoading(true);
      await _dio
          .get(
        URLs.NEW_USER_ZONE,
      )
          .then((value) {
        if (value.statusCode == 200) {
          hasNewUserZone.value = true;

          // var jsonString = jsonDecode(value.data);
          var data = new Map<String, dynamic>.from(value.data);
          return NewUser.NewUserZoneModel.fromJson(data);
        } else {
          hasNewUserZone.value = false;
          return null;
        }
      }).catchError((onError) {
        print('ERROR ${onError.stackTrace}');
      }).then((value) async {
        if (value is NewUser.NewUserZoneModel) {
          newUserZoneProducts.value =
              value.newUserZone!.allProducts!.data!.take(2).toList();
          newUserZoneCoupon.value = value.newUserZone!.coupon!;
        }
      });
    } catch (e) {
      isNewUserZoneLoading(false);
      print(e.toString());
    } finally {
      isNewUserZoneLoading(false);
    }
  }

  var subCats = <ParentCategory>[].obs;

  var subCatsInBrands = <CategoryData>[].obs;

  var subCatFilter = FilterType(filterTypeId: 'cat', filterTypeValue: []).obs;
  var brandFilter = FilterType(filterTypeId: 'brand', filterTypeValue: []).obs;
  var attributeFilter = FilterType(filterTypeId: '', filterTypeValue: []).obs;

  var attFilters = <FilterType>[].obs;

  var selectedSubCat = <ParentCategory>[].obs;

  var selectedBrands = <BrandData>[].obs;
  var filterPageNumber = 1.obs;
  var filterSortKey = 'new'.obs;
  var filterRating = 0.0.obs;

  List<FilterAttributeValue> selectedAttribute = [];

  List<FilterColorValue> selectedColorValue = [];

  var selectedBrandCat = <CategoryData>[].obs;
  List<FilterAttributeValue> selectedBrandAttribute = [];
  List<FilterColorValue> selectedBrandColorValue = [];

  Future addFilterAttribute(
      {FilterAttributeValue? value,
      typeId,
      bool? isColor,
      FilterColorValue? colorValue}) async {
    if (isColor!) {
      final addAttributeData =
          dataFilterCat.value.filterDataFromCat!.filterType!.firstWhere(
              (element) => element.filterTypeId.toString() == typeId.toString(),
              orElse: addIfNoAttribute(
                  isColor: true, colorValue: colorValue!, typeId: typeId));
      addAttributeData.filterTypeValue!.add(colorValue.id.toString());
    } else {
      final addAttributeData =
          dataFilterCat.value.filterDataFromCat!.filterType!.firstWhere(
              (element) => element.filterTypeId.toString() == typeId.toString(),
              orElse: addIfNoAttribute(
                  value: value!, typeId: typeId, isColor: false));
      addAttributeData.filterTypeValue!.add(value.id.toString());
    }

    print('ADD ${dataFilterCat.value.toJson()}');
  }

  addIfNoAttribute(
      {FilterAttributeValue? value,
      typeId,
      FilterColorValue? colorValue,
      bool? isColor}) {
    dataFilterCat.value.filterDataFromCat!.filterType!
        .add(FilterType(filterTypeId: typeId.toString(), filterTypeValue: []));
  }

  Future removeFilterAttribute(
      {FilterAttributeValue? value,
      typeId,
      bool? isColor,
      FilterColorValue? colorValue}) async {
    if (isColor!) {
      dataFilterCat.value.filterDataFromCat!.filterType!.forEach((element) {
        if (element.filterTypeId == typeId.toString()) {
          element.filterTypeValue!.remove(colorValue!.id.toString());
        }
      });
    } else {
      dataFilterCat.value.filterDataFromCat!.filterType!.forEach((element) {
        if (element.filterTypeId == typeId.toString()) {
          element.filterTypeValue!.remove(value!.id.toString());
        }
      });
    }

    print('REMOVE ${dataFilterCat.value.toJson()}');
  }

  Future<List<ProductModel>> getCategoryProducts() async {
    CategoryData parentCategoryElement = CategoryData();
    try {
      isProductsLoading(true);
      isMoreLoading(true);
      await _dio.get(URLs.ALL_CATEGORY + '/$categoryId', queryParameters: {
        'page': pageNumber,
      }).then((value) {
        print('URL: ${value.realUri}');
        final data = new Map<String, dynamic>.from(value.data);
        catAllData.value = SingleCategory.fromJson(value.data);

        print('catAllData.value ${catAllData.value}');

        print(
            'catAllData.value len  ${catAllData.value.data!.allProducts!.data!.length}');

        print('Cat ID ${categoryId.value.toString()}');

        dataFilterCat.value = FilterFromCatModel(
          filterDataFromCat: FilterDataFromCat(
            requestItem: categoryId.value.toString(),
            requestItemType: 'category',
            filterType: [],
          ),
          requestItemType: 'category',
          requestItem: categoryId.value.toString(),
          sortBy: filterSortKey.value.toString(),
          page: filterPageNumber.value.toString(),
        );

        if (catAllData.value.attributes!.length > 0) {
          catAllData.value.attributes!.forEach((element) {
            dataFilterCat.value.filterDataFromCat!.filterType!.add(FilterType(
                filterTypeId: element.id.toString(), filterTypeValue: []));
          });
        }

        if (catAllData.value.brands!.length > 0) {
          dataFilterCat.value.filterDataFromCat!.filterType!
              .add(FilterType(filterTypeId: 'brand', filterTypeValue: []));
        }
        if (catAllData.value.data!.subCategories!.length > 0) {
          dataFilterCat.value.filterDataFromCat!.filterType!
              .add(FilterType(filterTypeId: 'cat', filterTypeValue: []));
        }

        if (catAllData.value.heightPrice != null &&
            catAllData.value.lowestPrice != null) {
          dataFilterCat.value.filterDataFromCat!.filterType!.add(
              FilterType(filterTypeId: 'price_range', filterTypeValue: []));
        }

        dataFilterCat.value.filterDataFromCat!.filterType!
            .add(FilterType(filterTypeId: 'rating', filterTypeValue: []));

        lowRangeCatCtrl.text = catAllData.value.lowestPrice == null
            ? 0.toString()
            : catAllData.value.lowestPrice.toString();
        highRangeCatCtrl.text = catAllData.value.heightPrice == null
            ? 0.toString()
            : catAllData.value.heightPrice.toString();

        parentCategoryElement = CategoryData.fromJson(data['data']);
        category.value = parentCategoryElement;
        categoryTitle.value = parentCategoryElement.name!;
        categoryId.value = parentCategoryElement.id!;
        categoryImage.value = parentCategoryElement.categoryImage!.image!;
        if (parentCategoryElement.allProducts!.data!.length == 0) {
          isMoreLoading(false);
          lastPage(true);
        } else {
          isMoreLoading(true);
          allProds.addAll(parentCategoryElement.allProducts!.data!);
        }
        if (parentCategoryElement.subCategories!.length == 0) {
          isMoreLoading(false);
          lastPage(true);
        } else {
          isMoreLoading(true);
        }
      });
    } catch (e) {
      isProductsLoading(false);
      print(e.toString());
    } finally {
      isProductsLoading(false);
      isMoreLoading(false);
    }
    return allProds;
  }

  Future<SingleCategory> getCategoryFilterData() async {
    try {
      // isProductsLoading(true);
      // isMoreLoading(true);
      await _dio.get(URLs.ALL_CATEGORY + '/$categoryId', queryParameters: {
        'page': pageNumber,
      }).then((value) {
        print('URL: ${value.realUri.queryParameters}');
        print('URL: ${value.realUri}');
        catAllData.value = SingleCategory.fromJson(value.data);

        print('Filter Cat ID ${categoryId.value.toString()}');

        catAllData.value.data!.subCategories!.forEach((element) {
          subCats.add(element);
          element.subCategories!.forEach((element2) {
            subCats.add(element2);
          });
        });
      });
    } catch (e) {
      // isProductsLoading(false);
      print(e.toString());
    } finally {
      // isProductsLoading(false);
      // isMoreLoading(false);
    }
    return catAllData.value;
  }

  /// -----------------
  /// ----- BRAND -----
  /// -----------------

  Future<List<ProductModel>> getBrandProducts() async {
    BrandData allBrandModelDatum = BrandData();
    try {
      isBrandsProductsLoading(true);
      isMoreBrandLoading(true);
      await _dio.get(URLs.ALL_BRAND + '/$brandId', queryParameters: {
        'page': brandPageNumber,
      }).then((value) {
        print('Brand Query: ${value.realUri}');
        final data = new Map<String, dynamic>.from(value.data);

        brandAllData.value = SingleBrandModel.fromJson(value.data);

        print('Brand ID ${brandId.value.toString()}');

        dataFilterCat.value = FilterFromCatModel(
          filterDataFromCat: FilterDataFromCat(
            requestItem: brandId.value.toString(),
            requestItemType: 'brand',
            filterType: [],
          ),
          requestItemType: 'brand',
          requestItem: brandId.value.toString(),
          sortBy: filterSortKey.value.toString(),
          page: filterPageNumber.value.toString(),
        );

        if (brandAllData.value.attributes != null &&
            brandAllData.value.attributes!.length > 0) {
          brandAllData.value.attributes!.forEach((element) {
            dataFilterCat.value.filterDataFromCat!.filterType!.add(FilterType(
                filterTypeId: element.id.toString(), filterTypeValue: []));
          });
        }

        if (brandAllData.value.categories != null &&
            brandAllData.value.categories!.length > 0) {
          dataFilterCat.value.filterDataFromCat!.filterType!
              .add(FilterType(filterTypeId: 'cat', filterTypeValue: []));
        }

        if (brandAllData.value.heightPrice != null &&
            brandAllData.value.lowestPrice != null) {
          dataFilterCat.value.filterDataFromCat!.filterType!.add(
              FilterType(filterTypeId: 'price_range', filterTypeValue: []));
        }

        dataFilterCat.value.filterDataFromCat!.filterType!
            .add(FilterType(filterTypeId: 'rating', filterTypeValue: []));

        lowRangeBrandCtrl.text = brandAllData.value.lowestPrice == null
            ? 0.toString()
            : brandAllData.value.lowestPrice.toString();
        highRangeBrandCtrl.text = brandAllData.value.heightPrice == null
            ? 0.toString()
            : brandAllData.value.heightPrice.toString();

        allBrandModelDatum = BrandData.fromJson(data['data']);
        print(allBrandModelDatum);
        brandTitle.value = allBrandModelDatum.name!;
        brandId.value = allBrandModelDatum.id!;
        brandImage.value = allBrandModelDatum.logo!;
        if (allBrandModelDatum.allProducts!.data!.length == 0) {
          isMoreBrandLoading(false);
          lastBrandPage(true);
        } else {
          isMoreBrandLoading(true);
          allBrandProducts.addAll(allBrandModelDatum.allProducts!.data!);
        }
      });
    } catch (e) {
      isBrandsProductsLoading(false);
      print(e.toString());
    } finally {
      isBrandsProductsLoading(false);
      isMoreBrandLoading(false);
    }
    return allBrandProducts;
  }

  Future<SingleBrandModel> getBrandFilterData() async {
    try {
      await _dio.get(URLs.ALL_BRAND + '/$brandId', queryParameters: {
        'page': brandPageNumber,
      }).then((value) {
        print('URL: ${value.realUri.queryParameters}');
        brandAllData.value = SingleBrandModel.fromJson(value.data);

        print('Filter Brand ID ${brandId.value.toString()}');

        if (brandAllData.value.categories!.length != 0) {
          brandAllData.value.categories!.forEach((element) {
            subCatsInBrands.add(element);
          });
        }
      });
    } catch (e) {
      // isProductsLoading(false);
      print(e.toString());
    } finally {
      // isProductsLoading(false);
      // isMoreLoading(false);
    }
    return brandAllData.value;
  }

  Future<List<ProductModel>> filterBrandProducts() async {
    // print(filterFromCatModelToJson(dataFilter.value));

    dataFilterCat.value.filterDataFromCat!.filterType!.removeWhere((element) =>
        element.filterTypeValue!.length == 0 && element.filterTypeId != 'cat');

    dataFilterCat.value.page = filterPageNumber.value.toString();

    dataFilterCat.value.sortBy = filterSortKey.value.toString();

    print(filterFromCatModelToJson(dataFilterCat.value));

    print(URLs.FILTER_ALL_PRODUCTS);
    AllProducts parentCategoryElement = AllProducts();
    try {
      isBrandsProductsLoading(true);
      isMoreBrandLoading(true);
      await _dio
          .post(URLs.FILTER_ALL_PRODUCTS,
              data: filterFromCatModelToJson(dataFilterCat.value))
          .then((value) {
        parentCategoryElement = AllProducts.fromJson(value.data);
        print(parentCategoryElement.data!.length);

        if (parentCategoryElement.data!.length == 0) {
          isMoreBrandLoading(false);
          lastBrandPage(true);
        } else {
          isMoreBrandLoading(true);
          allBrandProducts.addAll(parentCategoryElement.data!);
        }
      });
    } catch (e) {
      isBrandsProductsLoading(false);
      print(e.toString());
    } finally {
      isBrandsProductsLoading(false);
      isMoreBrandLoading(false);
    }
    return allBrandProducts;
  }

  Future addBrandFilterAttribute(
      {FilterAttributeValue? value,
      typeId,
      bool? isColor,
      FilterColorValue? colorValue}) async {
    if (isColor!) {
      final addAttributeData =
          dataFilterCat.value.filterDataFromCat!.filterType!.firstWhere(
              (element) => element.filterTypeId.toString() == typeId.toString(),
              orElse: addIfNoBrandAttribute(
                  isColor: true, colorValue: colorValue!, typeId: typeId));
      addAttributeData.filterTypeValue!.add(colorValue.id.toString());
    } else {
      final addAttributeData =
          dataFilterCat.value.filterDataFromCat!.filterType!.firstWhere(
              (element) => element.filterTypeId.toString() == typeId.toString(),
              orElse: addIfNoBrandAttribute(
                  value: value!, typeId: typeId, isColor: false));
      addAttributeData.filterTypeValue!.add(value.id.toString());
    }

    print('ADD ${dataFilterCat.value.toJson()}');
  }

  addIfNoBrandAttribute(
      {FilterAttributeValue? value,
      typeId,
      FilterColorValue? colorValue,
      bool? isColor}) {
    dataFilterCat.value.filterDataFromCat!.filterType!
        .add(FilterType(filterTypeId: typeId.toString(), filterTypeValue: []));
  }

  Future removeBrandFilterAttribute(
      {FilterAttributeValue? value,
      typeId,
      bool? isColor,
      FilterColorValue? colorValue}) async {
    if (isColor!) {
      dataFilterCat.value.filterDataFromCat!.filterType!.forEach((element) {
        if (element.filterTypeId == typeId.toString()) {
          element.filterTypeValue!.remove(colorValue!.id.toString());
        }
      });
    } else {
      dataFilterCat.value.filterDataFromCat!.filterType!.forEach((element) {
        if (element.filterTypeId == typeId.toString()) {
          element.filterTypeValue!.remove(value!.id.toString());
        }
      });
    }

    print('REMOVE ${dataFilterCat.value.toJson()}');
  }

  var dealsText = ''.obs;
  var isFlashDealMoreProductLoading = false.obs;

  Future<List<FlashDealDataElement>> getFlashDealsData() async {
    FlashDealData flashDeals = FlashDealData();
    try {
      isFlashDealProductsLoading(true);
      isFlashDealMoreProductLoading(true);
      await _dio.get(URLs.FLASH_DEALS, queryParameters: {
        'page': flashPageNumber,
      }).then((value) async {
        print('Flash Query: ${value.realUri.queryParameters}');

        final data = new Map<String, dynamic>.from(value.data);
        flashDeals = FlashDealData.fromJson(data['flash_deal']);
        flashDealTitle.value = flashDeals.title!;
        flashDealImage.value = flashDeals.bannerImage!;

        int now = DateTime.now().millisecondsSinceEpoch;
        if (flashDeals.startDate!.millisecondsSinceEpoch > now) {
          dealDuration.value = Duration(
              milliseconds: flashDeals.startDate!.millisecondsSinceEpoch - now);
          dealsText.value = 'Deal Starts in';
          print('Deal Starts in ${dealDuration.value}');
        } else if (flashDeals.endDate!.millisecondsSinceEpoch < now) {
          dealDuration.value = Duration(milliseconds: 0);
          dealsText.value = 'Deal Ended';
          print('Deal Ended ${dealDuration.value}');
        } else {
          dealDuration.value = Duration(
              milliseconds: flashDeals.endDate!.millisecondsSinceEpoch - now);
          // if (!dealDuration.value.isNegative) {
          //   dealDuration.value = Duration(
          //       milliseconds: flashDeals.endDate.millisecondsSinceEpoch - now);
          // } else {
          //
          //   dealDuration.value = Duration(milliseconds: 0);
          // }
          print('Deal Ends in ${dealDuration.value}');
          dealsText.value = 'Deal Ends in';
        }

        if (flashDeals.backgroundColor == "white") {
          bgColor.value = 0xffFFFFFF;
        } else if (flashDeals.backgroundColor == "black") {
          bgColor.value = 0xff000000;
        } else {
          bgColor.value = getBGColor(flashDeals.backgroundColor!);
        }
        if (flashDeals.textColor == "white") {
          textColor.value = 0xffFFFFFF;
        } else if (flashDeals.textColor == "black") {
          textColor.value = 0xff000000;
        } else {
          textColor.value = getBGColor(flashDeals.textColor!);
        }

        if (flashDeals.allProducts!.data!.length == 0) {
          isFlashDealMoreProductLoading(false);
          lastFlashDealPage(true);
        } else {
          isFlashDealMoreProductLoading(true);
          flashProductData.addAll(flashDeals.allProducts!.data!);
        }
      });
    } catch (e) {
      isFlashDealProductsLoading(false);
      print(e.toString());
    } finally {
      isFlashDealProductsLoading(false);
      isFlashDealMoreProductLoading(false);
    }
    return flashProductData;
  }

  var isRecommendedLoading = false.obs;
  var isMoreRecommendedLoading = false.obs;
  var recommendedPageNumber = 1.obs;
  var recommendedLastPage = false.obs;
  var allRecommendedProds = <ProductModel>[].obs;

  Future<List<ProductModel>> getRecommendedProducts() async {
    AllRecommendedModel parentCategoryElement = AllRecommendedModel();
    try {
      isRecommendedLoading(true);
      isMoreRecommendedLoading(true);
      await _dio.get(URLs.ALL_RECOMMENDED, queryParameters: {
        'page': recommendedPageNumber,
      }).then((value) {
        final data = new Map<String, dynamic>.from(value.data);
        parentCategoryElement = AllRecommendedModel.fromJson(data);
        if (parentCategoryElement.data!.length == 0) {
          isMoreRecommendedLoading(false);
          recommendedLastPage(true);
        } else {
          isMoreRecommendedLoading(true);
          allRecommendedProds.addAll(parentCategoryElement.data!);
        }
      }).catchError((error) {
        if (error is DioError) {
          print(error.response);
        }
        isMoreRecommendedLoading(false);
        recommendedLastPage(true);
        print('ERROR is $error');
      });
    } catch (e) {
      isRecommendedLoading(false);
      print(e.toString());
    } finally {
      isRecommendedLoading(false);
      isMoreRecommendedLoading(false);
    }
    return allRecommendedProds;
  }

  var isTopPicksLoading = false.obs;
  var isMoreTopPicksLoading = false.obs;
  var topPicksPageNumber = 1.obs;
  var topPicksLastPage = false.obs;
  var allTopPicksProds = <ProductModel>[].obs;

  Future<List<ProductModel>> getTopPicksProducts() async {
    AllRecommendedModel parentCategoryElement = AllRecommendedModel();
    try {
      isTopPicksLoading(true);
      isMoreTopPicksLoading(true);
      await _dio.get(URLs.ALL_TOP_PICKS, queryParameters: {
        'page': topPicksPageNumber,
      }).then((value) {
        final data = new Map<String, dynamic>.from(value.data);
        parentCategoryElement = AllRecommendedModel.fromJson(data);
        if (parentCategoryElement.data!.length == 0) {
          isMoreTopPicksLoading(false);
          topPicksLastPage(true);
        } else {
          isMoreTopPicksLoading(true);
          allTopPicksProds.addAll(parentCategoryElement.data!);
        }
        print(allTopPicksProds.length);
      }).catchError((error) {
        if (error is DioError) {
          print(error.response);
        }
        isMoreTopPicksLoading(false);
        topPicksLastPage(true);
        print('ERROR is $error');
      });
    } catch (e) {
      isTopPicksLoading(false);
      print(e.toString());
    } finally {
      isTopPicksLoading(false);
      isMoreTopPicksLoading(false);
    }
    return allTopPicksProds;
  }

  int getBGColor(String color) {
    String col = color.replaceAll("#", "");
    String bg = "0xff$col";
    return int.parse(bg);
  }

  colourNameToHex(colour) {
    Map<String, dynamic> colours = {
      "aliceblue": 0xfff0f8ff,
      "antiquewhite": 0xfffaebd7,
      "aqua": 0xff00ffff,
      "aquamarine": 0xff7fffd4,
      "azure": 0xfff0ffff,
      "beige": 0xfff5f5dc,
      "bisque": 0xffffe4c4,
      "black": 0xff000000,
      "blanchedalmond": 0xffffebcd,
      "blue": 0xff0000ff,
      "blueviolet": 0xff8a2be2,
      "brown": 0xffa52a2a,
      "burlywood": 0xffdeb887,
      "cadetblue": 0xff5f9ea0,
      "chartreuse": 0xff7fff00,
      "chocolate": 0xffd2691e,
      "coral": 0xffff7f50,
      "cornflowerblue": 0xff6495ed,
      "cornsilk": 0xfffff8dc,
      "crimson": 0xffdc143c,
      "cyan": 0xff00ffff,
      "darkblue": 0xff00008b,
      "darkcyan": 0xff008b8b,
      "darkgoldenrod": 0xffb8860b,
      "darkgray": 0xffa9a9a9,
      "darkgreen": 0xff006400,
      "darkkhaki": 0xffbdb76b,
      "darkmagenta": 0xff8b008b,
      "darkolivegreen": 0xff556b2f,
      "darkorange": 0xffff8c00,
      "darkorchid": 0xff9932cc,
      "darkred": 0xff8b0000,
      "darksalmon": 0xffe9967a,
      "darkseagreen": 0xff8fbc8f,
      "darkslateblue": 0xff483d8b,
      "darkslategray": 0xff2f4f4f,
      "darkturquoise": 0xff00ced1,
      "darkviolet": 0xff9400d3,
      "deeppink": 0xffff1493,
      "deepskyblue": 0xff00bfff,
      "dimgray": 0xff696969,
      "dodgerblue": 0xff1e90ff,
      "firebrick": 0xffb22222,
      "floralwhite": 0xfffffaf0,
      "forestgreen": 0xff228b22,
      "fuchsia": 0xffff00ff,
      "gainsboro": 0xffdcdcdc,
      "ghostwhite": 0xfff8f8ff,
      "gold": 0xffffd700,
      "goldenrod": 0xffdaa520,
      "gray": 0xff808080,
      "green": 0xff008000,
      "greenyellow": 0xffadff2f,
      "honeydew": 0xfff0fff0,
      "hotpink": 0xffff69b4,
      "indianred ": 0xffcd5c5c,
      "indigo": 0xff4b0082,
      "ivory": 0xfffffff0,
      "khaki": 0xfff0e68c,
      "lavender": 0xffe6e6fa,
      "lavenderblush": 0xfffff0f5,
      "lawngreen": 0xff7cfc00,
      "lemonchiffon": 0xfffffacd,
      "lightblue": 0xffadd8e6,
      "lightcoral": 0xfff08080,
      "lightcyan": 0xffe0ffff,
      "lightgoldenrodyellow": 0xfffafad2,
      "lightgrey": 0xffd3d3d3,
      "lightgreen": 0xff90ee90,
      "lightpink": 0xffffb6c1,
      "lightsalmon": 0xffffa07a,
      "lightseagreen": 0xff20b2aa,
      "lightskyblue": 0xff87cefa,
      "lightslategray": 0xff778899,
      "lightsteelblue": 0xffb0c4de,
      "lightyellow": 0xffffffe0,
      "lime": 0xff00ff00,
      "limegreen": 0xff32cd32,
      "linen": 0xfffaf0e6,
      "magenta": 0xffff00ff,
      "maroon": 0xff800000,
      "mediumaquamarine": 0xff66cdaa,
      "mediumblue": 0xff0000cd,
      "mediumorchid": 0xffba55d3,
      "mediumpurple": 0xff9370d8,
      "mediumseagreen": 0xff3cb371,
      "mediumslateblue": 0xff7b68ee,
      "mediumspringgreen": 0xff00fa9a,
      "mediumturquoise": 0xff48d1cc,
      "mediumvioletred": 0xffc71585,
      "midnightblue": 0xff191970,
      "mintcream": 0xfff5fffa,
      "mistyrose": 0xffffe4e1,
      "moccasin": 0xffffe4b5,
      "navajowhite": 0xffffdead,
      "navy": 0xff000080,
      "oldlace": 0xfffdf5e6,
      "olive": 0xff808000,
      "olivedrab": 0xff6b8e23,
      "orange": 0xffffa500,
      "orangered": 0xffff4500,
      "orchid": 0xffda70d6,
      "palegoldenrod": 0xffeee8aa,
      "palegreen": 0xff98fb98,
      "paleturquoise": 0xffafeeee,
      "palevioletred": 0xffd87093,
      "papayawhip": 0xffffefd5,
      "peachpuff": 0xffffdab9,
      "peru": 0xffcd853f,
      "pink": 0xffffc0cb,
      "plum": 0xffdda0dd,
      "powderblue": 0xffb0e0e6,
      "purple": 0xff800080,
      "rebeccapurple": 0xff663399,
      "red": 0xffff0000,
      "rosybrown": 0xffbc8f8f,
      "royalblue": 0xff4169e1,
      "saddlebrown": 0xff8b4513,
      "salmon": 0xfffa8072,
      "sandybrown": 0xfff4a460,
      "seagreen": 0xff2e8b57,
      "seashell": 0xfffff5ee,
      "sienna": 0xffa0522d,
      "silver": 0xffc0c0c0,
      "skyblue": 0xff87ceeb,
      "slateblue": 0xff6a5acd,
      "slategray": 0xff708090,
      "snow": 0xfffffafa,
      "springgreen": 0xff00ff7f,
      "steelblue": 0xff4682b4,
      "tan": 0xffd2b48c,
      "teal": 0xff008080,
      "thistle": 0xffd8bfd8,
      "tomato": 0xffff6347,
      "turquoise": 0xff40e0d0,
      "violet": 0xffee82ee,
      "wheat": 0xfff5deb3,
      "white": 0xffffffff,
      "whitesmoke": 0xfff5f5f5,
      "yellow": 0xffffff00,
      "yellowgreen": 0xff9acd32
    };

    return colours[colour];
  }

  @override
  void onInit() {
    getAllSlider();
    getAllCategory();
    getNewUserZone();
    getFlashDeals();
    getAllBrand();
    getTopPicksProducts();
    forceR.value = false;
    // getAllSlider().then((value) async {
    //   await getAllCategory().then((value) async {
    //     await getNewUserZone().then((value) async {
    //       await getFlashDeals().then((value) async {
    //         await getAllBrand().then((value) async {
    //           await getTopPicksProducts();
    //         });
    //       });
    //     });
    //   });
    // });
    super.onInit();
  }
}
