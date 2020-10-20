//BASICS
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//DEPENDENCIAS
import 'package:bordered_text/bordered_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mayor_g/src/widgets/boton_widget.dart';
//WIDGETS
import 'package:mayor_g/src/widgets/input_text_widget.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
//SERVICIOS
import 'package:mayor_g/src/services/auth_service.dart';
import 'package:mayor_g/src/widgets/loading_widget.dart';
import '../services/auth_service.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin{
  final _formKey = GlobalKey<FormState>();
  var _username;
  var _password;
  bool _isLoading = false;
  bool _recuperandoContrasenia = false;
  bool _isMilitar = false;
  bool _isCivil = false;
  AnimationController _animationController;
  Animation fadeOutChoice;
  Animation fadeInCivilForm;
  Animation fadeInMilitarForm;
  Animation translateMilitarFormPosition;


  @override
  void initState() { 
    super.initState();
    _animationController = new AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    fadeOutChoice = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _animationController, curve: Interval(0.0, 0.5)));
    fadeInMilitarForm = Tween(begin:0.0,end:1.0).animate(CurvedAnimation(parent: _animationController, curve: Interval(0.5, 1.0)));
    translateMilitarFormPosition = Tween(begin:500.0, end: 0.0).animate(CurvedAnimation(parent:_animationController,curve:Interval(0.5, 1.0)));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    if(_animationController.isCompleted) {
      _animationController.reverse();
      return showDialog(context: null);
    }
    else return showDialog(
      context: context,
      builder: (context) => AlertDialog(
      title: Text('¿Quieres realmente abandonar la partida?'),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Salir')),
        FlatButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Cancelar'))
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
          child: Container(
        child: Scaffold(
            body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, _) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Opacity(
                        opacity: fadeOutChoice.value,
                        child: _buttonChoice(
                          (){_animationController.forward(); setState(() {
                          _isCivil = true;
                          _isMilitar = false;
                        });}, 
                        size, 
                        Text('Civil',style:Theme.of(context).textTheme.headline5.copyWith(color:Colors.white)),
                        Colors.blue,
                        Colors.blue[900],
                        Container(margin:EdgeInsets.symmetric(horizontal:15),height:30,width: 30,child:SvgPicture.asset('assets/Icon_Civil.svg'))
                        )
                      ),
                      Opacity(
                        opacity: fadeOutChoice.value,
                        child: _buttonChoice(
                          (){_animationController.forward(); setState(() {
                          _isMilitar = true;
                          _isCivil = false;
                        });}, 
                        size, 
                        Text('Militar',style:Theme.of(context).textTheme.headline5.copyWith(color:Colors.white)),
                        Theme.of(context).primaryColor,
                        Colors.lightGreen[900],
                        Container(margin:EdgeInsets.symmetric(horizontal:15),height:30,width: 30,child:SvgPicture.asset('assets/Icon_Mil.svg'))
                        ),                        
                      ),
                    ],
                  ),
                );
              }
            ),
              (_isMilitar)?AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return Positioned(
                    top: size.height * 0.2 + translateMilitarFormPosition.value,
                    left: size.width * 0.05,
                    child: Opacity(
                      opacity: fadeInMilitarForm.value,
                      child: _militarForm(size)
                    ),
                  );
                }
              ): Container(),
              (_isCivil)?AnimatedBuilder(
                animation: _animationController,
                builder: (context, _) {
                  return Positioned(
                  top:translateMilitarFormPosition.value,
                  child: Opacity(
                    opacity: fadeInMilitarForm.value,
                    child: Stack(
                      children: [
                        Container(
                          height: size.height,
                          width: size.width,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.black.withOpacity(0.1),
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.1),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter
                            )
                          ),
                        ),
                        Positioned(
                          top: size.height * 0.45,
                          left: size.width * 0.05,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.9,
                                child: Card(
                                  child: Column(
                                    children: [
                                      Text('ATENCIÓN!'),
                                      Text('En estos momentos MayorG no esta disponible para usuarios civiles', textAlign: TextAlign.center,),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  );
                }
              ):Container(),
            _isLoading ? LoadingWidget(
              caption:Text(!_recuperandoContrasenia ? 'Usted está ingresando a MayorG' : 'Recuperando contraseña',
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16)
              )) : Container(),
          ],
        )),
      ),
    );
  }


Widget _buttonChoice(Function open, Size size, Text text, Color colorPrimario, Color colorSecundario, Widget leading){
  return BotonWidget(
    leading: leading,
    colorPrimario: colorPrimario,
    onTap: open,
    text: text,
    trailing: Container(
      width: size.height * 0.1,
      height: size.height * 0.1,
      color: colorSecundario,
      child: Icon(Icons.keyboard_arrow_right, color:Colors.white,size: size.width * 0.1,),
    ),
  );
}

Widget _militarForm(Size size){
  return Container(
  decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.5),
      borderRadius: BorderRadius.circular(20)),
  width: size.width * 0.9,
  height: size.height * 0.65,
  child: Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          BorderedText(
            strokeColor: Theme.of(context).primaryColor,
            child: Text("Bienvenido soldado a",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                )),
          ),
          Container(
            height: 30,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/mayorG@3x.png'))),
          ),
          ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 300, minWidth: 300),
            child: Form(
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
          ),
          SizedBox(
            height: 30,
          ),
          ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: 350, minWidth: 300),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black.withOpacity(0.1),
                      width: 1),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 20)
                  ]),
              child: CupertinoButton(
                child: Text("Ingresar",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
                color: Colors.white,
                onPressed: () => _submit(),
              ),
            ),
          ),
          CupertinoButton(
      child: Text("Recuperar contraseña", style: TextStyle(fontSize: 15,)),
      onPressed: () => _recuperarContrasenia(),
    )
        ],
      ),
    ),
  ));
}


}
