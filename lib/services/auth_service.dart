import 'dart:convert';
import 'package:flutter/cupertino.dart';

import 'package:meta/meta.dart' show required;
import 'package:http/http.dart' as http;

import '../config.dart';
import 'package:mayor_g/models/auth/user.dart';
import 'package:mayor_g/widgets/alert_widget.dart';

class AuthService {

  final user = User();

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
      return Alert.alert(context, body: Text('Algo salió mal. Por favor volver a intentar.'));
    }

    final dynamic _decodedJson = jsonDecode(response.body); 

    if(_decodedJson['status'].toString().isEmpty || _decodedJson['status'] != 200) {
      return Alert.alert(context, body: Text('Usuario o contraseña incorrectos.'));
    }

    final User _user = User.fromJson(_decodedJson);
    await user.set(_decodedJson);

    Navigator.pushReplacementNamed(context, 'menu');


    print([_user.token.generatedAt,_user.dni.toString()]);
  }

  Future<String> getAccessToken() async {
      final result = await user.get();
      if(result == null) {
        return null;
      }
      final String uat = result['mut_uat'] as String;
      return uat;
  }

  logout({BuildContext context}){
    this.user.storage.deleteAll();
    Navigator.pushReplacementNamed(context, 'splash');
  }
/*logout() {
    this.storage.remove(this.TOKEN_KEY).then(()=>{
      this.authenticationState.next(false);
      this.router.navigateByUrl('/auth');
    })
  }*/

}