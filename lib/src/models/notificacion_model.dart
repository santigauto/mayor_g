class Notificacion{
  String id;
  String fechaDeCreacion;
  String titulo;
  String mensaje;
  String fechaDeLeido;
  String fechaDeBorrado;

  Notificacion({this.fechaDeBorrado,this.fechaDeCreacion,this.fechaDeLeido,this.id,this.mensaje,this.titulo});

  factory Notificacion.fromJson(Map<String,dynamic>json){
    return Notificacion(
      id : json['Id'],
      fechaDeCreacion : json['FechaCreacion'],
      titulo : json['Titulo'],
      mensaje : json['Mensaje'],
      fechaDeLeido : json['FechaLeido'],
      fechaDeBorrado : json['FechaBorrado'],
    );
  }
}