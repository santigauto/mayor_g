//TODO eliminar esto

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';

import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

import 'package:mayor_g/src/models/persona_model.dart';
import 'package:mayor_g/src/services/auth_service.dart';
import 'package:mayor_g/config.dart';

class PersonaServices {
  Future<List<Persona>>getPersona(BuildContext context, {@required String uat, int dni = 0, String apellido = '', String nombres = ''}) async {
    if(uat == null || uat.isEmpty){
      return null;
    }

    final url = Uri.https(Config.ApiURLCGE, '/api/INTRANETEA/Trae_Datos_Persona', {
      'uat'     : uat,
      'dni'     : dni.toString(),
      'apellido': apellido,
      'nombres' : nombres,
    });
    final http.Response response = await http.get(url, headers: Config.HttpHeaders);

    if (response.body.isEmpty || !response.headers['content-type'].contains('application/json; charset=utf-8')) {
      return null;
    }

    final dynamic _decodedJson = jsonDecode(response.body);

    if(_decodedJson[0]['Mensaje'].startsWith('UAT Vencida')){
      AuthService().logout(context: context);
      return null;
    }

    if (response.statusCode.toString().isEmpty || response.statusCode != 200) {
      return null;
    }

    List<Persona> _personas = [];

    _decodedJson.forEach((per){
      _personas.add(Persona.fromJsonMap(per));
    });

    return _personas;
  }
}
