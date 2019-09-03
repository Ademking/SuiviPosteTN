import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {

_launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child:
            RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(text: 'Suivi Poste TN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0)),
                TextSpan(text: ' v1.0.0'),
                TextSpan(text: "\nCette application vous permet d'obtenir à tout moment des informations sur les étapes de traitement de votre envoi et la confirmation de sa livraison."),
                TextSpan(text: "\n\nCette application n'est pas officielle et n'a pas été développée par la Poste Tunisenne."),
                TextSpan(text: '\n\nRéalisée par : \n'),
                TextSpan(text: 'Adem KOUKI ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0)),
              ],
            ),
          ),
          ),
          ButtonTheme(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
            minWidth: 300.0,
            child: FlatButton(
            child: const Text('Code Source de l\'application (Github)', style: TextStyle(color: Colors.white)),
            color: Color(0xFF404040),
            onPressed: () {
              _launchURL("https://github.com/Ademking/SuiviPosteTN");
            },
          ),
          ),
          ButtonTheme(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
            minWidth: 300.0,
            child: FlatButton(
            child: const Text('Mon compte Facebook', style: TextStyle(color: Colors.white)),
            color: Color(0xFF4078c0),
            onPressed: () {
              _launchURL("https://www.facebook.com/AdemKouki.Officiel");
            },
          ),
          ),
          ButtonTheme(
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(5.0)),
            minWidth: 300.0,
            child: FlatButton(
            child: const Text('Me contacter par @mail', style: TextStyle(color: Colors.white)),
            color: Color(0xFFbd2c00),
            onPressed: () {
              _launchURL("mailto:ademkingnew@gmail.com?subject=A%20Propos%20SuiviPosteTN");
            },
          ),
          ),
        ]
      ),
    );
  }
}