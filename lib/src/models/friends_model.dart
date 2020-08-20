
class Amigos {
  List<Amigo> amigos;

  Amigos({
    this.amigos,
  });

  factory Amigos.fromJson(Map<String,dynamic> parsedJson){

    for (var i = 0; i < parsedJson['amigos'].length; i++) {
      parsedJson['amigos'][i] = Amigo.fromJson(parsedJson['amigos'][i]);
    }

    return Amigos(
      amigos: parsedJson['amigos'].cast<Amigo>()
    );
  }
}

class Amigo {
  String dni;
  String nombre;

  Amigo({
    this.dni,
    this.nombre,
  });

  factory Amigo.fromJson(Map<String,dynamic> parsedJson){
    return Amigo(
      dni: parsedJson['dni'],
      nombre: parsedJson['nombre'].toString()
    );
  }

}
