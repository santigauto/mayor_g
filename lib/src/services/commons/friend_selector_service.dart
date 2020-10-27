
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/src/models/friends_model.dart';

class GetFriendsService{

  getFriends(BuildContext context,{ @required int dni }) async{
    final http.Response response = await http.post(
       'https://www.maderosolutions.com.ar/MayorG1/modelo/getAmigos.php',
       headers: MayorGApis.HttpHeaders,
       body: jsonEncode({
          'dni' : dni
        })
       );
    final dynamic _decodedJson = jsonDecode(response.body);
    final Amigos amigos = Amigos.fromJson(_decodedJson);
    print(amigos.amigos[0].nombre);
  }

  enviarSolicitud({@required int dni, @required int dniAmigo}) async{
    final http.Response response = await http.post(
       'https://cps-ea.mil.ar:5261/api/Amigos/Enviar_Solicitud',
       headers: MayorGApis.HttpHeaders,
       body: jsonEncode({
          'dni' : dni,
          'dniAmigo': dniAmigo
        })
       );
    final dynamic _decodedJson = jsonDecode(response.body);
    print(_decodedJson);
  }

  solicitudesPendientes({@required int dni}) async{
    final http.Response response = await http.post(
       'https://cps-ea.mil.ar:5261/api/Amigos/Solicitudes_Pendientes',
       headers: MayorGApis.HttpHeaders,
       body: jsonEncode({
          'dni' : dni,
        })
       );
    final dynamic _decodedJson = jsonDecode(response.body);
    print("holahola hola"+_decodedJson.toString());
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