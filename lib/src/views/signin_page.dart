//BASICS
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//DEPENDENCIAS
import 'package:mayor_g/src/models/persona_model.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/authentications/auth_service.dart';

//WIDGETS
import 'package:mayor_g/src/widgets/custom_widgets.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();

  var _username;
  var _password;
  Persona persona = new Persona();

  bool _isLoading = false;
  Size size;
  TextStyle style;
  PreferenciasUsuario prefs = new PreferenciasUsuario();
  bool booleanAccept = false;
  bool checkflag = false;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    style = Theme.of(context).textTheme.headline4.copyWith(fontSize:25,color: Colors.white,fontWeight: FontWeight.bold);
    super.didChangeDependencies();
  }

  _submit() async {
    if (!_isLoading) {
      if (_formKey.currentState.validate()) {
        if(booleanAccept){
          await AuthService().registrarCivil(context,dni: persona.dni.toString(),mail: persona.email,nickname: _username,password: _password);
          setState(() {
            _isLoading = true;
          });
          checkflag = false;
          setState(() {
            _isLoading = false;
          });
          showDialog(context: context,
          barrierDismissible: false,
          builder: (context){
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¡Su cuenta ha sido creada con éxito!', textAlign: TextAlign.center,),
                ],
              ),
              content: Text('Ya eres usuario de MayorG, ahora solo debes iniciar sesión para comenzar nuevas partidas'),
              actions: [
                MaterialButton(onPressed: (){
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, 'login');
                }, child: Text('Aceptar'))
              ],
            );
          });
        } else{ setState(()=>checkflag = true);}
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return false;},
      child: Scaffold(
        body: Stack(
          children: [
            BackgroundWidget(),
            //HeaderCurvo(),
            SafeArea(
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(child: _militarForm())),
            ),
            (_isLoading)?Stack(
              children: [
                Container(color:Colors.black.withOpacity(0.5)),
                LoadingWidget(caption: Text('Aguarde, estamos validando sus datos') ,),
              ],
            ): Container()
          ],
        ),
      ),
    );
  }
Widget _militarForm(){
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Bienvenido a',style: Theme.of(context).textTheme.headline5.copyWith(color:Colors.white),),
        Hero(tag:1,child: _mayorG()),
        Padding(
          padding: const EdgeInsets.symmetric(vertical:20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextInput(
                  label: 'Nickname',
                  color: Colors.white,
                  inputType: TextInputType.text,
                  inputIcon: Icon(
                    Icons.tag_faces,
                      color: Colors.white,
                  ),
                  validator: (String text) {
                    String x;
                    if (text.isEmpty) {
                      x='Por favor completar el campo';
                    }
                    this._username = text;
                    return x;
                  },
                ),

                SizedBox(
                  height: 30,
                ),

                TextInput(
                  label: 'DNI',
                  color: Colors.white,
                  inputType: TextInputType.number,
                  inputIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  validator: (String number) {
                    if (number.isEmpty) {
                      return 'Por favor completar el campo';
                    }
                    persona.dni = int.parse(number);
                    return null;
                  },
                ),

                TextInput(
                  label: 'Email',
                  color: Colors.white,
                  inputType: TextInputType.emailAddress,
                  inputIcon: Icon(
                    Icons.email,
                      color: Colors.white,
                  ),
                  validator: (String text) {
                    String x;
                    if (text.isEmpty) {
                      x='Por favor completar el campo';
                    }
                    persona.email = text;
                    return x;
                  },
                ),
                
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width *0.4,
                      child: TextInput(
                        label: 'Contraseña',
                        password: true,
                        color: Colors.white,
                        inputIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        validator: (String text) {
                          if (text.isEmpty) {
                            return 'Por favor completar el campo';
                          }
                          this._password = text;
                          return null;
                        },
                      ),
                    ),
                    //------------------------------------------------
                    Container(
                      width: size.width *0.4,
                      child: TextInput(
                        label: 'Confirmar contraseña',
                        password: true,
                        color: Colors.white,
                        inputIcon: Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        validator: (String text) {
                          String x;
                          if (text.isEmpty) {
                            x = 'Por favor completar el campo';
                          } else if (text != this._password){
                            x = 'Las claves no coinciden';
                          }
                          return x;
                        },
                      ),
                    ),
                  ],
                ),
                
                CheckboxListTile(
                  subtitle: (checkflag)?Text('Debe aceptar los terminos y condiciones.', style: TextStyle(color: Colors.red),textAlign: TextAlign.left,):Container(),
                  value: booleanAccept,
                  onChanged: (boolean){
                    setState(() {
                      booleanAccept = boolean;
                      print(booleanAccept);
                    });
                  },
                    title: AutoSizeText('Acepto terminos y condiciones',
                              maxLines: 1,style: TextStyle(color: Colors.white,),textAlign: TextAlign.left,),
                ),
              ],
            ),
          ),
        ),
        
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Theme.of(context).primaryColor,
            child: ListTile(
              title: Center(
                child: AutoSizeText("Registrarme",
                    style:Theme.of(context).textTheme.headline5.copyWith(color:Colors.white))),
              onTap: () {
                _submit();
              },
            ),
          ),
        ),
        
      ],
    ),
  );
}

Widget _mayorG(){
  return Container(
    height: size.height * 0.1,
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage('assets/mayorG@3x.png'))
    ),
  );
}

}
