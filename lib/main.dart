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
            canvasColor: Colors.transparent
          ),
          initialRoute: 'splash',
          routes: getApplicationRoutes(),
    );
        
  }
}
