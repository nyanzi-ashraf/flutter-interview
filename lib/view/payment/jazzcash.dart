import 'dart:convert';
import 'package:amazcart/AppConfig/api_keys.dart';
import 'package:amazcart/controller/payment_gateway_controller.dart';
import 'package:amazcart/model/JazzCashResponse.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class JazzCashService {
  Future<JazzCashResponse> payment(amount, phoneNumber) async {
    // var digest;
    String dateandtime = DateFormat("yyyyMMddHHmmss").format(DateTime.now());
    String dexpiredate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.now().add(Duration(days: 1)));
    String tre = "T" + dateandtime;
    String ppAmount = amount.toString();
    String ppBillReference = "billRef";
    String ppDescription = "Description";
    String ppLanguage = "EN";
    String ppVer = "1.1";
    String ppTxnCurrency = "PKR";
    String ppTxnDateTime = dateandtime.toString();
    String ppTxnExpiryDateTime = dexpiredate.toString();
    String ppTxnRefNo = tre.toString();
    String ppTxnType = "MWALLET";
    String ppmpf_1 = phoneNumber;
    String and = '&';
    String superdata = jazzCashIntegritySalt +
        and +
        ppAmount +
        and +
        ppBillReference +
        and +
        ppDescription +
        and +
        ppLanguage +
        and +
        jazzCashMerchantId +
        and +
        jazzCashPassword +
        and +
        jazzCashReturnUrl +
        and +
        ppTxnCurrency +
        and +
        ppTxnDateTime +
        and +
        ppTxnExpiryDateTime +
        and +
        ppTxnRefNo +
        and +
        ppTxnType +
        and +
        ppVer +
        and +
        ppmpf_1;

    var key = utf8.encode(jazzCashIntegritySalt);
    var bytes = utf8.encode(superdata);
    var hmacSha256 = new Hmac(sha256, key);
    Digest sha256Result = hmacSha256.convert(bytes);
    Uri url = Uri.parse(
        'https://sandbox.jazzcash.com.pk/ApplicationAPI/API/Payment/DoTransaction');

    print(url);
    var response = await http.post(url, body: {
      "pp_Version": ppVer,
      "pp_TxnType": ppTxnType,
      "pp_Language": ppLanguage,
      "pp_MerchantID": jazzCashMerchantId,
      "pp_Password": jazzCashPassword,
      "pp_TxnRefNo": tre,
      "pp_Amount": ppAmount,
      "pp_TxnCurrency": ppTxnCurrency,
      "pp_TxnDateTime": dateandtime,
      "pp_BillReference": ppBillReference,
      "pp_Description": ppDescription,
      "pp_TxnExpiryDateTime": dexpiredate,
      "pp_ReturnURL": jazzCashReturnUrl,
      "pp_SecureHash": sha256Result.toString(),
      "ppmpf_1": ppmpf_1
    });

    print("response=> $response");
    print(response.body);
    var jazzCashResponse = jazzCashResponseFromJson(response.body);
    return jazzCashResponse;
  }
}

class JazzCashSheet extends StatefulWidget {
  final Map? orderData;

  JazzCashSheet({this.orderData});

  @override
  _JazzCashSheetState createState() => _JazzCashSheetState();
}

class _JazzCashSheetState extends State<JazzCashSheet> {
  final PaymentGatewayController controller =
      Get.put(PaymentGatewayController());
  bool paymentProcessing = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController phoneNumberCtrl = TextEditingController();

  @override
  void initState() {
    phoneNumberCtrl.text = widget.orderData!['customer_phone'];
    super.initState();
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
            initialChildSize: 0.4,
            minChildSize: 0.4,
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
                            height: 10,
                          ),
                          Center(
                            child: Text(
                              'Jazzcash Payment',
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
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Text(
                                        'Phone number',
                                        style: AppStyles.appFont.copyWith(
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: TextFormField(
                                        controller: phoneNumberCtrl,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.red,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color:
                                                  AppStyles.textFieldFillColor,
                                            ),
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              phoneNumberCtrl.clear();
                                            },
                                          ),
                                          hintText: 'Enter Your Phone Number',
                                          hintMaxLines: 4,
                                          hintStyle: AppStyles.appFont.copyWith(
                                            color: Colors.grey,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                        keyboardType: TextInputType.text,
                                        style: AppStyles.appFont.copyWith(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        validator: (value) {
                                          if (value!.length == 0) {
                                            return 'Type Phone number';
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ButtonWidget(
                                      buttonText: 'Continue',
                                      onTap: () async {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            paymentProcessing = true;
                                          });

                                          final finalAmount =
                                              (widget.orderData![
                                                          'grand_total'] *
                                                      100)
                                                  .toInt();

                                          await JazzCashService()
                                              .payment(finalAmount,
                                                  phoneNumberCtrl.text)
                                              .then((value) async {
                                            if (value.ppResponseCode == "000" ||
                                                value.ppResponseCode == "157") {
                                              Map payment = {
                                                'amount': widget
                                                    .orderData!['grand_total'],
                                                'payment_method':
                                                    widget.orderData![
                                                        'payment_method'],
                                                'transection_id':
                                                    value.ppTxnRefNo,
                                              };
                                              await controller.paymentInfoStore(
                                                orderData: widget.orderData,
                                                paymentData: payment,
                                                transactionID: value.ppTxnRefNo,
                                              );
                                            } else {
                                              setState(() {
                                                paymentProcessing = false;
                                              });
                                            }
                                          });
                                        }
                                      },
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 20),
                                    ),
                                    SizedBox(
                                      height: 20,
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
