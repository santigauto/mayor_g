
// MODELO DE LISTA DE PREGUNTAS

import 'dart:convert';

  //NUEVO MODELO DE LISTA

 class ListaPreguntasNuevas {
  List<PreguntaNueva> preguntas;

  ListaPreguntasNuevas({
    this.preguntas,
  });
  factory ListaPreguntasNuevas.fromJson(List<dynamic> jsonDecoded){
    for(var i = 0; i <jsonDecoded.length;i++){
      jsonDecoded[i] = PreguntaNueva.fromJson(jsonDecoded[i]);
    }
    return ListaPreguntasNuevas(
      preguntas: jsonDecoded.cast<PreguntaNueva>()
    );
  }


} 


//////////////////////////////////////////////////////////////////////////////
///////////////////       NUEVO MODELO DE PREGUNTA          //////////////////
//////////////////////////////////////////////////////////////////////////////

class PreguntaNueva {
  String id;
  String nivel;
  bool imagenPregunta;
  bool imagenRespuesta;
  bool unirConFlechas;
  bool verdaderoFalso;
  bool esPrivada;
  String nombreArchivoImagen;
  String imagen;
  String pregunta;
  String organismo;
  String arma;
  String curso;
  String materia;
  String prescripcion;
  int longitud;
  List<String> respuestas;
  int respuestaCorrecta;

  PreguntaNueva({
    this.id,
    this.nivel,
    this.imagenPregunta,
    this.imagenRespuesta,
    this.unirConFlechas,
    this.verdaderoFalso,
    this.esPrivada,
    this.nombreArchivoImagen,
    this.imagen,
    this.pregunta,
    this.organismo,
    this.arma,
    this.curso,
    this.materia,
    this.prescripcion,
    this.longitud,
    this.respuestas,
    this.respuestaCorrecta,
  });


factory PreguntaNueva.fromJson(Map<String,dynamic> jsonDecoded){
    return PreguntaNueva(
      id                    : jsonDecoded['id'],
      nivel                 : jsonDecoded['nivel'],
      imagen                : jsonDecoded['Imagen'],
      pregunta              : jsonDecoded['pregunta'],
      organismo             : jsonDecoded['organismno'],
      arma                  : jsonDecoded['arma'],
      curso                 : jsonDecoded['curso'],
      materia               : jsonDecoded['materia'],
      prescripcion          : jsonDecoded['prescripcion'],
      longitud              : jsonDecoded['longitud'],
      respuestaCorrecta     : jsonDecoded['respuestaCorrecta'],
      respuestas            : jsonDecoded['respuestas'].cast<String>(),
      imagenPregunta        : jsonDecoded['imagenPregunta'],
      imagenRespuesta       : jsonDecoded['imagenRespuesta'],
      unirConFlechas        : jsonDecoded['unirConFlechas'],
      verdaderoFalso        : jsonDecoded['verdaderoFalso'],
      esPrivada             : jsonDecoded['esPrivada'],
      nombreArchivoImagen   : jsonDecoded['nombreArchivoImagen'],
      );
  }

  int getDuration(){
    switch (longitud) {
      case 1:
        return 20;
        break;
      case 2:
        return 25;
        break;
      case 3:
        return 30;
        break;
      default: return 20;
    } 
  }

  int getTipoPregunta(){
    if(verdaderoFalso == true) return 2;
    else if(unirConFlechas)return 3;
    else if(imagenRespuesta)return 1;
    else return 0;
  }

  Map getMapChoices(){
    Map choices = new Map();
    for (var i = 0; i < respuestas.length; i++) {
    List aux = respuestas[i].split(':');
    String aux1 = '{"'+ aux[0] +'"';
    String aux2 = '"'+ aux[1] +'"}';
    choices.addAll(json.decode(aux1+':'+aux2));
  }
  return choices;
  }

}
///////////////////////////////////////////////////////////////////////////////
///                 MODELO PREGUNTAS RESPONDIDAS
///////////////////////////////////////////////////////////////////////////////
///

class PreguntaRespondida{
  String id;
  int puntaje;

  PreguntaRespondida({this.id,this.puntaje});

  Map toJson() => {
        'IdPregunta': id,
        'CantCorrectas': puntaje,
  };

}