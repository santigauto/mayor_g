class ListaCurso {
  List<Curso> cursos = new List();
  ListaCurso();
  ListaCurso.fromJsonList(List<dynamic> jsonList){
    if(jsonList == null || jsonList.isEmpty) return;
    for(var item in jsonList){
      final curso = Curso.fromJson(item);
      cursos.add(curso);
    }
  }
}

class Curso {
  String id;
  String nombre;
  String descripcion;
  String organismoId;
  String organismoNombre;
  String armaId;
  String armaNombre;

  Curso({
    this.id,
    this.nombre,
    this.descripcion,
    this.organismoId,
    this.organismoNombre,
    this.armaId,
    this.armaNombre,
  });

  factory Curso.fromJson(Map<String,dynamic> json){
    return Curso(
      id : json['id'],
      nombre : json['nombre'],
      descripcion : json['descripcion'],
      organismoId : json['organismoId'],
      organismoNombre : json['organismoNombre'],
      armaId : json['armaId'],
      armaNombre : json['armaNombre'],
    );
  }
}
