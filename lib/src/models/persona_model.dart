
class Persona {
  String id;
  String apellido;
  String nombre;
  int dni;
  String email;
  String nickname;
  bool esMilitar;

  Persona({
    this.id,
    this.apellido,
    this.nombre,
    this.dni,
    this.email,
    this.nickname,
    this.esMilitar
  });

  Persona.fromJsonMap(Map<String, dynamic> json) {
    id        = json['Id'];
    apellido  = json['Apellido']?.trim();
    nombre    = json['Nombre']?.trim();
    email     = json['Email']?.trim();
    dni       = json['DNI'];
    nickname  = json['Nickname']?.trim();
    esMilitar = json['EsMilitar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Apellido'] = this.apellido;
    data['Nombre'] = this.nombre;
  }
}
