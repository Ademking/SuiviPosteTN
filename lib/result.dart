import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' hide Text;
import 'package:http/http.dart' as http;
import 'package:suivi_poste/database_helpers.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class SearchHistory {
  final int id;
  final String code;
  final String timestamp;
  SearchHistory(this.id, this.code, this.timestamp);
}

class Suivi {
  final String suivi_date;
  final String pays;
  final String lieu;
  final String type_event;
  final String autre;
  Suivi(this.suivi_date, this.pays, this.lieu, this.type_event, this.autre);
}

class ResultPage extends StatefulWidget {
  final String barcode;
  ResultPage({Key key, @required this.barcode}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  
  List<Suivi> listSuivi = [];
  bool loadingdone = false;
  int _currentStep = 0;
  bool _invalidCode = false;

  @override
  void initState() {
    super.initState();
    this.getData();
  }

  void getData() async {
    var url = 'http://www.rapidposte.poste.tn/fr/Item_Events.asp?ItemId=' +
        widget.barcode +
        '&submit=Valider';
    var response = await http.get(url);
    if (response.statusCode == 200) {
      
      setState(() {
        loadingdone = true;
      });

      var el = parse(response.body);
      var infoTable = el.getElementsByTagName("tbody")[22].children; // TR

      for (var i = 2; i < infoTable.length; i++) {
        var tds = infoTable[i].children; // TD
        var s = new Suivi(
            tds[0].text, tds[1].text, tds[2].text, tds[3].text, tds[4].text);
        this.listSuivi.add(s);
        print(s.suivi_date);
      }
    }
    else {
      // TODO :
      // error while getting data
    }
  }

  List<Step> _steps() {
    var list = <Step>[];

    for (var w in this.listSuivi.reversed) {
      list.add(Step(
          title: Text(w.suivi_date),
          subtitle: Text(w.pays, style: TextStyle(fontSize: 15.0)),
          content: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  // The long text inside this column overflows. Remove the row and column above this comment and the text wraps.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(FeatherIcons.mapPin, size: 15 ),
                            Text( " Lieu : ",style: TextStyle(fontWeight: FontWeight.bold),

                        ),
                          ]
                        ),
                        Text(w.lieu),
                        Row(
                          children: <Widget>[
                            Icon(FeatherIcons.flag, size: 15),
                            Text("Type d'évenement:", style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                          ]
                        ),
                        Text(w.type_event),
                        Text(w.autre == "" ? "" : w.autre),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
         state: _currentStep >= 0 ? StepState.complete : StepState.disabled,
          isActive: _currentStep >= 0,
));
    }
    return list.length == 0 ? [ Step(
      title: Text("Erreur - Code Invalide", style: TextStyle(fontSize: 20.0) ), 
      content: Text("Veuillez vérifier l'identifiant saisi..."),
      isActive: true,
      state: StepState.error
      ),] : list ;

  }


Widget _loadingUI(BuildContext context){
  return Center(
            child: CircularProgressIndicator(value: null,),
  );
}


Widget _resultUI(BuildContext context){
  return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
      left: 18,
      top: 30,
      right: 18,
      bottom: 18,
    ),
            child: Stack(
              alignment: AlignmentDirectional.center,

              children: <Widget>[
                Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                          new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Image(
                                width: 200.0,
                                image: new AssetImage('assets/search.png'),
                              ),

                                ]
                            ),
                            

                            Container(
                              margin: const EdgeInsets.all(15.0),
                              padding: const EdgeInsets.all(10.0),
                              decoration: new BoxDecoration(
                                border: new Border.all(color: Colors.blueAccent)
                              ),
                              child: Text(
                              "${widget.barcode.toUpperCase()}",
                              style: TextStyle(fontSize: 25.0),
                            ),
                            ),



                            Stepper(
                              physics: ClampingScrollPhysics(),
                              steps: _steps(),
                              currentStep: _currentStep,
                              // remove buttons from stepper
                              controlsBuilder: (BuildContext context,
                                      {VoidCallback onStepContinue,
                                      VoidCallback onStepCancel}) =>
                                  Container(),
                              onStepTapped: (int step) =>
                                  setState(() => _currentStep = step),
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Détails"),
        ),
        body: loadingdone == false ? _loadingUI(context) : _resultUI(context)


        );
  }




}
