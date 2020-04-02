import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/services/auth_service.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/input_text_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  var _username;
  var _password;
  bool _isLoading = false;

  _submit() async {
    if (!_isLoading) {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });

        await AuthService().login(context, username: _username, password: _password);

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
          body: Stack(
        children: <Widget>[
          BackgroundWidget(),
          SingleChildScrollView(
            child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20)),
                  width: size.width * 0.9,
                  height: size.height * 0.7,
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
                        height: 32,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Al Ingresar usted acepta los",
                              style:
                                  TextStyle(fontSize: 12, color: Colors.white)),
                          CupertinoButton(
                              padding: EdgeInsets.only(left: 4),
                              child: Text("Terminos Y Condiciones",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400)),
                              onPressed: () {})
                        ],
                      )
                    ],
                  )),
            ),
          )
        ],
      )),
    );
  }
}
