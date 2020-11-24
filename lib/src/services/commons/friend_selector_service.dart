
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:mayor_g/src/models/persona_model.dart';
import 'package:mayor_g/src/models/solicitudes_model.dart';
import 'package:mayor_g/src/services/http_request_service.dart';





class GetFriendsService{

  enviarSolicitud(BuildContext context,{@required int dni, @required int dniAmigo}) async{//devuelve true, es un post
  print('Enviar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Enviar_Solicitud',queryParameters: {
    'dni' : dni.toString(),
    'dniAmigo' : dniAmigo.toString()
  });
  }

  Future cambiarNick(BuildContext context,{@required int dni, @required String deviceId, @required nickname}) async{//devuelve true, es un post
    print('Cambiar Nickname');
    HttpService().getPost(context, apiRoute: 'api/Usuarios/Cambiar_Nickname',queryParameters: {
      'dni': dni.toString(),
      'deviceId': deviceId,
      'nickname': nickname
    });
  }

  Future<List<Solicitud>> solicitudesPendientes(BuildContext context,{@required int dni}) async{ // devuelve una lista, es un get
    print('solicitudesPedientes');
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Amigos/Solicitudes_Pendientes',queryParameters: {
      'dni' : dni.toString()
    });
    List<Solicitud> solicitudes = [];

    _decodedJson.forEach((solicitud){
      solicitudes.add(Solicitud.fromJson(solicitud));
    });
    return solicitudes;
  }


  Future<Persona> obtenerUsuarioDni(BuildContext context,{@required int dni, @required String deviceId, @required int dniBusqueda}) async{//devuelve true
    print('usuario ' + deviceId);
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Usuarios/Obtener_Usuario_DNI',queryParameters: {
      'dni'         : dni.toString(),
      'deviceId'    : deviceId,
      'dniBusqueda' : dniBusqueda.toString()
    });

    Persona persona = Persona.fromJsonMap(_decodedJson);

    return persona;
  }

  Future obtenerUsuario(BuildContext context,{@required int dni, @required String deviceId, @required String datos}) async{//devuelve datosUsuario
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Usuarios/Obtener_Usuario',queryParameters: {
      'dni'       : dni.toString(),
      'deviceId'  : deviceId,
      'datos'     : datos
    });
    
    List<Persona> _personas = [];

    _decodedJson.forEach((per){
      _personas.add(Persona.fromJsonMap(per));
    });

    return _personas;
  }

  //POST Aprobar_Solicitud(string idSolicitud)
  Future aprobarSolicitud(BuildContext context,{@required String idSolicitud}) async{//devuelve true, es un post
  print('AproBar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Aprobar_Solicitud',queryParameters: {
    'idSolicitud' : idSolicitud
  });
  }

  Future rechazarSolicitud(BuildContext context,{@required String idSolicitud}) async{//devuelve true, es un post
  print('Rechazar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Rechazar_Solicitud',queryParameters: {
    'idSolicitud' : idSolicitud
  });
  }

  Future obtenerAmigos(BuildContext context,{@required int dni})async{
    print('obtener Amigos');
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Amigos/Listado_Amigos',queryParameters: {
      'dni' : dni.toString()
    });
    List<Solicitud> _amigo = [];

    if(_decodedJson.isNotEmpty)_decodedJson.forEach((per){
      var amigo = Solicitud.fromJson(per);
      if(amigo.fechaAprobado != null)_amigo.add(amigo);
    });

    return _amigo;
  }

  Future eliminarAmistad(BuildContext context,{@required int dni, @required int dniAmigo})async{
    print('Eliminar amigo');
    HttpService().getPost(context,apiRoute: 'api/Amigos/Eliminar_Amigo',queryParameters: {
      'dni': dni.toString(),
      'dniAmigo' : dniAmigo.toString()
    });
  }

  Future generarUserDevice(BuildContext context,{@required int dni,@required String deviceId, @required String deviceName, @required deviceVersion}) async{//devuelve true, es un post
  print('Generar Device');
  HttpService().getPost(context,apiRoute: 'api/Usuarios/Generate_User_Device',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'deviceName': deviceName,
    'deviceVersion': deviceVersion
  });}

  Future iniciarJuego(BuildContext context,{@required int dni,@required String deviceId}) async{//devuelve true, es un post
  print('Iniciar Juego');
  HttpService().getPost(context,apiRoute: 'api/Usuarios/Iniciar_Juego',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId
  });
  }





Future registrarCivil(BuildContext context,{int dni, String password, String nickname, String deviceId, String deviceName, String deviceVersion, String mail}) async{//devuelve true, es un post
  print('Registrar Civil');
  HttpService().getPost(context,apiRoute: 'api/Usuarios/Registrar_Civil',queryParameters: {
    'dni': dni.toString(),
    'password': password,
    'nickname': nickname,
    'deviceId': deviceId,
    'deviceName': deviceName,
    'deviceVersion': deviceVersion,
    'mail': mail
  });
}

Future registrarMilitar(BuildContext context, {@required int dni,@required String password,@required String deviceId, @required String deviceName, 
                          @required deviceVersion,@required bool esMilitar}) async{

  HttpService().getPost(context, apiRoute: 'api/Usuarios/Registrar_Militar', 
    
    jsonEncode: jsonEncode({
	    "Apellido":"Gauto",
	    "Nombre":"Santiago",
	    "Email":"sgauto@gmail.com",
	    "DNI":44000111,
	    "Password": "12345678",
	    "DeviceId":"f14e204a6ee07d70",
	    "DeviceName":"SM-J710MN",
	    "DeviceVersion":"Instance of 'AndroidBuildVersion'"
	}));
}

Future sugerirPregunta(BuildContext context,{int dni, String deviceId,String pregunta,List<String> respuestas,
                          int respuestaCorrecta, bool unirConFlechas, bool verdaderoFalso, String arma,String organismo,String curso,
                          String materia, bool imagenPregunta, bool imagenRespuesta, String nombreArchivoImagen, String imagen}) async{
  HttpService().getPost(context, apiRoute: 'api/Usuarios/Enviar_Sugerencia_Pregunta',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId
  },jsonEncode: jsonEncode({
    'pregunta': pregunta,
    'respuestas' : respuestas,
    'respuestaCorrecta': respuestaCorrecta,
    'unirConFlechas': unirConFlechas,
    'verdaderoFalso': verdaderoFalso,
    'arma': arma,
    'organismo': organismo,
    'curso': curso,
    'materia': materia,
    'imagenPregunta': imagenPregunta,
    'imagenRespuesta': imagenRespuesta,
    'nombreArchivoImagen': nombreArchivoImagen,
    'Imagen': imagen
  }));
}

}
