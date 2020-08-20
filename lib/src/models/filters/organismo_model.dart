
class Organismo {
  String id;
  String nombre;
  String descripcion;

  Organismo({
    this.id,
    this.nombre,
    this.descripcion,
  });

  factory Organismo.fromJson(Map<String,dynamic> jsonDecoded){
    return Organismo(
      id          : jsonDecoded['id'],
      nombre      : jsonDecoded['Nombre'],
      descripcion : jsonDecoded['Descripcion']);
  }
}
