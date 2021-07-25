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

import 'Database/DBHelper.dart';
import 'Database/ValidationHistory.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CheckPhoneNo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phone no Validation'),
      ),
      body: SelectCountry(),
    );
  }
}

class SelectCountry extends StatefulWidget{
  @override
  _SelectCountry createState() => _SelectCountry();
}

class _SelectCountry extends State<SelectCountry>{
  static const int _HTTP_OK = 200;
  late String phoneNo;
  late TextEditingController myController;
  late CountryModel selectedCountry = CountryModel(id:0,name:"Hong Kong +852",flag:"HK",code:"+852");
  late List<ValidationHistory> validationHistoryList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController = new TextEditingController();
    phoneNo = "";
    validationHistoryList = [];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: FutureBuilder<List<CountryModel>>(
              future: loadCountryList(),
              builder: (context, snapshot) {
                return DropdownSearch<CountryModel>(
                  items: snapshot.data,
                  maxHeight: 300,
                  label: "Select Country",
                  onChanged:  (data) => {setState((){
                    selectedCountry = data!;
                  })},
                  selectedItem: selectedCountry,
                  showSearchBox: true,
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: myController,
            ),
          ),
          Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: () async {
                  phoneNo = myController.value.text;
                  int twilioResult = await TwilioValidation().phoneNoValidation(phoneNo,selectedCountry.flag);
                  insertValidationContent();
                  if(twilioResult == _HTTP_OK){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ValidationHistoryPage(historyList:validationHistoryList)),
                    );
                  }
                  else{
                    Fluttertoast.showToast(
                        msg: "Phone No format error",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 3,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                  }
                },
                child:Text('Validate !'),
              )
          )
        ],
      ),
    );
  }

  Future<List<CountryModel>> loadCountryList() async{
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
        phoneNo
    );
    setState(() {
      validationHistoryList.add(history);
    });
    // final database = await DBHelper.instance.database;
    // database!.validationHistoryDao.insertValidationHistory(history);
  }
}



