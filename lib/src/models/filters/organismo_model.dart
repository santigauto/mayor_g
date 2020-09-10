
class ListaOrganismo{
  List<Organismo> organismos = new List();

  ListaOrganismo();

  ListaOrganismo.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null || jsonList.isEmpty) return;
    for(var item in jsonList){
      final organismo = new Organismo.fromJson(item);
      organismos.add(organismo);
    }
  }

}


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
