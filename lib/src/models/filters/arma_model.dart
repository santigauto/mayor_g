
class Arma {
  String id;
  String nombre;
  String descripcion;
  String organismoId;
  String organismoNombre;

  Arma({
    this.id,
    this.nombre,
    this.descripcion,
    this.organismoId,
    this.organismoNombre,
  });

  factory Arma.fromJson(Map<String,dynamic> jsonDecoded){
    return Arma(
      id              :   jsonDecoded['id'],
      nombre          :   jsonDecoded['nombre'],
      descripcion     :   jsonDecoded['descripcion'],
      organismoId     :   jsonDecoded['organismoId'],
      organismoNombre :   jsonDecoded['organismoNombre'],
    );
  }
}
