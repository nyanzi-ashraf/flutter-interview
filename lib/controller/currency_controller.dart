import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/Currency.dart';
import 'package:amazcart/model/NewModel/GeneralSettingsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

class CurrencyController extends GetxController {
  var isLoading = false.obs;
  var appCurrency = ''.obs;
  var conversionRate = 0.0.obs;
  var generalCurrencyCode = ''.obs;
  var currencyName = ''.obs;
  var currencyCode = ''.obs;
  Rx<String> vendorType = ''.obs;
  var currenciesList = <Currency>[].obs;
  var currency = Currency().obs;

  Dio _dio = Dio();

  String? priceText;
  DateTime endDate = DateTime.now();

  Rx<GeneralSettingsModel> settingsModel = GeneralSettingsModel().obs;

  Future<GeneralSettingsModel> getGeneralSettings() async {
    try {
      isLoading(true);
      String uri = URLs.GENERAL_SETTINGS;

      var response = await _dio.get(
        uri,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      var data = new Map<String, dynamic>.from(response.data);

      settingsModel.value = GeneralSettingsModel.fromJson(data);
      if (settingsModel.value.msg == 'success') {
        generalCurrencyCode.value = settingsModel.value.settings!.currencyCode!;

        currenciesList.value = settingsModel.value.currencies!;
        currency.value = settingsModel.value.currencies!
            .where((element) => element.code == generalCurrencyCode.value)
            .first;
        appCurrency.value = currency.value.symbol.toString();
        conversionRate.value = currency.value.convertRate!.toPrecision(2);
        currencyName.value = currency.value.name!;
        currencyCode.value = currency.value.code!;
        vendorType.value = settingsModel.value.vendorType!;

        isLoading(false);
      }
    } catch (e) {
      print(e);
      throw e.toString();
    }
    return settingsModel.value;
  }

  // Future getCurrency() async {
  //   try {
  //     Uri uri = Uri.parse(URLs.CURRENCY_LIST);

  //     var response = await http.get(
  //       uri,
  //       headers: {
  //         'Content-Type': 'application/json',
  //         'Accept': 'application/json',
  //       },
  //     );
  //     var currencyModel = currencyModelFromJson(response.body);
  //     if (currencyModel.msg == 'success') {
  //       currenciesList.value = currencyModel.currencies;
  //       currency.value = currencyModel.currencies
  //           .where((element) => element.code == generalCurrencyCode.value)
  //           .first;
  //       appCurrency.value = currency.value.symbol.toString();
  //       conversionRate.value = currency.value.convertRate.toPrecision(2);
  //       currencyName.value = currency.value.name;
  //     }
  //   } catch (e) {
  //     isLoading(false);
  //     print(e);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  @override
  void onInit() {
    getGeneralSettings();
    super.onInit();
  }

  String calculateMainPrice(ProductModel? productModel) {
    String amountText;

    if (productModel!.hasDiscount == 'yes' || productModel.hasDeal != null) {
      if (productModel.product!.productType == 1) {
        amountText = double.parse(
                    (productModel.maxSellingPrice! * conversionRate.value)
                        .toString())
                .toStringAsFixed(2) +
            appCurrency.value;
      } else {
        amountText = double.parse(
                    (productModel.maxSellingPrice! * conversionRate.value)
                        .toString())
                .toStringAsFixed(2) +
            appCurrency.value;
      }
    } else {
      amountText = '';
    }
    return amountText;
  }

  String? calculatePrice(ProductModel? prod) {
    if (prod!.productType == ProductType.GIFT_CARD) {
      if (prod.giftCardEndDate!.compareTo(DateTime.now()) > 0) {
        priceText = singlePrice(sellingPrice(
                prod.giftCardSellingPrice, prod.discountType, prod.discount))
            .toStringAsFixed(2);
      } else {
        priceText = singlePrice(prod.giftCardSellingPrice!).toStringAsFixed(2);
      }
    } else {
      if (prod.hasDeal != null) {
        if (prod.product!.productType == 1) {
          priceText = singlePrice(sellingPrice(prod.skus!.first.sellingPrice,
                  prod.hasDeal!.discountType, prod.hasDeal!.discount))
              .toStringAsFixed(2);
        } else {
          if (sellingPrice(prod.minSellPrice, prod.hasDeal!.discountType,
                  prod.hasDeal!.discount) ==
              sellingPrice(prod.maxSellingPrice, prod.hasDeal!.discountType,
                  prod.hasDeal!.discount)) {
            priceText = singlePrice(sellingPrice(prod.minSellPrice,
                    prod.hasDeal!.discountType, prod.hasDeal!.discount))
                .toStringAsFixed(2);
          } else {
            // print("${prod.productName} -- ${prod.product!.productType} -- Max: ${prod.maxSellingPrice} -- Min: ${prod.minSellPrice}");
            priceText = singlePrice(sellingPrice(prod.minSellPrice,
                    prod.hasDeal!.discountType, prod.hasDeal!.discount))
                .toStringAsFixed(2);
          }
        }
      } else {
        if (prod.product!.productType == 1) {
          if (prod.hasDiscount == 'yes') {
            priceText = singlePrice(sellingPrice(
                    prod.maxSellingPrice, prod.discountType, prod.discount))
                .toStringAsFixed(2);
          } else {
            priceText = singlePrice(prod.maxSellingPrice!).toStringAsFixed(2);
          }
        } else {
          ///variant product
          if (sellingPrice(
                  prod.minSellPrice, prod.discountType, prod.discount) ==
              sellingPrice(
                  prod.maxSellingPrice, prod.discountType, prod.discount)) {
            if (prod.hasDiscount == 'yes') {
              priceText = singlePrice(sellingPrice(
                      prod.skus!.first.sellingPrice,
                      prod.discountType,
                      prod.discount))
                  .toStringAsFixed(2);
            } else {
              priceText = singlePrice(prod.skus!.first.sellingPrice!)
                  .toStringAsFixed(2);
            }
          } else {
            var priceA;
            // var priceB;
            if (prod.hasDiscount == 'yes') {
              priceA = singlePrice(sellingPrice(
                      prod.minSellPrice, prod.discountType, prod.discount))
                  .toStringAsFixed(2);
              // priceB = singlePrice(sellingPrice(
              //         prod.maxSellingPrice, prod.discountType, prod.discount))
              //     .toStringAsFixed(2);
            } else {
              priceA = singlePrice(prod.minSellPrice).toStringAsFixed(2);
              // priceB = singlePrice(prod.maxSellingPrice).toStringAsFixed(2);
            }
            priceText = '$priceA';
          }
        }
      }
    }

    return priceText;
  }

  String calculateMainPriceWithVariant(ProductModel productModel) {
    String amountText;

    if (productModel.hasDiscount == 'yes' || productModel.hasDeal != null) {
      if (productModel.product!.productType == 1) {
        amountText = double.parse(
                    (productModel.maxSellingPrice! * conversionRate.value)
                        .toString())
                .toStringAsFixed(2) +
            appCurrency.value;
      } else {
        amountText = double.parse(
                    (productModel.minSellPrice * conversionRate.value)
                        .toString())
                .toStringAsFixed(2) +
            appCurrency.value +
            ' - ' +
            double.parse((productModel.maxSellingPrice! * conversionRate.value)
                    .toString())
                .toStringAsFixed(2) +
            appCurrency.value;
      }
    } else {
      amountText = '';
    }
    return amountText;
  }

  String? calculatePriceWithVariant(ProductModel? prod) {
    if (prod!.hasDeal != null) {
      if (prod.product!.productType == 1) {
        priceText = singlePrice(sellingPrice(prod.skus!.first.sellingPrice,
                prod.hasDeal!.discountType, prod.hasDeal!.discount))
            .toStringAsFixed(2);
      } else {
        if (sellingPrice(prod.minSellPrice, prod.hasDeal!.discountType,
                prod.hasDeal!.discount) ==
            sellingPrice(prod.maxSellingPrice, prod.hasDeal!.discountType,
                prod.hasDeal!.discount))
          priceText = singlePrice(sellingPrice(prod.minSellPrice,
                  prod.hasDeal!.discountType, prod.hasDeal!.discount))
              .toStringAsFixed(2);
        else {
          priceText = singlePrice(sellingPrice(prod.minSellPrice,
                  prod.hasDeal!.discountType, prod.hasDeal!.discount))
              .toStringAsFixed(2);
        }
      }
    } else {
      if (prod.product!.productType == 1) {
        if (prod.hasDiscount == 'yes') {
          priceText = singlePrice(sellingPrice(
                  prod.maxSellingPrice, prod.discountType, prod.discount))
              .toStringAsFixed(2);
        } else {
          priceText = singlePrice(prod.maxSellingPrice!).toStringAsFixed(2);
        }
      } else {
        ///variant product
        if (sellingPrice(prod.minSellPrice, prod.discountType, prod.discount) ==
            sellingPrice(
                prod.maxSellingPrice, prod.discountType, prod.discount)) {
          if (prod.hasDiscount == 'yes') {
            priceText = singlePrice(sellingPrice(prod.skus!.first.sellingPrice,
                    prod.discountType, prod.discount))
                .toStringAsFixed(2);
          } else {
            priceText =
                singlePrice(prod.skus!.first.sellingPrice!).toStringAsFixed(2);
          }
        } else {
          var priceA;
          var priceB;
          if (prod.hasDiscount == 'yes') {
            priceA = singlePrice(sellingPrice(prod.skus!.first.sellingPrice,
                    prod.discountType, prod.discount))
                .toStringAsFixed(2);
            priceB = singlePrice(sellingPrice(prod.skus!.last.sellingPrice,
                    prod.discountType, prod.discount))
                .toStringAsFixed(2);
          } else {
            priceA =
                singlePrice(prod.skus!.first.sellingPrice!).toStringAsFixed(2);
            priceB =
                singlePrice(prod.skus!.last.sellingPrice!).toStringAsFixed(2);
          }
          priceText = '$priceA - $priceB';
        }
      }
    }
    return priceText;
  }

  dynamic sellingPrice(amount, discountType, discountAmount) {
    var discount = 0.0;
    if (discountType == "0" || discountType == 0) {
      discount = (amount / 100) * discountAmount;
    }
    if (discountType == "1" || discountType == 1) {
      discount = discountAmount;
    }
    var sellingPrice = amount - discount;
    return sellingPrice;
  }

  double singlePrice(double price) {
    return price * conversionRate.value;
  }

// dynamic getMin(List<ProductSkus> skus) {
//   skus.sort((u2, u1) => u2.sellingPrice.toInt() - u1.sellingPrice.toInt());
//   return skus.first.sellingPrice;
// }
//
// dynamic getMax(List<ProductSkus> skus) {
//   skus.sort((u1, u2) => u2.sellingPrice.toInt() - u1.sellingPrice.toInt());
//   return skus.first.sellingPrice;
// }
}
