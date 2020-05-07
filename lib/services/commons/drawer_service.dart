import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;


class _MenuProvider {
  List<dynamic> opciones = [];

  _MenuProvider() {
    //constructor
  }

  Future<List<dynamic>> cargarData() async{
    final res= await rootBundle.loadString('data/drawer_menu_opts.json');
      Map mapData = json.decode(res);
      opciones = mapData['rutas'];
      return opciones;
  }
}

final menuProvider = new _MenuProvider();
