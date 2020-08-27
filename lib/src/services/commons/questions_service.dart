import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/widgets/alert_widget.dart';


class QuestionsService{

  getQuestions(BuildContext context,{ @required int dni}) async{
    final http.Response response = await http.post(
       '${MayorGApis.ApiURL}/jugador_modelo10.php',
       headers: MayorGApis.HttpHeaders,
       body: jsonEncode({
          'dni' : dni,
        })
       );
    final dynamic _decodedJson = jsonDecode(response.body);
    ListaPreguntas preguntas = ListaPreguntas.fromJson(_decodedJson); 
    if(preguntas == null) {
      return Alert.alert(context, body: Text("ha ocurrido un error"));
    }
    else{
      return preguntas;
    }
  }   
}

/*  NUEVO MODELO DE SERVICIO DE PREGUNTAS*/

class QuestionServicePrueba{
    getNewQuestions(BuildContext context,{@required cantidad}) async{
      print('hola2');
      String _url = 'cps-ea.mil.ar:5261';
      final url = Uri.https(_url, 'api/Json/Obtener_Preguntas',{
        'cantidad' : cantidad.toString()
      });
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    print(decodedData);
    ListaPreguntasNuevas preguntas = ListaPreguntasNuevas.fromJson(decodedData);
    print(decodedData.toString());
    if(preguntas == null) {
      return Alert.alert(context, body: Text("ha ocurrido un error"));
    }
    else{
      return preguntas;
    }
  }
} 