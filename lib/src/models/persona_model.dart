
class Persona {
  String id;
  String apellido;
  String nombre;
  int dni;
  String email;
  String nickname;
  bool esMilitar;
  bool seleccionado;
  bool esAmigo;
  int puntos;

  Persona({
    this.id,
    this.apellido,
    this.nombre,
    this.dni,
    this.email,
    this.nickname,
    this.esMilitar,
    this.seleccionado = false,
    this.esAmigo,
    this.puntos
  });

  Persona.fromJsonMap(Map<String, dynamic> json) {
    id        = json['Id'];
    apellido  = json['Apellido']?.trim();
    nombre    = json['Nombre']?.trim();
    email     = json['Email']?.trim();
    dni       = json['DNI'];
    nickname  = json['Nickname']?.trim();
    esAmigo = json['EsAmigo'];
    puntos = json['Puntos'] ?? 0;
  }

  factory Persona.fromJson(Map<String,dynamic> json){
    return Persona(
      id: json['Id'],
      dni: json['dni'],
      nickname: json['Jugador'],
    );
  }

}
