import 'package:flutter/material.dart';

class ProfileInfo with ChangeNotifier{

String _nombre = '';

get nombre{return _nombre;}

set nombre(String text){
  _nombre = nombre;
  notifyListeners();
}
}