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



/*class Pregunta{
  int    id;
  int    nivel;
  String foto;
  String pregunta;
  String categoria;
  String tema;
  String prescripcion;

  Pregunta({this.tema,this.prescripcion,this.pregunta,this.categoria,this.foto,this.id,this.nivel});

  factory Pregunta.fromJson(Map<String,dynamic> parsedJson){
    return Pregunta(
      id: parsedJson['id'],
      nivel: parsedJson['nivel'],
      foto: parsedJson['foto'].toString(),
      pregunta: parsedJson['pregunta'].toString(),
      categoria: parsedJson['categoria'].toString(),
      tema: parsedJson['tema'].toString(),
      prescripcion: parsedJson['prescripcion'].toString(),
    );
  }
}

class Question{
  Pregunta pregunta;
  List<dynamic> respuestas;
  int respuestaCorrecta;

  Question({this.pregunta,this.respuestas,this.respuestaCorrecta});

factory Question.fromJson(Map<String,dynamic> parsedJson){
  return Question(
    pregunta: Pregunta.fromJson(parsedJson['pregunta']),
    respuestas: parsedJson['respuestas'].forEach((f){
        return f.toString();
      }), 
    respuestaCorrecta: parsedJson['respuestaCorrecta']
  );
}

}

class Questions{
  List<Question> preguntas;

  Questions({this.preguntas});

  factory Questions.fromJson(Map<String,Map<String,dynamic>> parsedJson){

    return Questions(
      preguntas: parsedJson['preguntas'].forEach((f){
        Question.fromJson(f);
      }), 
      );
  }
  
}

"id": 324,
  "nivel": 1,
  "foto": null,
  "pregunta": "¿Qué capacidad tiene la central telefonica automatica digital del RDC?",
  "categoria": "COMUNICACIONES",
  "tema": "RDC",
  "prescripcion": "PT - 05 - 63 RDC - CAP 1",
  "respuestas": [
    "12 abonados analógicos y 4 troncales",
    "12 abonados analógicos y 8 troncales",
    "2 abonados analógicos y 4 troncales",
    "13 abonados analógicos y 4 troncales"
  ],
  "respuestaCorrecta": 0 */