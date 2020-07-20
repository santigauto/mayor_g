
// MODELO DE LISTA DE PREGUNTAS

class ListaPreguntas {
  List<PreguntaYRespuesta> preguntas;

  ListaPreguntas({
    this.preguntas,
  });
  factory ListaPreguntas.fromJson(Map<String,dynamic> jsonDecoded){

for (var i = 0; i < jsonDecoded['preguntas'].length ; i++) {
  
  jsonDecoded['preguntas'][i] = PreguntaYRespuesta.fromJson(jsonDecoded['preguntas'][i]);

}

    return ListaPreguntas(
      preguntas: jsonDecoded['preguntas'].cast<PreguntaYRespuesta>()
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////////
////////////////////            VIEJO MODELO DE PREGUNTA        ///////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////

class PreguntaYRespuesta {
  Pregunta pregunta;
  List<String> respuestas;
  int respuestaCorrecta;

  PreguntaYRespuesta({
    this.pregunta,
    this.respuestas,
    this.respuestaCorrecta,
  });

  factory PreguntaYRespuesta.fromJson(Map<String,dynamic> jsonDecoded){
    return PreguntaYRespuesta(
      pregunta: Pregunta.fromJson(jsonDecoded['pregunta']),
      respuestaCorrecta: jsonDecoded['respuestaCorrecta'],
      respuestas: jsonDecoded['respuestas'].cast<String>(),
      );
  }

}
//------------------------------------------------------------------------------------------
class Pregunta {
  int id;
  int nivel;
  String foto;
  String pregunta;
  String categoria;
  String tema;
  String prescripcion;
  int longitud;

  Pregunta({
    this.id,
    this.nivel,
    this.foto,
    this.pregunta,
    this.categoria,
    this.tema,
    this.prescripcion,
    this.longitud,
  });

  factory Pregunta.fromJson(Map<String,dynamic> jsonDecoded){
    return Pregunta(
      id: jsonDecoded['id'],
      nivel: jsonDecoded['nivel'],
      foto: jsonDecoded['foto'].toString(),
      pregunta: jsonDecoded['pregunta'].toString(),
      categoria: jsonDecoded['categoria'].toString(),
      tema: jsonDecoded['tema'].toString(),
      prescripcion: jsonDecoded['prescripcion'].toString(),
      longitud: jsonDecoded['longitud'],
    );
  }


}
//////////////////////////////////////////////////////////////////////////////
///////////////////       NUEVO MODELO DE PREGUNTA          //////////////////
//////////////////////////////////////////////////////////////////////////////

class PreguntaYRespuestaNueva {
  String id;
  String nivel;
  int indiceTipoPregunta;
  dynamic imagen;
  String pregunta;
  String organismo;
  String arma;
  String curso;
  String materia;
  String prescripcion;
  int longitud;
  List<String> respuestas;
  int respuestaCorrecta;

  PreguntaYRespuestaNueva({
    this.id,
    this.nivel,
    this.indiceTipoPregunta,
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

factory PreguntaYRespuestaNueva.fromJson(Map<String,dynamic> jsonDecoded){
    return PreguntaYRespuestaNueva(
      id: jsonDecoded['id'],
      nivel: jsonDecoded['nivel'],
      indiceTipoPregunta: jsonDecoded['indiceTipoPregunta'],
      imagen: jsonDecoded['imagen'],
      pregunta: jsonDecoded['pregunta'],
      organismo: jsonDecoded['organismno'],
      arma: jsonDecoded['arma'],
      curso: jsonDecoded['curso'],
      materia: jsonDecoded['materia'],
      prescripcion: jsonDecoded['prescripcion'],
      longitud: jsonDecoded['longitud'],
      respuestaCorrecta: jsonDecoded['respuestaCorrecta'],
      respuestas: jsonDecoded['respuestas'].cast<String>(),
      );
  }

}
