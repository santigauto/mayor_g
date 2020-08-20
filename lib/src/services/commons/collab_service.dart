import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/src/models/collab_model.dart';
import 'package:mayor_g/src/widgets/alert_widget.dart';


class CollabService{

  sendCollab(BuildContext context,{ @required int dni, int idPregunta,  @required String sugerencia}) async{
    final http.Response response = await http.post(
       '${MayorGApis.ApiURL}/setSugerencia.php',
       headers: MayorGApis.HttpHeaders,
       body: jsonEncode({
          'dni' : dni,
          'id_pregunta' : idPregunta,
          'sugerencia' : sugerencia,
        })
       );
    final dynamic _decodedJson = jsonDecode(response.body);
    final Collab _collab = Collab.fromJson(_decodedJson); 
    if(_collab.estado == false) {
      return Alert.alert(context, body: Text(_collab.descripcion));
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
}
