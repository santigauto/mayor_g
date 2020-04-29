import 'package:flutter/material.dart';
import 'package:mayor_g/models/profileInfo.dart';
import 'package:mayor_g/routes/routes.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
          create: (context) => ProfileInfo(),
          child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mayor G Flutter',
          theme: ThemeData(
            appBarTheme: AppBarTheme(color:Colors.green[900]),
            primarySwatch: Colors.green,
            primaryColor: Colors.green[900]
          ),
          initialRoute: 'splash',
          routes: getApplicationRoutes(), 
          ),
    );
        
  }
}
