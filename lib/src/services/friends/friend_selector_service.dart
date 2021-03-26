
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/persona_model.dart';

import 'package:mayor_g/src/models/solicitudes_model.dart';
import 'package:mayor_g/src/services/http_request_service.dart';





class GetFriendsService{

  StreamController _solicitudController = new StreamController.broadcast();

  Stream get streamSolicitudes => _solicitudController.stream;
  Function get sinkSolicitudes => _solicitudController.sink.add;

  void disposeStreams(){
    _solicitudController.close();
  }

  List _solicitudes = [];
  List _amigos = [];

//ENVIAR SOLICITUD 
  enviarSolicitud(BuildContext context,{@required int dni,@required String deviceId, @required int dniAmigo}) async{//devuelve true, es un post
  print('Enviar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Enviar_Solicitud',queryParameters: {
    'dni' : dni.toString(),
    'deviceId': deviceId,
    'dniAmigo' : dniAmigo.toString()
  });
  }


//BUSCAR SOLICITUDES PENDIENTES
  Future solicitudesPendientes(BuildContext context,{@required int dni, @required String deviceId}) async{ // devuelve una lista, es un get
    print('solicitudesPedientes');
    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Amigos/Solicitudes_Pendientes',queryParameters: {
      'dni' : dni.toString(),
      'deviceId' : deviceId
    });

    if(_decodedJson != null)_decodedJson.forEach((solicitud){
      _solicitudes.add(Solicitud.fromJson(solicitud));
    });

    sinkSolicitudes(_solicitudes);
  }


  //POST APROBAR SOLICITUD DE AMISTAD
  Future aprobarSolicitud(BuildContext context,{ @required int dni, @required String deviceId, @required String idSolicitud}) async{//devuelve true, es un post
  print('Aprobar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Aprobar_Solicitud',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'idSolicitud' : idSolicitud
  });
  }

//RECHAZAR SOLICITUD
  Future rechazarSolicitud(BuildContext context,{@required int dni, @required String deviceId,@required String idSolicitud}) async{//devuelve true, es un post
  print('Rechazar Solicitud');
  HttpService().getPost(context,apiRoute: 'api/Amigos/Rechazar_Solicitud',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'idSolicitud' : idSolicitud
  });
  }

//OBTENER LISTADO DE AMIGOS
  Future obtenerAmigos(BuildContext context,{@required int dni, @required String deviceId})async{
    
    print('obtener Amigos');

    var _decodedJson = await HttpService().getGet(context,apiRoute: 'api/Amigos/Listado_Amigos',queryParameters: {
      'deviceId': deviceId,
      'dni' : dni.toString()
    });

    if(_decodedJson.isNotEmpty)_decodedJson.forEach((per){
      _amigos.add(Persona.fromJson(per));
    });

    sinkSolicitudes(_amigos);

  }

//ELIMINAR AMISTAD
  Future eliminarAmistad(BuildContext context,{@required int dni, @required int dniAmigo, @required String deviceId})async{
    print('Eliminar amigo');
    HttpService().getPost(context,apiRoute: 'api/Amigos/Eliminar_Amigo',queryParameters: {
      'dni': dni.toString(),
      'deviceId': deviceId,
      'dniAmigo' : dniAmigo.toString()
    });
    _amigos.removeWhere((element) => element.id == dniAmigo );
  }


}
