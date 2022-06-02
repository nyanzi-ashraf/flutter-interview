import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class ChangeReview extends StatefulWidget {
  @override
  _ChangeReviewState createState() => _ChangeReviewState();
}

class _ChangeReviewState extends State<ChangeReview> {
  bool _anonymous = false;
  bool _acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Change Review'.tr,
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
                  'Product Quality'.tr,
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
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 15),
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Container(
                            height: 60,
                            width: 60,
                            child: Image.asset(
                              'assets/images/product-2.png',
                              fit: BoxFit.cover,
                            )),
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
                              Text(
                                'Forget Yellow Full Sleeve T-Shirt for Men',
                                style: AppStyles.kFontBlack14w5,
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
                Divider(
                  height: 10,
                  color: AppStyles.greyColorLight,
                ),
                RatingBar.builder(
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  glow: false,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: AppStyles.goldenYellowColor,
                    size: 20,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
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
                        hintText: 'Change Review'.tr + '....',
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
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _anonymous = !_anonymous;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: _anonymous
                                ? Icon(
                                    Icons.check_circle,
                                    size: 20.0,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    size: 20.0,
                                    color: Colors.black,
                                  ),
                          ),
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
                  'assets/images/icon_rider.png',
                  height: 18,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  'Rate Your Rider'.tr,
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
                  initialRating: 5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  glow: false,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: AppStyles.goldenYellowColor,
                    size: 20,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
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
                        hintText: 'Change your comment....',
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
                  'Seller Service',
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
                  itemCount: 3,
                  glow: false,
                  itemPadding: EdgeInsets.symmetric(horizontal: 30.0),
                  // ignore: missing_return
                  itemBuilder: (context, index) {
                    switch (index) {
                      case 0:
                        return Icon(
                          Icons.sentiment_very_dissatisfied,
                          color: AppStyles.goldenYellowColor,
                        );
                      case 1:
                        return Icon(
                          Icons.sentiment_neutral,
                          color: AppStyles.goldenYellowColor,
                        );
                      case 2:
                        return Icon(
                          Icons.sentiment_very_satisfied,
                          color: AppStyles.goldenYellowColor,
                        );
                    }
                    return Container();
                  },
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
                SizedBox(
                  height: 10,
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
                    setState(() {
                      _acceptTerms = !_acceptTerms;
                    });
                  },
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: _acceptTerms
                          ? Icon(
                              Icons.check_circle,
                              size: 20.0,
                              color: AppStyles.darkBlueColor,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              size: 20.0,
                              color: AppStyles.darkBlueColor,
                            ),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: 'I accept Amazcart ',
                          style: AppStyles.kFontGrey14w5),
                      TextSpan(
                        text: 'Privacy Policy',
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
              buttonText: 'Change Review',
              onTap: () {},
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
