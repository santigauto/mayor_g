import 'package:flutter/material.dart';
import 'package:mayor_g/views/menu_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mayor G Flutter',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MenuPage());
  }
}
