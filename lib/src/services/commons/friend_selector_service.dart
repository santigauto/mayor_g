
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import 'package:mayor_g/config.dart';
import 'package:mayor_g/src/models/friends_model.dart';

class GetFriendsService{

  String _url = 'cps-ea.mil.ar:5261';

  Future getFriends(BuildContext context,{ @required int dni }) async{
    //'https://www.maderosolutions.com.ar/MayorG1/modelo/getAmigos.php'
    final url = Uri.https(_url, 'api/Amigos/Solicitudes_Pendientes',{
      'dni' : dni.toString()
    });
    final resp = await http.get(url);
    final dynamic _decodedJson = jsonDecode(resp.body);
    
    
  }

  enviarSolicitud({@required int dni, @required int dniAmigo}) async{//devuelve true, es un post
  print('Enviar Solicitud');
    final url = Uri.https(_url, 'api/Amigos/Enviar_Solicitud_Test',{
      'dni' : dni.toString(),
      'dniAmigo' : dniAmigo.toString()
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('es true?:' + _decodedJson.toString());
  }

  Future cambiarNick({@required int dni, @required String deviceId, @required nickname}) async{//devuelve true, es un post
    print('Cambiar Nickname');
    final url = Uri.https(_url, 'api/Usuarios/Cambiar_Nickname',{
      'dni': dni.toString(),
      'deviceId': deviceId,
      'nickname': nickname
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('es true?:' + _decodedJson.toString());
  }

  Future solicitudesPendientes({@required int dni}) async{ // devuelve una lista, es un get
    print('solicitudesPedientes');
    final url = Uri.https(_url, 'api/Amigos/Solicitudes_Pendientes',{
      'dni' : dni.toString()
    });
    final resp = await http.get(url);
    final dynamic _decodedJson = jsonDecode(resp.body);
    print("holahola hola"+_decodedJson.toString());
  }

  Future obtenerUsuarioDni({@required int dni}) async{//devuelve true
    print('usuario');
    final url = Uri.https(_url, 'api/Usuarios/Obtener_Usuario_DNI',{
      'dni' : dni.toString()
    });
    final response = await http.get(url);
    dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('obtuvo?:' + _decodedJson.toString());
  }

  Future obtenerUsuarioDatos({@required String datos}) async{//devuelve true
    print('usuario');
    final url = Uri.https(_url, 'api/Usuarios/Obtener_Usuario_DNI',{
      'datos' : datos
    });
    final response = await http.get(url);
    dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('obtuvo?:' + _decodedJson.toString());
  }

  //POST Aprobar_Solicitud(string idSolicitud)
  Future aprobarSolicitud({@required String idSolicitud}) async{//devuelve true, es un post
  print('AproBar Solicitud');
    final url = Uri.https(_url, 'api/Amigos/Aprobar_Solicitud',{
      'idSolicitud' : idSolicitud
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('que llega?:' + _decodedJson.toString());
  }

  Future rechazarSolicitud({@required String idSolicitud}) async{//devuelve true, es un post
  print('Rechazar Solicitud');
    final url = Uri.https(_url, 'api/Amigos/Rechazar_Solicitud',{
      'idSolicitud' : idSolicitud
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('que llega?:' + _decodedJson.toString());
  }

  Future obtenerAmigos({@required int dni})async{
    print('obtener Amigos');
    final url = Uri.https(_url, 'api/Amigos/Listado_Amigos',{
      'dni' : dni.toString()
    });
    final resp = await http.get(url);
    final dynamic _decodedJson = jsonDecode(resp.body);
    final Amigos amigos = Amigos.fromJson(_decodedJson);
    print(amigos.amigos[0].nombre);
    print(_decodedJson.toString());
  }

  Future eliminarAmistad({@required int dni, @required int dniAmigo})async{
    print('Eliminar amigo');
    final url = Uri.https(_url, 'api/Amigos/Eliminar_Amigo',{
      'dni': dni.toString(),
      'dniAmigo' : dniAmigo.toString()
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('elimino?:' + _decodedJson.toString());
  }

  Future generarUserDevice({@required int dni,@required String deviceId, @required String deviceName, @required deviceVersion}) async{//devuelve true, es un post
  print('Generar Device');
    final url = Uri.https(_url, 'api/Usuarios/Generate_User_Device',{
      'dni': dni.toString(),
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceVersion': deviceVersion
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('que llega?:' + _decodedJson.toString());
  }

  Future iniciarJuego({@required int dni,@required String deviceId}) async{//devuelve true, es un post
  print('Generar Device');
    final url = Uri.https(_url, 'api/Usuarios/Iniciar_Juego',{
      'dni': dni.toString(),
      'deviceId': deviceId
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('que llega?:' + response.body);
  }


  Future enviarAporte({@required int dni,@required String deviceId, @required String texto}) async{//devuelve true, es un post
  print('Generar Device');
    final url = Uri.https(_url, 'api/Usuarios/Enviar_Aporte',{
      'dni': dni.toString(),
      'deviceId': deviceId,
      'texto': texto
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('que llega?:' + response.body);
  }

Future reportarFalla({@required int dni,@required String deviceId,@required String descripcion,@required String preguntaId}) async{//devuelve true, es un post
  print('Generar Device');
    final url = Uri.https(_url, 'api/Usuarios/Reportar_Falla',{
      'dni': dni.toString(),
      'deviceId': deviceId,
      'descripcion': descripcion,
      'PreguntaId' : preguntaId
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('que llega?:' + _decodedJson.toString());
}

Future registrarMilitar({@required int dni,@required String password,@required String deviceId, @required String deviceName, @required deviceVersion,@required bool esMilitar}) async{//devuelve true, es un post
  print('Registrar Militar');
    final url = Uri.https(_url, 'api/Usuarios/Registrar_Militar',{
      'dni': dni.toString(),
      'password': password,
      'esMilitar': esMilitar.toString(),
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceVersion': deviceVersion
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('que llega?:' + _decodedJson.toString());
}

Future registrarCivil({int dni, String password, String nickname, String deviceId, String deviceName, String deviceVersion, String mail}) async{//devuelve true, es un post
  print('Registrar Civil');
    final url = Uri.https(_url, 'api/Usuarios/Registrar_Civil',{
      'dni': dni.toString(),
      'password': password,
      'nickname': nickname,
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceVersion': deviceVersion,
      'mail': mail
    });
    final response = await http.post(url);
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('que llega?:' + _decodedJson.toString());
}


}
