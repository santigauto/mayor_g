import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:mayor_g/src/widgets/alert_widget.dart';

abstract class ServiceFiltros<T>{
  String apiRoute;

  ServiceFiltros();

  String getApiRoute()=> apiRoute;
  void setApiRoute(String api){ apiRoute = api;}

  List<T> getLista(_decodedData);

  Future<List<T>> getAll(context,String filtro) async{
    final _url = Uri.https('mayorg.ejercito.mil.ar', apiRoute);
    final resp = await http.get(_url);
    List lista;

    if(!resp.headers['content-type'].contains('text/plain; charset=utf-8')) {
      Alert.alert(context, body: Text('Ups! No se encontraron filtros de $filtro. Por favor vuelva a intentar.'));
      lista = [];
    }else{
      final _decodedData = json.decode(resp.body);
      lista = getLista(_decodedData);
    }

    return lista;
    
  }

}