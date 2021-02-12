import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mayor_g/src/models/background_music.dart';

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

  final player = BackgroundMusic.backgroundAudioPlayer;
  @override
  void initState(){
    playMusic();
    super.initState();
  }

  playMusic() async{
    await player.setAsset('assets/audios/Background_Music.mp3').then((value) =>player.setLoopMode(LoopMode.one).then((value) => player.play()));
  }

  @override
  void dispose() { 
    player.dispose();
    super.dispose();
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
                unselectedWidgetColor: Colors.white,
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
