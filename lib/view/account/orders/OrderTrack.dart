import 'package:amazcart/model/NewModel/Order/OrderData.dart';
import 'package:amazcart/model/NewModel/Order/Package.dart';
import 'package:amazcart/model/NewModel/Order/Process.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timelines/timelines.dart';
import 'package:amazcart/model/DeliveryProcess.dart';

class OrderTrack extends StatefulWidget {
  final List<DeliveryProcess>? processes;
  final Package? package;
  final OrderData? order;

  OrderTrack({this.processes, this.package, this.order});

  @override
  _OrderTrackState createState() => _OrderTrackState();
}

class _OrderTrackState extends State<OrderTrack> {
  @override
  void initState() {
    super.initState();
  }

  String getDeliveryDate(Package package) {
    var deliveryStateName = "";
    package.processes!.forEach((element) {
      if (element.id == package.deliveryStatus) {
        deliveryStateName = element.name! +
            " on ${DateFormat.yMMMd().add_jm().format(package.updatedAt!)}";
      }
    });
    return deliveryStateName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Track Order'.tr,
      ),
      body: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: AppStyles.darkBlueColor,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/icon_delivery-parcel_white.png',
                        width: 30,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        getDeliveryDate(widget.package!),
                        style: AppStyles.kFontWhite14w5,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  left: 15,
                  top: 15,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/icon_delivery-parcel-transparent.png',
                      width: 70,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sold by'.tr + ': ${widget.package!.seller!.firstName}',
                  style: AppStyles.kFontBlack15w4,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tracking Number'.tr + ': ',
                style: AppStyles.kFontBlack12w4,
              ),
              Text(
                widget.package!.packageCode!,
                style: AppStyles.kFontDarkBlue12w5,
              ),
              IconButton(
                onPressed: () {
                  FlutterClipboard.copy('${widget.package!.packageCode!}').then(
                      (value) =>
                          print('copied: ${widget.package!.packageCode!}'));
                },
                icon: Image.asset(
                  'assets/images/icon_copy.png',
                  width: 15,
                ),
              ),
            ],
          ),
          widget.order!.shippingAddress! != null &&
                  widget.order!.billingAddress != null
              ? SizedBox(
                  height: 10,
                )
              : Container(),
          widget.order!.shippingAddress! != null &&
                  widget.order!.billingAddress != null
              ? Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      //SHIP TO
                      Text(
                        'Receiver'.tr,
                        style: AppStyles.kFontGrey12w5,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${widget.order!.shippingAddress!.name ?? ""}',
                        style: AppStyles.appFont.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: AppStyles.blackColor,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${widget.order!.shippingAddress!.email ?? ""}',
                        style: AppStyles.appFont.copyWith(
                          fontSize: 13,
                          color: AppStyles.blackColor,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${widget.order!.shippingAddress!.phone ?? ""}',
                        style: AppStyles.appFont.copyWith(
                          fontSize: 13,
                          color: AppStyles.blackColor,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${widget.order!.shippingAddress!.address ?? ""}',
                        style: AppStyles.appFont.copyWith(
                          fontSize: 13,
                          color: AppStyles.blackColor,
                        ),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  ),
                )
              : Container(),
          widget.order!.shippingAddress! != null &&
                  widget.order!.billingAddress != null
              ? SizedBox(
                  height: 20,
                )
              : Container(),
          widget.package!.deliveryStates!.length != 0
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  padding: EdgeInsets.all(20),
                  child: FixedTimeline.tileBuilder(
                    verticalDirection: VerticalDirection.down,
                    theme: TimelineThemeData(
                      color: Color(0xffF5F1FE),
                      nodePosition: 0.3,
                      connectorTheme:
                          ConnectorThemeData(thickness: 1.5, indent: 0.1),
                    ),
                    builder: TimelineTileBuilder.connected(
                      connectionDirection: ConnectionDirection.after,
                      itemCount: widget.package!.deliveryStates!.length,
                      contentsBuilder: (_, index) {
                        String getDeliveryStateName(List<Process> process) {
                          var stateName = "";
                          process.forEach((element) {
                            if (widget.package!.deliveryStates![index]
                                    .deliveryStatus ==
                                element.id) {
                              stateName = element.name!;
                            }
                          });
                          return stateName;
                        }

                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                getDeliveryStateName(
                                    widget.package!.processes!),
                                style: AppStyles.kFontBlack14w5,
                              ),
                              Text(
                                widget.package!.deliveryStates![index].note ??
                                    getDeliveryStateName(
                                        widget.package!.processes!),
                                style: AppStyles.kFontGrey12w5,
                              ),
                            ],
                          ),
                        );
                      },
                      oppositeContentsBuilder: (_, index) {
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                "${DateFormat.yMMMEd().add_jm().format(widget.package!.deliveryStates![index].createdAt!)}",
                                style: AppStyles.kFontGrey12w5,
                              ),
                            ],
                          ),
                        );
                      },
                      indicatorBuilder: (_, index) {
                        if (widget.package!.deliveryStates!.last ==
                            widget.package!.deliveryStates![index]) {
                          return Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: AppStyles.darkBlueColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12.0,
                            ),
                          );
                        } else if (widget.package!.deliveryStates!.last !=
                            widget.package!.deliveryStates![index]) {
                          return Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 12.0,
                            ),
                          );
                        } else {
                          return OutlinedDotIndicator(
                            borderWidth: 2.5,
                          );
                        }
                      },
                      connectorBuilder: (_, index, ___) => SolidLineConnector(
                        color: widget.package!.deliveryStates!.last !=
                                widget.package!.deliveryStates![index]
                            ? AppStyles.darkBlueColor
                            : Colors.red,
                      ),
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            padding: EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.order!.orderNumber!,
                    style: AppStyles.kFontDarkBlue14w5,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Row(
                    children: [
                      Text(
                        'Order Details'.tr,
                        style: AppStyles.kFontPink15w5,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: AppStyles.pinkColor,
                      )
                    ],
                  ),
                ),
              ],
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
