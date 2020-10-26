class Sugerencia {
  SugerenciaClass sugerencia;
  int dni;

  Sugerencia({
    this.sugerencia,
    this.dni,
  });
}

class SugerenciaClass {
  String pregunta;
  List<String> respuestas;
  int respuestaCorrecta;
  bool unirConFlechas;
  bool verdaderoFalso;
  String imagen;
  String arma;
  dynamic organismo;
  dynamic curso;
  dynamic materia;

  SugerenciaClass({
    this.pregunta,
    this.respuestas,
    this.respuestaCorrecta,
    this.unirConFlechas,
    this.verdaderoFalso,
    this.imagen,
    this.arma,
    this.organismo,
    this.curso,
    this.materia,
  });

  factory SugerenciaClass.fromSugerenciaPage(Map<String,dynamic> json){
    return SugerenciaClass(
      pregunta          : json['pregunta,'],
      respuestas        : json['respuestas,'].cast<String>(),
      respuestaCorrecta : json['respuestaCorrecta,'],
      unirConFlechas    : json['unirConFlechas,'],
      verdaderoFalso    : json['verdaderoFalso,'],
      imagen            : json['imagen,'],
      arma              : json['arma,'],
      organismo         : json['organismo,'],
      curso             : json['curso,'],
      materia           : json['materia,'],      
    );
  }
}
/*

{
    "sugerencia":
      {
        "pregunta":"¿que es esto?",
        "respuestas":
          [
            "una lata",
            "una botella",
            "un vaso",
            "una copa"
          ],
        "respuestaCorrecta": 1,
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