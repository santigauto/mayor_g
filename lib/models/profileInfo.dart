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

  get nombre{
    return _prefs.getString('nombre') ?? 'nombreO';
  }

  set nombre(String value){
    _prefs.setString('nombre', value);
  }

  get dni{
    return _prefs.getInt('dni') ?? 0;
  }

  set dni(int value){
    _prefs.setInt('dni', value);
  }

  get foto{
    return _prefs.getString('foto') ?? null;
  }

  set foto(String value){
    _prefs.setString('foto', value);
  }


}