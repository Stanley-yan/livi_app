import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livi_app/Database/CountryFlag.dart';
import 'package:livi_app/country_model.dart';
import 'package:livi_app/twilioValidation.dart';
import 'package:livi_app/validationHistory.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Database/DBHelper.dart';
import 'Database/ValidationHistory.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Loading.dart';

class CheckPhoneNo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
        title: Text('Phone no Validation'),
      ),
      body: SelectCountry(),
    );
  }
}

class SelectCountry extends StatefulWidget {
  @override
  _SelectCountry createState() => _SelectCountry();
}

class _SelectCountry extends State<SelectCountry> {
  static const int _HTTP_OK = 200;
  late String phoneNo;
  late TextEditingController myController;
  late CountryModel selectedCountry =
      CountryModel(id: 0, name: "Hong Kong +852", flag: "HK", code: "+852");
  late List<ValidationHistory> validationHistoryList;
  late List<CountryModel> countryModelList;
  late bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController = new TextEditingController();
    phoneNo = "";
    validationHistoryList = [];
    countryModelList = [];
    isLoading = true;

    SharedPreferences.getInstance().then((prefs) async {
      dotenv.load(fileName: "assets/.env");

      if (prefs.getBool("db_Initialized") == null) {
        DBHelper.instance.database.then((final database) async {
          List countryList = await getCountryFlag();
          for (Map country in countryList) {
            database!.countryFlagDao.insertCountryFlag(new CountryFlag(
                null, country["name"], country["flag"], country["code"]));
          }
          prefs.setBool("db_Initialized", true);
          setState(() {
            isLoading = false;
          });
        });
      } else {
        countryModelList = await loadCountryList();
        setState(() => isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return isLoading
        ? Loading()
        : Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  // child: FutureBuilder<List<CountryModel>>(
                  //   future: loadCountryList(),
                  //   builder: (context, snapshot) {
                  //     return
                  child: DropdownSearch<CountryModel>(
                    items: countryModelList,
                    maxHeight: 300,
                    label: "Select Country",
                    onChanged: (data) => {
                      setState(() {
                        selectedCountry = data!;
                      })
                    },
                    selectedItem: selectedCountry,
                    showSearchBox: true,
                  ),
                  //),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: myController,
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: TextButton(
                        onPressed: () async {
                          phoneNo = myController.value.text;
                          if (phoneNo.isEmpty) {
                            showToastBox("Please enter Phone No.");
                            return;
                          }
                          int twilioResult = await TwilioValidation()
                              .phoneNoValidation(phoneNo, selectedCountry.flag);
                          insertValidationContent();
                          if (twilioResult == _HTTP_OK) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ValidationHistoryPage(
                                      historyList: validationHistoryList)),
                            );
                          } else {
                            showToastBox("Phone No. format error");
                          }
                        },
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(
                            color: Theme.of(context).primaryColor,
                          ),
                        ))),
                        child: Text(
                          'Validate !',
                          style: Theme.of(context).textTheme.bodyText2,
                        )),
                  ),
                )
              ],
            ),
          );
  }

  Future<List<CountryModel>> loadCountryList() async {
    final database = await DBHelper.instance.database;
    List<CountryFlag> temp = await database!.countryFlagDao.getAllCountryFlag();
    return CountryModel.fromCountryFlagList(temp);
  }

  void insertValidationContent() {
    ValidationHistory history = new ValidationHistory(
        null,
        selectedCountry.name,
        selectedCountry.flag,
        selectedCountry.code,
        phoneNo);
    setState(() {
      validationHistoryList.add(history);
    });
    // final database = await DBHelper.instance.database;
    // database!.validationHistoryDao.insertValidationHistory(history);
  }

  void showToastBox(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<List> getCountryFlag() async {
    String jsonString =
        await rootBundle.loadString('assets/countryFlagList.json');
    List countryFlagList = await json.decode(jsonString);
    return countryFlagList;
  }
}
