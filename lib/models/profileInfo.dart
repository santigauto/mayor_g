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
  //APELLIDO
  get apellido{
    return _prefs.getString('apellido') ?? 'apellidoO';
  }

  set apellido(String value){
    _prefs.setString('apellido', value);
  }
//NOMBRE
  get nombre{
    return _prefs.getString('nombre') ?? 'nombreO';
  }

  set nombre(String value){
    
    value = value.toLowerCase();
    value = value.replaceFirst(RegExp(value[0]), value[0].toUpperCase());

    for(var i = 0; i < value.length ; i ++){
      if (value[i] == ' '){
        value = value.replaceFirst(value[i+1], value[i+1].toUpperCase(), i);
      }
    }
    _prefs.setString('nombre', value);
  }
//DNI
  get dni{
    return _prefs.getInt('dni') ?? 0;
  }

  set dni(int value){
    _prefs.setInt('dni', value);
  }
//FOTO
  get foto{
    return _prefs.getString('foto') ?? null;
  }

  set foto(String value){
    value = value.replaceFirst('data:image/jpeg;base64,', '');
    if(value.length < 2){value = '';}
    _prefs.setString('foto', value);
  }

  //ARMA
  get arma{
    return _prefs.getString('arma') ?? 'General';
  }

  set arma(String value){
    _prefs.setString('arma', value);
  }

  //COLEGIO
  get colegio{
    return _prefs.getString('colegio') ?? '';
  }

  set colegio(String value){
    _prefs.setString('colegio', value);
  }
  //CURSO
  get curso{
    return _prefs.getString('curso') ?? '';
  }

  set curso(String value){
    _prefs.setString('curso', value);
  }
  //MATERIA
  get materia{
    return _prefs.getString('materia') ?? '';
  }

  set materia(String value){
    _prefs.setString('materia', value);
  }

}