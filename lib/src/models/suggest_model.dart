import 'dart:convert';

Sugerencia sugerenciaFromJson(String str) => Sugerencia.fromJson(json.decode(str));

String sugerenciaToJson(Sugerencia data) => json.encode(data.toJson());

class Sugerencia {
    Sugerencia({
        this.sugerencia,
        this.dni,
    });

    SugerenciaClass sugerencia;
    int dni;

    factory Sugerencia.fromJson(Map<String, dynamic> json) => Sugerencia(
        sugerencia: SugerenciaClass.fromJson(json["sugerencia"]),
        dni: json["dni"],
    );

    Map<String, dynamic> toJson() => {
        "sugerencia": sugerencia.toJson(),
        "dni": dni,
    };
}

class SugerenciaClass {
    SugerenciaClass({
        this.pregunta,
        this.respuestaCorrecta,
        this.respuestas,
        this.unirConFlechas,
        this.verdaderoFalso,
        this.imagen,
        this.arma,
        this.organismo,
        this.curso,
        this.materia,
    });

    String pregunta;
    int respuestaCorrecta;
    List<String> respuestas;
    bool unirConFlechas;
    bool verdaderoFalso;
    String imagen;
    String arma;
    dynamic organismo;
    dynamic curso;
    dynamic materia;

    factory SugerenciaClass.fromJson(Map<String, dynamic> json) => SugerenciaClass(
        pregunta: json["pregunta"],
        respuestaCorrecta: json["respuestaCorrecta"],
        respuestas: List<String>.from(json["respuestas"].map((x) => x)),
        unirConFlechas: json["unirConFlechas"],
        verdaderoFalso: json["verdaderoFalso"],
        imagen: json["imagen"],
        arma: json["arma"],
        organismo: json["organismo"],
        curso: json["curso"],
        materia: json["materia"],
    );

    Map<String, dynamic> toJson() => {
        "pregunta": pregunta,
        "respuestaCorrecta": respuestaCorrecta,
        "respuestas": List<dynamic>.from(respuestas.map((x) => x)),
        "unirConFlechas": unirConFlechas,
        "verdaderoFalso": verdaderoFalso,
        "imagen": imagen,
        "arma": arma,
        "organismo": organismo,
        "curso": curso,
        "materia": materia,
    };
}
/*

{
    "sugerencia":
      {
        "pregunta":"¿que es esto?",
        "respuestasCorrectas":
          [
            "vidrio",
            "una botella",
          ],
        "respuestaIncorrectas":
          [
            "balde",
            "zapato",
            "lata",
            "chapa",
          ],
		    "unirConFlechas": false,
		    "verdaderoFalso": false,
		    "imagen":"/9j/4QGWRXhpZgAATU0AKgAAAAgABwEAAAMAAAABA4QAAAEQAAIAAAAKAAAAYgEBAAMAAAABA",
		    "arma":"General",
		    "organismo": null,
		    "curso": null,
		    "materia": null
		  },
	  "dni" : 41215183	
  }

*/