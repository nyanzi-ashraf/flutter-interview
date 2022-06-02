import 'package:amazcart/config/config.dart';
import 'package:amazcart/model/NewModel/CustomerDataModel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class AccountController extends GetxController {
  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  var customerData = CustomerDataModel().obs;

  String? token;

  Rx<bool> loggedIn = false.obs;

  Future<bool> checkToken() async {
    token = await userToken.read(tokenKey);
    print(token);
    if (token == null) {
      loggedIn.value = false;
    } else {
      loggedIn.value = true;
      await getAccountDetails();
    }
    return loggedIn.value;
  }

  Future getAccountDetails() async {
    try {
      token = await userToken.read(tokenKey);
      Uri userData = Uri.parse(URLs.CUSTOMER_GET_DATA);
      var response = await http.get(
        userData,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      customerData.value = customerDataModelFromJson(response.body.toString());
    } catch (e) {
      print(e);
    } finally {}
  }

  @override
  void onInit() {
    checkToken();
    super.onInit();
  }
}
