import 'dart:io';
import 'dart:developer';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/payment_gateway_controller.dart';
import 'package:amazcart/model/NewModel/BankPaymentResponse.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/dio_exception.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get_storage/get_storage.dart';

class BankPaymentSheet extends StatefulWidget {
  final Map? orderData;

  BankPaymentSheet({this.orderData});

  @override
  _BankPaymentSheetState createState() => _BankPaymentSheetState();
}

class _BankPaymentSheetState extends State<BankPaymentSheet> {
  final PaymentGatewayController controller =
      Get.put(PaymentGatewayController());
  bool paymentProcessing = false;
  final _formKey = GlobalKey<FormState>();
  File? file;
  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();
  final TextEditingController bankNameCtrl = TextEditingController();
  final TextEditingController branchNameCtrl = TextEditingController();
  final TextEditingController accountNumberCtrl = TextEditingController();
  final TextEditingController accountHolderCtrl = TextEditingController();
  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  void pickPaymentSlip() async {
    if (AppConfig.isDemo) {
      SnackBars().snackBarWarning("Disabled for demo.");
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null) {
        setState(() {
          file = File(result.files.single.path!);
        });
      } else {
        // User canceled the picker
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Container(
        child: Container(
          color: Color.fromRGBO(0, 0, 0, 0.001),
          child: DraggableScrollableSheet(
            initialChildSize: .9,
            minChildSize: .9,
            maxChildSize: 1,
            builder: (_, scrollController2) {
              return GestureDetector(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.white,
                    body: Form(
                      key: _formKey,
                      child: ListView(
                        controller: scrollController2,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                width: 40,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Color(0xffDADADA),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Center(
                            child: Text(
                              'Bank Payment',
                              style: AppStyles.kFontBlack15w4,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          paymentProcessing == true
                              ? Center(
                                  child: Column(
                                    children: [
                                      CupertinoActivityIndicator(),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Center(
                                        child: Text(
                                          'Payment Processing. Please don\'t close this until payment is complete',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack17w5,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                )
                              : Column(
                                  children: [
                                    ///Bank Details
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Bank Name',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                        Text(
                                          '${controller.bank.value.bankInfo!.bankName}',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Branch Name',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                        Text(
                                          '${controller.bank.value.bankInfo!.branchName}',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Account Number',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                        Text(
                                          '${controller.bank.value.bankInfo!.accountNumber}',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Account holder',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                        Text(
                                          '${controller.bank.value.bankInfo!.accountHolder}',
                                          textAlign: TextAlign.center,
                                          style: AppStyles.kFontBlack14w5,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),

                                    ///User Info
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Bank Name',
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  controller: bankNameCtrl,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    hintText: 'Bank Name',
                                                    hintMaxLines: 4,
                                                    hintStyle: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  validator: (value) {
                                                    if (value!.length == 0) {
                                                      return 'Type Bank name';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Branch Name',
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  controller: branchNameCtrl,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    hintText: 'Branch Name',
                                                    hintMaxLines: 4,
                                                    hintStyle: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  validator: (value) {
                                                    if (value!.length == 0) {
                                                      return 'Type Branch name';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Account Number',
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  controller: accountNumberCtrl,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    hintText: 'Account Number',
                                                    hintMaxLines: 4,
                                                    hintStyle: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  validator: (value) {
                                                    if (value!.length == 0) {
                                                      return 'Type Account Number';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Account Holder',
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                child: TextFormField(
                                                  controller: accountHolderCtrl,
                                                  autovalidateMode:
                                                      AutovalidateMode
                                                          .onUserInteraction,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    errorBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: AppStyles
                                                            .textFieldFillColor,
                                                      ),
                                                    ),
                                                    hintText: 'Account Holder',
                                                    hintMaxLines: 4,
                                                    hintStyle: AppStyles.appFont
                                                        .copyWith(
                                                      color: Colors.grey,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  style: AppStyles.appFont
                                                      .copyWith(
                                                    color: Colors.black,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  validator: (value) {
                                                    if (value!.length == 0) {
                                                      return 'Type Account Holder';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),

                                    InkWell(
                                      onTap: pickPaymentSlip,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                  file == null
                                                      ? 'Attach Payment Slip'
                                                      : "Payment Slip: ${file!.path.split('/').last}",
                                                  style:
                                                      AppStyles.kFontBlack15w4),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(),
                                          ),
                                          Icon(Icons.attach_file),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 25,
                                    ),
                                    PinkButtonWidget(
                                      width: Get.width * 0.7,
                                      height: 50,
                                      btnText: 'Submit',
                                      btnOnTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          if (file != null) {
                                            setState(() {
                                              paymentProcessing = true;
                                            });
                                            try {
                                              String token = await userToken
                                                  .read(tokenKey);

                                              final slip =
                                                  await DIO.MultipartFile
                                                      .fromFile(file!.path,
                                                          filename:
                                                              '${file!.path}');

                                              final formData =
                                                  DIO.FormData.fromMap({
                                                'image': slip,
                                                'payment_for': 'order_payment',
                                                'payment_method':
                                                    widget.orderData![
                                                        'payment_method'],
                                                'bank_name': bankNameCtrl.text,
                                                'branch_name':
                                                    branchNameCtrl.text,
                                                'account_number':
                                                    accountNumberCtrl.text,
                                                'account_holder':
                                                    accountHolderCtrl.text,
                                                'bank_amount': widget
                                                    .orderData!['grand_total'],
                                              });

                                              response = await dio.post(
                                                URLs.BANK_PAYMENT_DATA_STORE,
                                                data: formData,
                                                options: DIO.Options(
                                                  headers: {
                                                    'Accept':
                                                        'application/json',
                                                    'Authorization':
                                                        'Bearer $token',
                                                  },
                                                ),
                                                onSendProgress:
                                                    (received, total) {
                                                  if (total != -1) {
                                                    print((received /
                                                                total *
                                                                100)
                                                            .toStringAsFixed(
                                                                0) +
                                                        '%');
                                                  }
                                                },
                                              ).catchError((e) {
                                                print("EEEE $e");
                                                final errorMessage =
                                                    DioExceptions.fromDioError(
                                                            e)
                                                        .toString();
                                                print(
                                                    "ERROR MSG : $errorMessage");
                                                if (errorMessage == "401") {
                                                  SnackBars().snackBarWarning(
                                                      'Unauthorized');
                                                  Get.back();
                                                }
                                                setState(() {
                                                  paymentProcessing = false;
                                                });
                                              });
                                              if (response!.statusCode == 201) {
                                                var bankResponse =
                                                    BankPaymentResponse
                                                        .fromJson(
                                                            response!.data);

                                                log('Payment Info ${bankResponse.paymentInfo!.id.toString()}');
                                                log('Bank Info ${bankResponse.bankDetails!.id.toString()}');

                                                widget.orderData!.addAll({
                                                  'payment_id': bankResponse
                                                      .paymentInfo!.id,
                                                  'bank_details_id':
                                                      bankResponse
                                                          .bankDetails!.id
                                                });

                                                await controller.submitOrder(
                                                    widget.orderData);
                                              } else {
                                                if (response!.statusCode ==
                                                    401) {
                                                  SnackBars().snackBarWarning(
                                                      'Invalid Access token. Please re-login.');
                                                } else {
                                                  SnackBars().snackBarError(
                                                      response!.data);
                                                  return null;
                                                }
                                              }
                                            } catch (e) {
                                              print('ERROR  $e');
                                            }
                                          } else {
                                            SnackBars().snackBarWarning(
                                                'Please attach Payment slip');
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
