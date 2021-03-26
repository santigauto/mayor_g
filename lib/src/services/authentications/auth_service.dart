import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mayor_g/src/models/auth/obtain_password.dart';
import 'package:mayor_g/src/models/auth/user.dart';
import 'package:mayor_g/src/models/persona_model.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/authentications/device_info_service.dart';
import 'package:mayor_g/src/services/http_request_service.dart';
import 'package:mayor_g/src/services/user/user_service.dart';

import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';

/*TODO: Backend! el servicio de logueo deberia cumplir con la funcion ternaria de ingresar como civil o militar, 
en este momento solo puedo loguearme como militar y tengo que pasar por un monton de otras funciones que deberian
estar del lado del back*/

class AuthService {

  final user = User();
  User _profile = User();
  final prefs = new PreferenciasUsuario();

//------------------------------ FUNCION DE LOGEO ------------------------------------

  login(BuildContext context, { @required String username, @required String password}) async {
    
    try{
      
      final http.Response response = await http.post(
        Uri.https(Config.ApiURL, '/api/musuario/Login'),
        headers: Config.HttpHeaders,
        body: jsonEncode({
            'usu_dni' : username,
            'usu_password' : password,
            'push_id' : '',
            'device_id' : ''
          })
        );
        if(!response.headers['content-type'].contains('application/json; charset=utf-8')) {
          return Alert.alert(
            context, 
            body: Text('Ups! Algo salió mal. Por favor vuelva a intentar.'),
            );
        }

        final dynamic _decodedJson = jsonDecode(response.body); 

        if(_decodedJson['status'].toString().isEmpty || _decodedJson['status'] != 200) {
          return Alert.alert(
            context, 
            body: Text('Usuario o contraseña incorrectos.'),
            );
        }
        await user.set(_decodedJson);
        _profile =await getUserProfile(_decodedJson['mut_uat']);
        
        prefs.apellido=_profile.apellido;
        prefs.nombre=_profile.nombre;
        prefs.dni=_profile.dni;
        prefs.foto=_profile.foto;
        prefs.email=_profile.email;

        if(_profile.dni != null){
          print("registrar militar arranca acá");
          await registrarMilitar(context, 
            dni: prefs.dni, 
            password: password, 
            deviceId: prefs.deviceId, 
            deviceName: prefs.deviceName, 
            deviceVersion: prefs.deviceVersion, 
            apellido: prefs.apellido,
            nombre: prefs.nombre, 
            email:prefs.email
          ).then((value) async => await GetUserService().generarUserDevice(context, 
            dni: prefs.dni, 
            deviceId: prefs.deviceId, 
            deviceName: prefs.deviceName, 
            deviceVersion: prefs.deviceVersion
          ).then((value) async{
            Persona _persona = await GetUserService().obtenerUsuarioDni(context, dni: prefs.dni, deviceId: prefs.deviceId, dniBusqueda: prefs.dni);
            prefs.nickname = _persona.nickname;
          }));
        } 
        
    }catch(e){
      return Alert.alert(
        context, 
        body: Text("${e.toString()}\nPor favor vuelva a intentarlo, en caso de que persista el error intente recuperar su contraseña."),
        actions: [
          BotonWidget(
            text: Text('ok'),
            onTap: ()=>Navigator.pop(context),)
        ]
        );
    } /* on SocketException { print('SocketException');} on FormatException{print('FormatException');} on HttpException{print('HttpException');} */
    Navigator.pushReplacementNamed(context, 'menu');

  }

//------------------------ LOGOUT -------------------------------
  logout({BuildContext context}){
    this.user.storage.deleteAll();
    prefs.nickname = null;
    Navigator.pushReplacementNamed(context, 'splash');
  }

//------------- FUNCION PEDIR DATOS DEL USUARIO ------------------

  Future<User>getUserProfile(_uat) async{

    User _profile = User();

    final http.Response response = await http.get(
      Uri.https(Config.ApiURL, '/api/musuario/Trae_Datos_Usuario',
        {
          'mut_uat': _uat,
        }
      ),
      headers: Config.HttpHeaders,);
    
    final dynamic _decodedJson = jsonDecode(response.body);
    print(_decodedJson);
    if(_decodedJson['usu_DNI'].toString().isEmpty){
      _profile = null;
      return User(apellido: '',dni: 0,deviceId: '',email: '',grado: '',nombre: '',pushId: '');
    }
    else{
      _profile = User.fromJsonProfile(_decodedJson);
      _profile.deviceId = await DeviceInfoService().getDeviceDetails();
      return _profile;
    }

  }

//------------------------ REGISTRO DE CIVILES -------------------------------

Future registrarCivil(BuildContext context,{String name,String surname,String dni, String password, String nickname, String mail}) async{//devuelve true, es un post
  print('Registrar Civil');
  var result;
  await DeviceInfoService().getDeviceDetails().then((value) async  {
    print(prefs.deviceId);
   result = await HttpService().getPost(context,apiRoute: 'api/Usuarios/Registrar_Civil',jsonEncode: jsonEncode({
    "Apellido":"",
	  "Nombre":"",
	  "Email":mail,
	  "DNI":dni,
	  "Password": password,
	  "Nickname": nickname,
	  "DeviceId":prefs.deviceId,
	  "DeviceName":prefs.deviceName,
	  "DeviceVersion":prefs.deviceVersion
  })).then((value) {
      prefs.dni = int.parse(dni);
      prefs.email = mail;
      prefs.apellido = surname;
      prefs.nombre = name;
      prefs.nickname = nickname;
    });}
  );
  print(result);
  if(result == 'true'){
    print('es true el result loco');
  }

}

//------------------------- REGISTRO DE MILITARES -----------------------------

Future registrarMilitar(BuildContext context, {@required int dni,@required String password, @required String nombre, @required String apellido,
                          @required String email,@required String deviceId, @required String deviceName, @required deviceVersion,}) async{

  bool result = await HttpService().getPost(context, apiRoute: 'api/Usuarios/Registrar_Militar', 
    
    jsonEncode: jsonEncode({
	    "Apellido":apellido,
	    "Nombre":nombre,
	    "Email":email,
	    "DNI":dni,
	    "Password": password,
	    "DeviceId":deviceId,
	    "DeviceName":deviceName,
	    "DeviceVersion":deviceVersion
	}));

  return result;
}


//----------------------------- RECUPERAR CLAVE ------------------------------

recuperarContrasenia(BuildContext context, {@required String dni}) async {
    final url = Uri.https(Config.ApiURL, '/api/musuario/PasswordRecovery');
    final http.Response response = await http.post(url, headers: Config.HttpHeaders,
      body: jsonEncode({
        'usu_dni': dni
      })
    );
    if (!response.headers['content-type'].contains('application/json; charset=utf-8')) {
      return Alert.alert(context, body: Text('Algo salió mal. Por favor volver a intentar.'),
      actions: [
        BotonWidget(
          text: Text('Ok'),
          onTap: ()=>Navigator.pop(context),
        )
      ]);
    }

    final dynamic _decodedJson = jsonDecode(response.body);

    if (_decodedJson['status'].toString().isEmpty || _decodedJson['status'] != 200) {
      return Alert.alert(context, body: Text('Algo salió mal. Por favor volver a intentar.'),
      actions: [
        BotonWidget(
          text: Text('ok'),
          onTap: ()=>Navigator.pop(context),
        )
      ]);
    }

    final RecuperarContrasenia _recuperarContrasenia = RecuperarContrasenia.fromJsonMap(_decodedJson);

    return Alert.alert(context, body: Text(_recuperarContrasenia.mensaje),
    actions: [
      BotonWidget(
        text: Text('ok'),
        onTap: ()=>Navigator.pop(context),
      )
    ]);
  }



}




