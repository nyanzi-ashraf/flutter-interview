import 'package:amazcart/controller/support_ticket_controller.dart';
import 'package:amazcart/model/SupportTicketModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/support/TicketDetailsPage.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketDataWidget extends StatelessWidget {
  TicketDataWidget({this.ticketData});

  final TicketData? ticketData;

  final SupportTicketController controller = Get.put(SupportTicketController());

  String categoryName(id) {
    var name;
    controller.ticketCategories.value.categories!.forEach((element) {
      if (id == element.id) {
        name = element.name;
      }
    });
    return name;
  }

  String priorityName(id) {
    var name;
    controller.ticketPriorities.value.priorities!.forEach((element) {
      if (id == element.id) {
        name = element.name;
      }
    });
    return name;
  }

  String statusName(id) {
    var name;
    controller.supportTickets.value.statuses!.forEach((element) {
      if (id == element.id) {
        name = element.name;
      }
    });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TicketDetailsPage(
              ticketId: ticketData!.referenceNo,
              id: ticketData!.id,
            ));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket ID: ${ticketData!.referenceNo}',
              style: AppStyles.kFontBlack15w6,
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Subject',
                    style: AppStyles.kFontBlack14w5,
                  ),
                  TextSpan(
                    text: ': ${ticketData!.subject}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Category',
                    style: AppStyles.kFontBlack14w5,
                  ),
                  TextSpan(
                    text: ': ${categoryName(ticketData!.categoryId)}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Priority',
                    style: AppStyles.kFontBlack14w5,
                  ),
                  TextSpan(
                    text: ': ${priorityName(ticketData!.priorityId)}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Last Updated',
                    style: AppStyles.kFontBlack14w5,
                  ),
                  TextSpan(
                    text:
                        ': ${CustomDate().formattedDateTime(ticketData!.updatedAt)}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TicketDataWidgetAll extends StatelessWidget {
  TicketDataWidgetAll({this.ticketData});

  final TicketData? ticketData;

  final SupportTicketController controller = Get.put(SupportTicketController());

  String categoryName(id) {
    var name;
    controller.ticketCategories.value.categories!.forEach((element) {
      if (id == element.id) {
        name = element.name;
      }
    });
    return name;
  }

  String priorityName(id) {
    var name;
    controller.ticketPriorities.value.priorities!.forEach((element) {
      if (id == element.id) {
        name = element.name;
      }
    });
    return name;
  }

  String statusName(id) {
    var name;
    controller.supportTickets.value.statuses!.forEach((element) {
      if (id == element.id) {
        name = element.name;
      }
    });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Get.to(() => TicketDetailsPage(
            ticketId: ticketData!.referenceNo, id: ticketData!.id));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      'Ticket ID: ${ticketData!.referenceNo}',
                      style: AppStyles.kFontBlack15w6,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                  ],
                ),
                Chip(
                  label: Text(
                    '${statusName(ticketData!.statusId)}',
                    style: AppStyles.kFontBlack14w5,
                  ),
                )
              ],
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Subject',
                    style: AppStyles.kFontBlack14w5,
                  ),
                  TextSpan(
                    text: ': ${ticketData!.subject}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Category',
                    style: AppStyles.kFontBlack14w5,
                  ),
                  TextSpan(
                    text: ': ${categoryName(ticketData!.categoryId)}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Priority',
                    style: AppStyles.kFontBlack14w5,
                  ),
                  TextSpan(
                    text: ': ${priorityName(ticketData!.priorityId)}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Last Updated',
                    style: AppStyles.kFontBlack14w5,
                  ),
                  TextSpan(
                    text:
                        ': ${CustomDate().formattedDateTime(ticketData!.updatedAt)}',
                    style: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
