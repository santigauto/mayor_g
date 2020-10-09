import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:mayor_g/src/models/auth/obtain_password.dart';
import 'package:mayor_g/src/models/auth/user.dart';
import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/src/widgets/alert_widget.dart';


class AuthService {

  final user = User();
  User _profile = User();
  final prefs = new PreferenciasUsuario();

//------------------------------ FUNCION DE LOGEO ------------------------------------

  login(BuildContext context, { @required String username, @required String password}) async {
    try{
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
        _profile =await getUserProfile(await getAccessToken());

        _profile.deviceId = await getDeviceDetails();

        prefs.apellido=_profile.apellido;
        prefs.nombre=_profile.nombre;
        prefs.dni=_profile.dni;
        prefs.foto=_profile.foto;

        Navigator.pushReplacementNamed(context, 'menu');
        print('${[_user.token.generatedAt,_user.toString()]}');
    }catch(e){
      return Alert.alert(context, body: Text("${e.toString()}\nPor favor vuelva a intentarlo, en caso de que persista el error intente recuperar su contraseña."));
    }


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
      print('${_decodedJson.toString()}');
      return _profile;
    }

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
      return Alert.alert(context, body: Text('Algo salió mal. Por favor volver a intentar.'));
    }

    final dynamic _decodedJson = jsonDecode(response.body);

    if (_decodedJson['status'].toString().isEmpty || _decodedJson['status'] != 200) {
      return Alert.alert(context, body: Text('Algo salió mal. Por favor volver a intentar.'));
    }

    final RecuperarContrasenia _recuperarContrasenia = RecuperarContrasenia.fromJsonMap(_decodedJson);

    return Alert.alert(context, body: Text(_recuperarContrasenia.mensaje));
  }



  //----------------------------- OBTENER DEVICE INFO -------------------------------

   static Future<String> getDeviceDetails() async {
    //String deviceName;
    //String deviceVersion;
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        //deviceName = build.model;
        //deviceVersion = build.version.toString();
        identifier = build.androidId;  //UUID for Android
        print('ID:'+identifier);
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        //deviceName = data.name;
        //deviceVersion = data.systemVersion;
        identifier = data.identifierForVendor;  //UUID for iOS
      }
    } on PlatformException {
      print('Hubo un error al obtener la versión del dispositivo');
    }

//if (!mounted) return;
return identifier/* [deviceName, deviceVersion, identifier] */;
}


}


