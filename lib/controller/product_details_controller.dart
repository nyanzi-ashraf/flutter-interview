import 'dart:convert';

import 'package:amazcart/config/config.dart';

import 'package:amazcart/model/NewModel/Product/ProductDetailsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductSkus.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/model/NewModel/Product/Review.dart';
import 'package:amazcart/model/NewModel/ShippingMethod/ShippingMethodElement.dart';
import 'package:amazcart/model/NewModel/Product/SellerSkuModel.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as DIO;

class ProductDetailsController extends GetxController {
  var products = ProductDetailsModel().obs;

  var isLoading = false.obs;

  var productId = 0.obs;

  // ignore: deprecated_member_use
  var productReviews = <Review>[].obs;

  // ignore: deprecated_member_use
  var giftCardReviews = <Review>[].obs;

  var visibleSKU = ProductSku().obs;

  var productSKU = SkuData().obs;

  var isSkuLoading = false.obs;

  var finalPrice = 0.0.obs;
  var productPrice = 0.0.obs;

  dynamic discount;
  dynamic discountType;

  var itemQuantity = 1.obs;

  var minOrder = 1.obs;
  var maxOrder = 1.obs;

  var productSkuID = 0.obs;

  var shippingID = 0.obs;

  Map getSKU = {};

  var stockManage = 0.obs;
  var stockCount = 0.obs;
  var isCartLoading = false.obs;

  var shippingValue = ShippingMethodElement().obs;

  Future fetchProductDetails(id) async {
    try {
      print(productId.value);
      Uri userData = Uri.parse(URLs.ALL_PRODUCTS + '/$id');
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] != 'not found') {
        return ProductDetailsModel.fromJson(jsonString);
      } else {
        Get.back();
        SnackBars().snackBarWarning('not found');
      }
    } catch (e) {
      print(e);
    }
    return ProductDetailsModel();
  }

  Future getProductDetails2(id) async {
    try {
      isCartLoading(true);
      var data = await fetchProductDetails(id);
      if (data != null) {
        products.value = data;
        productReviews.value = data.data.reviews
            .where((element) => element.type == ProductType.PRODUCT)
            .toList();
        visibleSKU.value = products.value.data!.product!.skus!.first;

        if (products.value.data!.discountStartDate != null &&
            products.value.data!.discountStartDate != '') {
          var endDate =
              DateTime.parse('${products.value.data!.discountEndDate}');
          if (endDate.millisecondsSinceEpoch <
              DateTime.now().millisecondsSinceEpoch) {
            discount = 0;
          } else {
            discount = products.value.data!.discount;
          }
        } else {
          discount = products.value.data!.discount;
        }
        discountType = products.value.data!.discountType;
        minOrder.value = products.value.data!.product!.minimumOrderQty;
        maxOrder.value = products.value.data!.product!.maxOrderQty;
        shippingID.value = products
            .value.data!.product!.shippingMethods!.first.shippingMethodId!;

        itemQuantity.value = products.value.data!.product!.minimumOrderQty;

        print('max ${maxOrder.value}');

        if (products.value.data!.variantDetails!.length > 0) {
          await skuGet();
        } else {
          stockManage.value = products.value.data!.stockManage;
          stockCount.value = products.value.data!.skus!.first.productStock!;

          print('StockMAnage ${stockManage.value}');
          print('stockCount ${stockCount.value}');
          visibleSKU.value = products.value.data!.product!.skus!.first;
        }
        productSkuID.value = products.value.data!.skus!.first.id!;
      } else {
        products.value = ProductDetailsModel();
      }
      calculatePrice();
    } catch (e) {
      print(e.toString());
      isCartLoading(false);
    } finally {
      isCartLoading(false);
    }
    // return ProductDetailsModel();
  }

  Future skuGet() async {
    for (var i = 0; i < products.value.data!.variantDetails!.length; i++) {
      getSKU.addAll({
        'id[$i]':
            "${products.value.data!.variantDetails![i].attrValId!.first}-${products.value.data!.variantDetails![i].attrId}"
      });
    }
    getSKU.addAll({
      'product_id': products.value.data!.id,
      'user_id': products.value.data!.userId
    });
    print("SKU PRICE GET ${getSKU.toString()}");
    await getSkuWisePrice(getSKU);
  }

  Future getSkuWisePrice(Map data) async {
    print(jsonEncode(data));
    try {
      isSkuLoading(true);
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
        getProductDetails2(data['product_id']).then((value) {
          itemQuantity.value = products.value.data!.product!.minimumOrderQty;
          productId.value = data['product_id'];

          shippingValue.value =
              products.value.data!.product!.shippingMethods!.first;
        });
      } else {
        final returnData = new Map<String, dynamic>.from(response.data);
        discount = returnData['data']['product']['discount'];
        discountType = returnData['data']['product']['discount_type'];
        // visibleSKU.value = ProductSkus.fromJson(returnData['data']['sku']);
        productSKU.value = SkuData.fromJson(returnData['data']);
        productSkuID.value = returnData['data']['id'];
        stockManage.value = products.value.data!.stockManage;
        stockCount.value = productSKU.value.productStock;

        print('StockMAnage ${stockManage.value}');
        print('stockCount ${stockCount.value}');

        itemQuantity.value = products.value.data!.product!.minimumOrderQty;
        calculatePriceAfterSku();
      }
    } catch (e) {
      isSkuLoading(false);
      print(e.toString());
    } finally {
      isSkuLoading(false);
    }
  }

  void calculatePrice() {
    print('calculate price');
    if (products.value.data!.hasDeal != null) {
      if (products.value.data!.hasDeal!.discountType == 0) {
        finalPrice.value = products.value.data!.skus!.first.sellingPrice! -
            ((products.value.data!.hasDeal!.discount! / 100) *
                products.value.data!.skus!.first.sellingPrice!);
        productPrice.value = products.value.data!.skus!.first.sellingPrice! -
            ((products.value.data!.hasDeal!.discount! / 100) *
                products.value.data!.skus!.first.sellingPrice!);
      } else {
        finalPrice.value = products.value.data!.skus!.first.sellingPrice! -
            products.value.data!.hasDeal!.discount!;
        productPrice.value = products.value.data!.skus!.first.sellingPrice! -
            products.value.data!.hasDeal!.discount!;
      }
    } else {
      if (discount > 0) {
        print('here dis asce');

        ///percentage - type
        if (discountType == "0" || discountType == 0) {
          ///has variant
          ///
          finalPrice.value = products.value.data!.skus!.first.sellingPrice! -
              ((discount / 100) *
                  products.value.data!.skus!.first.sellingPrice!);
          productPrice.value = products.value.data!.skus!.first.sellingPrice! -
              ((discount / 100) *
                  products.value.data!.skus!.first.sellingPrice!);
        } else {
          ///has variant
          finalPrice.value =
              products.value.data!.skus!.first.sellingPrice! - discount;
          productPrice.value =
              products.value.data!.skus!.first.sellingPrice! - discount;
        }
      } else {
        ///
        ///no discount
        ///
        ///has variant
        finalPrice.value = products.value.data!.skus!.first.sellingPrice!;
        productPrice.value = products.value.data!.skus!.first.sellingPrice!;
      }
    }
  }

  void calculatePriceAfterSku() {
    print('calculate price after sku');
    if (products.value.data!.hasDeal != null) {
      if (products.value.data!.hasDeal!.discountType == 0) {
        finalPrice.value = productSKU.value.sellingPrice -
            ((products.value.data!.hasDeal!.discount! / 100) *
                productSKU.value.sellingPrice);
        productPrice.value = productSKU.value.sellingPrice -
            ((products.value.data!.hasDeal!.discount! / 100) *
                productSKU.value.sellingPrice);
      } else {
        finalPrice.value = productSKU.value.sellingPrice -
            products.value.data!.hasDeal!.discount;
        productPrice.value = productSKU.value.sellingPrice -
            products.value.data!.hasDeal!.discount;
      }
    } else {
      if (discount > 0) {
        ///percentage - type
        if (discountType == "0") {
          ///has variant
          ///
          finalPrice.value = productSKU.value.sellingPrice -
              ((discount / 100) * productSKU.value.sellingPrice);
          productPrice.value = productSKU.value.sellingPrice -
              ((discount / 100) * productSKU.value.sellingPrice);
        } else {
          ///has variant
          finalPrice.value = productSKU.value.sellingPrice - discount;
          productPrice.value = productSKU.value.sellingPrice - discount;
        }
      } else {
        ///
        ///no discount
        ///
        ///has variant
        finalPrice.value = productSKU.value.sellingPrice;
        productPrice.value = productSKU.value.sellingPrice;
      }
    }
    print("Selling Price ${productSKU.value.sellingPrice}");
    print("Product Price after check ${productPrice.value}");
  }

  void cartIncrease() {
    if (maxOrder.value != null) {
      if (itemQuantity.value < maxOrder.value) {
        itemQuantity.value++;
      }
    } else {
      itemQuantity.value++;
    }

    finalPrice.value = productPrice.roundToDouble() * itemQuantity.value;
  }

  void cartDecrease() {
    if (itemQuantity.value > minOrder.value) {
      itemQuantity.value--;
      finalPrice.value = productPrice * itemQuantity.value;
    }
  }

  @override
  void onInit() {
    // getProductDetails();
    super.onInit();
  }

  @override
  void onClose() {
    print('onclose');
    super.onClose();
  }
}
