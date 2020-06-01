
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:mayor_g/config.dart';
import 'package:mayor_g/models/friends_model.dart';

class GetFriendsService{

  getFriends(BuildContext context,{ @required int dni }) async{
    final http.Response response = await http.post(
       '${MayorGApis.ApiURL}/getAmigos.php',
       headers: MayorGApis.HttpHeaders,
       body: jsonEncode({
          'dni' : dni
        })
       );
    final dynamic _decodedJson = jsonDecode(response.body);
    final Amigos amigos = Amigos.fromJson(_decodedJson);
    print(amigos.toString());
  }
}


/*IONIC CODE
----
MODELO LISTA*
----
private urlObtener = 'https://www.maderosolutions.com.ar/MayorG2/modelo/getAmigos.php';
----
GetFriends(dni){
        this.http.post(this.urlObtener, JSON.stringify(dni))
            .subscribe((res: any) => {
                if (res == null){ return []; }

            for ( var i=0; i < res.amigos.length ; i++ ){
                this.lista*[i] = res.amigos[i]; //noAmigos
            }
            }), 
            {headers : this.headers}
        return this.lista*
    }
 */