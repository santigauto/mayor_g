import 'dart:convert';

import 'package:flutter/material.dart';
//import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';


/*  NUEVO MODELO DE SERVICIO DE PREGUNTAS*/

class QuestionServicePrueba{

  getNewQuestions(BuildContext context,{@required cantidad}) async{
    String _url = 'mayorg.ejercito.mil.ar';
    final url = Uri.https(_url, 'api/Json/Obtener_Preguntas',{
      'cantidad' : cantidad.toString()
    });
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    ListaPreguntasNuevas preguntas = ListaPreguntasNuevas.fromJson(decodedData);
    if(preguntas == null || preguntas.preguntas.isEmpty) {
      return Alert.alert(context, body: Text("ERROR! No se encontraron preguntas, intente nuevamente"));
    }
    else{
      return preguntas;
    }
  }
  
} 