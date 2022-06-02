import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/login_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/model/NewModel/Category/CategoryData.dart';
import 'package:amazcart/model/NewModel/Category/SingleCategory.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductDetailsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/ProductVariantDetail.dart';
import 'package:amazcart/model/NewModel/Product/Review.dart';
import 'package:amazcart/model/NewModel/Product/SellerSkuModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/MainNavigation.dart';
import 'package:amazcart/view/SearchPageMain.dart';
import 'package:amazcart/view/account/Account.dart';
import 'package:amazcart/view/account/SignInOrRegister.dart';
import 'package:amazcart/view/authentication/LoginPage.dart';
import 'package:amazcart/view/cart/AddToCartWidget.dart';
import 'package:amazcart/view/cart/CartMain.dart';
import 'package:amazcart/view/products/RecommendedProductLoadMore.dart';
import 'package:amazcart/view/products/tags/ProductsByTags.dart';
import 'package:amazcart/view/seller/StoreHome.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:amazcart/widgets/HorizontalProductWidget.dart';
import 'package:amazcart/widgets/SliverAppBarTitleWidget.dart';
import 'package:amazcart/widgets/StarCounterWidget.dart';
import 'package:amazcart/widgets/custom_clipper.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/flutter_swiper/flutter_swiper.dart';
import 'package:expandable/expandable.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extend;
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:amazcart/view/products/RatingsAndReviews.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:amazcart/widgets/snackbars.dart';

import '../category/ProductsByCategory.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter_html/flutter_html.dart';

// ignore: must_be_immutable
class ProductDetails extends StatefulWidget {
  final int? productID;

  ProductDetails({this.productID});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  // final ProductDetailsController controller =
  // Get.put(ProductDetailsController());

  final CartController cartController = Get.put(CartController());

  final HomeController homeController = Get.put(HomeController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final LoginController _loginController = Get.put(LoginController());

  String popUpItem1 = "Home";

  String popUpItem2 = "Share";

  String popUpItem3 = "Search";

  var shippingValue;

  Future<ProductDetailsModel>? productFuture;

  bool _inWishList = false;
  int? _wishListId;

  var split;
  DateTime? endDate;

  String getDiscountType(ProductModel productModel) {
    String discountType;

    if (productModel.hasDiscount == "yes") {
      if (productModel.hasDeal != null) {
        if (productModel.hasDeal!.discountType == 0) {
          discountType =
              '(-${productModel.hasDeal!.discount!.toStringAsFixed(2)}%)';
        } else {
          discountType =
              '(-${currencyController.appCurrency.value}${(productModel.hasDeal!.discount! * currencyController.conversionRate.value).toStringAsFixed(2)})';
        }
      } else {
        if (productModel.discount! > 0) {
          if (productModel.discountType == '0') {
            discountType = '(-${productModel.discount!.toStringAsFixed(2)}%)';
          } else {
            discountType =
                '(-${(productModel.discount! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value})';
          }
        } else {
          discountType = '';
        }
      }
    } else {
      discountType = '';
    }

    return discountType;
  }

  RecommendedProductsLoadMore? source;

  @override
  void initState() {
    productFuture = fetchProductDetails(widget.productID);
    source = RecommendedProductsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();
    // Get.delete<ProductDetailsController>();

    super.dispose();
  }

  ProductDetailsModel _productDetailsModel = ProductDetailsModel();

  List<Review> productReviews = [];

  int stockManage = 0;
  int stockCount = 0;

  Future<ProductDetailsModel> fetchProductDetails(id) async {
    try {
      print(widget.productID);
      Uri url = Uri.parse(URLs.ALL_PRODUCTS + '/$id');
      print(url);
      var response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      print("Status Code => ${response.statusCode}");
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] != 'not found') {
        _productDetailsModel = ProductDetailsModel.fromJson(jsonString);
        shippingValue =
            _productDetailsModel!.data!.product!.shippingMethods!.first;

        productReviews = _productDetailsModel!.data!.reviews!
            .where((element) => element.type == ProductType.PRODUCT)
            .toList();

        await checkWishList();

        if (_productDetailsModel!.data!.variantDetails!.length > 0) {
          await skuGet();
        } else {
          setState(() {
            stockManage =
                int.parse(_productDetailsModel!.data!.stockManage.toString());
            stockCount = int.parse(_productDetailsModel!
                .data!.skus!.first.productStock
                .toString());
          });

          print('StockMAnage $stockManage');
          print('stockCount $stockCount');
        }
        return _productDetailsModel;
      } else {
        Get.back();
        SnackBars().snackBarWarning('not found');
      }
    } catch (e) {
      print(e);
    }
    return ProductDetailsModel();
  }

  Future checkWishList() async {
    if (!_loginController.loggedIn.value) {
      return;
    } else {
      final MyWishListController _myWishListController =
          Get.put(MyWishListController());
      await _myWishListController.getAllWishList();
      _myWishListController.wishListModel.value.products!.values
          .forEach((element) {
        element.forEach((element2) {
          if (element2.product!.id == widget.productID) {
            setState(() {
              _inWishList = true;
              _wishListId = element2.id;
            });
          }
        });
      });
    }
  }

  Map getSKU = {};

  Future skuGet() async {
    for (var i = 0;
        i < _productDetailsModel!.data!.variantDetails!.length;
        i++) {
      getSKU.addAll({
        'id[$i]':
            "${_productDetailsModel!.data!.variantDetails![i].attrValId!.first}-${_productDetailsModel!.data!.variantDetails![i].attrId}"
      });
    }
    getSKU.addAll({
      'product_id': _productDetailsModel!.data!.id,
      'user_id': _productDetailsModel!.data!.userId
    });
    print("SKU PRICE GET ${getSKU.toString()}");
    await getSkuWisePrice(getSKU);
  }

  Future getSkuWisePrice(Map data) async {
    print(jsonEncode(data));
    try {
      DIO.Response response;
      DIO.Dio dio = new DIO.Dio();
      var formData = DIO.FormData();
      data.forEach((k, v) {
        formData.fields.add(MapEntry(k, v.toString()));
      });
      response = await dio.post(
        URLs.PRODUCT_PRICE_SKU_WISE,
        options: DIO.Options(
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'multipart/form-data',
          },
        ),
        data: formData,
      );
      if (response.data == "0") {
        SnackBars().snackBarWarning('Product not available');
      } else {
        final returnData = new Map<String, dynamic>.from(response.data);

        SkuData productSKU = SkuData.fromJson(returnData['data']);

        setState(() {
          stockManage = _productDetailsModel!.data!.stockManage;
          stockCount = productSKU.productStock;
        });
      }
    } catch (e) {
      print(e.toString());
    } finally {}
  }

  void openCategory(dynamic category) {
    final HomeController controller = Get.put(HomeController());
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

    Get.to(() => ProductsByCategory(
          categoryId: category.id,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var pinnedHeaderHeight = statusBarHeight + kToolbarHeight;

    return FutureBuilder<ProductDetailsModel>(
        future: productFuture,
        builder: (context, snapshot) {
          print(snapshot.connectionState);
          if (snapshot.connectionState == ConnectionState.done) {
            print(snapshot.data);
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  '${snapshot.error} occured',
                  style: TextStyle(fontSize: 18),
                ),
              );

              // if we got our data
            } else if (snapshot.hasData) {
              return Scaffold(
                backgroundColor: AppStyles.appBackgroundColor,
                body: NestedScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 250.0,
                        pinned: true,
                        collapsedHeight: 70,
                        stretch: false,
                        forceElevated: false,
                        titleSpacing: 0,
                        backgroundColor: Colors.white,
                        automaticallyImplyLeading: false,
                        title: SliverAppBarTitleWidget(
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 10, top: 2),
                                child: IconButton(
                                  tooltip: "Back",
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    _productDetailsModel!.data!.productName!,
                                    maxLines: 1,
                                    style: AppStyles.kFontBlack17w5
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  Positioned(
                                    child: IconButton(
                                      tooltip: "Cart",
                                      onPressed: () {
                                        Get.to(() => CartMain(false));
                                      },
                                      icon: Container(
                                        width: 45,
                                        alignment: Alignment.center,
                                        child: Image.asset(
                                          'assets/images/icon_cart_white.png',
                                          width: 35,
                                          height: 35,
                                          color: AppStyles.blackColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: AppStyles.pinkColor,
                                          shape: BoxShape.circle,
                                        ),
                                        alignment: Alignment.center,
                                        child: Obx(() {
                                          return Text(
                                            '${cartController.cartListSelectedCount.value}',
                                            textAlign: TextAlign.center,
                                            style: AppStyles.kFontWhite12w5,
                                          );
                                        }),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 10),
                                child: PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.black,
                                      size: 30,
                                    ),
                                    padding: EdgeInsets.zero,
                                    onSelected: (value) {
                                      if (value == "Home") {
                                        Get.offAll(MainNavigation(
                                          navIndex: 0,
                                        ));
                                      }
                                      if (value == "Share") {
                                        print(
                                            '${URLs.HOST}/item/${_productDetailsModel!.data!.slug}');
                                        Share.share(
                                            '${URLs.HOST}/item/${_productDetailsModel!.data!.slug}',
                                            subject: _productDetailsModel
                                                .data!.productName!);
                                      }
                                      if (value == "Search") {
                                        Get.to(() => SearchPageMain());
                                      }
                                    },
                                    itemBuilder: (context) {
                                      return [
                                        '$popUpItem1',
                                        '$popUpItem2',
                                        '$popUpItem3',
                                      ].map((String item) {
                                        return PopupMenuItem(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: AppStyles.kFontBlack13w5
                                                .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        );
                                      }).toList();
                                    }),
                              ),
                            ],
                          ),
                        ),
                        actions: [Container()],
                        flexibleSpace: FlexibleSpaceBar(
                          centerTitle: true,
                          background: Container(
                            child: Stack(
                              fit: StackFit.expand,
                              alignment: Alignment.bottomCenter,
                              children: [
                                Positioned.fill(
                                  child: _productDetailsModel!.data!.product!
                                              .gallaryImages!.length >
                                          1
                                      ? Swiper(
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                              onTap: () {
                                                Get.to(() => PhotoViewerWidget(
                                                      productDetailsModel:
                                                          _productDetailsModel,
                                                      initialIndex: index,
                                                    ));
                                              },
                                              child: FancyShimmerImage(
                                                imageUrl:
                                                    "${AppConfig.assetPath}/${_productDetailsModel!.data!.product!.gallaryImages![index].imagesSource}",
                                                boxFit: BoxFit.contain,
                                                errorWidget: FancyShimmerImage(
                                                  imageUrl:
                                                      "${AppConfig.assetPath}/backend/img/default.png",
                                                  boxFit: BoxFit.contain,
                                                ),
                                              ),
                                            );
                                          },
                                          itemCount: _productDetailsModel!.data!
                                              .product!.gallaryImages!.length,
                                          control: new SwiperControl(
                                              color: AppStyles.pinkColor),
                                          pagination: SwiperPagination(
                                              margin:
                                                  EdgeInsets.only(bottom: 10.0),
                                              builder: SwiperCustomPagination(
                                                  builder:
                                                      (BuildContext context,
                                                          SwiperPluginConfig
                                                              config) {
                                                return Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child:
                                                      RectSwiperPaginationBuilder(
                                                    color: AppStyles
                                                        .lightBlueColorAlt,
                                                    activeColor:
                                                        AppStyles.pinkColor,
                                                    size: Size(10.0, 10.0),
                                                    activeSize:
                                                        Size(25.0, 10.0),
                                                  ).build(context, config),
                                                );
                                              })),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            Get.to(() => PhotoViewerWidget(
                                                  productDetailsModel:
                                                      _productDetailsModel,
                                                  initialIndex: 0,
                                                ));
                                          },
                                          child: FancyShimmerImage(
                                            imageUrl:
                                                "${AppConfig.assetPath}/${_productDetailsModel!.data!.product!.thumbnailImageSource!}",
                                            boxFit: BoxFit.contain,
                                            errorWidget: FancyShimmerImage(
                                              imageUrl:
                                                  "${AppConfig.assetPath}/backend/img/default.png",
                                              boxFit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                ),
                                Positioned(
                                  top: 30,
                                  left: 0,
                                  right: 0,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Container(
                                          width: 45,
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.8),
                                            shape: BoxShape.circle,
                                          ),
                                          child: IconButton(
                                            tooltip: "Back",
                                            icon: Icon(
                                              Icons.arrow_back,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              Get.back();
                                            },
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Get.to(() => CartMain(false));
                                        },
                                        child: Container(
                                          height: 50,
                                          child: Stack(
                                            children: [
                                              Positioned(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.8),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  width: 45,
                                                  alignment: Alignment.center,
                                                  child: Image.asset(
                                                    'assets/images/icon_cart_white.png',
                                                    width: 35,
                                                    height: 35,
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                right: 0,
                                                top: 0,
                                                child: Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    width: 25,
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          AppStyles.pinkColor,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Obx(() {
                                                      return Text(
                                                        '${cartController.cartListSelectedCount.value}',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppStyles
                                                            .kFontWhite12w5,
                                                      );
                                                    }),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.8),
                                          shape: BoxShape.circle,
                                        ),
                                        child: PopupMenuButton<String>(
                                            icon: Icon(
                                              Icons.more_vert,
                                              color: Colors.white,
                                            ),
                                            padding: EdgeInsets.zero,
                                            onSelected: (value) {
                                              if (value == "Home") {
                                                Get.offAll(MainNavigation(
                                                  navIndex: 0,
                                                ));
                                              }
                                              if (value == "Share") {
                                                print(
                                                    '${URLs.HOST}/item/${_productDetailsModel!.data!.slug}');
                                                Share.share(
                                                    '${URLs.HOST}/item/${_productDetailsModel!.data!.slug}',
                                                    subject:
                                                        _productDetailsModel
                                                            .data!.productName);
                                              }
                                              if (value == "Search") {
                                                Get.to(() => SearchPageMain());
                                              }
                                            },
                                            itemBuilder: (context) {
                                              return [
                                                '$popUpItem1',
                                                '$popUpItem2',
                                                '$popUpItem3',
                                              ].map((String item) {
                                                return PopupMenuItem(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: AppStyles
                                                        .kFontBlack13w5
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                );
                                              }).toList();
                                            }),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  // pinnedHeaderSliverHeightBuilder: () {
                  //   return pinnedHeaderHeight;
                  // },
                  body: LoadingMoreCustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        currencyController
                                                .calculatePriceWithVariant(
                                                    _productDetailsModel!
                                                        .data)! +
                                            currencyController
                                                .appCurrency.value,
                                        style: AppStyles.kFontPink15w5.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                      Expanded(child: Container()),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: InkWell(
                                          onTap: () async {
                                            final LoginController
                                                loginController =
                                                Get.put(LoginController());

                                            if (loginController
                                                .loggedIn.value) {
                                              final MyWishListController
                                                  wishListController = Get.put(
                                                      MyWishListController());
                                              if (_inWishList) {
                                                await wishListController
                                                    .deleteWishListProduct(
                                                        _wishListId)
                                                    .then((value) {
                                                  setState(() {
                                                    _inWishList = false;
                                                  });
                                                });
                                              } else {
                                                print('add to wishlist');
                                                Map data = {
                                                  'seller_product_id':
                                                      _productDetailsModel
                                                          .data!.id,
                                                  'seller_id':
                                                      _productDetailsModel
                                                          .data!.seller!.id,
                                                  'type': 'product',
                                                };

                                                await wishListController
                                                    .addProductToWishList(data)
                                                    .then((value) {
                                                  setState(() {
                                                    _inWishList = true;
                                                  });
                                                });
                                              }
                                            } else {
                                              Get.dialog(LoginPage(),
                                                  useSafeArea: false);
                                            }
                                          },
                                          child: Icon(
                                            _inWishList
                                                ? FontAwesomeIcons.solidHeart
                                                : FontAwesomeIcons.heart,
                                            size: 20,
                                            color: _inWishList
                                                ? AppStyles.pinkColor
                                                : AppStyles.greyColorLight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(
                                        width: 30,
                                        height: 30,
                                        child: InkWell(
                                          onTap: () {
                                            print(
                                                '${URLs.HOST}/item/${_productDetailsModel!.data!.slug}');
                                            Share.share(
                                                '${URLs.HOST}/item/${_productDetailsModel!.data!.slug}',
                                                subject: _productDetailsModel
                                                    .data!.productName);
                                          },
                                          child: Icon(
                                            FontAwesomeIcons.shareAlt,
                                            size: 20,
                                            color: AppStyles.greyColorLight,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                  currencyController
                                              .calculateMainPriceWithVariant(
                                                  _productDetailsModel!
                                                      .data!) !=
                                          ""
                                      ? Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  currencyController
                                                      .calculateMainPriceWithVariant(
                                                          _productDetailsModel
                                                              .data!),
                                                  style: AppStyles.kFontGrey14w5.copyWith(
                                                      decoration:
                                                          _productDetailsModel
                                                                      .data!
                                                                      .hasDiscount! ==
                                                                  "yes"
                                                              ? TextDecoration
                                                                  .lineThrough
                                                              : TextDecoration
                                                                  .none),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  getDiscountType(
                                                      _productDetailsModel
                                                          .data!),
                                                  style:
                                                      AppStyles.kFontGrey14w5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                          ],
                                        )
                                      : Container(),
                                  Text(
                                    _productDetailsModel!.data!.productName!,
                                    style: AppStyles.kFontBlack15w4.copyWith(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                      letterSpacing: 0.5,
                                      color: Color(0xff242424),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  _productDetailsModel!.data!.rating > 0
                                      ? Row(
                                          children: [
                                            _productDetailsModel!.data!.rating >
                                                    0
                                                ? StarCounterWidget(
                                                    value: _productDetailsModel
                                                        .data!.rating
                                                        .toDouble(),
                                                    color: Colors.amber,
                                                    size: 12,
                                                  )
                                                : Container(),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            _productDetailsModel
                                                        .data!.reviews!.length >
                                                    0
                                                ? Text(
                                                    '${_productDetailsModel!.data!.rating.toDouble().toString()} (${_productDetailsModel!.data!.reviews!.length.toString()})',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style:
                                                        AppStyles.kFontGrey12w5,
                                                  )
                                                : Container(),
                                          ],
                                        )
                                      : SizedBox.shrink(),
                                  _productDetailsModel!.data!.rating > 0
                                      ? SizedBox(
                                          height: 15,
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),

                            _productDetailsModel!.data!.variantDetails!.length >
                                    0
                                ? SizedBox(
                                    height: 10,
                                  )
                                : SizedBox.shrink(),
                            //**Variant
                            _productDetailsModel!.data!.variantDetails!.length >
                                    0
                                ? Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: InkWell(
                                      onTap: () async {
                                        await Get.bottomSheet(
                                          AddToCartWidget(
                                              _productDetailsModel!.data!.id),
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          persistent: true,
                                        );
                                        Get.delete<ProductDetailsController>();
                                      },
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                              width: 100,
                                              child: Text(
                                                'Variant'.tr,
                                                style: AppStyles.kFontBlack13w5,
                                              )),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                padding: EdgeInsets.zero,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: _productDetailsModel
                                                    .data!
                                                    .variantDetails!
                                                    .length,
                                                itemBuilder:
                                                    (context, variantIndex) {
                                                  ProductVariantDetail variant =
                                                      _productDetailsModel!
                                                              .data!
                                                              .variantDetails![
                                                          variantIndex];
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Expanded(
                                                        child: Wrap(
                                                          runSpacing: 0,
                                                          spacing: 5,
                                                          children:
                                                              List.generate(
                                                            variant
                                                                .value!.length,
                                                            (index) {
                                                              if (index == 0) {
                                                                return Text(
                                                                  '${variant.name}: ${variant.value![index]}',
                                                                  style: AppStyles
                                                                      .kFontBlack14w5,
                                                                );
                                                              }
                                                              return Text(
                                                                '${variant.value![index]}',
                                                                style: AppStyles
                                                                    .kFontBlack14w5,
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Icon(
                                            Icons.arrow_forward_ios,
                                            size: 13,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : SizedBox.shrink(),

                            SizedBox(
                              height: 10,
                            ),

                            //**Delivery & Service
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) {
                                      return GestureDetector(
                                        onTap: () =>
                                            Navigator.of(context).pop(),
                                        child: Container(
                                          color: Color.fromRGBO(0, 0, 0, 0.001),
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: DraggableScrollableSheet(
                                              initialChildSize: 0.4,
                                              minChildSize: 0.2,
                                              maxChildSize: 0.75,
                                              builder: (_, scrollController) {
                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          const Radius.circular(
                                                              25.0),
                                                      topRight:
                                                          const Radius.circular(
                                                              25.0),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              Get.back();
                                                            },
                                                            child: Container(
                                                              width: 40,
                                                              height: 5,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xffDADADA),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .all(
                                                                  Radius
                                                                      .circular(
                                                                          30),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Text(
                                                            'Delivery'.tr,
                                                            style: AppStyles
                                                                .kFontBlack15w4,
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      Expanded(
                                                        child: ListView.builder(
                                                          controller:
                                                              scrollController,
                                                          itemCount:
                                                              _productDetailsModel
                                                                  .data!
                                                                  .product!
                                                                  .shippingMethods!
                                                                  .length,
                                                          itemBuilder: (context,
                                                              shipIndex) {
                                                            return Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(8.0),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    width: 5,
                                                                    height: 5,
                                                                    color: AppStyles
                                                                        .darkBlueColor,
                                                                  ),
                                                                  SizedBox(
                                                                    width: 3,
                                                                  ),
                                                                  Expanded(
                                                                    child: Text(
                                                                      '${_productDetailsModel!.data!.product!.shippingMethods![shipIndex].shippingMethod!.methodName} (${_productDetailsModel!.data!.product!.shippingMethods![shipIndex].shippingMethod!.shipmentTime})',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 100,
                                        child: Text(
                                          'Delivery'.tr,
                                          style: AppStyles.kFontGrey14w5,
                                        )),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Wrap(
                                        children: List.generate(
                                            _productDetailsModel
                                                .data!.product!.shippingMethods!
                                                .take(1)
                                                .length, (shipIndex) {
                                          if (shipIndex == 0) {
                                            return Text(
                                              '${_productDetailsModel!.data!.product!.shippingMethods![shipIndex].shippingMethod!.methodName} (${_productDetailsModel!.data!.product!.shippingMethods![shipIndex].shippingMethod!.shipmentTime})',
                                              style: AppStyles.kFontBlack14w5,
                                            );
                                          }
                                          return Text(
                                            ',${_productDetailsModel!.data!.product!.shippingMethods![shipIndex].shippingMethod!.methodName} (${_productDetailsModel!.data!.product!.shippingMethods![shipIndex].shippingMethod!.shipmentTime})',
                                            style: AppStyles.kFontBlack14w5,
                                          );
                                        }),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 13,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Divider(
                              color: AppStyles.textFieldFillColor,
                              thickness: 1,
                              height: 1,
                            ),

                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      child: Text(
                                        'Product Specifications'.tr,
                                        style: AppStyles.kFontGrey14w5,
                                      )),
                                  Divider(
                                    color: AppStyles.textFieldFillColor,
                                    thickness: 1,
                                    height: 1,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _productDetailsModel!.data!.product!.brand !=
                                          null
                                      ? Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  color:
                                                      AppStyles.darkBlueColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Brand".tr + ": ",
                                                  style:
                                                      AppStyles.kFontGrey14w5,
                                                ),
                                                Text(
                                                  "${_productDetailsModel!.data!.product!.brand!.name}",
                                                  style:
                                                      AppStyles.kFontBlack14w5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  //** MODEL NUMBER */

                                  _productDetailsModel
                                              .data!.product!.modelNumber !=
                                          null
                                      ? Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  color:
                                                      AppStyles.darkBlueColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Model Number".tr + ": ",
                                                  style:
                                                      AppStyles.kFontGrey14w5,
                                                ),
                                                Text(
                                                  "${_productDetailsModel!.data!.product!.modelNumber}",
                                                  style:
                                                      AppStyles.kFontBlack14w5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  //** AVAILABLITY */

                                  _productDetailsModel!.data!.stockManage == 1
                                      ? Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  color:
                                                      AppStyles.darkBlueColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Availability".tr + ": ",
                                                  style:
                                                      AppStyles.kFontGrey14w5,
                                                ),
                                                Text(
                                                  "${_productDetailsModel!.data!.skus!.first.productStock! > 0 ? "In Stock" : "Not in stock"}",
                                                  style:
                                                      AppStyles.kFontBlack14w5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  //** SKU */
                                  _productDetailsModel
                                              .data!.product!.skus!.first.sku !=
                                          null
                                      ? Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  color:
                                                      AppStyles.darkBlueColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Product SKU".tr + ": ",
                                                  style:
                                                      AppStyles.kFontGrey14w5,
                                                ),
                                                Text(
                                                  "${_productDetailsModel!.data!.product!.skus!.first.sku}",
                                                  style:
                                                      AppStyles.kFontBlack14w5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  //** Min Order Quantity */
                                  _productDetailsModel
                                              .data!.product!.minimumOrderQty !=
                                          null
                                      ? Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  color:
                                                      AppStyles.darkBlueColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Minimum Order Quantity".tr +
                                                      ": ",
                                                  style:
                                                      AppStyles.kFontGrey14w5,
                                                ),
                                                Text(
                                                  "${_productDetailsModel!.data!.product!.minimumOrderQty}",
                                                  style:
                                                      AppStyles.kFontBlack14w5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  //** Max Order Quantity */
                                  _productDetailsModel
                                              .data!.product!.maxOrderQty !=
                                          null
                                      ? Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 5,
                                                  height: 5,
                                                  color:
                                                      AppStyles.darkBlueColor,
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  "Maximum Order Quantity".tr +
                                                      ": ",
                                                  style:
                                                      AppStyles.kFontGrey14w5,
                                                ),
                                                Text(
                                                  "${_productDetailsModel!.data!.product!.maxOrderQty}",
                                                  style:
                                                      AppStyles.kFontBlack14w5,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  //** Category */
                                  _productDetailsModel.data!.product!
                                              .categories!.length >
                                          0
                                      ? Column(
                                          children: [
                                            Wrap(
                                              spacing: 5,
                                              children: List.generate(
                                                  _productDetailsModel
                                                          .data!
                                                          .product!
                                                          .categories!
                                                          .length +
                                                      1, (categoryIndex) {
                                                if (categoryIndex == 0) {
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Category'.tr + ':',
                                                        style: AppStyles
                                                            .kFontGrey14w5,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  );
                                                }
                                                return InkWell(
                                                  onTap: () {
                                                    openCategory(
                                                        _productDetailsModel
                                                                .data!
                                                                .product!
                                                                .categories![
                                                            categoryIndex - 1]);
                                                  },
                                                  child: Chip(
                                                    backgroundColor: AppStyles
                                                        .lightBlueColorAlt,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    label: Text(
                                                      '${_productDetailsModel!.data!.product!.categories![categoryIndex - 1].name}',
                                                      style: AppStyles
                                                          .kFontBlack14w5,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  //** TAGS */
                                  _productDetailsModel
                                              .data!.product!.tags!.length >
                                          0
                                      ? Column(
                                          children: [
                                            Wrap(
                                              spacing: 5,
                                              children: List.generate(
                                                  _productDetailsModel!
                                                          .data!
                                                          .product!
                                                          .tags!
                                                          .length +
                                                      1, (tagIndex) {
                                                if (tagIndex == 0) {
                                                  return Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Tags'.tr + ':',
                                                        style: AppStyles
                                                            .kFontGrey14w5,
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                    ],
                                                  );
                                                }
                                                return InkWell(
                                                  onTap: () {
                                                    Get.to(() => ProductsByTags(
                                                          tagName:
                                                              _productDetailsModel
                                                                  .data!
                                                                  .product!
                                                                  .tags![
                                                                      tagIndex -
                                                                          1]
                                                                  .name,
                                                          tagId:
                                                              _productDetailsModel
                                                                  .data!
                                                                  .product!
                                                                  .tags![
                                                                      tagIndex -
                                                                          1]
                                                                  .id,
                                                        ));
                                                  },
                                                  child: Chip(
                                                    backgroundColor: AppStyles
                                                        .lightBlueColorAlt,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                    label: Text(
                                                      '${_productDetailsModel!.data!.product!.tags![tagIndex - 1].name}',
                                                      style: AppStyles
                                                          .kFontBlack14w5,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        )
                                      : SizedBox.shrink(),

                                  _productDetailsModel
                                              .data!.product!.specification !=
                                          null
                                      ? htmlExpandingWidget(
                                          "${_productDetailsModel!.data!.product!.specification ?? ""}")
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),

                            _productDetailsModel!.data!.product!.description !=
                                    null
                                ? Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Text(
                                              'Description'.tr,
                                              style: AppStyles.kFontGrey14w5,
                                            )),
                                        Divider(
                                          color: AppStyles.textFieldFillColor,
                                          thickness: 1,
                                          height: 1,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          child: htmlExpandingWidget(
                                              "${_productDetailsModel!.data!.product!.description ?? ""}"),
                                        ),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),

                            //** Ratings And reviews
                            productReviews.length > 0
                                ? ListView(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          Get.to(() => RatingsAndReviews(
                                                productReviews: productReviews,
                                              ));
                                        },
                                        child: Container(
                                          color: Colors.white,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 15),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Ratings & Reviews'.tr,
                                                textAlign: TextAlign.center,
                                                style: AppStyles.kFontBlack14w5
                                                    .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Expanded(child: Container()),
                                              Row(
                                                children: [
                                                  Text(
                                                    'VIEW ALL'.tr,
                                                    textAlign: TextAlign.center,
                                                    style: AppStyles
                                                        .kFontBlack14w5
                                                        .copyWith(
                                                            color: AppStyles
                                                                .pinkColor),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    size: 14,
                                                    color: AppStyles.pinkColor,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        color: AppStyles.textFieldFillColor,
                                        thickness: 1,
                                        height: 1,
                                      ),
                                      Container(
                                        color: Colors.white,
                                        child: ListView.separated(
                                          separatorBuilder: (context, index) {
                                            return Divider(
                                              height: 20,
                                              thickness: 2,
                                              color:
                                                  AppStyles.appBackgroundColor,
                                            );
                                          },
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          shrinkWrap: true,
                                          itemCount:
                                              productReviews.take(4).length,
                                          itemBuilder: (context, index) {
                                            Review review =
                                                productReviews[index];
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    review.isAnonymous == 1
                                                        ? Text(
                                                            'User'.tr,
                                                            style: AppStyles
                                                                .kFontGrey12w5
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppStyles
                                                                  .blackColor,
                                                            ),
                                                          )
                                                        : Text(
                                                            review.customer!
                                                                        .firstName
                                                                        .toString()
                                                                        .capitalizeFirst! +
                                                                    ' ' +
                                                                    review!
                                                                        .customer!
                                                                        .lastName!
                                                                        .toString()!
                                                                        .capitalizeFirst! ??
                                                                "",
                                                            style: AppStyles
                                                                .kFontGrey12w5
                                                                .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppStyles
                                                                  .blackColor,
                                                            ),
                                                          ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      '- ' +
                                                          CustomDate()
                                                              .formattedDate(
                                                                  review
                                                                      .createdAt),
                                                      style: AppStyles
                                                          .kFontGrey12w5,
                                                    ),
                                                    Expanded(
                                                        child: Container()),
                                                    StarCounterWidget(
                                                      value: int.parse(review
                                                              .rating
                                                              .toString())
                                                          .toDouble(),
                                                      color: AppStyles
                                                          .goldenYellowColor,
                                                      size: 15,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  review.review!,
                                                  style:
                                                      AppStyles.kFontGrey12w5,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            currencyController.vendorType.value == "single"
                                ? SizedBox.shrink()
                                : Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 15),
                                    color: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        _productDetailsModel
                                                    .data!.seller!.photo! !=
                                                null
                                            ? Image.network(
                                                AppConfig.assetPath +
                                                        '/' +
                                                        _productDetailsModel
                                                            .data!
                                                            .seller!
                                                            .photo! ??
                                                    "",
                                                height: 40,
                                                width: 40,
                                                fit: BoxFit.contain,
                                                errorBuilder: (BuildContext
                                                        context,
                                                    Object? exception,
                                                    StackTrace? stackTrace) {
                                                  return Image.asset(
                                                    AppConfig.appLogo,
                                                    height: 40,
                                                    width: 40,
                                                  );
                                                },
                                              )
                                            : CircleAvatar(
                                                foregroundColor:
                                                    AppStyles.pinkColor,
                                                backgroundColor:
                                                    AppStyles.pinkColor,
                                                radius: 20,
                                                child: Container(
                                                  color: AppStyles.pinkColor,
                                                  child: Image.asset(
                                                    AppConfig.appLogo,
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                ),
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            '${_productDetailsModel!.data!.seller!.name ?? ""}',
                                            overflow: TextOverflow.ellipsis,
                                            style: AppStyles.kFontBlack14w5
                                                .copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                      ],
                                    ),
                                  ),

                            Divider(
                              height: 1,
                              thickness: 1,
                              color: AppStyles.textFieldFillColor,
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            _productDetailsModel.data!.product!.relatedProducts!
                                        .length >
                                    0
                                ? Container(
                                    color: Colors.white,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20, vertical: 10),
                                            child: Text('Related Products'.tr)),
                                        Divider(
                                          color: AppStyles.textFieldFillColor,
                                          thickness: 1,
                                          height: 1,
                                        ),
                                        Builder(builder: (context) {
                                          List<ProductModel> relatedProducts =
                                              [];
                                          _productDetailsModel
                                              .data!.product!.relatedProducts!
                                              .forEach((element) {
                                            if (element.relatedSellerProducts!
                                                    .length >
                                                0) {
                                              relatedProducts.add(element
                                                  .relatedSellerProducts!
                                                  .first);
                                            }
                                          });
                                          return Container(
                                            height: 220,
                                            child: ListView.separated(
                                                itemCount: relatedProducts
                                                    .toSet()
                                                    .toList()
                                                    .length,
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    BouncingScrollPhysics(),
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15,
                                                    vertical: 15),
                                                separatorBuilder:
                                                    (context, index) {
                                                  return SizedBox(
                                                    width: 10,
                                                  );
                                                },
                                                itemBuilder: (context,
                                                    relatedProductIndex) {
                                                  ProductModel prod =
                                                      relatedProducts[
                                                          relatedProductIndex];
                                                  return HorizontalProductWidget(
                                                    productModel: prod,
                                                  );
                                                }),
                                          );
                                        }),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),

                            _productDetailsModel
                                        .data!.product!.displayInDetails ==
                                    1
                                ? _productDetailsModel!.data!.product!
                                            .upSalesProducts!.length >
                                        0
                                    ? Container(
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                child: Text(
                                                    'Up Sales Products'.tr)),
                                            Divider(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                              thickness: 1,
                                              height: 1,
                                            ),
                                            Builder(builder: (context) {
                                              List<ProductModel>
                                                  upSalesProducts = [];
                                              _productDetailsModel.data!
                                                  .product!.upSalesProducts!
                                                  .forEach((element) {
                                                if (element.upSaleProducts!
                                                        .length >
                                                    0) {
                                                  upSalesProducts.add(element
                                                      .upSaleProducts!.first);
                                                }
                                              });
                                              return Container(
                                                height: 220,
                                                child: ListView.separated(
                                                    itemCount: upSalesProducts
                                                        .toSet()
                                                        .toList()
                                                        .length,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 15),
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return SizedBox(
                                                        width: 10,
                                                      );
                                                    },
                                                    itemBuilder: (context,
                                                        upSalesIndex) {
                                                      ProductModel prod =
                                                          upSalesProducts[
                                                              upSalesIndex];
                                                      return HorizontalProductWidget(
                                                        productModel: prod,
                                                      );
                                                    }),
                                              );
                                            }),
                                          ],
                                        ),
                                      )
                                    : SizedBox.shrink()
                                : _productDetailsModel!.data!.product!
                                            .crossSalesProducts!.length >
                                        0
                                    ? Container(
                                        color: Colors.white,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20,
                                                    vertical: 10),
                                                child: Text(
                                                    'Cross Sales Products'.tr)),
                                            Divider(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                              thickness: 1,
                                              height: 1,
                                            ),
                                            Builder(builder: (context) {
                                              List<ProductModel>
                                                  crossSalesProducts = [];
                                              _productDetailsModel!.data!
                                                  .product!.crossSalesProducts!
                                                  .forEach((element) {
                                                if (element.crossSaleProducts!
                                                        .length >
                                                    0) {
                                                  crossSalesProducts.add(element
                                                      .crossSaleProducts!
                                                      .first);
                                                }
                                              });
                                              return Container(
                                                height: 220,
                                                child: ListView.separated(
                                                    itemCount:
                                                        crossSalesProducts
                                                            .toSet()
                                                            .toList()
                                                            .length,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    physics:
                                                        BouncingScrollPhysics(),
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 15,
                                                            vertical: 15),
                                                    separatorBuilder:
                                                        (context, index) {
                                                      return SizedBox(
                                                        width: 10,
                                                      );
                                                    },
                                                    itemBuilder: (context,
                                                        crossSalesIndex) {
                                                      ProductModel prod =
                                                          crossSalesProducts[
                                                              crossSalesIndex];
                                                      return HorizontalProductWidget(
                                                        productModel: prod,
                                                      );
                                                    }),
                                              );
                                            }),
                                          ],
                                        ),
                                      )
                                    : SizedBox.shrink(),
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
                          padding: EdgeInsets.all(5),
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
                          itemBuilder:
                              (BuildContext c, ProductModel prod, int index) {
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
                bottomNavigationBar: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0.0, 0.3),
                        )
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => MainNavigation(
                                  navIndex: 0,
                                  hideNavBar: false,
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'assets/images/icon_nav_home.svg',
                                  color: AppStyles.pinkColor,
                                  width: 25,
                                ),
                              ),
                              Text(
                                'Home'.tr,
                                style: AppStyles.kFontPink15w5.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        // GestureDetector(
                        //   onTap: () {
                        //     Get.to(() => MessageNotifications());
                        //   },
                        //   child: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.center,
                        //     mainAxisAlignment: MainAxisAlignment.center,
                        //     children: [
                        //       Container(
                        //         child: SvgPicture.asset(
                        //           'assets/images/icon_nav_message.svg',
                        //           color: AppStyles.pinkColor,
                        //           width: 25.h,
                        //         ),
                        //       ),
                        //       Text(
                        //         'Notification'.tr,
                        //         style: AppStyles.kFontPink15w5.copyWith(
                        //           fontSize: 12.sp,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        currencyController.vendorType.value == "single"
                            ? GestureDetector(
                                onTap: () {
                                  Get.to(() => CartMain(false));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: SvgPicture.asset(
                                        'assets/images/icon_nav_cart.svg',
                                        color: AppStyles.pinkColor,
                                        width: 25,
                                      ),
                                    ),
                                    Text(
                                      'Cart'.tr,
                                      style: AppStyles.kFontPink15w5.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : InkWell(
                                onTap: () {
                                  print(_productDetailsModel!.data!.seller!.id);
                                  Get.to(() => StoreHome(
                                        sellerId: _productDetailsModel!
                                            .data!.seller!.id,
                                      ));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/icon_store_alt.png',
                                      width: 25,
                                    ),
                                    Text(
                                      'Store'.tr,
                                      style: AppStyles.kFontPink15w5.copyWith(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_loginController.loggedIn.value) {
                              Get.to(() => Account());
                            } else {
                              Get.to(() => SignInOrRegister());
                            }
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                child: SvgPicture.asset(
                                  'assets/images/icon_nav_account.svg',
                                  color: AppStyles.pinkColor,
                                  width: 25,
                                ),
                              ),
                              Text(
                                'Account'.tr,
                                style: AppStyles.kFontPink15w5.copyWith(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ClipPath(
                          clipper: SkewCutRight(),
                          child: GestureDetector(
                            onTap: () async {
                              if (stockManage == 1) {
                                if (stockCount >= 1) {
                                  await Get.bottomSheet(
                                    AddToCartWidget(
                                        _productDetailsModel!.data!.id),
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    persistent: true,
                                  );
                                  Get.delete<ProductDetailsController>();
                                }
                              } else {
                                await Get.bottomSheet(
                                  AddToCartWidget(
                                      _productDetailsModel!.data!.id),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  persistent: true,
                                );
                                Get.delete<ProductDetailsController>();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: Get.width * 0.40,
                              decoration: BoxDecoration(
                                color: AppStyles.pinkColor,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: stockManage == 1
                                    ? Text(
                                        stockCount >= 1
                                            ? "Add to Cart"
                                            : "Out of Stock",
                                        textAlign: TextAlign.center,
                                        style:
                                            AppStyles.kFontWhite14w5.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    : Text(
                                        "Add to Cart",
                                        textAlign: TextAlign.center,
                                        style:
                                            AppStyles.kFontWhite14w5.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        // PinkButtonWidget(
                        //   height: 40.h,
                        //   btnText: 'Add to Cart'.tr,
                        //   btnOnTap: () async {
                        //     await Get.bottomSheet(
                        //       AddToCartWidget(_productDetailsModel!.data!.id),
                        //       isScrollControlled: true,
                        //       backgroundColor: Colors.transparent,
                        //       persistent: true,
                        //     );
                        //     Get.delete<ProductDetailsController>();
                        //   },
                        // ),
                        // SizedBox(width: 20),
                      ],
                    )),
              );
            }
          }
          // Displaying LoadingSpinner to indicate waiting state
          return Center(
            child: CustomLoadingWidget(),
          );
        });
  }

  ExpandableNotifier htmlExpandingWidget(text) {
    return ExpandableNotifier(
      child: ScrollOnExpand(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expandable(
              controller: ExpandableController.of(context),
              collapsed: Container(
                height: 50,
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Html(
                        data: '''$text''',
                      ),
                    ),
                  ],
                ),
              ),
              expanded: Container(
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Html(
                        data: '''$text''',
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Builder(
                  builder: (context) {
                    var controller = ExpandableController.of(context);
                    return TextButton(
                      child: Text(
                        !controller!.expanded ? "View more" : "Show less",
                        style: AppStyles.kFontGrey12w5,
                      ),
                      onPressed: () {
                        controller.toggle();
                      },
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class PhotoViewerWidget extends StatefulWidget {
  final ProductDetailsModel? productDetailsModel;
  final int? initialIndex;

  PhotoViewerWidget({this.productDetailsModel, this.initialIndex = 0});

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget> {
  int currentIndex = 0;
  PageController? pageController;

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    pageController = PageController(initialPage: widget.initialIndex!);
    currentIndex = pageController!.initialPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(AppConfig.assetPath +
                    '/' +
                    widget.productDetailsModel!.data!.product!
                        .gallaryImages![index].imagesSource!),
                initialScale: PhotoViewComputedScale.contained * 0.8,
                heroAttributes: PhotoViewHeroAttributes(
                    tag: widget.productDetailsModel!.data!.product!
                        .gallaryImages![index].id!),
              );
            },
            itemCount: widget
                .productDetailsModel!.data!.product!.gallaryImages!.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
            backgroundDecoration: const BoxDecoration(
              color: Colors.white,
            ),
            pageController: pageController,
            onPageChanged: onPageChanged,
            enableRotation: false,
          ),
        ),
        Positioned(
          top: Get.statusBarHeight * 0.3,
          left: 10,
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Icons.arrow_back_sharp,
                    color: Colors.black,
                  )),
              Text(
                  "${widget.productDetailsModel!.data!.productName!.capitalizeFirst! ?? ""}",
                  style: AppStyles.kFontBlack14w5),
            ],
          ),
        ),
        Positioned(
          bottom: Get.bottomBarHeight * 0.3,
          left: 0,
          right: 0,
          child: Container(
            height: Get.height * 0.1,
            width: 100,
            child: ListView.separated(
                itemCount: widget
                    .productDetailsModel!.data!.product!.gallaryImages!.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                separatorBuilder: (context, index) {
                  return SizedBox(width: 10);
                },
                itemBuilder: (context, imageIndex) {
                  return GestureDetector(
                    onTap: () {
                      pageController!.jumpToPage(imageIndex);
                    },
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: imageIndex == currentIndex
                            ? Colors.red
                            : Colors.white,
                      )),
                      child: FancyShimmerImage(
                        imageUrl: AppConfig.assetPath +
                            '/' +
                            widget.productDetailsModel!.data!.product!
                                .gallaryImages![imageIndex].imagesSource!,
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
        ),
      ],
    );
  }
}
