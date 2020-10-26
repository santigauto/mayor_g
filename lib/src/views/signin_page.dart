//BASICS
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/commons/friend_selector_service.dart';
//DEPENDENCIAS
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:mayor_g/src/widgets/boton_widget.dart';
//WIDGETS
//import 'package:mayor_g/src/widgets/custom_header_widget.dart';
import 'package:mayor_g/src/widgets/input_text_widget.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
//SERVICIOS
import 'package:mayor_g/src/services/auth_service.dart';
//import 'package:mayor_g/src/widgets/loading_widget.dart';
import '../services/auth_service.dart';


class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  var _username;
  var _password;
  bool _isLoading = false;
  Size size;
  TextStyle style;
  PreferenciasUsuario prefs = new PreferenciasUsuario();


  @override
  void didChangeDependencies() {
    size = MediaQuery.of(context).size;
    style = Theme.of(context).textTheme.headline4.copyWith(fontSize:25,color: Colors.white,fontWeight: FontWeight.bold);
    super.didChangeDependencies();
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
                child: SingleChildScrollView(child: _militarForm(size))),
            ),
          ],
        ),
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
        _mayorG(size),
        SizedBox(height: size.height*0.1,),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextInput(
                label: 'Nickname',
                color: Colors.white,
                inputType: TextInputType.text,
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
        //------------------------------------------------
        TextInput(
          label: 'Confirmar contraseña',
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
        SizedBox(height: 20,),
        CheckboxListTile(
          value: false,
          onChanged: (bool){},
            title: AutoSizeText('Acepto terminos y condiciones',maxLines: 1,style: TextStyle(color: Colors.white,),textAlign: TextAlign.left,),
        ),
            ],
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
              onTap: () => GetFriendsService().enviarSolicitud(dni: prefs.dni, dniAmigo: 31669679),
            ),
          ),
        ),
        
      ],
    ),
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
