class Collab{
  bool estado;
  String descripcion;

  Collab({this.descripcion,this.estado});

factory Collab.fromJson(Map<String,dynamic> parsedJson){
  return Collab(
    descripcion: parsedJson['descripcion'].toString(),
    estado: parsedJson['estado'],
  );
}

}