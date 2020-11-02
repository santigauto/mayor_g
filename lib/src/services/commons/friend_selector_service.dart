
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//import 'package:mayor_g/config.dart';
import 'package:mayor_g/src/models/friends_model.dart';
import 'package:mayor_g/src/widgets/alert_widget.dart';




class GetFriendsService{

  String _url = 'cps-ea.mil.ar:5261';

  Future getGet(context,{String apiRoute, Map<String, String> queryParameters}) async{
    final __url = Uri.https(_url, apiRoute, queryParameters);
    final resp = await http.get(__url);
    dynamic result;

    if(resp.body.isEmpty) {
      Alert.alert(context, body: Text('Ups! Ha ocurrido un error.'));
    }else{
      final _decodedData = json.decode(resp.body);
      result = _decodedData;
    }
    print(result);
    return result;
    
  }

  Future getPost(context,{String apiRoute, String jsonEncode, Map<String, String> queryParameters}) async{
    final __url = Uri.https(_url, apiRoute, queryParameters);
    final resp = await http.post(__url,body: (jsonEncode));
    dynamic result;

    if(resp.body.isEmpty) {
      Alert.alert(context, body: Text('Ups! Ha ocurrido un error.'));
    }else{
      final _decodedData = json.decode(resp.body);
      result = _decodedData;
    }
    print(result);
    return result;
    
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

  Future solicitudesPendientes(BuildContext context,{@required int dni}) async{ // devuelve una lista, es un get
    print('solicitudesPedientes');
    getGet(context,apiRoute: 'api/Amigos/Solicitudes_Pendientes',queryParameters: {
      'dni' : dni.toString()
    });
  }

  Future obtenerUsuarioDni(BuildContext context,{@required int dni}) async{//devuelve true
    print('usuario');
    getGet(context,apiRoute: 'api/Usuarios/Obtener_Usuario_DNI',queryParameters: {
      'dni' : dni.toString()
    });
  }

  Future obtenerUsuarioDatos(BuildContext context,{@required String datos}) async{//devuelve datosUsuario
    getGet(context,apiRoute: 'api/Usuarios/Obtener_Usuario_Dato',queryParameters: {
      'datos' : datos
    });
  }

  //POST Aprobar_Solicitud(string idSolicitud)
  Future aprobarSolicitud(BuildContext context,{@required String idSolicitud}) async{//devuelve true, es un post
  print('AproBar Solicitud');
  getPost(context,apiRoute: 'api/Amigos/Aprobar_Solicitud',queryParameters: {
    'idSolicitud' : idSolicitud
  });
  }

  Future rechazarSolicitud(BuildContext context,{@required String idSolicitud}) async{//devuelve true, es un post
  print('Rechazar Solicitud');
  getPost(context,apiRoute: 'api/Amigos/Rechazar_Solicitud',queryParameters: {
    'idSolicitud' : idSolicitud
  });
  }

  Future obtenerAmigos(BuildContext context,{@required int dni})async{
    print('obtener Amigos');
    getGet(context,apiRoute: 'api/Amigos/Listado_Amigos',queryParameters: {
      'dni' : dni.toString()
    });
  }

  Future eliminarAmistad(BuildContext context,{@required int dni, @required int dniAmigo})async{
    print('Eliminar amigo');
    getPost(context,apiRoute: 'api/Amigos/Eliminar_Amigo',queryParameters: {
      'dni': dni.toString(),
      'dniAmigo' : dniAmigo.toString()
    });
  }

  Future generarUserDevice(BuildContext context,{@required int dni,@required String deviceId, @required String deviceName, @required deviceVersion}) async{//devuelve true, es un post
  print('Generar Device');
  getPost(context,apiRoute: 'api/Usuarios/Generate_User_Device',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'deviceName': deviceName,
    'deviceVersion': deviceVersion
  });}

  Future iniciarJuego(BuildContext context,{@required int dni,@required String deviceId}) async{//devuelve true, es un post
  print('Iniciar Juego');
  getPost(context,apiRoute: 'api/Usuarios/Iniciar_Juego',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId
  });
  }


  Future enviarAporte(BuildContext context,{@required int dni,@required String deviceId, @required String texto}) async{//devuelve true, es un post
  print('Generar Device');
  getPost(context,apiRoute: 'api/Usuarios/Enviar_Aporte',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'texto': texto
  });
  }

Future reportarFalla(BuildContext context,{@required int dni,@required String deviceId,@required String descripcion,@required String preguntaId}) async{//devuelve true, es un post
  print('Reportar Falla');
  getPost(context, apiRoute: 'api/Usuarios/Reportar_Falla',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'descripcion': descripcion,
    'PreguntaId' : preguntaId
  });
}


Future registrarCivil(BuildContext context,{int dni, String password, String nickname, String deviceId, String deviceName, String deviceVersion, String mail}) async{//devuelve true, es un post
  print('Registrar Civil');
  getPost(context,apiRoute: 'api/Usuarios/Registrar_Civil',queryParameters: {
    'dni': dni.toString(),
    'password': password,
    'nickname': nickname,
    'deviceId': deviceId,
    'deviceName': deviceName,
    'deviceVersion': deviceVersion,
    'mail': mail
  });
}

Future registrarMilitar(BuildContext context, {@required int dni,@required String password,@required String deviceId, @required String deviceName, @required deviceVersion,@required bool esMilitar}) async{
  getPost(context, apiRoute: 'api/Usuarios/Registrar_Militar',
  queryParameters: {
    'dni': dni.toString(),
      'password': password,
      'esMilitar': 'true',
      'deviceId': deviceId,
      'deviceName': deviceName,
      'deviceVersion': deviceVersion
  }, jsonEncode: jsonEncode({
	    "Apellido":"Gauto",
	    "Nombre":"Santiago",
	    "Email":"sgauto@gmail.com",
	    "DNI":41215183,
	    "Password": "12345678",
	    "DeviceId":"f14e204a6ee07d70",
	    "DeviceName":"SM-J710MN",
	    "DeviceVersion":"Instance of 'AndroidBuildVersion'"
	}));
}


}
