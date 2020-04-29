import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

import '../config.dart';
import 'package:mayor_g/models/auth/user.dart';
import 'package:mayor_g/widgets/alert_widget.dart';


class Bloc{

  //-------------------- STREAM DE DATOS DE USUARIO LOGEADO ---------------------------

  final _profileStreamController = StreamController<User>.broadcast();

  Function(User) get userProfileSink => _profileStreamController.sink.add;

  Stream<User> get userProfileStream => _profileStreamController.stream;

  void disposeStreams(){
    _profileStreamController.close();
  }

}
Bloc bloc = Bloc();

/////////////////////////////////////////////////////////////////////////////////////////

class AuthService {

  final user = User();
  User profile = User();


//------------------------------ FUNCION DE LOGEO ------------------------------------

  login(BuildContext context, { @required String username, @required String password}) async {

   final http.Response response = await http.post(
     '${Config.ApiURL}/musuario/login',
     headers: Config.HttpHeaders,
     body: jsonEncode({
        'usu_dni' : username,
        'usu_password' : password,
        'push_id' : '',
        'device_id' : ''
      })
     );
    if(!response.headers['content-type'].contains('application/json; charset=utf-8')) {
      return Alert.alert(context, body: Text('Ups! Algo salió mal. Por favor vuelva a intentar.'));
    }

    final dynamic _decodedJson = jsonDecode(response.body); 

    if(_decodedJson['status'].toString().isEmpty || _decodedJson['status'] != 200) {
      return Alert.alert(context, body: Text('Usuario o contraseña incorrectos.'));
    }

    final User _user = User.fromJson(_decodedJson);

    await user.set(_decodedJson);
    //profile =await getUserProfile(await getAccessToken());
    profile = User(apellido: 'gutierrez',nombre: 'marcos');
    bloc.userProfileSink(profile);

    Navigator.pushReplacementNamed(context, 'menu');
    print('hola manito ${[_user.token.generatedAt,_user.dni.toString()]}');


  }
//---------------- ACCESO AL TOKEN --------------------------
  Future<String> getAccessToken() async {

      final result = await user.get();
      if(result == null) {
        return null;
      }
      final String uat = result['mut_uat'] as String;
      return uat;
  }

//------------------------ LOGOUT -------------------------------
  logout({BuildContext context}){
    this.user.storage.deleteAll();
    Navigator.pushReplacementNamed(context, 'splash');
  }

//------------- FUNCION PEDIR DATOS DEL USUARIO ------------------

  Future<User>getUserProfile(_uat) async{
    User _profile = User();
    final http.Response response = await http.get(
      '${Config.ApiURL}/musuario/Trae_Datos_Usuario?mut_uat=$_uat',
      headers: Config.HttpHeaders,);
    
    final dynamic _decodedJson = jsonDecode(response.body);

    if(_decodedJson['usu_DNI'].toString().isEmpty){
      _profile = null;
      return User(apellido: '',dni: 0,deviceId: '',email: '',grado: '',nombre: '',pushId: '');
    }
    else{
      _profile = User.fromJsonProfile(_decodedJson);
      print(_profile.nombre);
      return _profile;
    }

  }

}


