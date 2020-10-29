
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
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
    final Amigos amigos = Amigos.fromJson(_decodedJson);
    print(amigos.amigos[0].nombre);
  }

  enviarSolicitud({@required int dni, @required int dniAmigo}) async{//devuelve true, es un post
  print('Enviar Solicitud');
  /* final http.Response response = await http.post(
    'https://cps-ea.mil.ar:5261/api/Amigos/Enviar_Solicitud',
    /* headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, */
    body: jsonEncode(<String, String>{
      'dni' : dni.toString(),
      'dniAmigo' : dniAmigo.toString()
    }),
  ); */
    final url = Uri.https(_url, 'api/Amigos/Enviar_Solicitud',{
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

  Future cambiarDni({@required int dni, @required String deviceId, @required nickname}) async{//devuelve true, es un post
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

  Future obtenerUsuario() async{//devuelve true
    final http.Response response = await http.get(
       'https://cps-ea.mil.ar:5261/api/Usuarios/Obtener_Usuario',
       );
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
    print("holahola hola"+_decodedJson.toString());
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
}


/*IONIC CODE
----
MODELO LISTA*
----
private urlObtener = 'https://www.maderosolutions.com.ar/MayorG2/modelo/getAmigos.php';
----
GetFriends(dni){
        this.http.post(this.urlObtener, JSON.stringify(dni))
            .subscribe((res: any) => {
                if (res == null){ return []; }

            for ( var i=0; i < res.amigos.length ; i++ ){
                this.lista*[i] = res.amigos[i]; //noAmigos
            }
            }), 
            {headers : this.headers}
        return this.lista*
    }
 */