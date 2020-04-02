import 'dart:convert';

import 'package:mayor_g/models/auth/accessToken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
class User {
  num dni;
  String nombre;
  String apellido;
  String email;
  String pushId;
  String deviceId;
  Token token;

  final storage = FlutterSecureStorage();
  final tokenKey = 'session_id';

  User({this.dni,this.nombre,this.apellido,this.deviceId,this.email,this.pushId,this.token});


  set(_decodedUser) async {
    await storage.write(key: tokenKey, value: jsonEncode(_decodedUser));
  }

  get() async {
    final _user = await storage.read(key: tokenKey);

    if(_user != null) { 
      return jsonDecode(_user);
    }
    return null;
  }

  // User deserialization from JSON 
  // Method used for parsign JSON User Data to a User Model
  // Generally getted from API Service

  factory User.fromJson(Map<String, dynamic> parsedJson)
    {
      return User (
        dni: parsedJson['usu_dni'],
        nombre: '',
        email: '',
        pushId: '',
        deviceId: '',
        token: Token(
          expiresIn: 3600,
          generatedAt: DateTime.now(),
          token: parsedJson['mut_uat']
        )
      );
    }

}