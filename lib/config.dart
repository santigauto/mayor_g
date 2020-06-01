
//PETICIÓN DE UAT
class Config { 
  static const ApiURL = "https://cps-ea.mil.ar:612/api";
  static const ApiURLCGE = "www.cge.mil.ar:81";

  static const HttpHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS, PUT, PATCH, DELETE',
    'Access-Control-Expose-Headers': 'Access-Control-*',
    'Access-Control-Allow-Headers': 'Access-Control-*, Origin, X-Requested-With, Content-Type, Accept',
    'Content-Type': 'application/json'
  };

}
//PETICIONES A MADEROSOLUTIONS
class MayorGApis { 
  static const ApiURL = 'https://www.maderosolutions.com.ar/MayorG2/modelo';

  static const HttpHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': '*',
    'Content-Type': 'application/x-www-form-urlencoded'
  };

}