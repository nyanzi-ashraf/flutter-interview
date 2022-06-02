import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/gift_card_controller.dart';
import 'package:amazcart/controller/product_controller.dart';
import 'package:amazcart/model/AllGiftCardsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/GridViewProductWidget.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_more_list/loading_more_list.dart';

// ignore: must_be_immutable
class AllGiftCardPage extends StatefulWidget {
  @override
  _AllGiftCardPageState createState() => _AllGiftCardPageState();
}

class _AllGiftCardPageState extends State<AllGiftCardPage> {
  final ProductController controller = Get.put(ProductController());
  final CartController cartController = Get.put(CartController());

  final GiftCardController giftCardController = Get.put(GiftCardController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  // Sorting _selectedSort;

  bool freeSelected = false;

  Future<void> onRefresh() async {
    print('onref');
    controller.allProducts.clear();
    controller.productPageNumber.value = 1;
    controller.productLastPage.value = false;
    await controller.getAllProducts();
  }

  AllGiftCardsLoadMore? source;

  @override
  void initState() {
    source = AllGiftCardsLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();

    super.dispose();
  }

  String calculatePrice(ProductModel prod) {
    String priceText;
    if (prod.giftCardEndDate!.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch) {
      priceText =
          (prod.giftCardSellingPrice! * currencyController.conversionRate.value)
              .toString();
    } else {
      if (prod.discountType == 0) {
        priceText = ((prod.giftCardSellingPrice! -
                    ((prod.discount! / 100) * prod.giftCardSellingPrice!)) *
                currencyController.conversionRate.value)
            .toString();
      } else {
        priceText = ((prod.giftCardSellingPrice! - prod.discount!) *
                currencyController.conversionRate.value)
            .toString();
      }
    }
    return priceText;
  }

  String calculateMainPrice(ProductModel productModel) {
    String amountText;

    if (productModel.discount! > 0) {
      amountText = (productModel.giftCardSellingPrice! *
              currencyController.conversionRate.value)
          .toString();
    } else {
      amountText = '';
    }

    return amountText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppStyles.appBackgroundColor,
        appBar: AppBarWidget(
          title: "Browse Gift Cards".tr,
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                child: LoadingMoreList<ProductModel>(
                  ListConfig<ProductModel>(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    indicatorBuilder: BuildIndicatorBuilder(
                      source: source,
                      isSliver: false,
                      name: 'Gift Card'.tr,
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
              ),
            ],
          ),
        ));
  }
}

class AllGiftCardsLoadMore extends LoadingMoreBase<ProductModel> {
  bool isSorted = false;
  String sortKey = 'new';

  final ProductController controller = Get.put(ProductController());

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
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    DIO.Dio _dio = DIO.Dio();

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      DIO.Response? result;
      AllGiftCardsModel? source;

      if (!isSorted) {
        if (this.length == 0) {
          result = await _dio
              .get(
            URLs.ALL_GIFT_CARDS,
          )
              .catchError((onError) {
            print('ERRORRRRR');
            this.length = 0;
          });
        } else {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'page': pageIndex,
          }).catchError((onError) {
            print('ERRORRRRR');
          });
        }
        if (result != null) {
          print(result.statusCode);
          final data = new Map<String, dynamic>.from(result.data);
          source = AllGiftCardsModel.fromJson(data);
          productsLength = source.giftcards!.total;
        }
      } else {
        if (this.length == 0) {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'sort_by': sortKey,
          });
        } else {
          result = await _dio.get(URLs.ALL_GIFT_CARDS, queryParameters: {
            'sort_by': sortKey,
            'page': pageIndex,
          });
        }
        print(result.realUri);
        final data = new Map<String, dynamic>.from(result.data);
        source = AllGiftCardsModel.fromJson(data);
        productsLength = source.giftcards!.total;
      }

      if (source! != null) {
        if (pageIndex == 1) {
          this.clear();
        }
        for (var item in source.giftcards!.data!) {
          this.add(item);
        }

        _hasMore = source.giftcards!.data!.length != 0;
        pageIndex++;
        isSuccess = true;
      }
    } catch (exception, stack) {
      isSuccess = false;
      print('Exception => $exception');
      print('Stack => $stack');
    }
    return isSuccess;
  }
}
