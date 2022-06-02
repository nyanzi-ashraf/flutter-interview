import 'package:amazcart/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:get/get.dart';

class SettingsModalWidget extends StatelessWidget {
  SettingsModalWidget(
      {this.buttonOnTap,
      this.modalTitle,
      this.textFieldHint,
      this.textFieldTitle,
      this.errorMsg,
      this.textEditingController});
  final VoidCallback? buttonOnTap;
  final String? modalTitle;
  final String? textFieldTitle;
  final String? textFieldHint;
  final String? errorMsg;
  final TextEditingController? textEditingController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Color(0xffDADADA),
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            modalTitle!,
            style: AppStyles.appFont.copyWith(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              textFieldTitle!,
              style: AppStyles.appFont.copyWith(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Color(0xffF6FAFC),
                borderRadius: BorderRadius.all(Radius.circular(4))),
            child: TextFormField(
              maxLines: 3,
              controller: textEditingController,
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
                suffixIcon: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        textEditingController!.clear();
                      },
                    ),
                  ],
                ),
                hintText: textFieldHint,
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
                  return errorMsg;
                } else {
                  return null;
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          ButtonWidget(
            buttonText: 'Save'.tr,
            onTap: buttonOnTap!,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          ),
        ],
      ),
    );
  }
}
