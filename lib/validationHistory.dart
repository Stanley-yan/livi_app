import 'package:flutter/material.dart';
import 'package:livi_app/Database/ValidationHistory.dart';

import 'Database/DBHelper.dart';

class ValidationHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validation History'),
      ),
      body:Text('Body'),
    );
  }
}

class DisplayValidationHistory extends StatefulWidget{
  @override
  _DisplayValidationHistory createState() => _DisplayValidationHistory();
}

class _DisplayValidationHistory extends State<DisplayValidationHistory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: FutureBuilder<List<ValidationHistory>>(
        future: loadValidationHistory(),
        builder: (contect,snapshot) {
          return ListView(
            scrollDirection: Axis.vertical,
          );
        }
      ),
    );
  }

  Future<List<ValidationHistory>> loadValidationHistory() async{
    final database = await DBHelper.instance.database;
    List<ValidationHistory> temp = await database!.validationHistoryDao.getAllValidationHistory();
    return temp;
  }

}
