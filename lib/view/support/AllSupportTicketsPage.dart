import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/SupportTicketModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/view/support/CreateTicketPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loading_more_list/loading_more_list.dart';
import 'package:get/get.dart';

import 'TIcketIndicator.dart';
import 'TicketDataWidget.dart';

class AllSupportTicketsPage extends StatefulWidget {
  @override
  _AllSupportTicketsPageState createState() => _AllSupportTicketsPageState();
}

class _AllSupportTicketsPageState extends State<AllSupportTicketsPage> {
  AllSupportTicketPageLoadMore? source;

  @override
  void initState() {
    source = AllSupportTicketPageLoadMore();

    super.initState();
  }

  @override
  void dispose() {
    source!.dispose();

    super.dispose();
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
            return TicketDataWidgetAll(ticketData: ticketData);
          },
          sourceList: source!,
        ),
      ),
    );
  }
}

class AllSupportTicketPageLoadMore extends LoadingMoreBase<TicketData> {
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
        );
      } else {
        result = await _dio.get(URLs.TICKET_LIST,
            options: Options(
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Authorization': 'Bearer $token',
              },
            ),
            queryParameters: {
              'page': pageIndex,
            });
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
