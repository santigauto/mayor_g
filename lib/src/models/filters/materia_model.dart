
class Materia {
  String id;
  String nombre;
  String descripcion;
  String organismoId;
  String organismoNombre;
  String armaId;
  String armaNombre;
  String cursoId;
  String cursoNombre;

  Materia({
    this.id,
    this.nombre,
    this.descripcion,
    this.organismoId,
    this.organismoNombre,
    this.armaId,
    this.armaNombre,
    this.cursoId,
    this.cursoNombre,
  });

  factory Materia.fromJson(Map<String,dynamic> json){
    return Materia(
      id              : json['id'],
      nombre          : json['nombre'],
      descripcion     : json['descripcion'],
      organismoId     : json['organismoId'],
      organismoNombre : json['organismoNombre'],
      armaId          : json['armaId'],
      armaNombre      : json['armaNombre'],
      cursoId         : json['cursoId'],
      cursoNombre     : json['cursoNombre'],
    );
  }
}
