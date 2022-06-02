import 'dart:io';

import 'package:amazcart/AppConfig/app_config.dart';
import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/support_ticket_controller.dart';
import 'package:amazcart/model/SupportTicketModel.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/dio_exception.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as DIO;

class CreateTicketPage extends StatefulWidget {
  final dynamic source;
  CreateTicketPage(this.source);
  @override
  _CreateTicketPageState createState() => _CreateTicketPageState();
}

class _CreateTicketPageState extends State<CreateTicketPage> {
  SupportTicketController ticketController = Get.put(SupportTicketController());

  final _formKey = GlobalKey<FormState>();

  File? file;

  List<File>? files = [];

  var tokenKey = 'token';

  bool ticketProcessing = false;

  GetStorage userToken = GetStorage();

  DIO.Response? response;
  DIO.Dio dio = new DIO.Dio();

  final TextEditingController subjectController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  void pickTicketFile() async {
    if (AppConfig.isDemo) {
      SnackBars().snackBarWarning("Disabled for demo.");
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
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

  Future submitTicket() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          ticketProcessing = true;
        });

        String token = await userToken.read(tokenKey);

        final formData = DIO.FormData.fromMap({
          'subject': subjectController.text,
          'category_id': ticketController.selectedTicketCategory.value.id,
          'priority_id': ticketController.selectedTicketPriority.value.id,
          'description': bodyController.text,
        });

        if (files!.length > 0) {
          for (var file in files!) {
            formData.files.addAll([
              MapEntry(
                  "ticket_file", await DIO.MultipartFile.fromFile(file.path)),
            ]);
          }
        }
        print(formData.fields);
        // return;

        response = await dio.post(
          URLs.TICKET_STORE,
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
          await widget.source.refresh(true);
          Future.delayed(Duration(seconds: 3), () {
            Get.back();
            SnackBars().snackBarSuccess('Ticket created successfully');
          });
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
    print(widget.source.length);
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
          'Create Ticket'.tr,
          style: AppStyles.appFont.copyWith(
            color: Colors.black,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                    'Subject',
                    textAlign: TextAlign.left,
                    style: AppStyles.kFontBlack14w5,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: TextFormField(
                      controller: subjectController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        hintText: 'Subject',
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
                          return 'Type Subject';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    'Select Category'.tr,
                    textAlign: TextAlign.left,
                    style: AppStyles.kFontBlack14w5,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Obx(() {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: AppStyles.textFieldFillColor,
                      )),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<TicketCategory>(
                          elevation: 1,
                          isExpanded: true,
                          underline: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                            ),
                          ),
                          value: ticketController.selectedTicketCategory.value,
                          items: ticketController
                              .ticketCategories.value.categories!
                              .map((e) {
                            return DropdownMenuItem<TicketCategory>(
                              child: Text('${e.name}'),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (TicketCategory? value) {
                            setState(() {
                              ticketController.selectedTicketCategory.value =
                                  value!;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    'Select Priority'.tr,
                    textAlign: TextAlign.left,
                    style: AppStyles.kFontBlack14w5,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Obx(() {
                    return DecoratedBox(
                      decoration: BoxDecoration(
                          border: Border.all(
                        color: AppStyles.textFieldFillColor,
                      )),
                      child: Container(
                        height: 50,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<TicketPriority>(
                          elevation: 1,
                          isExpanded: true,
                          underline: Container(),
                          value: ticketController.selectedTicketPriority.value,
                          items: ticketController
                              .ticketPriorities.value.priorities!
                              .map((e) {
                            return DropdownMenuItem<TicketPriority>(
                              child: Text('${e.name}'),
                              value: e,
                            );
                          }).toList(),
                          onChanged: (TicketPriority? value) {
                            setState(() {
                              ticketController.selectedTicketPriority.value =
                                  value!;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    'Description',
                    textAlign: TextAlign.left,
                    style: AppStyles.kFontBlack14w5,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Container(
                    child: TextFormField(
                      controller: bodyController,
                      maxLines: 10,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        hintText: 'Subject',
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
                          return 'Type Subject';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    child: InkWell(
                      onTap: pickTicketFile,
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: files!.length == 0
                                  ? Text(
                                      'Attach Files',
                                      style: AppStyles.kFontBlack15w4,
                                    )
                                  : Column(
                                      children: List.generate(
                                          files!.length,
                                          (filesIndex) => Text(
                                              '${files![filesIndex].path.split('/').last}',
                                              style: AppStyles.kFontBlack15w4)),
                                    ),
                            ),
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Icon(Icons.attach_file),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ticketProcessing
                        ? CupertinoActivityIndicator()
                        : GestureDetector(
                            onTap: submitTicket,
                            child: Container(
                              alignment: Alignment.center,
                              width: Get.width * 0.7,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppStyles.pinkColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Text(
                                'Submit',
                                style: AppStyles.kFontWhite14w5,
                              ),
                            ),
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
