
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/notificacion_model.dart';

import 'package:mayor_g/src/models/persona_model.dart';
import 'package:mayor_g/src/models/solicitudes_model.dart';
import 'package:mayor_g/src/services/http_request_service.dart';





class GetFriendsService{

  enviarSolicitud(BuildContext context,{@required int dni,@required String deviceId, @required int dniAmigo}) async{//devuelve true, es un post
  print('Enviar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Enviar_Solicitud',queryParameters: {
    'dni' : dni.toString(),
    'deviceId': deviceId,
    'dniAmigo' : dniAmigo.toString()
  });
  }

  Future cambiarNick(BuildContext context,{@required int dni, @required String deviceId, @required nickname}) async{//devuelve true, es un post
    print('Cambiar Nickname');
    bool boolean = await HttpService().getPost(context, apiRoute: 'api/Usuarios/Cambiar_Nickname',queryParameters: {
      'dni': dni.toString(),
      'deviceId': deviceId,
      'nickname': nickname
    });
    return boolean;
  }

  Future<List<Solicitud>> solicitudesPendientes(BuildContext context,{@required int dni, @required String deviceId}) async{ // devuelve una lista, es un get
    print('solicitudesPedientes');
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Amigos/Solicitudes_Pendientes',queryParameters: {
      'dni' : dni.toString(),
      'deviceId' : deviceId
    });
    List<Solicitud> solicitudes = [];

    if(_decodedJson != null)_decodedJson.forEach((solicitud){
      solicitudes.add(Solicitud.fromJson(solicitud));
    });
    return solicitudes;
  }


  Future<Persona> obtenerUsuarioDni(BuildContext context,{@required int dni, @required String deviceId, @required int dniBusqueda}) async{//devuelve usuario con dni coincidente
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Usuarios/Obtener_Usuario_DNI',queryParameters: {
      'dni'         : dni.toString(),
      'deviceId'    : deviceId,
      'dniBusqueda' : dniBusqueda.toString()
    });
    print("obtengo esto de obtenerUsuarioDni: " + _decodedJson.toString());
    Persona persona ;
    if(_decodedJson != {}) persona = Persona.fromJsonMap(_decodedJson);
    return persona;
  }

  Future obtenerUsuario(BuildContext context,{@required int dni, @required String deviceId, @required String datos}) async{//devuelve datosUsuario
    
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Usuarios/Obtener_Usuario',queryParameters: {
      'dni'       : dni.toString(),
      'deviceId'  : deviceId,
      'datos'     : datos
    });
    print("obtengo esto de obtenerUsuario  --->   " + _decodedJson.toString());
    List<Persona> _personas = [];
    if(_decodedJson == null) return _personas;
    _decodedJson.forEach((per){
      _personas.add(Persona.fromJsonMap(per));
    });

    return _personas;
  }

  //POST Aprobar_Solicitud(string idSolicitud)
  Future aprobarSolicitud(BuildContext context,{ @required int dni, @required String deviceId, @required String idSolicitud}) async{//devuelve true, es un post
  print('Aprobar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Aprobar_Solicitud',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'idSolicitud' : idSolicitud
  });
  }

  Future rechazarSolicitud(BuildContext context,{@required int dni, @required String deviceId,@required String idSolicitud}) async{//devuelve true, es un post
  print('Rechazar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Rechazar_Solicitud',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'idSolicitud' : idSolicitud
  });
  }

  Future obtenerAmigos(BuildContext context,{@required int dni, @required String deviceId})async{
    print('obtener Amigos');
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Amigos/Listado_Amigos',queryParameters: {
      'deviceId': deviceId,
      'dni' : dni.toString()
    });
    List<Solicitud> _amigo = [];

    if(_decodedJson.isNotEmpty)_decodedJson.forEach((per){
      var amigo = Solicitud.fromJson(per);
      if(amigo.fechaAprobado != null)_amigo.add(amigo);
    });

    return _amigo;
  }

  Future eliminarAmistad(BuildContext context,{@required int dni, @required int dniAmigo, @required String deviceId})async{
    print('Eliminar amigo');
    HttpService().getPost(context,apiRoute: 'api/Amigos/Eliminar_Amigo',queryParameters: {
      'dni': dni.toString(),
      'deviceId': deviceId,
      'dniAmigo' : dniAmigo.toString()
    });
  }

  Future generarUserDevice(BuildContext context,{@required int dni,@required String deviceId, @required String deviceName, @required deviceVersion}) async{//devuelve true, es un post
  print('Generar Device');
  HttpService().getPost(context,apiRoute: 'api/Usuarios/Generar_Device',queryParameters: {
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

  Future<List<Notificacion>> obtenerNotificaciones(BuildContext context,{@required int dni,@required String deviceId})async{
    print('Empieza ObtenerNotificaciones');
    var _decodedJson = await HttpService().getGet(context, apiRoute: 'api/Usuarios/Obtener_Notificaciones',queryParameters: {
      'dni': dni.toString(),
      'deviceId': deviceId
    });
    List<Notificacion> notificaciones = [];
    print("FriendsService/obtenerNotificaciones():  " +_decodedJson.toString());
    if(_decodedJson.isNotEmpty)_decodedJson.forEach((noti){
      print(noti.toString());
      var notificacion = Notificacion.fromJson(noti);
      if(notificacion.fechaDeCreacion != null)notificaciones.add(notificacion);
    });

    return notificaciones;
  }

  Future<int> obtenerCantidadNotificaciones(BuildContext context,{@required int dni,@required String deviceId})async{
    print('Empieza ObtenerNotificaciones');
    var _decodedJson = await HttpService().getGet(context, apiRoute: 'api/Usuarios/Obtener_Cantidad_Notificaciones',queryParameters: {
      'dni': dni.toString(),
      'deviceId': deviceId
    });
    int notificaciones = 0;
    print("FriendsService/obtenerNotificaciones():  " +_decodedJson.toString());
    if(_decodedJson != null) notificaciones = _decodedJson;

    return notificaciones;
  }
  
  Future cambiarFoto(BuildContext context, { @required int dni, @required String deviceId,@required String imagen})async{
    var _decodedJson = await HttpService().getPost(context, apiRoute: 'api/Usuarios/Cambiar_Foto',queryParameters: {
      'dni': dni.toString(),
      'deviceId': deviceId
    },jsonEncode: jsonEncode({
        'nombreArhcivoImagen' : imagen,
        'Imagen' : 'imagen-${dni.toString()}.png'
    }));

    print('cambiarFoto'+_decodedJson);
    return _decodedJson;
    
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
