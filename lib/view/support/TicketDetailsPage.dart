import 'dart:convert';
import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/SupportTicketModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/CustomDate.dart';
import 'package:amazcart/widgets/custom_loading_widget.dart';
import 'package:amazcart/widgets/dio_exception.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as DIO;

class TicketDetailsPage extends StatefulWidget {
  final String? ticketId;
  final int? id;

  TicketDetailsPage({this.ticketId, this.id});

  @override
  _TicketDetailsPageState createState() => _TicketDetailsPageState();
}

class _TicketDetailsPageState extends State<TicketDetailsPage> {
  bool ticketProcessing = false;

  GetStorage userToken = GetStorage();
  var tokenKey = 'token';

  final _formKey = GlobalKey<FormState>();

  Future<TicketData>? ticket;

  Future<TicketData> getTicketDetails() async {
    var jsonString;
    try {
      String token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.TICKET_SHOW + '/${widget.ticketId}');
      print(userData);
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response!.statusCode == 200) {
        jsonString = jsonDecode(response!.body);
        print('ticket data $jsonString');
      }
    } catch (e) {}
    return TicketData.fromJson(jsonString['ticket']);
  }

  File? file;

  List<File> files = [];

  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();

  final TextEditingController replyCtrl = TextEditingController();

  void pickTicketFile() async {
    if (AppConfig.isDemo) {
      SnackBars().snackBarWarning("Disabled for demo.");
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'pdf', 'doc'],
      );

      if (result != null) {
        setState(() {
          files = result.paths.map((path) => File(path!)).toList();
        });
      } else {
        SnackBars().snackBarWarning('Cancelled');
      }
    }
  }

  String result = '';

  Future replyTicket() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          ticketProcessing = true;
        });

        String token = await userToken.read(tokenKey);

        final formData = DIO.FormData.fromMap({
          'text': replyCtrl.text,
          'ticket_id': widget.id,
        });

        if (files.length > 0) {
          for (var file in files) {
            formData.files.addAll([
              MapEntry(
                  "ticket_file", await DIO.MultipartFile.fromFile(file.path)),
            ]);
          }
        }
        print(formData.fields);
        // return;

        response = await dio.post(
          URLs.TICKET_REPLY,
          data: formData,
          options: DIO.Options(
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          ),
          onSendProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + '%');
            }
          },
        ).catchError((e) {
          print("EEEE $e");
          final errorMessage = DioExceptions.fromDioError(e).toString();
          print("ERROR MSG : $errorMessage");
          if (errorMessage == "401") {
            SnackBars().snackBarWarning('Unauthorized');
            Get.back();
          }
          setState(() {
            ticketProcessing = false;
          });
        });
        setState(() {
          ticketProcessing = false;
        });
        if (response!.statusCode == 201) {
          SnackBars().snackBarSuccess('${response!.data.toString()}');
        } else {
          if (response!.statusCode == 401) {
            SnackBars()
                .snackBarWarning('Invalid Access token. Please re-login.');
          } else {
            SnackBars().snackBarError(response!.data);
            return false;
          }
        }
      } catch (e) {
        print('ERROR  $e');
      }
    }
  }

  @override
  void initState() {
    setState(() {
      ticket = getTicketDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Details'.tr + "- ${widget.ticketId}",
          style: AppStyles.appFont.copyWith(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<TicketData>(
                future: ticket,
                builder: (context, snapshot) {
                  print(snapshot.connectionState);
                  if (snapshot.connectionState == ConnectionState.done) {
                    // If we got an error
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          '${snapshot.error} occured',
                          style: TextStyle(fontSize: 18),
                        ),
                      );

                      // if we got our data
                    } else if (snapshot.hasData) {
                      TicketData ticketData = snapshot.data!;
                      return Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Form(
                              child: ListView(
                                children: [
                                  // TicketDataWidget(
                                  //   ticketData: ticketData,
                                  // ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppStyles.appBackgroundColor,
                                      borderRadius: BorderRadius.circular(
                                        15,
                                      ),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: Html(
                                      data: '''${ticketData.description}''',
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: ticketData.messages!.length,
                                      separatorBuilder: (context, index) {
                                        return SizedBox(
                                          height: 10,
                                        );
                                      },
                                      itemBuilder: (context, index) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                            right: ticketData.messages![index]
                                                        .type ==
                                                    1
                                                ? 25
                                                : 0,
                                            left: ticketData.messages![index]
                                                        .type ==
                                                    0
                                                ? 25
                                                : 0,
                                          ),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: ticketData.messages![index]
                                                        .type ==
                                                    1
                                                ? AppStyles.lightPinkColor
                                                : AppStyles.appBackgroundColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(15),
                                              topRight: Radius.circular(15),
                                              bottomLeft: ticketData
                                                          .messages![index]
                                                          .type ==
                                                      0
                                                  ? Radius.circular(15)
                                                  : Radius.circular(0),
                                              bottomRight: ticketData
                                                          .messages![index]
                                                          .type ==
                                                      0
                                                  ? Radius.circular(0)
                                                  : Radius.circular(15),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: ticketData
                                                        .messages![index]
                                                        .type ==
                                                    1
                                                ? MainAxisAlignment.start
                                                : MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ticketData.messages![index]
                                                          .type ==
                                                      1
                                                  ? CircleAvatar(
                                                      radius: 12.0,
                                                      backgroundImage: ticketData
                                                                  .messages![
                                                                      index]
                                                                  .user!
                                                                  .avatar !=
                                                              null
                                                          ? NetworkImage(
                                                              "${AppConfig.assetPath}/${ticketData.messages![index].user!.avatar}")
                                                          : NetworkImage(
                                                              '${AppConfig.hostUrl}/public/backend/img/avatar.png'),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    )
                                                  : SizedBox.shrink(),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: ticketData
                                                              .messages![index]
                                                              .type ==
                                                          1
                                                      ? CrossAxisAlignment.start
                                                      : CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      '${ticketData.messages![index].user!.firstName} ${ticketData.messages![index].user!.lastName ?? ""}',
                                                      style: AppStyles
                                                          .kFontBlack12w4,
                                                    ),
                                                    Text(
                                                      '${CustomDate().formattedDateTime(ticketData.messages![index].createdAt)}',
                                                      style: AppStyles
                                                          .kFontBlack12w4,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Html(
                                                      data:
                                                          '${ticketData.messages![index].text}',
                                                      style: {
                                                        "p": Style(
                                                          textAlign: ticketData
                                                                      .messages![
                                                                          index]
                                                                      .type ==
                                                                  1
                                                              ? TextAlign.left
                                                              : TextAlign.right,
                                                        ),
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              ticketData.messages![index]
                                                          .type ==
                                                      0
                                                  ? CircleAvatar(
                                                      radius: 12.0,
                                                      backgroundImage: ticketData
                                                                  .messages![
                                                                      index]
                                                                  .user!
                                                                  .avatar !=
                                                              null
                                                          ? NetworkImage(
                                                              "${AppConfig.assetPath}/${ticketData.messages![index].user!.avatar}")
                                                          : AssetImage(
                                                                  'assets/images/icon_account.png')
                                                              as ImageProvider,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                          // Positioned(
                          //   right: Get.width * 0.2,
                          //   left: Get.width * 0.2,
                          //   bottom: 30,
                          //   child: Align(
                          //     alignment: Alignment.bottomCenter,
                          //     child: ticketProcessing
                          //         ? CupertinoActivityIndicator()
                          //         : GestureDetector(
                          //             onTap: () {},
                          //             child: Container(
                          //               alignment: Alignment.center,
                          //               width: Get.width * 0.7,
                          //               height: 50.h,
                          //               decoration: BoxDecoration(
                          //                   color: AppStyles.pinkColor,
                          //                   borderRadius: BorderRadius.all(
                          //                       Radius.circular(5.0))),
                          //               child: Text(
                          //                 'Submit',
                          //                 style: AppStyles.kFontWhite14w5,
                          //               ),
                          //             ),
                          //           ),
                          //   ),
                          // ),
                        ],
                      );
                    }
                  }
                  // Displaying LoadingSpinner to indicate waiting state
                  return Center(
                    child: CustomLoadingWidget(),
                  );
                }),
          ),
          Form(
            key: _formKey,
            child: Container(
              height: 70,
              child: Row(
                children: [
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.attach_file_rounded,
                        color: AppStyles.greyColorDark,
                        size: 20,
                      ),
                      onPressed: () {},
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      maxLines: 15,
                      minLines: 1,
                      autofocus: false,
                      scrollPhysics: AlwaysScrollableScrollPhysics(),
                      controller: replyCtrl,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        hintText: 'Type a message here',
                        fillColor: AppStyles.appBackgroundColor,
                        isDense: true,
                        contentPadding: EdgeInsets.all(10),
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
                        hintStyle: AppStyles.kFontGrey12w5,
                      ),
                      style: AppStyles.kFontBlack12w4,
                    ),
                  ),
                  Container(
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        color: AppStyles.greyColorDark,
                        size: 20,
                      ),
                      onPressed: () async {
                        print('send');
                        await replyTicket();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
