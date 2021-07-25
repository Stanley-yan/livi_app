import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:livi_app/Database/CountryFlag.dart';
import 'package:livi_app/country_model.dart';
import 'package:livi_app/validationHistory.dart';

import 'Database/DBHelper.dart';
import 'Database/ValidationHistory.dart';

class CheckPhoneNo extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SelectCountry(),
    );
  }
}

class SelectCountry extends StatefulWidget{
  @override
  _SelectCountry createState() => _SelectCountry();
}

class _SelectCountry extends State<SelectCountry>{

  late String phoneNo;
  late TextEditingController myController;
  late CountryModel selectedCountry = CountryModel(id:0,name:"Hong Kong",flag:"HK",code:"+852");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myController = new TextEditingController();
    phoneNo = "";
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: [
          Container(
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
            child: TextField(
              keyboardType: TextInputType.number,
              controller: myController,
            ),
          ),
          Container(
              child: TextButton(
                onPressed: () {
                  print('clicked Validate');
                  print(myController.value.text);
                  print(selectedCountry.code+" "+selectedCountry.name);
                  insertValidationContent();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ValidationHistoryPage()),
                  );
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

  Future<void> insertValidationContent() async {
    final database = await DBHelper.instance.database;
    database!.validationHistoryDao.insertValidationHistory(
      new ValidationHistory(
        null,
        selectedCountry.name,
        selectedCountry.flag,
        selectedCountry.code,
        phoneNo
      )
    );
  }
}



