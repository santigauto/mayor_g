import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/widgets/alert_widget.dart';


class QuestionsService{

  sendCollab(BuildContext context,{ @required int dni}) async{
    final http.Response response = await http.post(
       '${MayorGApis.ApiURL}/jugador_modelo10.php',
       headers: MayorGApis.HttpHeaders,
       body: jsonEncode({
          'dni' : dni,
        })
       );
    final dynamic _decodedJson = jsonDecode(response.body);
    final Question _collab = Question.fromJson(_decodedJson); 
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