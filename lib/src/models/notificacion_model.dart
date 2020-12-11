class Notificacion{
  int id;
  DateTime fechaDeCreacion;
  String titulo;
  String mensaje;
  String fechaDeLeido;
  String fechaDeBorrado;

  Notificacion({this.fechaDeBorrado,this.fechaDeCreacion,this.fechaDeLeido,this.id,this.mensaje,this.titulo});

  factory Notificacion.fromJson(Map<String,dynamic>json){
    return Notificacion(
      id : json['Id'],
      fechaDeCreacion : json['FechaDeCreacion'],
      titulo : json['Titulo'],
      mensaje : json['Mensaje'],
      fechaDeLeido : json['FechaDeLeido'],
      fechaDeBorrado : json['FechaDeBorrado'],
    );
  }
}