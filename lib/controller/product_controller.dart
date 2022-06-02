import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/Product/AllProductsModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  Dio _dio = Dio();

  @override
  void onInit() {
    getAllProducts();
    super.onInit();
  }

  var isProductLoading = false.obs;
  var isMoreProductLoading = false.obs;
  var productPageNumber = 1.obs;
  var productLastPage = false.obs;
  var allProducts = <ProductModel>[].obs;

  Future<List<ProductModel>> getAllProducts() async {
    print('get all prod');
    AllProductsModel parentCategoryElement = AllProductsModel();
    try {
      isProductLoading(true);
      isMoreProductLoading(true);
      await _dio.get(URLs.ALL_PRODUCTS, queryParameters: {
        'page': productPageNumber,
      }).then((value) {
        final data = new Map<String, dynamic>.from(value.data);
        parentCategoryElement = AllProductsModel.fromJson(data);
        print(parentCategoryElement.data!.length);
        if (parentCategoryElement.data!.length == 0) {
          isMoreProductLoading(false);
          productLastPage(true);
        } else {
          isMoreProductLoading(true);
          allProducts.addAll(parentCategoryElement.data!);
        }
      }).catchError((error) {
        if (error is DioError) {
          print(error.response);
        }
        isMoreProductLoading(false);
        productLastPage(true);
        print('ERROR is $error');
      });
    } catch (e) {
      isProductLoading(false);
      print(e.toString());
    } finally {
      isProductLoading(false);
      isMoreProductLoading(false);
    }
    return allProducts;
  }

  Future<List<ProductModel>> getFreeDeliveryProducts() async {
    print('get free del');
    AllProductsModel parentCategoryElement = AllProductsModel();
    try {
      isProductLoading(true);
      isMoreProductLoading(true);
      await _dio.get(URLs.ALL_PRODUCTS, queryParameters: {
        'page': productPageNumber,
      }).then((value) {
        final data = new Map<String, dynamic>.from(value.data);
        parentCategoryElement = AllProductsModel.fromJson(data);
        print(parentCategoryElement.data!.length);
        if (parentCategoryElement.data!.length == 0) {
          isMoreProductLoading(false);
          productLastPage(true);
        } else {
          isMoreProductLoading(true);
          allProducts.addAll(parentCategoryElement.data!.where((element) =>
              element.product!.skus!.first.additionalShipping <= 0 ||
              element.product!.shippingCost! <= 0 ||
              element.product!.shippingMethods!.first.shippingMethod!.cost! <=
                  0));
        }
      }).catchError((error) {
        if (error is DioError) {
          print(error.response);
        }
        isMoreProductLoading(false);
        productLastPage(true);
        print('ERROR is $error');
      });
    } catch (e) {
      isProductLoading(false);
      print(e.toString());
    } finally {
      isProductLoading(false);
      isMoreProductLoading(false);
    }
    return allProducts;
  }

  Future<List<ProductModel>> sortProducts({
    int? paginate,
    String? sortBy,
  }) async {
    print(URLs.SORT_ALL_PRODUCTS + '?&sort_by=$sortBy');
    print('sort prods');
    AllProductsModel parentCategoryElement = AllProductsModel();
    try {
      allProducts.clear();
      isProductLoading(true);
      isMoreProductLoading(true);
      await _dio.get(URLs.SORT_ALL_PRODUCTS, queryParameters: {
        'page': productPageNumber,
      }).then((value) {
        final data = new Map<String, dynamic>.from(value.data);
        parentCategoryElement = AllProductsModel.fromJson(data);
        print(parentCategoryElement.data!.length);
        if (parentCategoryElement.data!.length == 0) {
          isMoreProductLoading(false);
          productLastPage(true);
        } else {
          isMoreProductLoading(true);
          allProducts.addAll(parentCategoryElement.data!);
        }
      }).catchError((error) {
        if (error is DioError) {
          print(error.response);
        }
        isMoreProductLoading(false);
        productLastPage(true);
        print('ERROR is $error');
      });
    } catch (e) {
      isProductLoading(false);
      print(e.toString());
    } finally {
      isProductLoading(false);
      isMoreProductLoading(false);
    }
    return allProducts;
  }
}
