
class Pregunta{
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
  List<String> respuestas;
  int respuestaCorrecta;

  Question({this.pregunta,this.respuestas,this.respuestaCorrecta});

factory Question.fromJson(Map<String,dynamic> parsedJson){
  return Question(
    pregunta: Pregunta.fromJson(parsedJson['pregunta']),
    respuestas: parsedJson['respuestas'],
    respuestaCorrecta: parsedJson['respuestaCorrecta']
  );
}

}

class Questions{
  List<Question> preguntas;
  bool estado;

  Questions({this.estado,this.preguntas});

  factory Questions.fromJson(Map<String,dynamic> parsedJson){

    return Questions(
      estado: parsedJson['estado'],
      preguntas: parsedJson['preguntas'].forEach((f){
        Question.fromJson(f);
      }), 
      );
  }
  
}

/*"id": 324,
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