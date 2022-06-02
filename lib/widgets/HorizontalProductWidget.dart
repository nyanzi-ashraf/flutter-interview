import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/product_details_controller.dart';
import 'package:amazcart/model/NewModel/Product/ProductModel.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/cart/AddToCartGiftCard.dart';
import 'package:amazcart/view/cart/AddToCartWidget.dart';
import 'package:amazcart/view/products/product/ProductDetails.dart';
import 'package:amazcart/widgets/StarCounterWidget.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HorizontalProductWidget extends StatefulWidget {
  final ProductModel? productModel;
  HorizontalProductWidget({this.productModel});
  @override
  _HorizontalProductWidgetState createState() =>
      _HorizontalProductWidgetState();
}

class _HorizontalProductWidgetState extends State<HorizontalProductWidget> {
  final CurrencyController currencyController = Get.put(CurrencyController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (widget.productModel!.productType! == ProductType.PRODUCT) {
          Get.to(() => ProductDetails(productID: widget.productModel!.id),
              preventDuplicates: false);
        }
      },
      child: Container(
        width: 180,
        padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        widget.productModel!.productType! !=
                                ProductType.GIFT_CARD
                            ? FancyShimmerImage(
                                imageUrl: AppConfig.assetPath +
                                    '/' +
                                    widget.productModel!.product!
                                        .thumbnailImageSource!,
                                boxFit: BoxFit.contain,
                                errorWidget: FancyShimmerImage(
                                  imageUrl:
                                      "${AppConfig.assetPath}/backend/img/default.png",
                                  boxFit: BoxFit.contain,
                                ),
                              )
                            : FancyShimmerImage(
                                imageUrl: AppConfig.assetPath +
                                    '/' +
                                    widget
                                        .productModel!.giftCardThumbnailImage!,
                                boxFit: BoxFit.contain,
                                errorWidget: FancyShimmerImage(
                                  imageUrl:
                                      "${AppConfig.assetPath}/backend/img/default.png",
                                  boxFit: BoxFit.contain,
                                ),
                              ),
                        widget.productModel!.productType! ==
                                ProductType.GIFT_CARD
                            ? Positioned(
                                top: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: widget.productModel!.giftCardEndDate!
                                              .compareTo(DateTime.now()) >
                                          0
                                      ? Container(
                                          padding: EdgeInsets.all(4),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: AppStyles.pinkColor,
                                          ),
                                          child: Text(
                                            widget.productModel!.discountType ==
                                                        "0" ||
                                                    widget.productModel!
                                                            .discountType! ==
                                                        0
                                                ? '-${widget.productModel!.discount.toString()}% '
                                                : '${(widget.productModel!.discount! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                                            textAlign: TextAlign.center,
                                            style: AppStyles.appFont.copyWith(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              )
                            : Positioned(
                                top: 0,
                                right: 0,
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: widget.productModel!.hasDeal != null
                                      ? widget.productModel!.hasDeal!
                                                  .discount! >
                                              0
                                          ? Container(
                                              padding: EdgeInsets.all(4),
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: AppStyles.pinkColor,
                                              ),
                                              child: Text(
                                                widget.productModel!.hasDeal!
                                                            .discountType ==
                                                        0
                                                    ? '${widget.productModel!.hasDeal!.discount.toString()}% '
                                                    : '${(widget.productModel!.hasDeal!.discount! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                                                textAlign: TextAlign.center,
                                                style:
                                                    AppStyles.appFont.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            )
                                          : Container()
                                      : widget.productModel!
                                                      .discountStartDate !=
                                                  null &&
                                              currencyController.endDate
                                                      .millisecondsSinceEpoch <
                                                  DateTime.now()
                                                      .millisecondsSinceEpoch
                                          ? Container()
                                          : widget.productModel!.discount! > 0
                                              ? Container(
                                                  padding: EdgeInsets.all(4),
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: AppStyles.pinkColor,
                                                  ),
                                                  child: Text(
                                                    widget.productModel!
                                                                .discountType ==
                                                            "0"
                                                        ? '-${widget.productModel!.discount.toString()}% '
                                                        : '${(widget.productModel!.discount! * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value} ',
                                                    textAlign: TextAlign.center,
                                                    style: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                )
                                              : Container(),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        widget.productModel!.productType! == ProductType.PRODUCT
                            ? widget.productModel!.productName.toString()
                            : widget.productModel!.giftCardName.toString(),
                        style: AppStyles.appFont.copyWith(
                          color: AppStyles.blackColor,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 5),
                      widget.productModel!.hasDeal != null
                          ? widget.productModel!.hasDeal!.discount! > 0
                              ? Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.start,
                                  runSpacing: 2,
                                  spacing: 2,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                      '${currencyController.calculatePrice(widget.productModel)}${currencyController.appCurrency.value}',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFont.copyWith(
                                        fontSize: 12,
                                        color: AppStyles.pinkColor,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      '${currencyController.calculateMainPrice(widget.productModel)}',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFont.copyWith(
                                        fontSize: 12,
                                        color: AppStyles.greyColorDark,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                )
                              : Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.start,
                                  runSpacing: 2,
                                  spacing: 2,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    Text(
                                      '${currencyController.calculatePrice(widget.productModel)}${currencyController.appCurrency.value}',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFont.copyWith(
                                        fontSize: 12,
                                        color: AppStyles.pinkColor,
                                      ),
                                    ),
                                  ],
                                )
                          : Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              alignment: WrapAlignment.start,
                              runSpacing: 2,
                              spacing: 2,
                              runAlignment: WrapAlignment.start,
                              children: [
                                Text(
                                  '${currencyController.calculatePrice(widget.productModel)}${currencyController.appCurrency.value}',
                                  style: AppStyles.appFont.copyWith(
                                    fontSize: 12,
                                    color: AppStyles.pinkColor,
                                  ),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  '${currencyController.calculateMainPrice(widget.productModel)}',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.appFont.copyWith(
                                    fontSize: 12,
                                    color: AppStyles.greyColorDark,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              widget.productModel!.avgRating > 0
                                  ? StarCounterWidget(
                                      value: widget.productModel!.rating
                                          .toDouble(),
                                      color: Colors.amber,
                                      size: 12,
                                    )
                                  : StarCounterWidget(
                                      value: 0,
                                      color: Colors.amber,
                                      size: 12,
                                    ),
                              SizedBox(
                                width: 2,
                              ),
                              widget.productModel!.avgRating > 0
                                  ? Text(
                                      '(${widget.productModel!.rating.toString()})',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFont.copyWith(
                                        color: AppStyles.greyColorDark,
                                        fontSize: 12,
                                      ),
                                    )
                                  : Text(
                                      '(0)',
                                      overflow: TextOverflow.ellipsis,
                                      style: AppStyles.appFont.copyWith(
                                        color: AppStyles.greyColorDark,
                                        fontSize: 12,
                                      ),
                                    ),
                            ],
                          ),
                          Expanded(child: Container()),
                          InkWell(
                            onTap: () async {
                              if (widget.productModel!.productType! ==
                                  ProductType.PRODUCT) {
                                await Get.bottomSheet(
                                  AddToCartWidget(widget.productModel!.id),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  persistent: true,
                                );
                                Get.delete<ProductDetailsController>();
                              } else {
                                await Get.bottomSheet(
                                  AddToCartGiftCard(widget.productModel!),
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  persistent: true,
                                );
                              }
                            },
                            child: Container(
                              height: 35,
                              width: 35,
                              child: SvgPicture.asset(
                                  'assets/images/cart_rounded.svg'),
                              // width: 30.w,
                              // height: 30.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
