import 'dart:convert';

import 'package:http/http.dart' as http;

abstract class ServiceFiltros<T>{
  String apiRoute;

  ServiceFiltros();

  String getApiRoute()=> apiRoute;
  void setApiRoute(String api){ apiRoute = api;}

  List<T> getLista(_decodedData);

  Future<List<T>> getAll() async{
    final _url = Uri.https('cps-ea.mil.ar:5261', apiRoute);

    final resp = await http.get(_url);
    final _decodedData = json.decode(resp.body);
    print(_decodedData);
    return getLista(_decodedData);
  }

}