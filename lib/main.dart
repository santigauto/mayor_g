import 'package:flutter/material.dart';

import 'package:mayor_g/routes/routes.dart';
import 'package:mayor_g/models/profileInfo.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mayor G Flutter',
          theme: ThemeData(
            cursorColor: Colors.white38,
            hintColor: Colors.white54,
            primarySwatch: Colors.green,
            primaryColor: Colors.green[900],
            canvasColor: Colors.transparent,
            hoverColor: Colors.white,
            textSelectionColor: Colors.white,
            focusColor: Colors.white,
            appBarTheme: AppBarTheme(
              textTheme: TextTheme(
                title: TextStyle(color: Colors.white),
                subhead: TextStyle(color: Colors.white),
                subtitle: TextStyle(color: Colors.white),
                body1: TextStyle(color: Colors.white),
                caption: TextStyle(color: Colors.white),

              )
            )
          ),
          initialRoute: 'splash',
          routes: getApplicationRoutes(),
    );
        
  }
}
