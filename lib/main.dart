import 'dart:io';


import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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



  final AssetsAudioPlayer player = BackgroundMusic.backgroundAssetsAudioPlayer;
  @override
  void initState(){
    playMusic();
    super.initState();
  }

  playMusic() async{
    player.open(
      Audio("assets/audios/Background_Music.mp3"),
    );
    player.loop = true;
    player.play();

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
                textSelectionTheme: TextSelectionThemeData(cursorColor: Colors.white),
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
