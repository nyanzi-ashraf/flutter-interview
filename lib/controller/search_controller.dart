import 'dart:async';
import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/LiveSearchModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<LiveSearchModel> liveSearchModel = LiveSearchModel().obs;

  Rx<TextEditingController> keywordCtrl = TextEditingController().obs;

  Future<LiveSearchModel?> getData({String? keyword, String? catId}) async {
    LiveSearchModel? result;
    try {
      isLoading(true);
      Map body = {
        "keyword": keyword,
        "cat_id": catId,
      };
      var response = await Dio().post(
        URLs.LIVE_SEARCH,
        data: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        isLoading(false);

        result = LiveSearchModel.fromJson(response.data);

        liveSearchModel.value = result;
      } else {
        isLoading(false);
      }

      return result;
    } catch (e) {
      isLoading(false);
      throw e.toString();
    }
  }

  List<TextSpan> highlightOccurrences(String source, String query) {
    if (query == null ||
        query.isEmpty ||
        !source.toLowerCase().contains(query.toLowerCase())) {
      return [TextSpan(text: source)];
    }
    final matches = query.toLowerCase().allMatches(source.toLowerCase());

    int lastMatchEnd = 0;

    final List<TextSpan> children = [];
    for (var i = 0; i < matches.length; i++) {
      final match = matches.elementAt(i);

      if (match.start != lastMatchEnd) {
        children.add(TextSpan(
          text: source.substring(lastMatchEnd, match.start),
        ));
      }

      children.add(TextSpan(
        text: source.substring(match.start, match.end),
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ));

      if (i == matches.length - 1 && match.end != source.length) {
        children.add(TextSpan(
          text: source.substring(match.end, source.length),
        ));
      }

      lastMatchEnd = match.end;
    }
    return children;
  }

  @override
  void onInit() {
    super.onInit();
  }
}

class Search {
  final int? id;
  final String? name;

  Search({this.id, this.name});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> user = Map<String, dynamic>();
    user["id"] = id;
    user["name"] = this.name;
    return user;
  }

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        id: json["id"],
        name: json["name"],
      );
}
