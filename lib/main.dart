import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/routes/routes.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  //static BackgroundMusicBloc bloc;
  //static AudioCache audioCacheBackground;
  @override
  void initState(){
    //bloc = new BackgroundMusicBloc();
    //audioCacheBackground = new AudioCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    HttpOverrides.global = new MyHttpOverrides ();
    
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
        return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Mayor G Flutter',
              theme: ThemeData(
                cursorColor: Colors.white38,
                hintColor: Colors.white54,
                primarySwatch: Colors.green,
                primaryColor: Color(0xFF5C8D60),
                canvasColor: Colors.transparent,
              ),
              initialRoute: 'splash',
              routes: getApplicationRoutes(),
        );
      }
    //);
        
  //}
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}
