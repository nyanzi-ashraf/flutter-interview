import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/Brand/BrandData.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/SellerFilterModel.dart';
import 'package:amazcart/model/NewModel/Seller/SellerProfileModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SellerProfileController extends GetxController
    with SingleGetTickerProviderMixin {
  var isLoading = false.obs;

  var seller = SellerProfileModel().obs;

  var recentProductsList = <ProductModel>[].obs;

  var scaffoldKey = GlobalKey<ScaffoldState>().obs;

  var sellerId = 0.obs;

  final TextEditingController lowRangeCatCtrl = TextEditingController();
  final TextEditingController highRangeCatCtrl = TextEditingController();

  var filterPageNumber = 1.obs;
  var filterSortKey = 'new'.obs;
  var filterRating = 0.0.obs;

  var sellerFilter = SellerFilterModel().obs;
  var subCatFilter = FilterType(filterTypeId: 'cat', filterTypeValue: []).obs;
  var brandFilter = FilterType(filterTypeId: 'brand', filterTypeValue: []).obs;
  var attributeFilter = FilterType(filterTypeId: '', filterTypeValue: []).obs;

  var attFilters = <FilterType>[].obs;

  var selectedSubCat = <CategoryList>[].obs;

  var selectedBrand = <BrandData>[].obs;

  var sellerRating = 0.0.obs;

  Future fetchSellerProfile(id) async {
    try {
      Uri userData = Uri.parse(URLs.SELLER_PROFILE + '/$id');
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      return sellerProfileModelFromJson(response.body.toString());
    } catch (e) {
      print(e);
    }
    // return ProductDetailsModel();
  }

  Future getSellerProfile(id) async {
    try {
      isLoading(true);
      var data = await fetchSellerProfile(id);
      print(data);
      if (data != null) {
        seller.value = data;

        recentProductsList
            .addAll(seller.value.seller!.sellerProductsApi!.data!.reversed);

        sellerFilter.value = SellerFilterModel(
          filterType: [],
          sellerId: seller.value.seller!.id,
          sortBy: filterSortKey.value,
          paginate: 10,
          page: filterPageNumber.value,
        );

        if (seller.value.heightPrice != null &&
            seller.value.lowestPrice != null) {
          sellerFilter.value.filterType!.add(
              FilterType(filterTypeId: 'price_range', filterTypeValue: []));
        }

        sellerFilter.value.filterType!
            .add(FilterType(filterTypeId: 'rating', filterTypeValue: []));

        lowRangeCatCtrl.text = seller.value.lowestPrice == null
            ? 0.toString()
            : seller.value.lowestPrice.toString();
        highRangeCatCtrl.text = seller.value.heightPrice == null
            ? 0.toString()
            : seller.value.heightPrice.toString();

        var rating = 0.0;
        seller.value.seller!.sellerReviews!.forEach((element) {
          rating += element.rating;
        });
        sellerRating.value = rating;
      } else {
        seller.value = SellerProfileModel();
      }
    } catch (e) {
      isLoading(false);
    } finally {
      isLoading(false);
    }
  }

  TabController? tabController;

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Home Page'.tr),
    Tab(text: 'All Products'.tr),
    // Tab(text: 'Quiz'.tr),
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void onClose() {
    tabController!.dispose();
    super.onClose();
  }
}
