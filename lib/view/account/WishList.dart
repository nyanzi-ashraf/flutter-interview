import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/home_controller.dart';
import 'package:amazcart/controller/my_wishlist_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/model/MyWishListModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/cart/AddToCartWidget.dart';
import 'package:amazcart/view/products/product/ProductDetails.dart';
import 'package:amazcart/view/seller/StoreHome.dart';
import 'package:amazcart/widgets/cart_icon_widget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  final MyWishListController wishListController =
      Get.put(MyWishListController());
  final HomeController controller = Get.put(HomeController());
  final CurrencyController _currencyController = Get.put(CurrencyController());

  String calculateGiftCardPrice(WishListProduct productModel) {
    String amountText;

    if (productModel.giftcard!.discount > 0) {
      ///percentage - type
      if (productModel.giftcard!.discountType == 0) {
        amountText = ((productModel.giftcard!.sellingPrice -
                        ((productModel.giftcard!.discount / 100) *
                            productModel.giftcard!.sellingPrice)) *
                    _currencyController.conversionRate.value)
                .toString() +
            '${_currencyController.appCurrency.value}';
      } else {
        ///minus - type
        ///no variant
        amountText = ((productModel.giftcard!.sellingPrice -
                        productModel.giftcard!.discount) *
                    _currencyController.conversionRate.value)
                .toString() +
            '${_currencyController.appCurrency.value}';
      }
    } else {
      ///
      ///no discount
      ///
      amountText = (productModel.giftcard!.sellingPrice *
                  _currencyController.conversionRate.value)
              .toString() +
          '${_currencyController.appCurrency.value}';
    }
    return amountText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
        actions: [
          CartIconWidget(),
        ],
        title: Obx(() {
          if (wishListController.isLoading.value) {
            return Text(
              'My Wishlist'.tr,
              style: AppStyles.appFont.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: AppStyles.blackColor),
            );
          }
          return Text(
            'My Wishlist'.tr + ' (${wishListController.wishListCount.value})',
            style: AppStyles.appFont.copyWith(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppStyles.blackColor,
            ),
          );
        }),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        if (wishListController.isLoading.value) {
          return Center(
            child: CustomLoadingWidget(),
          );
        } else {
          if (wishListController.wishListModel.value.products == null ||
              wishListController.wishListModel.value.products!.length == 0) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Icon(
                    FontAwesomeIcons.exclamation,
                    color: AppStyles.pinkColor,
                    size: 25,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'No Products found'.tr,
                    textAlign: TextAlign.center,
                    style: AppStyles.kFontPink15w5.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount:
                    wishListController.wishListModel.value.products!.length,
                itemBuilder: (context, index) {
                  List<WishListProduct> value = wishListController
                      .wishListModel.value.products!.values
                      .elementAt(index);
                  return Column(
                    children: [
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            _currencyController.vendorType.value == "single"
                                ? SizedBox.shrink()
                                : InkWell(
                                    onTap: () {
                                      print(
                                          'Seller id: ${value[0].seller!.id}');
                                      Get.to(() => StoreHome(
                                            sellerId: value[0].seller!.id!,
                                          ));
                                    },
                                    child: Container(
                                      height: 40,
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              value[0].seller!.firstName!,
                                              style: AppStyles.appFont.copyWith(
                                                color: AppStyles.blackColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            height: 70,
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              size: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            Column(
                              children:
                                  List.generate(value.length, (prodIndex) {
                                return GestureDetector(
                                  onTap: () {
                                    if (value[prodIndex].type ==
                                        ProductType.PRODUCT) {
                                      Get.to(
                                        () => ProductDetails(
                                          productID:
                                              value[prodIndex].product!.id,
                                        ),
                                      );
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        color: AppStyles.appBackgroundColor,
                                        thickness: 4,
                                        height: 0,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 65,
                                            width: 65,
                                            child: value[prodIndex].type ==
                                                    ProductType.PRODUCT
                                                ? Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        value[prodIndex]
                                                            .product!
                                                            .product!
                                                            .thumbnailImageSource!,
                                                  )
                                                : Image.network(
                                                    AppConfig.assetPath +
                                                        '/' +
                                                        value[prodIndex]
                                                            .giftcard!
                                                            .thumbnailImage!,
                                                  ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    value[prodIndex].type ==
                                                            ProductType.PRODUCT
                                                        ? value[prodIndex]
                                                            .product!
                                                            .productName!
                                                            .capitalizeFirst!
                                                        : value[prodIndex]
                                                            .giftcard!
                                                            .name!
                                                            .capitalizeFirst!,
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color:
                                                          AppStyles.blackColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        value[prodIndex]
                                                                    .type! ==
                                                                ProductType
                                                                    .PRODUCT
                                                            ? _currencyController
                                                                .calculatePrice(
                                                                    value[prodIndex]
                                                                        .product)!
                                                            : calculateGiftCardPrice(
                                                                value[
                                                                    prodIndex]),
                                                        style: AppStyles.appFont
                                                            .copyWith(
                                                          color: AppStyles
                                                              .pinkColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        value[prodIndex].type ==
                                                                ProductType
                                                                    .PRODUCT
                                                            ? value[prodIndex]
                                                                        .product!
                                                                        .discount! >
                                                                    0
                                                                ? '(Price dropped)'
                                                                : ''
                                                            : value[prodIndex]
                                                                        .giftcard!
                                                                        .discount >
                                                                    0
                                                                ? '(Price dropped)'
                                                                : '',
                                                        style: AppStyles.appFont
                                                            .copyWith(
                                                          color: AppStyles
                                                              .darkBlueColor,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    _currencyController
                                                        .calculateMainPrice(
                                                            value[prodIndex]
                                                                .product),
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color: AppStyles
                                                          .greyColorDark,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      decorationColor:
                                                          AppStyles.pinkColor,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            print(
                                                                value[prodIndex]
                                                                    .id);
                                                            wishListController
                                                                .deleteWishListProduct(
                                                                    value[prodIndex]
                                                                        .id);
                                                          },
                                                          child: Container(
                                                              height: 30,
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/images/wishlist_delete.svg')),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            await Get
                                                                .bottomSheet(
                                                              AddToCartWidget(value[
                                                                      prodIndex]
                                                                  .sellerProductId),
                                                              isScrollControlled:
                                                                  true,
                                                              backgroundColor:
                                                                  Colors
                                                                      .transparent,
                                                              persistent: true,
                                                            );
                                                            Get.delete<
                                                                ProductDetailsController>();

                                                            // final ProductDetailsController
                                                            // productDetailsController =
                                                            // Get.put(
                                                            //     ProductDetailsController());
                                                            // await productDetailsController
                                                            //     .getProductDetails(value[prodIndex]
                                                            //     .sellerProductId)
                                                            //     .then(
                                                            //         (v) {
                                                            //           productDetailsController
                                                            //               .itemQuantity
                                                            //               .value = productDetailsController.products!.value.data.product.minimumOrderQty;
                                                            //       productDetailsController.productId.value = value[prodIndex].sellerProductId;
                                                            //
                                                            //     });
                                                          },
                                                          child: Container(
                                                              height: 30,
                                                              width: 30,
                                                              child: SvgPicture
                                                                  .asset(
                                                                      'assets/images/wishlist_cart.svg')),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                });
          }
        }
      }),
    );
  }
}
