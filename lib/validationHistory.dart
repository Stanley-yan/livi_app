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
      body:DisplayValidationHistory()
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
        builder: (context,snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            //print('project snapshot data is: ${projectSnap.data}');
            return Container();
          }
          return ListView.builder(
            padding: const EdgeInsets.all(10.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, i){
              return ListTile(
                title: Text(
                  snapshot.data![i].phoneNo,
                ),
              );
            },
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
