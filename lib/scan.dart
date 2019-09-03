import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:suivi_poste/result.dart';
import 'package:suivi_poste/search.dart';
import 'package:suivi_poste/database_helpers.dart';
import 'package:suivi_poste/fancy_dialog.dart';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {

  



@override
  

  Future<void> _ackAlert(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: const Text('Code-Barres non valide. Veuillez rescanner'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  scanQR() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.camera]);
    if (permissions[PermissionGroup.camera] == PermissionStatus.granted) {
      print('have cam permission');
      String barcodeScanRes =
          await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true);
      print(barcodeScanRes);

      if (barcodeScanRes.length == 13) {
        _save(barcodeScanRes);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(barcode: barcodeScanRes),
          ),
        );
      } else {
        _ackAlert(context);
      }
    }
  }


showFancyDialog() async {
 await showDialog(
                      context: context,
                      builder: (_) => AssetGiffyDialog(
                        key: Key("popup"),
                            image: Image.asset(
                              'assets/scan.gif',
                              fit: BoxFit.scaleDown ,

                            ),
                            title: Text(
                              'Conseil',
                              style: TextStyle(
                                  fontSize: 22.0, fontWeight: FontWeight.w600),
                            ),
                            description: Text(
                              'Pour scanner votre code-barres, positionnez-vous dans le champ de scan. (Vous pouvez même activer le flash)',
                              textAlign: TextAlign.center,
                              style: TextStyle(),
                            ),
                            onlyOkButton: true,
                            buttonOkColor: Colors.green,
                            onOkButtonPressed: () { 
                               Navigator.pop(_); // pop dialog
                               scanQR();

                              },
                          ));
}



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: new AssetImage('assets/mail.png'),
          height: 200.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
            child: Text('Pour démarrer, taper sur "Scanner Code-Barres"'),
          ),
          FloatingActionButton.extended(
            heroTag: "scan",
            onPressed: showFancyDialog,
            icon: Icon(Icons.camera),
            label: Text("Scanner Code-Barres", style: TextStyle(fontSize: 20)),
            backgroundColor: Colors.pink,
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
            child: Text('Ou bien, vous pouvez saisir le numéro d\'envoi'),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          //   child: TextField(
          //     controller: _codeController,
          //     decoration: InputDecoration(
          //       border: new OutlineInputBorder(
          //       borderRadius: const BorderRadius.all(
          //             const Radius.circular(10.0),
          //           ),
          //       ),
          //       filled: true,
          //       hintStyle: new TextStyle(color: Colors.grey[800]),
          //       hintText: "Exemple: EE995454657TN",
          //       prefixIcon: Icon(Icons.edit, color: Colors.grey),
          //       fillColor: Colors.white70,
          //       errorText: _validate ? 'Value Can\'t Be Empty' : null,
          //     ),
          //   ),
          // ),

         Padding(

          padding: const EdgeInsets.only(bottom: 20.0),
          child:  FloatingActionButton.extended(
            heroTag: "recherche",
            onPressed: _openSearch,
            icon: Icon(FeatherIcons.search),
            label: Text("Recherche Manuelle", style: TextStyle(fontSize: 20)),
          ),

         ),
        ],
      ),
    );
  }


  _openSearch(){
    Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchPage(),
          ),
    );
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
