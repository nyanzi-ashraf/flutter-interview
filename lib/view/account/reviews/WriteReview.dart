import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/model/NewModel/Order/OrderProductElement.dart';
// import 'package:amazcart/model/NewModel/Order/OrderproductElement!.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/model/NewModel/Product/ProductType.dart';
import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/order_controller.dart';
import 'package:amazcart/controller/review_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:url_launcher/url_launcher.dart';

class WriteReview extends StatefulWidget {
  final Package? package;

  final int? productID;
  final int? sellerID;
  final int? orderID;
  final int? packageID;

  // final List<int> productIds;
  final String? type;

  WriteReview(
      {this.package,
      this.productID,
      this.sellerID,
      this.orderID,
      this.packageID,
      // this.productIds,
      this.type});

  @override
  _WriteReviewState createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  final ReviewController reviewController = Get.put(ReviewController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  double productRating = 5.0;
  double sellerRating = 5.0;

  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();

  var formData = DIO.FormData();

  var prod;
  var prodRating = <String, dynamic>{};

  List<TextEditingController> productReviewController = [];

  final TextEditingController sellerReviewController = TextEditingController();

  List<int>? productIds;

  var tokenKey = "token";
  GetStorage userToken = GetStorage();

  List<Model> list = [];

  var img;

  var images = <String, List<File>>{};

  List<MapEntry<String, DIO.MultipartFile>> mapImages = [];

  List<MapEntry<String, String>> listRating = [];

  @override
  void initState() {
    // print({
    //   'product_id': ,
    //   'seller_id': widget.sellerID,
    //   'order_id': widget.orderID,
    //   'package_id': widget.package!ID,
    // });
    // productIds = widget.productIds;
    list.add(Model([File('')]));
    this.formData.fields.addAll([
      MapEntry(
        'seller_id',
        widget.sellerID.toString(),
      ),
      MapEntry(
        'order_id',
        widget.orderID.toString(),
      ),
      MapEntry(
        'package_id',
        widget.packageID.toString(),
      ),
    ]);
    print(formData.fields);
    super.initState();
  }

  Future submitReview(DIO.FormData body) async {
    String token = await userToken.read(tokenKey);

    print('BODY FIELDS ${body.fields}');
    print('BODY FILES ${body.files}');

    // return null;
    try {
      EasyLoading.show(
          maskType: EasyLoadingMaskType.none, indicator: CustomLoadingWidget());
      response = await dio.post(
        URLs.ORDER_REVIEW,
        options: DIO.Options(
          followRedirects: false,
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
          },
          // validateStatus: (status){
          //   print(response!.data);
          // }
        ),
        onSendProgress: (received, total) {
          if (total != -1) {
            print((received / total * 100).toStringAsFixed(0) + '%');
            // _progress = (received / total);
            // EasyLoading.showProgress(_progress,
            //     status: '${(received / total * 100).toStringAsFixed(0)}%');
            // if (_progress >= 1) {
            //   _timer?.cancel();
            //   EasyLoading.dismiss();
            // }
          }
        },
        data: body,
      );
      print(response);
      print(response!.statusCode);
      if (response!.statusCode == 201) {
        EasyLoading.dismiss();
        Get.snackbar(
          'Review Done'.tr,
          "Thanks for your feedback.".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 5,
        );
        Future.delayed(Duration(seconds: 5), () {
          final OrderController orderController = Get.put(OrderController());
          orderController.getAllOrders();
          Get.back();
        });
      } else if (response!.statusCode == 401) {
        EasyLoading.dismiss();
        Get.snackbar(
          'Invalid Credentials'.tr,
          "Unauthorized".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
      }
    } on DIO.DioError catch (e) {
      EasyLoading.dismiss();
      var jsonString = jsonDecode(e.response!.toString());

      if (jsonString == null) {
        Get.back();
        Get.snackbar(
          'Something went wrong'.tr,
          "Please try again. Thank you.".tr,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppStyles.pinkColor,
          colorText: Colors.white,
          borderRadius: 5,
        );
      }

      print(jsonString);

      String errorText1;
      String errorText2;

      bool isNullEmptyOrFalse(Object o) => o == null || false == o || "" == o;

      if (isNullEmptyOrFalse(jsonString['errors'])) {
        errorText1 = "";
        errorText2 = "";
      } else {
        if (isNullEmptyOrFalse(jsonString['errors']['product_review'])) {
          errorText1 = "";
        } else {
          errorText1 = jsonString['errors']['product_review']
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '');
        }
        if (isNullEmptyOrFalse(jsonString['errors']['seller_review'])) {
          errorText2 = "";
        } else {
          errorText2 = jsonString['errors']['seller_review']
              .toString()
              .replaceAll('[', '')
              .replaceAll(']', '');
        }
      }
      Get.back();
      Get.snackbar(
        '${jsonString['message']}',
        "$errorText1$errorText2",
        snackPosition: SnackPosition.TOP,
        backgroundColor: AppStyles.pinkColor,
        colorText: Colors.white,
        borderRadius: 5,
      );
    }
  }

  Widget rateProduct(OrderProductElement productElement, productIndex) {
    // if (productElement!.type == ProductType.PRODUCT) {
    //   prod =
    //   'product_rating_${widget.package!.products![productIndex].sellerProductSku!.productId}';
    // } else {
    //   prod =
    //   'giftcard_rating_${widget.package!.products![productIndex].giftCard!.id}';
    // }
    productReviewController.add(new TextEditingController());
    // prodRating.addAll({
    //   prod: 5.0.toString(),
    // });
    // print(prodRating);
    // this.formData.fields.add(
    //   MapEntry(prod, 5.toString()),
    // );
    list.add(Model([File("")]));
    return Container(
      margin: EdgeInsets.only(top: 5, bottom: 10),
      decoration: BoxDecoration(
        color: AppStyles.appBackgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    child: Container(
                      height: 80,
                      width: 80,
                      child: productElement!.type == ProductType.GIFT_CARD
                          ? Image.network(
                              AppConfig.assetPath +
                                  '/' +
                                  productElement!.giftCard!.thumbnailImage!,
                              fit: BoxFit.cover,
                            )
                          : Image.network(
                              AppConfig.assetPath +
                                  '/' +
                                  productElement!.sellerProductSku!.product!
                                      .product!.thumbnailImageSource!,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          productElement!.type == ProductType.GIFT_CARD
                              ? Text(
                                  productElement!.giftCard!.name!,
                                  style: AppStyles.kFontBlack14w5,
                                )
                              : Text(
                                  productElement!.sellerProductSku!.product!
                                      .product!.productName!,
                                  style: AppStyles.kFontBlack14w5,
                                ),
                          productElement!.type != ProductType.GIFT_CARD
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: productElement!.sellerProductSku!
                                      .productVariations!.length,
                                  itemBuilder: (context, variantIndex) {
                                    if (productElement
                                            .sellerProductSku!
                                            .productVariations![variantIndex]
                                            .attribute!
                                            .name ==
                                        'Color') {
                                      return Text(
                                        'Color: ${productElement!.sellerProductSku!.productVariations![variantIndex].attributeValue!.color!.name}',
                                        style: AppStyles.kFontBlack12w4,
                                      );
                                    } else {
                                      return Text(
                                        '${productElement!.sellerProductSku!.productVariations![variantIndex].attribute!.name}: ${productElement!.sellerProductSku!.productVariations![variantIndex].attributeValue!.value}',
                                        style: AppStyles.kFontBlack12w4,
                                      );
                                    }
                                  },
                                )
                              : Container(),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${(productElement!.price * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                        style: AppStyles.kFontPink15w5,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        '(${productElement!.qty}x)',
                                        style: AppStyles.kFontBlack14w5,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    child: RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      maxRating: 5,
                                      direction: Axis.horizontal,
                                      allowHalfRating: false,
                                      itemCount: 5,
                                      itemSize: 30,
                                      glow: false,
                                      itemPadding:
                                          EdgeInsets.symmetric(horizontal: 0.0),
                                      itemBuilder: (context, _) {
                                        return Icon(
                                          Icons.star,
                                          color: AppStyles.goldenYellowColor,
                                          size: 20,
                                        );
                                      },
                                      onRatingUpdate: (rating) {
                                        // print(rating);
                                        // print('product_rating_${widget.productIds[productIndex]}');

                                        if (widget.package!
                                                .products![productIndex].type ==
                                            ProductType.PRODUCT) {
                                          prod =
                                              'product_rating_${widget.package!.products![productIndex].sellerProductSku!.productId}';
                                        } else if (widget.package!
                                                .products![productIndex].type ==
                                            ProductType.GIFT_CARD) {
                                          prod =
                                              'giftcard_rating_${widget.package!.products![productIndex].giftCard!.id}';
                                        }
                                        prodRating.addAll({
                                          prod: rating.toString(),
                                        });
                                        // this.formData.fields.remove(
                                        //       MapEntry(prod, 5.toString()),
                                        //     );
                                        // this.formData.fields.addAll(
                                        //   [MapEntry(prod, rating.toString())],
                                        // );

                                        // listRating.toSet().toList().add(
                                        //     MapEntry(prod, rating.toString()));
                                        print(prodRating);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
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
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Container(
                decoration: BoxDecoration(
                    color: Color(0xffF6FAFC),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: TextFormField(
                  controller: productReviewController[productIndex],
                  decoration: productElement!.type == ProductType.GIFT_CARD
                      ? InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.textFieldFillColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.textFieldFillColor,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.textFieldFillColor,
                            ),
                          ),
                          hintText: 'Review'.tr +
                              ' ${productElement!.giftCard!.name}',
                          hintMaxLines: 3,
                          hintStyle: AppStyles.kFontBlack14w5,
                        )
                      : InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.textFieldFillColor,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.textFieldFillColor,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.red,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppStyles.textFieldFillColor,
                            ),
                          ),
                          hintText: 'Review'.tr +
                              ' ${productElement!.sellerProductSku!.product!.product!.productName}',
                          hintMaxLines: 3,
                          hintStyle: AppStyles.kFontBlack14w5,
                        ),
                  keyboardType: TextInputType.text,
                  style: AppStyles.kFontBlack14w5,
                  maxLines: 4,
                  validator: (value) {
                    if (value!.length == 0) {
                      return 'Please Type something...';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              direction: Axis.horizontal,
              runSpacing: 10,
              spacing: 10,
              children: List.generate(
                list[productIndex].images.length,
                (imageIndex) {
                  if (imageIndex == 0) {
                    return GestureDetector(
                      onTap: () async {
                        if (AppConfig.isDemo) {
                          SnackBars().snackBarWarning("Disabled for demo.");
                        } else {
                          getImages(productIndex);
                        }
                      },
                      child: DottedBorder(
                        color: AppStyles.pinkColor,
                        padding: EdgeInsets.zero,
                        borderType: BorderType.RRect,
                        radius: Radius.circular(5),
                        child: Container(
                          width: 50,
                          height: 50,
                          color: AppStyles.pinkColor.withOpacity(0.1),
                          child: Column(
                            children: [
                              Icon(
                                Icons.add,
                                color: AppStyles.pinkColor,
                              ),
                              Text('${list[productIndex].images.length - 1}/6'),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return GestureDetector(
                      onTap: () async {
                        try {
                          if (widget.package!.products![productIndex].type ==
                              ProductType.PRODUCT) {
                            img =
                                'product_images_${widget.package!.products![productIndex].sellerProductSku!.productId}[]';
                          } else if (widget
                                  .package!.products![productIndex].type ==
                              ProductType.GIFT_CARD) {
                            img =
                                'gift_images_${widget.package!.products![productIndex].giftCard!.id}[]';
                          }
                          MapEntry<String, DIO.MultipartFile> file = MapEntry(
                              img,
                              await DIO.MultipartFile.fromFile(
                                  list[productIndex]
                                      .images[imageIndex]
                                      .absolute
                                      .path,
                                  filename:
                                      '${list[productIndex].images[imageIndex].absolute.path}'));

                          // print(file.value!.filename);
                          //
                          // print(mapImages.length);

                          // final File selectedFile = File(list[productIndex]
                          //     .images[imageIndex]
                          //     .absolute
                          //     .path);
                          // print('Selected file $selectedFile');
                          // removeValueToMap(images, img, selectedFile);
                          // print('removed $images');

                          // mapImages.remove(file);

                          this.formData.files.remove(file);

                          list[productIndex]
                              .images
                              .remove(list[productIndex].images[imageIndex]);
                        } catch (e) {
                          print('ERROR: ${e.toString()}');
                        }
                        setState(() {});
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: Image.file(
                              list[productIndex].images[imageIndex],
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              // errorBuilder: (BuildContext context,
                              //     Object exception, StackTrace stackTrace) {
                              //   return Text('Error');
                              // },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: AppStyles.pinkColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5),
                                  bottomLeft: Radius.circular(5),
                                ),
                              ),
                              child: Icon(
                                Icons.close,
                                size: 15,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getImages(productIndex) async {
    if (list[productIndex].images.length > 6) {
      SnackBars().snackBarWarning('Max 6 files allowed'.tr);
    } else {
      print('len ' + list[productIndex].images.length.toString());
      print(list[productIndex].images.length > 6);
      if (list[productIndex].images.length > 6) {
        SnackBars().snackBarWarning('Max 6 files allowed'.tr);
      }
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg'],
        allowCompression: true,
      );
      if (result != null) {
        if (result.files.length > 6) {
          SnackBars().snackBarWarning('Max 6 files allowed'.tr);
        } else {
          try {
            list[productIndex]
                .images
                .addAll(result.files.map((e) => File(e.path!)).toList());

            if (widget.package!.products![productIndex].type ==
                ProductType.PRODUCT) {
              img =
                  'product_images_${widget.package!.products![productIndex].sellerProductSku!.productId}[]';
            } else if (widget.package!.products![productIndex].type ==
                ProductType.GIFT_CARD) {
              img =
                  'gift_images_${widget.package!.products![productIndex].giftCard!.id}[]';
            }

            result.files.forEach((element) async {
              final MapEntry<String, DIO.MultipartFile> file = MapEntry(
                  img,
                  await DIO.MultipartFile.fromFile(element.path!,
                      filename: '${element.path}'));

              // mapImages.add(file);

              this.formData.files.add(file);

              //
              // final File selectedFile = File(element.path);
              //
              // addValueToMap(images, img, selectedFile);
              // print(images);
            });

            print(mapImages.length);
          } catch (e) {
            print('ADD ERROR ${e.toString()}');
          }
          setState(() {});
        }
      }
    }
  }

  void addValueToMap<K, V>(Map<K, List<V>> map, K key, V value) {
    map.update(key, (v) => v..add(value), ifAbsent: () => [value]);
  }

  void removeValueToMap<K, V>(Map<K, List<V>> map, K key, V value) {
    map.update(key, (list) => list..remove(value), ifAbsent: () => [value]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Write Review',
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_productQuality.png',
                  height: 18,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Product Review'.tr,
                  style: AppStyles.kFontGrey14w5,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.package!.products!.length,
                    itemBuilder: (context, productIndex) {
                      return rateProduct(
                          widget.package!.products![productIndex],
                          productIndex);
                    }),
                Divider(
                  height: 10,
                  color: AppStyles.greyColorLight,
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: InkWell(
                    onTap: () {
                      reviewController.anonCheck();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Obx(() {
                                return reviewController.isAnon.value
                                    ? Icon(
                                        Icons.check_circle,
                                        size: 20,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons.radio_button_unchecked,
                                        size: 20,
                                        color: Colors.black,
                                      );
                              })),
                        ),
                        Text(
                          'Anonymous'.tr,
                          style: AppStyles.kFontBlack14w5,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/icon_sellerService.png',
                  height: 18,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Seller Service'.tr,
                  style: AppStyles.kFontGrey14w5,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 0,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  glow: false,
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: AppStyles.goldenYellowColor,
                          size: 20,
                        );
                      case 1:
                        return Icon(
                          Icons.sentiment_dissatisfied,
                          color: AppStyles.goldenYellowColor,
                          size: 20,
                        );
                      case 2:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: AppStyles.goldenYellowColor,
                          size: 20,
                        );
                      case 3:
                        return Icon(
                          Icons.sentiment_satisfied_sharp,
                          color: AppStyles.goldenYellowColor,
                          size: 20,
                        );
                      case 4:
                        return Icon(
                          Icons.sentiment_very_satisfied,
                          color: AppStyles.goldenYellowColor,
                          size: 20,
                        );
                    }
                    return Container();
                  },
                  onRatingUpdate: (rating) {
                    sellerRating = rating;
                  },
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xffF6FAFC),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: TextFormField(
                      controller: sellerReviewController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppStyles.textFieldFillColor,
                          ),
                        ),
                        hintText: 'Write your comment'.tr + '....',
                        hintMaxLines: 3,
                        hintStyle: AppStyles.kFontBlack14w5,
                      ),
                      keyboardType: TextInputType.text,
                      style: AppStyles.kFontBlack14w5,
                      maxLines: 4,
                      validator: (value) {
                        if (value!.length == 0) {
                          return 'Please Type something';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    reviewController.termCheck();
                  },
                  child: Container(
                    child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Obx(() {
                          return reviewController.isTerms.value
                              ? Icon(
                                  Icons.check_circle,
                                  size: 20,
                                  color: AppStyles.darkBlueColor,
                                )
                              : Icon(
                                  Icons.radio_button_unchecked,
                                  size: 20,
                                  color: AppStyles.darkBlueColor,
                                );
                        })),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'I accept'.tr + ' ${AppConfig.appName}',
                          style: AppStyles.kFontGrey14w5),
                      TextSpan(text: ' ', style: AppStyles.kFontGrey14w5),
                      TextSpan(
                        text: 'Privacy Policy'.tr,
                        style: AppStyles.kFontGrey14w5
                            .copyWith(decoration: TextDecoration.underline),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            if (!await launch(AppConfig.privacyPolicyUrl))
                              throw 'Could not launch ${AppConfig.privacyPolicyUrl}';
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ButtonWidget(
              buttonText: 'Submit Review'.tr,
              onTap: () async {
                if (!reviewController.isTerms.value) {
                  Get.snackbar(
                    'Please accept terms'.tr,
                    "",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    borderRadius: 5,
                  );
                } else {
                  if (prodRating.isEmpty) {
                    Get.snackbar(
                      'Please Add Ratings'.tr,
                      "",
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      borderRadius: 5,
                    );
                    return null;
                  }
                  try {
                    List<String> reviews = [];
                    productReviewController.forEach((element) {
                      if (element.text != "") reviews.addNonNull(element.text);
                    });

                    this.formData.fields.addAll([
                      MapEntry('seller_review',
                          sellerReviewController.text.toString()),
                      MapEntry('seller_rating', sellerRating.toString()),
                      MapEntry("is_anonymous",
                          reviewController.isAnon.value ? "1" : "0"),
                    ]);

                    print(prodRating);
                    prodRating.forEach((k, v) {
                      this.formData.fields.add(MapEntry(k, v));
                    });

                    widget.package!.products!.forEach((element) {
                      if (element.type == ProductType.GIFT_CARD) {
                        this.formData.fields.add(MapEntry(
                            'product_id[]', element.giftCard!.id.toString()));
                      } else {
                        this.formData.fields.add(MapEntry('product_id[]',
                            element.sellerProductSku!.productId.toString()));
                      }
                    });
                    widget.package!.products!.forEach((element) {
                      if (element.type == ProductType.GIFT_CARD) {
                        this
                            .formData
                            .fields
                            .add(MapEntry('product_type[]', 'gift_card'));
                      } else {
                        this
                            .formData
                            .fields
                            .add(MapEntry('product_type[]', 'product'));
                      }
                    });
                    reviews.forEach((element) {
                      this.formData.fields.add(
                          MapEntry('product_review[]', element.toString()));
                    });

                    print(this.formData.fields);
                    print(this.formData.files);

                    await submitReview(this.formData);
                  } catch (e) {
                    print('ERR ${e.toString()}');
                  }
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class Model {
  List<File> images;

  //or use network path
  //String path;
  //other properties

  Model(this.images);
}
