import 'package:amazcart/controller/support_ticket_controller.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'AllSupportTicketsPage.dart';
import 'SupportTicketByStatusPage.dart';

class SupportTicketsPage extends StatefulWidget {
  @override
  _SupportTicketsPageState createState() => _SupportTicketsPageState();
}

class _SupportTicketsPageState extends State<SupportTicketsPage> {
  final SupportTicketController controller = Get.put(SupportTicketController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Scaffold(
          body: Center(
            child: CustomLoadingWidget(),
          ),
        );
      } else {
        return DefaultTabController(
          length: controller.supportTickets.value.statuses!.length + 1,
          child: Scaffold(
            backgroundColor: context.theme.cardColor,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: Colors.white,
              centerTitle: false,
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () {
                  Get.back();
                },
              ),
              title: Text(
                'Support Ticket'.tr,
                style: AppStyles.appFont.copyWith(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              bottom: TabBar(
                labelColor: AppStyles.pinkColor,
                indicator: BoxDecoration(
                  color: Color(0xffFFF0F4),
                ),
                unselectedLabelColor: AppStyles.greyColorDark,
                indicatorColor: AppStyles.pinkColor,
                isScrollable: true,
                physics: AlwaysScrollableScrollPhysics(),
                automaticIndicatorColorAdjustment: true,
                tabs: List.generate(
                    controller.supportTickets.value.statuses!.length + 1,
                    (index) {
                  if (index == 0) {
                    return Tab(
                      child: Text(
                        'All'.tr,
                      ),
                    );
                  }
                  return Tab(
                    child: Text(
                      controller
                          .supportTickets.value.statuses![index - 1].name!,
                    ),
                  );
                }),
              ),
            ),
            body: TabBarView(
              children: List.generate(
                  controller.supportTickets.value.statuses!.length + 1,
                  (index) {
                if (index == 0) {
                  return AllSupportTicketsPage();
                }
                return SupportTicketByStatusPage(
                    statusId: controller
                        .supportTickets.value.statuses![index - 1].id!,
                    statusName: controller
                        .supportTickets.value.statuses![index - 1].name!);
              }),
            ),
          ),
        );
      }
    });
  }
}
