import 'package:amazcart/model/NewModel/Product/Review.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:amazcart/widgets/StarCounterWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RatingsAndReviews extends StatefulWidget {
  final List<Review>? productReviews;
  RatingsAndReviews({this.productReviews});
  @override
  _RatingsAndReviewsState createState() => _RatingsAndReviewsState();
}

class _RatingsAndReviewsState extends State<RatingsAndReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Ratings And Reviews'.tr,
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          ListView.separated(
            separatorBuilder: (context, index) {
              return Divider(
                height: 20,
                thickness: 2,
                color: AppStyles.appBackgroundColor,
              );
            },
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20),
            shrinkWrap: true,
            itemCount: widget.productReviews!.length,
            itemBuilder: (context, index) {
              Review review = widget.productReviews![index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      review.isAnonymous == 1
                          ? Text(
                              'User'.tr,
                              style: AppStyles.kFontGrey12w5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppStyles.blackColor,
                              ),
                            )
                          : Text(
                              review.customer!.firstName!.toString() +
                                  ' ' +
                                  review.customer!.lastName!.toString(),
                              style: AppStyles.kFontGrey12w5.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppStyles.blackColor,
                              ),
                            ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '- ' + CustomDate().formattedDate(review.createdAt),
                        style: AppStyles.kFontGrey12w5,
                      ),
                      Expanded(child: Container()),
                      StarCounterWidget(
                        value: int.parse(review.rating.toString()).toDouble(),
                        color: AppStyles.goldenYellowColor,
                        size: 15,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    review.review!,
                    style: AppStyles.kFontGrey12w5,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
