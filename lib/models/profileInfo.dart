import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario{

  static final PreferenciasUsuario _instancia = new PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();

  SharedPreferences _prefs;

  initPrefs() async{
    this._prefs = await SharedPreferences.getInstance();
  }


  //String _nombre;
  //String _apellido;
  //int _dni;

  get apellido{
    return _prefs.getString('apellido') ?? 'apellidoO';
  }

  set apellido(String value){
    _prefs.setString('apellido', value);
  }



}