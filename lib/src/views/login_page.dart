//BASICS
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//DEPENDENCIAS
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
  Size size;
  TextStyle style;

  @override
  void initState() { 
    super.initState();
    _animationController = new AnimationController(vsync: this,duration: Duration(milliseconds: 1000));
    fadeOutChoice = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _animationController, curve: Interval(0.0, 0.5)));
    fadeInMilitarForm = Tween(begin:0.0,end:1.0).animate(CurvedAnimation(parent: _animationController, curve: Interval(0.5, 1.0)));
    
  }

  @override
  void didChangeDependencies() {
    translateMilitarFormPosition = Tween(begin:MediaQuery.of(context).size.height, end: 0.0).animate(CurvedAnimation(parent:_animationController,curve:Interval(0.5, 1.0)));
    size = MediaQuery.of(context).size;
    style = Theme.of(context).textTheme.headline4.copyWith(fontSize:25,color: Colors.white,fontWeight: FontWeight.bold);
    super.didChangeDependencies();
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
    return WillPopScope(
      onWillPop: onWillPop,
          child: Scaffold(
              body: Stack(
            children: <Widget>[
              BackgroundWidget(),
              SafeArea(
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) {
                    return Opacity(
                      opacity: fadeOutChoice.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            height: size.height * 0.1,
                          ),
                          Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Colors.white,width: 3.0))
                            ),
                            child: Text('INGRESAR COMO',style: style,)
                          ),
                          SizedBox(height: size.height * 0.05,),
                          _buttonChoice(
                            (){_animationController.forward(); setState(() {
                            _isCivil = true;
                            _isMilitar = false;
                          });}, 
                          size, 
                          Text('Civil',style:style),
                          Colors.blue,
                          Colors.blue[900],
                          Container(margin:EdgeInsets.symmetric(horizontal:15),height:30,width: 30,child:SvgPicture.asset('assets/Icon_Civil.svg'))
                          ),
                          _buttonChoice(
                            (){_animationController.forward(); setState(() {
                            _isMilitar = true;
                            _isCivil = false;
                          });}, 
                          size, 
                          Text('Militar',style:style),
                          Theme.of(context).primaryColor,
                          Colors.lightGreen[900],
                          Container(margin:EdgeInsets.symmetric(horizontal:15),height:30,width: 30,child:SvgPicture.asset('assets/Icon_Mil.svg'))
                          ),
                          _buttonChoice(
                            (){_animationController.forward(); setState(() {
                            _isMilitar = true;
                            _isCivil = false;
                          });}, 
                          size, 
                          Text('Retirado',style:style),
                          Theme.of(context).primaryColor,
                          Colors.lightGreen[900],
                          Container(margin:EdgeInsets.symmetric(horizontal:15),height:30,width: 30,child:SvgPicture.asset('assets/Icon_Mil.svg'))
                          ),
                          SizedBox(
                            height: size.height * 0.1,
                          ),

                        ],
                      ),
                    );
                  }
                ),
              ),
                (_isMilitar)?AnimatedBuilder(
                  animation: _animationController,
                  builder: (context, _) {
                    return Positioned(
                      top:translateMilitarFormPosition.value,
                      child: /* Opacity(
                        opacity: fadeInMilitarForm.value,
                        child: */ _militarForm(size)
                      //),
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
  return SafeArea(
    child: Container(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Bienvenido a',style: Theme.of(context).textTheme.headline5.copyWith(color:Colors.white),),
            _mayorG(size),
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
                        onTap: () => _submit(),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.white,
                      child: ListTile(
                        title: Center(
                          child: AutoSizeText("Registrarme",
                              style:Theme.of(context).textTheme.headline5.copyWith(color:Color(0xff49634B)))),
                        onTap: _showMyDialog,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(child: Container(),),
                      Container(
                        width: size.width * 0.5,
                        child: ListTile(
                          onTap: ()=>_recuperandoContrasenia,
                          title: AutoSizeText('Recuperar contraseña',maxLines: 1,style: TextStyle(color: Colors.white,),textAlign: TextAlign.right,),
                        )
                      ),
                    ],
                  ),
                  /* Row(
                children: [
                  Container(
                    width: size.width * 0.5,
                    child: ListTile(
                      title: AutoSizeText('Recuperar contraseña',maxLines: 1,style: TextStyle(color: Colors.white,),textAlign: TextAlign.left,),
                    )
                  ),
                  Expanded(child: Container(),),
                  Container(
                    width: size.width * 0.4,
                    child: ListTile(
                      title: Text('Registrarse',style: TextStyle(color:Colors.white),textAlign: TextAlign.end,),
                    )
                  ),
                ],
              ), */
              
                  /* Container(
                    width: size.width * 0.5,
                    height: size.height *0.1,
                    child: BotonWidget(
                      text: Container(
                        height: size.height *0.1,
                        child: Center(
                          child: AutoSizeText("Registrarse", style: TextStyle(fontSize: 15,)))),
                      onTap: () => _recuperarContrasenia(),
                      colorPrimario: Colors.white,
                    ),
                  ), */
                ],
              ),
            ),
            
          ],
        ),
      ),
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
              Text('Sí usted es personal militar en actividad, ya puede ingresar utilizando sus credenciales de SIAM.'),
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
            child: Text('Registrarme'),
            onPressed: () {
              Navigator.of(context).pop();
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
