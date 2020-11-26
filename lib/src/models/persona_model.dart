
class Persona {
  String id;
  String apellido;
  String nombre;
  int dni;
  String email;
  String nickname;
  bool esMilitar;
  bool esSeleccionado;

  Persona({
    this.id,
    this.apellido,
    this.nombre,
    this.dni,
    this.email,
    this.nickname,
    this.esMilitar,
    this.esSeleccionado
  });

  Persona.fromJsonMap(Map<String, dynamic> json) {
    id        = json['Id'];
    apellido  = json['Apellido']?.trim();
    nombre    = json['Nombre']?.trim();
    email     = json['Email']?.trim();
    dni       = json['DNI'];
    nickname  = json['Nickname']?.trim();
    esSeleccionado = false;
  }

}
