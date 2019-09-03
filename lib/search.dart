import 'package:flutter/material.dart';
import 'package:suivi_poste/result.dart';
import 'package:suivi_poste/database_helpers.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class SearchPage extends StatefulWidget {

   @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  var _codeController = TextEditingController();
  bool _validate = false;
  String _errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("Recherche Manuelle"),
        ),
        body: Center(child: Column(
            children: <Widget>[

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _codeController,
                    maxLength: 13,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                    textCapitalization: TextCapitalization.characters ,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                            const Radius.circular(10.0),
                          ),
                      ),
                      filled: true,
                      hintStyle: new TextStyle(color: Colors.grey[800]),
                      hintText: "Exemple: EE995454657TN",
                      prefixIcon: Icon(FeatherIcons.hash, color: Colors.grey),
                      fillColor: Colors.white70,
                      errorText: errorTextValidation(),
                    ),
                  ),
                ),



          FloatingActionButton.extended(
            heroTag: "recherche",
            onPressed: (){
              _validateInput();
              },
            icon: Icon(Icons.search),
            label: Text("Recherche", style: TextStyle(fontSize: 20)),
            backgroundColor: Colors.pink,
          ),


             Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0 , top: 20.0, bottom: 0),
                  child:   Column(
                      children: <Widget>[
                      Text("- Pour les envois destinés à l'étranger et en Tunisie, saisissez le numéro d'envoi Rapid-Poste,composé de 13 caractères ( Exemple de N° : EE995454657TN ), figurant sur le bordereau de dépôt dont vous disposez."),
                  ],
                  ),
              ),

              Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0 , top: 20.0, bottom: 0),
                  child:   Column(
                      children: <Widget>[
                      Text("- Pour les envois en provenance de l'étranger, saisisez le numéro d'envoi communiqué par votre correspondant à l'étranger"),
                  ],
                  ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Image(image: new AssetImage('assets/num_envoi.jpg'), height: 100),
              ),

            ],
        )),
        );
  }



String errorTextValidation(){
 return _validate ? _errorMsg : null;
}


  _validateInput(){

    if (_codeController.text.length != 13){
      setState(() {
            _validate = true;
            _errorMsg = "Votre code doit être composé de 13 caractères";
      }); 
    }
    else {
      _save(_codeController.text.toUpperCase());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(barcode: _codeController.text),
          ),
      );
      setState(() {
            _validate = false;
      });

    }
    
  }


  _save(String code) async {
        Search search = Search();
        search.code = code;
        search.timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        DatabaseHelper helper = DatabaseHelper.instance;
        int id = await helper.insert(search);
        print('inserted row: $id');
      }





}