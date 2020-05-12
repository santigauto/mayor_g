  class RecuperarContrasenia{
  int usuDni;
  int status;
  String mensaje;

  RecuperarContrasenia({
    this.usuDni,
    this.status,
    this.mensaje,
  });

  RecuperarContrasenia.fromJsonMap(Map<String, dynamic> json){
    usuDni = json['usu_dni'];
    status  = json['status'];
    mensaje = json['mensaje'];
  }
}