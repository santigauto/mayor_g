import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/views/question_page.dart';
import 'package:mayor_g/widgets/alert_widget.dart';


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
      preguntas.preguntas.forEach((f){
        print('la respuesta correcta es la ${f.pregunta.pregunta}');
      });
      var route = MaterialPageRoute(builder: (context)=>QuestionPage(questions: preguntas,));
      Navigator.push(context, route);
    }
  }   
}








/*IONIC CODE
----
private urlObtener = 'https://www.maderosolutions.com.ar/MayorG2/modelo/jugador_modelo10.php';
  private urlComprobar =
    'https://www.maderosolutions.com.ar/MayorG2/modelo/almacenar_historial.php';
  private _pregunta = new BehaviorSubject<Pregunta>(
    new Pregunta({id:null,nivel:null,foto:null,pregunta:'',categoria:'',prescripcion:'',tema:''}, 1, ['', '', '', ''])
  );
----
async obtenerPregunta(dni) {
    return new Promise((resolve)=>{
      this.http.post<any>(this.urlObtener,JSON.stringify(dni),this.httpOptions)
        .subscribe(data => {
          resolve(data);
        })
    })
  }

  get pregunta() {
    return this._pregunta.asObservable();
  }

  enviarDatos(datos) {
    return this.http.post(this.urlComprobar, datos, this.httpOptions);
  }

  // Para que, cuando la app esté cargando una nueva pregunta
  // no se vea la preg anterior atrás del cuadrito de cargando,
  // emito una pregunta vacía momentánea.
  clearPregunta() {
    const preg = new Pregunta({id:null,nivel:null,foto:null,pregunta:'',categoria:'',prescripcion:'',tema:''}, 1, ['', '', '', '']);
    this._pregunta.next(preg);
  }
 */