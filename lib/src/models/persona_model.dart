import 'dart:convert';

import 'dart:typed_data';

class Persona {
  int id;
  String apellido;
  String nombres;
  String grado;
  DateTime fechaNacimiento;
  String destino;
  Uint8List foto;
  String celular;
  String telefono;
  int dni;
  String email;
  String mensaje;
  int estado;
  int escalafon;
  String uat;

  Persona({
    this.id,
    this.apellido,
    this.nombres,
    this.grado,
    this.fechaNacimiento,
    this.destino,
    this.foto,
    this.celular,
    this.telefono,
    this.dni,
    this.email,
    this.mensaje,
    this.estado,
    this.escalafon,
    this.uat
  });

  Persona.fromJsonMap(Map<String, dynamic> json) {
    id = json['Id'];
    apellido = json['Apellido']?.trim();
    nombres = json['Nombres']?.trim();
    grado = json['Grado']?.trim();
    fechaNacimiento = DateTime.parse(json['FechaNacimiento']);
    destino = json['Destino']?.trim();
    try{
      foto = (json['Foto'] != null && json['Foto'].isNotEmpty) ? base64Decode(json['Foto'].replaceFirst('data:image/jpeg;base64,', '')) : null;
    }catch(e){
      foto = null;
    }
    celular = (json['Celular'] != null && json['Celular'].isNotEmpty) ? json['Celular'] : '';
    telefono = (json['Telefono'] != null && json['Telefono'].isNotEmpty) ? json['Telefono'] : '';
    dni = json['DNI'];
    email = (json['Email'] != null && json['Email'].isNotEmpty) ? json['Email'] : '';
    mensaje = json['Mensaje'];
    estado = json['Estado'];
    escalafon = json['Escalafon'];
    uat = json['UAT'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Apellido'] = this.apellido;
    data['Nombres'] = this.nombres;
    data['Grado'] = this.grado;
    data['FechaNacimiento'] = this.fechaNacimiento.toString();
    data['Destino'] = this.destino;
    data['Foto'] = this.foto;
    data['Celular'] = this.celular;
    data['Telefono'] = this.telefono;
    data['DNI'] = this.dni;
    data['Email'] = this.email;
    data['Mensaje'] = this.mensaje;
    data['Estado'] = this.estado;
    data['Escalafon'] = this.escalafon;
    data['UAT'] = this.uat;
    return data;
  }
}
