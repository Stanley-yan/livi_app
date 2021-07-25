import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:livi_app/Database/ValidationHistory.dart';
import 'Database/DBHelper.dart';

class ValidationHistoryPage extends StatelessWidget {

  const ValidationHistoryPage({Key? key, required this.historyList}) : super(key: key);

  final List<ValidationHistory> historyList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Validation History'),
      ),
      body:DisplayValidationHistory(historyList)
    );
  }
}

class DisplayValidationHistory extends StatefulWidget{
  final List<ValidationHistory> historyList;
  DisplayValidationHistory(this.historyList);

  @override
  _DisplayValidationHistory createState() => _DisplayValidationHistory();
}

class _DisplayValidationHistory extends State<DisplayValidationHistory> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // child: FutureBuilder<List<ValidationHistory>>(
      //   future: loadValidationHistory(),
      //   builder: (context,snapshot) {
      //     if (snapshot.connectionState != ConnectionState.done) {
      //       //print('project snapshot data is: ${projectSnap.data}');
      //       return Container();
      //     }
      //     return ListView.builder(
      //       padding: const EdgeInsets.all(10.0),
      //       itemCount: snapshot.data!.length,
      //       itemBuilder: (context, i){
      //         return ListTile(
      //           title: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children:<Widget>[
      //               Text(snapshot.data![i].phoneNo),
      //               Text(snapshot.data![i].countryName),
      //               Text(snapshot.data![i].countryFlag),
      //             ],
      //           ),
      //         );
      //       },
      //     );
      //   }
      // ),
      child: ListView.builder(
          padding: const EdgeInsets.all(10.0),
          itemCount: widget.historyList.length,
          itemBuilder: (context, i){
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:<Widget>[
                  Text(widget.historyList[i].phoneNo),
                  Text(widget.historyList[i].countryName),
                  Text(widget.historyList[i].countryFlag),
                ],
              ),
            );
          },
          ),
    );
  }

  Future<List<ValidationHistory>> loadValidationHistory() async{
    final database = await DBHelper.instance.database;
    List<ValidationHistory> temp = await database!.validationHistoryDao.getAllValidationHistory();
    return temp;
  }

}
