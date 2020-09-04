import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mayor_g/src/models/filters/arma_model.dart';

class ArmaService{

  Future<List<Arma>> getArmas() async{
    final _url = Uri.https('cps-ea.mil.ar:5261', 'api/Json/Obtener_Armas');

    final resp = await http.get(_url);
    final _decodedData = json.decode(resp.body);
    final listaArmas = ListaArma.fromJsonList(_decodedData);
    return listaArmas.listaArma;
  }
}