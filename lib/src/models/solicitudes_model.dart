
class Solicitud {
  String id;
  int dni;
  String jugador;
  String fechaEnviado;
  dynamic fechaAprobado;
  bool seleccionado;

  Solicitud({
    this.id,
    this.dni,
    this.jugador,
    this.fechaEnviado,
    this.fechaAprobado,
    this.seleccionado = false
  });

  factory Solicitud.fromJson(Map<String,dynamic> json){
    return Solicitud(
      id: json['Id'],
      dni: json['dni'],
      jugador: json['Jugador'],
      fechaEnviado: json['FechaEnviado'],
      fechaAprobado: json['FechaAprobado'],
    );
  }
}

//{"Id":"b21ee5a2-01e9-41ce-80c4-883ad1da8fdd","Jugador":"wappY","FechaEnviado":"2020-12-04T10:06:35.6166257","FechaAprobado":"2020-12-04T10:24:27.8837964"}