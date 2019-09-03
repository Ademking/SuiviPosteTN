import 'dart:async';

import 'package:flutter/material.dart';
import 'package:suivi_poste/about.dart';
import 'history.dart';
import 'package:suivi_poste/scan.dart';
import 'package:suivi_poste/navbar.dart';
import 'package:suivi_poste/database_helpers.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'package:feather_icons_flutter/feather_icons_flutter.dart';

// This will works always for lock screen Orientation.
void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
        fontFamily: 'Airbnb',
        scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      ),
      
    home: new MyApp(),

  ));
    });
}

// for AlertDialog
enum ConfirmAction { CANCEL, ACCEPT }

class MyApp extends StatefulWidget {


  @override
  _MyAppState createState() => new _MyAppState();

}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new AfterSplash(),
      title: new Text('Suivi Poste TN',
        style: new TextStyle(
          fontSize: 30.0,
           color: Color(0xFF003366),
           fontFamily: "Airbnb"
        ),
      ),
      image: new Image(image: new AssetImage('assets/mail.png')),
      backgroundColor: Color(0xFFFFFFFF),
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 160.0,
      onClick: ()=> {},
      loaderColor: Color(0xFF003366),
      loadingText: Text("Veuillez patienter...", style: new TextStyle(
           color: Color(0xFF003366),
           fontFamily: "Airbnb"
        ),)
    );
  }
}


class AfterSplash extends StatelessWidget {
  
  static const MaterialColor blue_poste = const MaterialColor(
  0xFF003366,
  const <int, Color>{
    50: const Color(0xFF003366),
    100: const Color(0xFF003366),
    200: const Color(0xFF003366),
    300: const Color(0xFF003366),
    400: const Color(0xFF003366),
    500: const Color(0xFF003366),
    600: const Color(0xFF003366),
    700: const Color(0xFF003366),
    800: const Color(0xFF003366),
    900: const Color(0xFF003366),
  },
);



  @override
  Widget build(BuildContext context) {
    
    return new DynamicTheme(
      defaultBrightness: Brightness.light,
      data: (brightness) => new ThemeData(
              primarySwatch: blue_poste,
              accentColor: Color(0xFF003366),
              bottomAppBarColor: brightness == Brightness.light ? const Color(0xFFFFFFFF) : const Color(0xFF303030),
              fontFamily: 'Airbnb',
              scaffoldBackgroundColor: brightness == Brightness.light ? const Color(0xFFFFFFFF) : const Color(0xFF303030),
              brightness: brightness,
              inputDecorationTheme: new InputDecorationTheme(
                fillColor: Colors.orange,
                filled: true,
              )
            ),
      themedWidgetBuilder: (context, theme) {
        return MaterialApp(
            title: 'Suivi Poste TN',
            theme: theme,
            home: MyHomePage(title: 'Suivi Poste TN'),
            debugShowCheckedModeBanner: false,
        );
      }
    );



    
  }

}







class MyHomePage extends StatefulWidget {

  
    MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {


    


  
  int _selectedIndex = 1;
  static const TextStyle optionStyle =  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  

  Widget _placeholder() {
    switch (_selectedIndex) {
      case 0:
        return HistoryPage();
        break;
      case 1:
        return ScanPage();
        break;
      case 2:
        return AboutPage();
        break;
      default:
    }
  }

  void _onItemTapped(int index) {
    
    switch (index) {
      case 0:
        print('Scan Page');
        break;
      case 1:
        print('History Page');
        break;
      case 2:
        print('About Page');
        break;
      default:
    }
    setState(() {
      _selectedIndex = index;
    });
  }

 void changeBrightness() {
    DynamicTheme.of(context).setBrightness(Theme.of(context).brightness == Brightness.dark? Brightness.light: Brightness.dark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _selectedIndex == 0 ? Text("Historique") : Text(widget.title),
        centerTitle: false,
        elevation: 5,
        actions: <Widget>[
                  _selectedIndex == 0 ? IconButton(
                    icon: Icon(FeatherIcons.trash2, color: Color(0xFFFFFFFF)),
                    onPressed: (){_asyncConfirmDialog(context);},
                  ) : IconButton(
                    icon: DynamicTheme.of(context).data.brightness == Brightness.light ? Icon(FeatherIcons.moon, color: Color(0xFFFFFFFF)) : Icon(FeatherIcons.sun, color: Color(0xFFFFFFFF)),
                    onPressed: (){changeBrightness();},
                  )
                ],
      ),
      
      body: _placeholder(),

      // bottomNavigationBar: BottomNavigationBar(
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.camera_enhance),
      //       title: Text('Scan'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.history),
      //       title: Text('Historique'),
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.info),
      //       title: Text('A Propos'),
      //     ),
      //   ],
      //   currentIndex: _selectedIndex,
      //   selectedItemColor: Colors.amber[800],
      //   onTap: _onItemTapped,
      // ),


          bottomNavigationBar: ExpandingBottomBar(
                  backgroundColor: Theme.of(context).bottomAppBarColor,
                  navBarHeight: 70.0,
                  items: [
                    ExpandingBottomBarItem(
                      icon: FeatherIcons.archive,
                      text: "Historique ",
                      selectedColor: DynamicTheme.of(context).data.brightness == Brightness.light ? Color(0xFF003366) : Color(0xFFFFFFFF),
                    ),
                    ExpandingBottomBarItem(
                      icon: FeatherIcons.home,
                      text: "Accueil  ",
                      selectedColor: DynamicTheme.of(context).data.brightness == Brightness.light ? Color(0xFF003366) : Color(0xFFFFFFFF),
                    ),
                    ExpandingBottomBarItem(
                      icon: FeatherIcons.info,
                      text: "A Propos ",
                      selectedColor: DynamicTheme.of(context).data.brightness == Brightness.light ? Color(0xFF003366) : Color(0xFFFFFFFF),
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onIndexChanged: _onItemTapped,
                ),



    );
  }





Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
  return showDialog<ConfirmAction>(
    context: context,
    barrierDismissible: false, // user must tap button for close dialog!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Effacer votre historique'),
        content: const Text(
            'Tout l\'historique sera effacé. Cette action est irréversible.'),
        actions: <Widget>[
          FlatButton(
            child: const Text('Annuler'),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.CANCEL);
            },
          ),
          FlatButton(
            child: const Text('Tout supprimer', style: TextStyle(color: Colors.red)),
            onPressed: () {
              Navigator.of(context).pop(ConfirmAction.ACCEPT);
              _deleteAll();
              setState(() {
                _selectedIndex = 1;
              });
            },
          )
        ],
      );
    },
  );
}
  
_deleteAll() async {
        DatabaseHelper helper = DatabaseHelper.instance;
        int id = await helper.deleteAll();
        print('All deleted! $id');

  }

 

}
