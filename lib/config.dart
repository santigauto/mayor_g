

//---- AQUI SE ARMARAN LAS CLASES UTILIZADAS PARA LAS PETICIONES A LAS APIS  ------


//PETICIÓN DE UAT
class Config { 
  static const ApiURL = "somosea.ejercito.mil.ar";
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