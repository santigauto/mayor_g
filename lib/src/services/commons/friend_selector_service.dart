
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/src/models/friends_model.dart';

class GetFriendsService{

  String _url = 'cps-ea.mil.ar:5261';

  getFriends(BuildContext context,{ @required int dni }) async{
    final http.Response response = await http.post(
       'https://www.maderosolutions.com.ar/MayorG1/modelo/getAmigos.php',
       headers: MayorGApis.HttpHeaders,
       body: jsonEncode({
          'dni' : dni.toString()
        })
       );
    final dynamic _decodedJson = jsonDecode(response.body);
    final Amigos amigos = Amigos.fromJson(_decodedJson);
    print(amigos.amigos[0].nombre);
  }

  enviarSolicitud({@required int dni, @required int dniAmigo}) async{//devuelve true, es un post
    final url = Uri.https(_url, 'api/Amigos/Enviar_Solicitud',{
      'dni' : dni.toString()
    });
    final resp = await http.post(url);
      dynamic _decodedJson;
      if(resp.body.isNotEmpty) {
        _decodedJson = json.decode(resp.body);
      }
    print('es true?:' + _decodedJson.toString());
  }

  solicitudesPendientes({@required int dni}) async{ // devuelve una lista, es un get
    print('solicitudesPedientes');
    final url = Uri.https(_url, 'api/Amigos/Solicitudes_Pendientes',{
      'dni' : dni.toString()
    });
    final resp = await http.get(url);
    final dynamic _decodedJson = jsonDecode(resp.body);
    print("holahola hola"+_decodedJson.toString());
  }

  obtenerUsuario() async{//devuelve true
    final http.Response response = await http.get(
       'https://cps-ea.mil.ar:5261/api/Usuarios/Obtener_Usuario',
       );
      dynamic _decodedJson;
      if(response.body.isNotEmpty) {
        _decodedJson = json.decode(response.body);
      }
    print('obtuvo?:' + _decodedJson.toString());
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