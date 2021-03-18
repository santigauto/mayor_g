import 'package:flutter/material.dart';
import 'dart:convert';


import 'package:mayor_g/src/services/http_request_service.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';


class CollabService{

  Future enviarAporte(BuildContext context,{@required int dni,@required String deviceId, @required String texto}) async{//devuelve true, es un post
    print('Enviar Aporte');

    final resp = await HttpService().getPost(context,apiRoute: 'api/Usuarios/Enviar_Aporte',queryParameters: {
      'dni': dni.toString(),
      'deviceId': deviceId,
      'texto': texto
    });

  final dynamic _decodedJson = jsonDecode(resp.body);
  print(_decodedJson);
    if(!_decodedJson) {
      return Alert.alert(context, body: Text(_decodedJson.descripcion));
    }
    else{
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
          return AlertDialog(
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.yellow)
            ),
            title: Text('¡Muchas gracias por su aporte!',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 200,
                  child: Image.asset('assets/capa53x.png')),
              ],
            ),
          );
        }
      );
    }

  }

Future reportarFalla(BuildContext context,{@required int dni,@required String deviceId,@required String descripcion,@required String preguntaId}) async{//devuelve true, es un post
  print('Reportar Falla');
  HttpService().getPost(context, apiRoute: 'api/Usuarios/Reportar_Falla',queryParameters: {
    'dni': dni.toString(),
    'deviceId': deviceId,
    'descripcion': descripcion,
    'PreguntaId' : preguntaId
  });

}
}
