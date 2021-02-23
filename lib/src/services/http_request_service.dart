import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mayor_g/config.dart';

import 'package:flutter/material.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';

class HttpService{

  String _url = 'mayorg.ejercito.mil.ar';

  Future getGet(context,{@required String apiRoute, Map<String, String> queryParameters}) async{
    final __url = Uri.https(_url, apiRoute, queryParameters);
    final resp = await http.get(__url,headers: Config.HttpHeaders);
    dynamic result;

    print("HttpService/getGet:  " + resp.body);
    if(resp.body== "") return "";
    if(resp.body.isEmpty || resp.body.contains('DOCTYPE html')) {
      Alert.alert(context, body: Text('Ups! Ha ocurrido un error.'));
    }else{
      final _decodedData = json.decode(resp.body);
      result = _decodedData;
    }
    
    return result;
  }

  Future getPost(context,{@required String apiRoute, String jsonEncode, Map<String, String> queryParameters}) async{
    final __url = Uri.https(_url, apiRoute, queryParameters);
    final resp = await http.post(__url,body: jsonEncode,headers: Config.HttpHeaders,);
    dynamic result;
    print("getPost " + resp.body);
    if(resp.body.isEmpty || resp.body.contains('DOCTYPE html')) {
      Alert.alert(context, body: Text('Ups! Ha ocurrido un error.'));
    }else{
      final _decodedData = json.decode(resp.body);
      result = _decodedData;
    }
    
    return result;
    
  }

}