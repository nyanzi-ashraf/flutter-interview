import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/controller/currency_controller.dart';
import 'package:amazcart/controller/payment_gateway_controller.dart';
import 'package:amazcart/model/NewModel/GpayTokenModel.dart';
import 'package:amazcart/model/PaymentGatewayModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/payment/bank_payment_sheet.dart';
import 'package:amazcart/view/payment/instamojo_payment.dart';
import 'package:amazcart/view/payment/jazzcash.dart';
import 'package:amazcart/view/payment/midtrans_payment.dart';
import 'package:amazcart/view/payment/paypal/paypal_payment.dart';
import 'package:amazcart/view/payment/paytm_service.dart';
import 'package:amazcart/view/payment/razorpay_sheet.dart';
import 'package:amazcart/view/payment/stripe/stripe_payment.dart';
import 'package:amazcart/view/payment/gpay_service.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/PinkButtonWidget.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:get/get.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:intl/intl.dart';
import 'package:pay/pay.dart';

class GatewaySelection extends StatefulWidget {
  final Map? data;

  GatewaySelection({this.data});

  @override
  _GatewaySelectionState createState() => _GatewaySelectionState();
}

class _GatewaySelectionState extends State<GatewaySelection> {
  final PaymentGatewayController controller =
      Get.put(PaymentGatewayController());
  final AddressController addressController = Get.put(AddressController());

  final CurrencyController currencyController = Get.put(CurrencyController());

  final plugin = PaystackPlugin();

  bool selectedGooglePay = false;

  int radioSelector = 0;

  @override
  void initState() {
    plugin.initialize(publicKey: payStackPublicKey);
    widget.data!.addAll({
      'wallet_amount': 'wallet_amount',
      'payment_id': 'id',
    });
    // print(widget.data!);
    super.initState();
  }

  bool selected = false;

  final _paymentItems = <PaymentItem>[];

  setSelectedMethod(Gateway gateWay) {
    setState(() {
      controller.selectedGateway.value = gateWay;
      selected = true;
    });

    if (controller.selectedGateway.value.id == 13) {
      _paymentItems.add(PaymentItem(
        amount: widget.data!['grand_total'].toString(),
        label: "${AppConfig.appName}" + "Order",
        status: PaymentItemStatus.final_price,
      ));
      setState(() {
        selectedGooglePay = true;
      });
      print(_paymentItems[0].amount);
    } else {
      _paymentItems.clear();
      setState(() {
        selectedGooglePay = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Select Gateway'.tr,
      ),
      body: Obx(() {
        if (controller.isPaymentGatewayLoading.value) {
          return Center(child: CustomLoadingWidget());
        } else {
          return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: controller.gatewayList.length,
              padding: EdgeInsets.only(top: 8),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              separatorBuilder: (context, index) {
                return SizedBox(
                  height: 8,
                );
              },
              itemBuilder: (BuildContext context, int position) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      width: 0.2,
                      color: controller.gatewayList[position] ==
                              controller.gatewayList[radioSelector]
                          ? Get.textTheme.subtitle1!.color!
                          : Get.theme.canvasColor,
                    ),
                  ),
                  child: RadioListTile<Gateway>(
                    value: controller.gatewayList[position],
                    activeColor: AppStyles.pinkColor,
                    groupValue: controller.selectedGateway.value,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    onChanged: (value) {
                      setState(() {
                        radioSelector = position;
                      });
                      setSelectedMethod(value!);
                      print('${value.id} = ${value.method}');
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(controller.gatewayList[position].method!),
                        Expanded(child: Container()),
                        Container(
                          height: 35,
                          width: 50,
                          child: FadeInImage(
                            image: NetworkImage(AppConfig.assetPath +
                                '/' +
                                controller.gatewayList[position].logo!),
                            placeholder: AssetImage("${AppConfig.appBanner}"),
                            fit: BoxFit.fitWidth,
                            imageErrorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Image.asset('${AppConfig.appBanner}');
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                );
              });
        }
      }),
      bottomNavigationBar: Material(
        elevation: 20,
        child: Container(
          height: 70,
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Total: '.tr,
                          textAlign: TextAlign.center,
                          style: AppStyles.appFont.copyWith(
                            fontSize: 17,
                            color: AppStyles.blackColor,
                          ),
                        ),
                        Obx(() {
                          if (controller.checkoutController.isLoading.value) {
                            return Center(
                              child: Container(),
                            );
                          } else {
                            if (controller.checkoutController.checkoutModel
                                        .value.packages ==
                                    null ||
                                controller.checkoutController.checkoutModel
                                        .value.packages!.length ==
                                    0) {
                              return Container();
                            } else {
                              return Text(
                                '${(controller.checkoutController.grandTotal.value * currencyController.conversionRate.value).toStringAsFixed(2)}${currencyController.appCurrency.value}',
                                textAlign: TextAlign.center,
                                style: AppStyles.appFont.copyWith(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: AppStyles.darkBlueColor,
                                ),
                              );
                            }
                          }
                        })
                      ],
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 3),
                      child: Text(
                        'TAX/GST included, where applicable'.tr,
                        style: AppStyles.kFontGrey12w5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 5),
              selectedGooglePay
                  ? Platform.isAndroid
                      ? GooglePayButton(
                          width: 100,
                          height: 50,
                          onError: (Object? error) {
                            debugPrint(error.toString());
                          },
                          childOnError: const Text('errror'),
                          onPressed: () {
                            debugPrint('pressed');
                          },
                          paymentConfigurationAsset: "payment/google_pay.json",
                          paymentItems: _paymentItems,
                          style: GooglePayButtonStyle.white,
                          type: GooglePayButtonType.pay,
                          margin: EdgeInsets.symmetric(vertical: 10),
                          onPaymentResult: (paymentResult) async {
                            final data = jsonEncode(paymentResult);
                            final gpayTokenModel = gpayTokenModelFromJson(data);

                            final tokenModel = tokenFromJson(jsonDecode(
                                jsonEncode(gpayTokenModel.paymentMethodData!
                                    .tokenizationData!.token)));

                            log(tokenModel.id!);

                            await GooglePaymentIntentConfirm()
                                .postGpayPaymentIntent(
                                    email: addressController
                                        .billingAddress.value.email!,
                                    orderAmount:
                                        widget.data!['grand_total'].toString(),
                                    token: tokenModel.id!)
                                .then((value) async {
                              print(value.paymentIntent!.id!);

                              Map payment = {
                                'amount': widget.data!['grand_total'],
                                'payment_method':
                                    controller.selectedGateway.value.id,
                                'transection_id': '${value.paymentIntent!.id}'
                              };
                              widget.data!.addAll({
                                'payment_method':
                                    controller.selectedGateway.value.id,
                              });

                              await controller.paymentInfoStore(
                                orderData: widget.data!,
                                paymentData: payment,
                                transactionID: value.paymentIntent!.id,
                              );
                            });
                          },
                          loadingIndicator: Center(
                            child: CustomLoadingWidget(),
                          ),
                        )
                      : ApplePayButton(
                          paymentConfigurationAsset: 'payment/apple_pay.json',
                          paymentItems: _paymentItems,
                          style: ApplePayButtonStyle.black,
                          type: ApplePayButtonType.buy,
                          margin: const EdgeInsets.only(top: 15.0),
                          onPaymentResult: (paymentResult) {
                            debugPrint(paymentResult.toString());
                          },
                          loadingIndicator: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                  : PinkButtonWidget(
                      height: 40,
                      btnText: 'Order Confirm'.tr,
                      btnOnTap: () async {
                        print(controller.selectedGateway.value.id);

                        /// Cash on delivery
                        if (controller.selectedGateway.value.id == 1) {
                          widget.data!.addAll({
                            'payment_method':
                                controller.selectedGateway.value.id,
                          });
                          Map payment = {
                            'amount': widget.data!['grand_total'],
                            'payment_method':
                                controller.selectedGateway.value.id,
                          };
                          controller.paymentInfoStore(
                              paymentData: payment, orderData: widget.data!);
                        }

                        /// Wallet
                        else if (controller.selectedGateway.value.id == 2) {
                          widget.data!.addAll({
                            'wallet_amount': 'wallet_amount',
                            'payment_method': 2,
                          });
                          log(widget.data!.toString());
                        }

                        ///Paypal
                        else if (controller.selectedGateway.value.id == 3) {
                          Map payment = {
                            'amount': widget.data!['grand_total'],
                            'payment_method':
                                controller.selectedGateway.value.id,
                          };
                          widget.data!.addAll({'payment_method': 3});
                          Get.to(
                            () => PaypalPayment(
                              onFinish: (number) async {
                                payment.addAll({
                                  'transection_id': number,
                                });
                                await controller.paymentInfoStore(
                                    orderData: widget.data!,
                                    paymentData: payment,
                                    transactionID: number);
                              },
                            ),
                          );
                        }

                        ///Stripe
                        else if (controller.selectedGateway.value.id == 4) {
                          widget.data!.addAll({
                            'payment_method':
                                controller.selectedGateway.value.id,
                          });
                          Map payment = {
                            'amount': widget.data!['grand_total'],
                            'payment_method':
                                controller.selectedGateway.value.id,
                          };
                          Get.bottomSheet(
                            StripePaymentScreen(
                              orderData: widget.data!,
                              paymentData: payment,
                              onFinish: (onFinish) async {
                                print(onFinish['id']);

                                payment.addAll(
                                    {'transection_id': '${onFinish['id']}'});

                                log(payment.toString());

                                await controller.paymentInfoStore(
                                    orderData: widget.data!,
                                    paymentData: payment,
                                    transactionID: onFinish['id']);
                              },
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            ignoreSafeArea: false,
                            persistent: true,
                          );
                        }

                        ///PayStack
                        else if (controller.selectedGateway.value.id == 5) {
                          widget.data!.addAll({
                            'payment_method':
                                controller.selectedGateway.value.id,
                          });
                          final finalAmount =
                              (widget.data!['grand_total'] * 100).toInt();
                          Charge charge = Charge()
                            ..amount = finalAmount
                            ..currency = 'ZAR'
                            ..reference = _getReference()
                            ..email = widget.data!['customer_email'];
                          CheckoutResponse response = await plugin.checkout(
                            context,
                            method: CheckoutMethod.card,
                            // Defaults to CheckoutMethod.selectable
                            charge: charge,
                          );

                          if (response.status == true) {
                            print(response.reference);
                            Map payment = {
                              'amount': widget.data!['grand_total'],
                              'payment_method':
                                  controller.selectedGateway.value.id,
                              'transection_id': response.reference,
                            };
                            await controller.paymentInfoStore(
                                orderData: widget.data!,
                                paymentData: payment,
                                transactionID: response.reference);
                          } else {
                            SnackBars().snackBarWarning(response.message);
                          }
                        }

                        ///Razorpay
                        else if (controller.selectedGateway.value.id == 6) {
                          widget.data!.addAll({
                            'payment_method':
                                controller.selectedGateway.value.id,
                          });
                          Get.bottomSheet(
                            RazorpaySheet(
                              orderData: widget.data!,
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            persistent: true,
                          );
                        }

                        ///Bank Payment
                        else if (controller.selectedGateway.value.id == 7) {
                          widget.data!.addAll({
                            'payment_method':
                                controller.selectedGateway.value.id,
                          });
                          await controller.getBankInfo();
                          Get.bottomSheet(
                            BankPaymentSheet(
                              orderData: widget.data!,
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            persistent: true,
                          );
                        }

                        ///Instamojo
                        else if (controller.selectedGateway.value.id == 8) {
                          Map payment = {
                            'amount': widget.data!['grand_total'],
                            'payment_method':
                                controller.selectedGateway.value.id,
                          };
                          widget.data!.addAll({'payment_method': 8});
                          Get.to(
                            () => InstaMojoPayment(
                              orderData: widget.data!,
                              paymentData: payment,
                              onFinish: (number) async {
                                if (number != null) {
                                  payment.addAll({
                                    'transection_id': number,
                                  });
                                  print(payment);
                                  await controller.paymentInfoStore(
                                      orderData: widget.data!,
                                      paymentData: payment,
                                      transactionID: number);
                                }
                              },
                            ),
                          );
                        }

                        ///PayTM
                        else if (controller.selectedGateway.value.id == 9) {
                          widget.data!.addAll({'payment_method': 9});

                          final orderId =
                              "PayTM_${DateTime.now().millisecondsSinceEpoch}";

                          String callBackUrl = (payTmIsTesting
                                  ? 'https://securegw-stage.paytm.in'
                                  : 'https://securegw.paytm.in') +
                              '/theia/paytmCallback?ORDER_ID=' +
                              orderId;

                          Map payment = {
                            'orderId': orderId,
                            'amount': double.parse(
                                    widget.data!['grand_total'].toString())
                                .toStringAsFixed(2),
                            'payment_method':
                                controller.selectedGateway.value.id,
                            "custID": "USER_" +
                                addressController
                                    .shippingAddress.value.customerId
                                    .toString(),
                            "custEmail": widget.data!['customer_email'],
                            "custPhone": widget.data!['customer_phone'],
                            'callbackUrl': callBackUrl,
                          };

                          await PayTmService().payTmPayment(
                              trxData: payment, orderData: widget.data!);
                        }

                        ///Midtrans
                        else if (controller.selectedGateway.value.id == 10) {
                          widget.data!.addAll({'payment_method': 10});

                          Map payment = {
                            'amount': widget.data!['grand_total'],
                            'payment_method':
                                controller.selectedGateway.value.id,
                          };

                          Get.to(
                            () => MidTransPaymentPage(
                              orderData: widget.data!,
                              paymentData: payment,
                              onFinish: (number) async {
                                if (number != null) {
                                  payment.addAll({
                                    'transection_id': number,
                                  });
                                  print(payment);
                                  await controller.paymentInfoStore(
                                      orderData: widget.data!,
                                      paymentData: payment,
                                      transactionID: number);
                                }
                              },
                            ),
                          );
                        }

                        ///PayUMoney
                        else if (controller.selectedGateway.value.id == 11) {
                          widget.data!.addAll({'payment_method': 11});

                          // Map payment = {
                          //   'amount': widget.data!['grand_total'],
                          //   'payment_method': controller.selectedGateway.value.id,
                          // };

                          // await initPlatformState();
                        }

                        ///Jazzcash
                        else if (controller.selectedGateway.value.id == 12) {
                          widget.data!.addAll({
                            'payment_method':
                                controller.selectedGateway.value.id,
                          });
                          Get.bottomSheet(
                            JazzCashSheet(
                              orderData: widget.data!,
                            ),
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            persistent: true,
                          );
                        }

                        ///Google Pay
                        else if (controller.selectedGateway.value.id == 13) {
                          // Map payment = {
                          //   'amount': widget.data!['grand_total'],
                          //   'payment_method': controller.selectedGateway.value.id,
                          // };
                        }

                        ///Flutter wave
                        else if (controller.selectedGateway.value.id == 14) {
                          final AddressController addressController =
                              Get.put(AddressController());
                          widget.data!.addAll({
                            'payment_method':
                                controller.selectedGateway.value.id,
                          });
                          try {
                            final String currency = FlutterwaveCurrency.NGN;

                            Flutterwave flutterwave = Flutterwave.forUIPayment(
                              context: this.context,
                              encryptionKey: flutterWaveEncryptionKey,
                              publicKey: flutterWavePublicKey,
                              currency: currency,
                              amount: widget.data!['grand_total'].toString(),
                              email: widget.data!['customer_email'],
                              fullName:
                                  addressController.shippingAddress.value.name!,
                              txRef:
                                  'AMZ_${DateFormat("yyyyMMddHHmmss").format(DateTime.now())}',
                              isDebugMode: false,
                              phoneNumber: widget.data!['customer_phone'],
                              acceptCardPayment: true,
                              acceptUSSDPayment: true,
                              acceptAccountPayment: true,
                              acceptFrancophoneMobileMoney: false,
                              acceptGhanaPayment: false,
                              acceptMpesaPayment: false,
                              acceptRwandaMoneyPayment: false,
                              acceptUgandaPayment: false,
                              acceptZambiaPayment: false,
                              acceptBankTransfer: true,
                            );

                            final ChargeResponse response =
                                await flutterwave.initializeForUiPayments();
                            print(response.data!.txRef!);

                            if (response.data!.txRef! != null) {
                              Map payment = {
                                'amount': widget.data!['grand_total'],
                                'payment_method':
                                    controller.selectedGateway.value.id,
                                'transection_id': response.data!.txRef!,
                              };
                              controller.paymentInfoStore(
                                  paymentData: payment,
                                  orderData: widget.data!,
                                  transactionID: response.data!.txRef!);
                            }
                          } catch (error) {
                            print("ERROR =>  ${error.toString()}");
                          }
                        }
                      },
                    ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'AMZ-${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
