import 'package:flutter/material.dart';
import 'package:suivi_poste/database_helpers.dart';
import 'package:suivi_poste/result.dart';
import 'package:intl/intl.dart';

class HistoryPage extends StatefulWidget {
  



  @override
  HistoryPageState createState() => HistoryPageState();


}

class HistoryPageState extends State<HistoryPage> {


  var _historyEmpty = true;
  List<Search> _listofS;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _read();
    
  }


  @override
  Widget build(BuildContext context) {
    if (isLoaded == false) return _loadingUI(context);
    return _historyEmpty ? _emptyUI(context) : _HistoryListUI(context);
  }



// empty UI
Widget _emptyUI(BuildContext context) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.history, size: 100.0,),
            Text("Historique Vide")
          ],
        ),
      );
}


Widget _loadingUI(BuildContext context){
  return Center(
            child: CircularProgressIndicator(value: null,),
  );
}




// List of History search UI
Widget _HistoryListUI(BuildContext context) {
      return Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _listofS.length,
              itemBuilder: (context, index) {

                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(barcode: _listofS[index].code),
                      ),
                    );
                  },
                  leading: Icon(Icons.gradient),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  title: Text(_listofS[index].code), 
                  subtitle: Text(readTimestamp(_listofS[index].timestamp))
                ); // list[index].att
              },
            )
          ),
        ],
      );
}


    _read() async {
        DatabaseHelper helper = DatabaseHelper.instance;
        final searchs = await helper.queryAllCodes();
        setState(() => {
          isLoaded = true
        });
        if (searchs != null) {
          setState(() => {
            _historyEmpty = false,
            _listofS = searchs.reversed.toList()
           });
          

          searchs.forEach((search) {
            print('row ${search.id}: ${search.code} ${search.timestamp}');
          });
        }
        else {
         setState(() => _historyEmpty = true);
        }
      }


_deleteAll() async {
        DatabaseHelper helper = DatabaseHelper.instance;
        int id = await helper.deleteAll();
        print('All deleted! $id');

  }


    // _save() async {
    //     Search search = Search();
    //     search.code = 'code123';
    //     search.timestamp = '123456789';
    //     DatabaseHelper helper = DatabaseHelper.instance;
    //     int id = await helper.insert(search);
    //     print('inserted row: $id');
    //   }
 



  // Helper method
  // convert timestamp to readable date
  String readTimestamp(String timestamp) {
    var now = new DateTime.now();
    var format = new DateFormat('HH:mm a');
    var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 || diff.inMinutes > 0 && diff.inHours == 0 || diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = 'il y a ' + diff.inDays.toString() + ' jour';
      } else {
        time = 'il y a ' + diff.inDays.toString() + ' jours';
      }
    } else {
      if (diff.inDays == 7) {
        time = 'il y a ' + (diff.inDays / 7).floor().toString() + ' semaine';
      } else {
        time = 'il y a ' + (diff.inDays / 7).floor().toString() + ' semaines';
      }
    }

    return time;
  }
}