import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:livi_app/Database/CountryFlag.dart';
import 'package:livi_app/checkPhoneNo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Database/DBHelper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences.getInstance().then((prefs) {
    dotenv.load(fileName: "assets/.env");
    DBHelper.instance.database.then((final database) async {
      if (prefs.getBool("db_Initialized") == null) {
        List countryList = await getCountryFlag();
        for(Map country in countryList){
          database!.countryFlagDao.insertCountryFlag(
              new CountryFlag(null,country["name"],country["flag"],country["code"]));
        }
        prefs.setBool("db_Initialized", true);
      }
    });
  });
  runApp(MyApp());
}

Future<List> getCountryFlag() async{
  String jsonString = await rootBundle.loadString('assets/countryFlagList.json');
  List countryFlagList = await json.decode(jsonString);
  return countryFlagList;
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appName = 'Custom Themes';

    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false ,
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.light,
        primaryColor: Colors.lightBlue[900],
        accentColor: Colors.cyan[600],

        // Define the default font family.
        fontFamily: 'Georgia',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic,color:Colors.lightBlue[900]),
          bodyText2: TextStyle(fontSize: 25.0, fontFamily: 'Hind',color:Colors.lightBlue[900]),
        ),
      ),
      home: MyHomePage(
        title: appName,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:<Widget>[
            Container(
                color: Theme.of(context).accentColor,
                child:  Image.asset('assets/image/livi_logo.png'),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 60.0),
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child:TextButton(
                  onPressed: () {
                    print('Clicked Start!');
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckPhoneNo()),
                    );
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                              ),
                          )
                      )
                  ),
                  child: Text(
                    'Start !',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              )
            )
          ]
        ),
      ),
    );
  }
}