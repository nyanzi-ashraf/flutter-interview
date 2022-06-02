import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/cart_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/model/MyPurchasedGiftCards.dart';
import 'package:amazcart/model/SortingModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/products/giftCard/AllGiftCardsPage.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/BuildIndicatorBuilder.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:clipboard/clipboard.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_more_list/loading_more_list.dart';

import 'package:scratcher/widgets.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class MyGiftCardsPage extends StatefulWidget {
  @override
  _MyGiftCardsPageState createState() => _MyGiftCardsPageState();
}

class _MyGiftCardsPageState extends State<MyGiftCardsPage> {
  final CartController cartController = Get.put(CartController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  Sorting? _selectedSort;

  bool freeSelected = false;

  MyGiftCardsLoadMore? source;

  @override
  void initState() {
    source = MyGiftCardsLoadMore();

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
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: "My Gift Cards",
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            Container(
              height: 50,
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
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButton(
                        hint: Text('Sort'.tr),
                        underline: Container(),
                        value: _selectedSort,
                        style: AppStyles.kFontBlack14w5,
                        onChanged: (newValue) async {
                          // print(newValue.sortKey);
                          setState(() {
                            _selectedSort = newValue as Sorting?;
                            setState(() {
                              source!.sortKey = newValue!.sortKey!;
                              source!.isSorted = true;
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
                        Get.to(() => AllGiftCardPage());
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              Icons.card_giftcard,
                            ),
                            Text(
                              ' ' + 'Buy Gift Card'.tr,
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
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: LoadingMoreList<GiftCardDatum>(
                ListConfig<GiftCardDatum>(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  indicatorBuilder: BuildIndicatorBuilder(
                    source: source,
                    isSliver: false,
                    name: 'Gift Cards',
                  ).buildIndicator,
                  showGlowLeading: true,
                  itemBuilder: (BuildContext c, GiftCardDatum prod, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          height: 130,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Positioned.fill(
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      'assets/images/voucher_bg.png',
                                      fit: BoxFit.fill,
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: DottedLine(
                                        direction: Axis.horizontal,
                                        lineLength: double.infinity,
                                        lineThickness: 4.0,
                                        dashLength: 4.0,
                                        dashColor: Colors.white,
                                        dashGapLength: 4.0,
                                        dashGapColor: Colors.transparent,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: DottedLine(
                                        direction: Axis.horizontal,
                                        lineLength: double.infinity,
                                        lineThickness: 4.0,
                                        dashLength: 4.0,
                                        dashColor: Colors.white,
                                        dashGapLength: 4.0,
                                        dashGapColor: Colors.transparent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            prod.giftCard!.name!,
                                            style: AppStyles.kFontBlack17w5,
                                          ),
                                          Text(
                                            'Validity'.tr +
                                                ': ${CustomDate().formattedDate(prod.giftCard!.startDate)} - ${CustomDate().formattedDate(prod.giftCard!.endDate)}',
                                            style: AppStyles.appFont.copyWith(
                                              color: AppStyles.blackColor,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                double.parse((prod.giftCard!
                                                                .sellingPrice! *
                                                            currencyController
                                                                .conversionRate
                                                                .value)
                                                        .toString())
                                                    .toPrecision(2)
                                                    .toString(),
                                                style:
                                                    AppStyles.appFont.copyWith(
                                                  color: AppStyles.pinkColor,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${currencyController.appCurrency}',
                                                style:
                                                    AppStyles.appFont.copyWith(
                                                  color: AppStyles.pinkColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Scratch to reveal'.tr,
                                            style: AppStyles.appFont.copyWith(
                                              color: AppStyles.blackColor,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Scratcher(
                                            brushSize: 30,
                                            threshold: 100,
                                            color: AppStyles.pinkColor,
                                            onScratchEnd: () {
                                              FlutterClipboard.copy(
                                                      '${prod.secretCode!}')
                                                  .then((value) {
                                                print(
                                                    'copied: ${prod.secretCode!}');
                                                SnackBars().snackBarSuccess(
                                                    'Secret Code copied to Clipboard'
                                                        .tr);
                                              });
                                            },
                                            onChange: (value) => print(
                                                "Scratch progress: $value%"),
                                            onThreshold: () {
                                              FlutterClipboard.copy(
                                                      '${prod.secretCode!}')
                                                  .then((value) {
                                                print(
                                                    'copied: ${prod.secretCode!}');
                                                SnackBars().snackBarSuccess(
                                                    'Secret Code copied to Clipboard'
                                                        .tr);
                                              });
                                            },
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 4.0),
                                              child: Text(
                                                prod.secretCode!,
                                                style:
                                                    AppStyles.appFont.copyWith(
                                                  color: AppStyles.blackColor,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Spacer(),
                                      // PinkButtonWidget(
                                      //   height: 32.h,
                                      //   width: 100.w,
                                      //   btnOnTap: () {},
                                      //   btnText: 'Redeem'.tr,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  },
                  sourceList: source!,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MyGiftCardsLoadMore extends LoadingMoreBase<GiftCardDatum> {
  bool isSorted = false;
  String sortKey = 'new';

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
    GetStorage userToken = GetStorage();
    var tokenKey = 'token';

    String token = await userToken.read(tokenKey);

    bool isSuccess = false;
    try {
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      http.Response result;
      MyPurchasedGiftCards? source;

      if (!isSorted) {
        if (this.length == 0) {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        } else {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS + '?page=$pageIndex'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        }
        if (result.statusCode != 404) {
          final data = jsonDecode(result.body);
          source = MyPurchasedGiftCards.fromJson(data);
          productsLength = source.giftcards!.total;
        } else {
          isSuccess = false;
        }
      } else {
        if (this.length == 0) {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS + '?sort_by=$sortKey'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        } else {
          result = await http.get(
            Uri.parse(URLs.MY_PURCHASED_GIFT_CARDS +
                '?sort_by=$sortKey&page=$pageIndex'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );
        }
        if (result.statusCode != 404) {
          final data = jsonDecode(result.body);
          source = MyPurchasedGiftCards.fromJson(data);
          productsLength = source.giftcards!.total;
        } else {
          isSuccess = false;
        }
      }

      if (pageIndex == 1) {
        this.clear();
      }
      if (result.statusCode != 404) {
        for (var item in source!.giftcards!.data!) {
          this.add(item);
        }

        _hasMore = source.giftcards!.data?.length != 0;
        pageIndex++;
        isSuccess = true;
      } else {}
    } catch (exception, stack) {
      isSuccess = false;
      print("exc $exception");
      print("stk $stack");
    }
    return isSuccess;
  }
}
