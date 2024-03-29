//BASICS
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/background_music.dart';
import 'package:mayor_g/src/views/signin_page.dart';
//DEPENDENCIAS
import 'package:auto_size_text/auto_size_text.dart';
//WIDGETS
import 'package:mayor_g/src/widgets/custom_widgets.dart';
//SERVICIOS
import 'package:mayor_g/src/services/authentications/auth_service.dart';
import '../services/authentications/auth_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{

  final player = BackgroundMusic.backgroundAssetsAudioPlayer;
  final _formKey = GlobalKey<FormState>();
  var _username;
  var _password;
  bool _isLoading = false;
  bool _recuperandoContrasenia = false;
  Size size;
  TextStyle style;
  bool musicaSwitch = true;

  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    style = Theme.of(context).textTheme.headline4.copyWith(fontSize:25,color: Colors.white,fontWeight: FontWeight.bold);
    super.didChangeDependencies();
  }
  
  IconData musicaTernario(){
    return (musicaSwitch)? Icons.music_note_rounded:Icons.music_off_rounded;
  }

  _submit() async {
    if (!_isLoading) {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });

        await AuthService()
            .login(context, username: _username, password: _password);

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  _recuperarContrasenia() async{
    if(!_recuperandoContrasenia) { 
      if(_formKey.currentState.validate()) {
        setState(() {
          _recuperandoContrasenia = true;
        });

        await AuthService().recuperarContrasenia(context,dni: _username);

        setState(() {
          _recuperandoContrasenia = false;
        });
      }
    }
  }

  Future<bool> onWillPop(){
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
      title: Text('¿Quieres salir de la aplicación?'),
      actions: <Widget>[
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Salir')),
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Cancelar'))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (notification) {
        notification.disallowGlow();
        return false;},
      child: WillPopScope(
        onWillPop: onWillPop,
          child: Scaffold(
            body: Stack(
              children: [
                BackgroundWidget(),
                SafeArea(
                  child: Align(
                    alignment: Alignment.center,
                    child: SingleChildScrollView(child: _militarForm(size))),
                ),
                
                (_isLoading)?LoadingWidget(
                  caption: Text('Aguarde... Usted \nestá ingresando a MayorG', style: Theme.of(context).textTheme.headline6.copyWith(color:Colors.white),textAlign: TextAlign.center,),
                ):Container()
              ],
            ),
          )
      ),
    );
  }
  
Widget _militarForm(Size size){
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text('Bienvenido a',style: Theme.of(context).textTheme.headline5.copyWith(color:Colors.white),),
        Hero(tag:1,child: _mayorG(size)),
        SizedBox(height: size.height*0.1,),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
        TextInput(
          label: 'DNI',
          color: Colors.white,
          inputType: TextInputType.number,
          inputIcon: Icon(
        Icons.person,
        color: Colors.white,
          ),
          validator: (String text) {
        if (text.isEmpty) {
          return 'Por favor completar el campo';
        }
        this._username = text;
        return null;
          },
        ),
        SizedBox(
          height: 30,
        ),
        TextInput(
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
      ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: size.height *0.1),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: ListTile(
                    title: Center(
                      child: AutoSizeText("Ingresar",
                          style:Theme.of(context).textTheme.headline5.copyWith(color:Colors.white))),
                    onTap: (){
                      _submit();
                    }
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Container(
                    width: size.width * 0.4,
                    child: ListTile(
                      onTap: ()=>_showMyDialog(),
                      title: AutoSizeText('Registrarse',maxLines: 1,style: TextStyle(color: Colors.white,),textAlign: TextAlign.left,),
                    )
                  ),
                  Expanded(child: Container(),),
                  Container(
                    width: size.width * 0.4,
                    child: ListTile(
                      onTap: ()=>_recuperarContrasenia(),
                      title: AutoSizeText('Recuperar contraseña',maxLines: 2,style: TextStyle(color: Colors.white,),textAlign: TextAlign.center,),
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(musicaTernario(),color: Colors.white.withOpacity(0.5),), 
              onPressed: (){
                musicaSwitch = !musicaSwitch;
                setState(() {});
                player.setVolume((musicaSwitch)?1:0);
              }
            ),
          ],
        )
      ],
    ),
  );
}

Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('¡Atención!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Sí usted es personal militar en actividad, ya puede ingresar utilizando sus credenciales de SomosEA.'),
              Text('¿Quiere continuar con el registro?'),
            ],
          ),
        ),
        actions: <Widget>[
          CupertinoButton(
            child: Text('Atrás'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          CupertinoButton(
            child: Text('Continuar'),
            onPressed: () {
              var route = new MaterialPageRoute(
                  builder: (context) => SignInPage());
                  Navigator.pop(context);
              Navigator.push(context, route);
            },
          ),
        ],
      );
    },
  );
}

Widget _mayorG(Size size){
  return Container(
    height: size.height * 0.1,
    decoration: BoxDecoration(
      image: DecorationImage(image: AssetImage('assets/mayorG@3x.png'))
    ),
  );
}
}
