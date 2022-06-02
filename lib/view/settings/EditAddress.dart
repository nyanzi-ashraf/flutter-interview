import 'dart:convert';

import 'package:amazcart/config/config.dart';
import 'package:amazcart/controller/address_book_controller.dart';
import 'package:amazcart/model/NewModel/CityList.dart';
import 'package:amazcart/model/NewModel/CountryList.dart';
import 'package:amazcart/model/CustomerAddress.dart';
import 'package:amazcart/model/StateList.dart';
import 'package:amazcart/utils/styles.dart';
import 'package:amazcart/widgets/AppBarWidget.dart';
import 'package:amazcart/widgets/ButtonWidget.dart';
import 'package:amazcart/widgets/snackbars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class EditAddress extends StatefulWidget {
  final Address address;

  EditAddress(this.address);

  @override
  _EditAddressState createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final AddressController addressController = Get.put(AddressController());
  bool defaultBilling = false;
  bool defaultShipping = false;

  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController postalCodeCtrl = TextEditingController();

  var tokenKey = 'token';

  GetStorage userToken = GetStorage();

  Future<CountryList?>? allCountry;
  String? selectedCountryName;
  int? selectedCountryId;

  Future<StateList?>? allStates;
  String? selectedStateName;
  int? selectedStateId;

  Future<CityList?>? allCities;
  String? selectedCityName;
  int? selectedCityId;

  @override
  void initState() {
    fullNameCtrl.text = widget.address.name!;
    emailCtrl.text = widget.address.email!;
    addressCtrl.text = widget.address.address!;
    phoneCtrl.text = widget.address.phone!;
    postalCodeCtrl.text = widget.address.postalCode!;
    if (widget.address.isShippingDefault == 1) {
      defaultShipping = true;
    }
    if (widget.address.isBillingDefault == 1) {
      defaultBilling = true;
    }
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  Future<CountryList?> getCountries() async {
    try {
      Uri myAddressUrl = Uri.parse(URLs.COUNTRY);
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return CountryList.fromJson(jsonString['countries']);
      } else {
        Get.snackbar(
          'Error'.tr,
          jsonString['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return null;
      }
    } finally {}
  }

  Future<StateList?> getStates(countryId) async {
    try {
      Uri myAddressUrl = Uri.parse(URLs.stateByCountry(countryId));
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return StateList.fromJson(jsonString['states']);
      } else {
        Get.snackbar(
          'Error'.tr,
          jsonString['message'],
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          borderRadius: 5,
        );
        return null;
      }
    } finally {}
  }

  Future<CityList?> getCities(stateId) async {
    try {
      Uri myAddressUrl = Uri.parse(URLs.cityByState(stateId));
      var response = await http.get(
        myAddressUrl,
      );
      var jsonString = jsonDecode(response.body);
      if (jsonString['message'] == 'success') {
        return CityList.fromJson(jsonString['cities']);
      } else {
        return null;
      }
    } finally {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      allCountry = getCountries();
      allCountry!.then((value) {
        value!.countries.forEach((element) {
          if (element.id.toString() == widget.address.country) {
            selectedCountryName = element.name;
            selectedCountryId = element.id;
          }
        });
        setState(() {
          allStates = getStates(selectedCountryId);
          allStates!.then((stateValue) {
            stateValue!.states!.forEach((stateElement) {
              if (stateElement.id.toString() == widget.address.state) {
                selectedStateName = stateElement.name;
                selectedStateId = stateElement.id;
              }
            });
            setState(() {
              allCities = getCities(selectedStateId);
              allCities!.then((cityValue) {
                if (cityValue != null) {
                  cityValue.cities.forEach((cityElement) {
                    if (cityElement.id.toString() == widget.address.city) {
                      selectedCityName = cityElement.name;
                      selectedCityId = cityElement.id;
                    }
                  });
                } else {
                  return null;
                }
                print({
                  'countryName': selectedCountryName,
                  'countryId': selectedCountryId,
                  'stateName': selectedStateName,
                  'stateId': selectedStateId,
                  'cityName': selectedCityName,
                  'cityId': selectedCityId,
                });
              });
            });
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyles.appBackgroundColor,
      appBar: AppBarWidget(
        title: 'Edit Address'.tr,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: fullNameCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Full Name'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Full Name'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.greyColorDark,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return 'Please Type Full name'.tr;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: emailCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Email'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Email'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return 'Please Type Email address'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                FutureBuilder<CountryList?>(
                  future: allCountry,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Country'.tr,
                            style: AppStyles.kFontBlack14w5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          getCountryDropDown(snapshot.data!.countries),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Select State'.tr,
                            style: AppStyles.kFontBlack14w5,
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          FutureBuilder<StateList?>(
                            future: allStates,
                            builder: (context, secSnap) {
                              if (secSnap.hasData) {
                                return getStatesDropDown(secSnap.data!.states!);
                              } else {
                                return Center(
                                    child: CupertinoActivityIndicator());
                              }
                            },
                          ),
                        ],
                      );
                    } else {
                      return Center(child: CupertinoActivityIndicator());
                    }
                  },
                ),
                TextFormField(
                  controller: addressCtrl,
                  keyboardType: TextInputType.text,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Address'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Address'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return 'Please Type Address'.tr;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: postalCodeCtrl,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: 'Postal/Zip Code'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Postal/Zip Code'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return 'Please Type Postal/Zip code'.tr;
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Phone Number'.tr,
                    hintStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    labelText: 'Phone Number'.tr,
                    labelStyle: AppStyles.appFont.copyWith(
                      color: AppStyles.blackColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  validator: (value) {
                    if (value!.length == 0) {
                      return 'Please Type Phone number'.tr;
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () async {
                print('delete');
                await deleteAddress().then((value) async {
                  if (value) {
                    SnackBars()
                        .snackBarSuccess('Address deleted successfully'.tr);
                    await addressController.getAllAddress().then((value) {
                      Future.delayed(Duration(seconds: 4), () {
                        Get.back();
                      });
                    });
                  }
                });
              },
              child: Container(
                height: 20,
                child: Text(
                  'Delete this Address'.tr,
                  style: AppStyles.appFont.copyWith(
                    color: AppStyles.pinkColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ButtonWidget(
              buttonText: 'Save Change'.tr,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await editAddress().then((value) async {
                    if (value) {
                      SnackBars()
                          .snackBarSuccess('Address updated successfully'.tr);
                      await addressController.getAllAddress().then((value) {
                        Future.delayed(Duration(seconds: 4), () {
                          Get.back();
                        });
                      });
                    }
                  });
                }
              },
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<bool> editAddress() async {
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.editAddress(widget.address.id));
    print(addressUrl);
    Map data = {
      "name": fullNameCtrl.text,
      "email": emailCtrl.text,
      "address": addressCtrl.text,
      "phone": phoneCtrl.text,
      "city": selectedCityId,
      "state": selectedStateId,
      "country": selectedCountryId,
      "postal_code": postalCodeCtrl.text
    };
    var body = json.encode(data);
    print(body);
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      return true;
    } else {
      if (response.statusCode == 401) {
        SnackBars()
            .snackBarWarning('Invalid Access token. Please re-login.'.tr);
        return false;
      } else {
        SnackBars().snackBarError(jsonString['message']);
        return false;
      }
    }
  }

  Future<bool> deleteAddress() async {
    String token = await userToken.read(tokenKey);
    Uri addressUrl = Uri.parse(URLs.DELETE_ADDRESS);
    print(addressUrl);
    Map data = {
      "id": widget.address.id,
    };
    var body = json.encode(data);
    var response = await http.post(addressUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body);
    var jsonString = jsonDecode(response.body);
    print(jsonString);
    if (response.statusCode == 202) {
      return true;
    } else {
      if (response.statusCode == 401) {
        SnackBars()
            .snackBarWarning('Invalid Access token. Please re-login.'.tr);
        return false;
      } else {
        SnackBars().snackBarError(jsonString['message']);
        return false;
      }
    }
  }

  Widget getCountryDropDown(List<AllCountry> country) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      height: 35,
      child: DropdownButton(
        elevation: 1,
        isExpanded: true,
        underline: Container(),
        items: country.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Row(
                children: [
                  item.flag == null
                      ? Icon(Icons.flag)
                      : Image.network(
                          '${URLs.HOST}/public${item.flag}',
                          width: 20,
                          errorBuilder: (context, object, stackTrace) {
                            return Icon(Icons.flag);
                          },
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    item.name!,
                    style: AppStyles.kFontBlack14w5,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            selectedCountryName = value.toString();

            selectedCountryId = getCode(country, value.toString());

            allStates = getStates(selectedCountryId);
            allStates!.then((stateValue) {
              selectedStateName = stateValue!.states![0].name;
              selectedStateId = stateValue!.states![0].id;
              debugPrint(
                  'User select state $selectedStateId $selectedStateName');

              setState(() {
                allCities = getCities(selectedStateId);
                allCities!.then((cityVal) {
                  selectedCityId = cityVal != null ? cityVal.cities[0].id : 0;
                  selectedCityName =
                      cityVal != null ? cityVal.cities[0].name : "None";
                });
                debugPrint(
                    'User select city $selectedCityId $selectedCityName');
              });
            });

            print({
              'countryName': selectedCountryName,
              'countryId': selectedCountryId,
              'stateName': selectedStateName,
              'stateId': selectedStateId,
              'cityName': selectedCityName,
              'cityId': selectedCityId,
            });
          });
        },
        value: selectedCountryName,
      ),
    );
  }

  Widget getStatesDropDown(List<AllState> states) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          height: 35,
          child: DropdownButton(
            elevation: 0,
            isExpanded: true,
            underline: Container(),
            items: states.map((item) {
              return DropdownMenuItem<String>(
                value: item.name,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    item.name!,
                    style: AppStyles.kFontBlack14w5,
                  ),
                ),
              );
            }).toList(),
            style:
                Theme.of(context).textTheme.headline4!.copyWith(fontSize: 15.0),
            onChanged: (value) {
              setState(() {
                selectedStateName = value.toString();
                selectedStateId = getCode(states, value.toString());
                allCities = getCities(selectedStateId);
                allCities!.then((value) {
                  selectedCityId = value != null ? value!.cities[0].id : 0;
                  selectedCityName =
                      value != null ? value!.cities[0].name : 'not found';
                });
                debugPrint(
                    'User select state $selectedStateName $selectedStateId');
                debugPrint(
                    'User select city $selectedCityName $selectedCityId');
              });

              print({
                'countryName': selectedCountryName,
                'countryId': selectedCountryId,
                'stateName': selectedStateName,
                'stateId': selectedStateId,
                'cityName': selectedCityName,
                'cityId': selectedCityId,
              });
            },
            value: selectedStateName,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          'Select City'.tr,
          style: AppStyles.kFontBlack14w5,
        ),
        SizedBox(
          height: 5,
        ),
        FutureBuilder<CityList?>(
          future: allCities,
          builder: (context, secSnap) {
            print(secSnap.hasData);
            if (secSnap.connectionState == ConnectionState.waiting) {
              return Center(child: CupertinoActivityIndicator());
            } else {
              if (secSnap.hasData) {
                return getCitiesDropDown(secSnap.data!.cities);
              } else {
                return Text('No City found');
              }
            }
          },
        ),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  Widget getCitiesDropDown(List<AllCity> cities) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      height: 35,
      child: DropdownButton(
        elevation: 0,
        isExpanded: true,
        underline: Container(),
        items: cities.map((item) {
          return DropdownMenuItem<String>(
            value: item.name,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                item.name!,
                style: AppStyles.kFontBlack14w5,
              ),
            ),
          );
        }).toList(),
        style: Theme.of(context).textTheme.headline4!.copyWith(fontSize: 15.0),
        onChanged: (value) {
          setState(() {
            selectedCityName = value.toString();
            selectedCityId = getCode(cities, value.toString());
            debugPrint('User select city $selectedCityId, $selectedCityName');
          });

          print({
            'countryName': selectedCountryName,
            'countryId': selectedCountryId,
            'stateName': selectedStateName,
            'stateId': selectedStateId,
            'cityName': selectedCityName,
            'cityId': selectedCityId,
          });
        },
        value: selectedCityName,
      ),
    );
  }

  int getCode<T>(List<dynamic> t, String title) {
    int? code;
    // for (var i = 0; i < int.parse(t.toString()); i++) {

    // }
    for (var cls in t) {
      if (cls.name == title) {
        code = cls.id;
        break;
      }
    }
    return code!;
  }
}
