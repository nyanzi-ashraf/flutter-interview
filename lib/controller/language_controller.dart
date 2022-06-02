import 'package:amazcart/AppConfig/language/translation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LangController extends GetxController {
  var langValue = false.obs;

  var selectedLanguage = Get.deviceLocale!.languageCode.obs;

  var languageName = ''.obs;

  var languageKey = 'lang';

  GetStorage getStorage = GetStorage();

  Future changeLanguage(String lang) async {
    Locale locale = new Locale(lang);
    Get.updateLocale(locale);
    selectedLanguage.value = lang;
    await getStorage.write(languageKey, selectedLanguage.value);
  }

  Future getLanguageName() async {
    String savedLanguage = await getStorage.read(languageKey);

    print("GOT Language from storage $savedLanguage");

    savedLanguage != null ? langValue.value = true : langValue.value = false;

    print(langValue.value);

    selectedLanguage.value = savedLanguage;

    print("GOT LANG ${selectedLanguage.value}");

    languages.forEach((element) {
      // print(element);
      // print("${element.languageValue} ${selectedLanguage.value}");
      if (element.languageValue == selectedLanguage.value) {
        languageName.value = element.languageText!;
        print(languageName.value);
      }
    });
  }

  LangController._privateConstructor();

  static LangController get instance => _instance;

  static final LangController _instance = LangController._privateConstructor();

  factory LangController() {
    return _instance;
  }

  @override
  void onInit() {
    getLanguageName();
    super.onInit();
  }
}
