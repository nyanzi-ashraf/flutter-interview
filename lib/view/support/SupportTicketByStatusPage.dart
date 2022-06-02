import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/support_ticket_controller.dart';
import 'package:amazcart/model/SupportTicketModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/support/CreateTicketPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'TIcketIndicator.dart';
import 'TicketDataWidget.dart';

class SupportTicketByStatusPage extends StatefulWidget {
  final int? statusId;
  final String? statusName;

  SupportTicketByStatusPage({this.statusId, this.statusName});

  @override
  _SupportTicketByStatusPageState createState() =>
      _SupportTicketByStatusPageState();
}

class _SupportTicketByStatusPageState extends State<SupportTicketByStatusPage> {
  final SupportTicketController controller = Get.put(SupportTicketController());

  TicketByStatusLoadMore? source;

  @override
  void initState() {
    source = TicketByStatusLoadMore(widget.statusId!);

    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();

    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('onp');
          Get.to(() => CreateTicketPage(source));
        },
        backgroundColor: AppStyles.pinkColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: LoadingMoreList<TicketData>(
        ListConfig<TicketData>(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          indicatorBuilder: TicketIndicator(
            source: source,
            isSliver: false,
            name: 'Tickets'.tr,
          ).buildIndicator,
          showGlowLeading: true,
          itemBuilder: (BuildContext c, TicketData ticketData, int index) {
            return TicketDataWidget(ticketData: ticketData);
          },
          sourceList: source!,
        ),
      ),
    );
  }
}

class TicketByStatusLoadMore extends LoadingMoreBase<TicketData> {
  final int statusId;

  TicketByStatusLoadMore(this.statusId);

  bool isSorted = false;
  String sortKey = 'new';

  int pageIndex = 1;
  bool _hasMore = true;
  bool forceRefresh = false;
  int productsLength = 0;

  @override
  bool get hasMore => (_hasMore && length < productsLength) || forceRefresh;

  @override
  Future<bool> refresh([bool clearBeforeRequest = false]) async {
    _hasMore = true;
    pageIndex = 1;
    //force to refresh list when you don't want clear list before request
    //for the case, if your list already has 20 items.
    forceRefresh = !clearBeforeRequest;
    var result = await super.refresh(clearBeforeRequest);
    forceRefresh = false;
    return result;
  }

  @override
  Future<bool> loadData([bool isloadMoreAction = false]) async {
    Dio _dio = Dio();

    bool isSuccess = false;
    try {
      GetStorage userToken = GetStorage();
      var tokenKey = 'token';

      String token = await userToken.read(tokenKey);
      //to show loading more clearly, in your app,remove this
      // await Future.delayed(Duration(milliseconds: 500));
      var result;
      SupportTicketModel source;

      if (this.length == 0) {
        result = await _dio.get(
          URLs.TICKET_LIST,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'page': pageIndex, 'status': statusId},
        );
      } else {
        result = await _dio.get(
          URLs.TICKET_LIST,
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          queryParameters: {'page': pageIndex, 'status': statusId},
        );
      }
      print(result.realUri);
      final data = new Map<String, dynamic>.from(result.data);
      source = SupportTicketModel.fromJson(data);
      productsLength = source.tickets!.total!;

      if (pageIndex == 1) {
        this.clear();
      }
      for (var item in source.tickets!.data!) {
        this.add(item);
      }

      _hasMore = source.tickets!.data!.length != 0;
      pageIndex++;
      isSuccess = true;
    } catch (exception, stack) {
      isSuccess = false;
      print(exception);
      print(stack);
    }
    return isSuccess;
  }
}
