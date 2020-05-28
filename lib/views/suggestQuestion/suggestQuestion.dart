import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:bordered_text/bordered_text.dart';

import 'package:mayor_g/services/commons/camara.dart';

import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/views/suggestQuestion/widgets/myInput.dart';

import 'package:mayor_g/models/question_model.dart';

class SuggestQuestionPage extends StatefulWidget {
  SuggestQuestionPage({Key key}) : super(key: key);

  @override
  _SuggestQuestionPageState createState() => _SuggestQuestionPageState();
}

class _SuggestQuestionPageState extends State<SuggestQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Camara camaraController = new Camara();

  Pregunta _pregunta = new Pregunta();
  List<String> _correctas = ['','','','',''];
  List<String> _incorrectas = ['','','','',''];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Sugerir pregunta')),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            _suggestQuestionPageBody(),
          ],
        ),
      ),
    );
  }

  Widget _suggestQuestionPageBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              /* BorderedText(
                strokeColor: Theme.of(context).primaryColor,
                child: Text(
                  'Puede sugerir una pregunta para que este en el juego.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ), */
              SizedBox(height: 25),
              _createQuestion(),
              SizedBox(height: 25),
              _createCorrects(),
              SizedBox(height: 25),
              _createIncorrects(),
              SizedBox(height: 25),

              _pregunta.foto == null || _pregunta.foto.isEmpty ? Container() :
                Image.memory(
                  base64Decode(_pregunta.foto), fit: BoxFit.cover,
                ),
              RaisedButton.icon(
                icon: Icon(Icons.camera),
                label: Text("Cargar imagen", style: TextStyle(fontSize: 20)),
                onPressed: uploadImage,
                color: Colors.green[900],
                textColor: Colors.white,
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black),
                ),
              ),

              SizedBox(height: 25),

              RaisedButton.icon(
                icon: Icon(Icons.mail_outline),
                label: Text("Enviar", style: TextStyle(fontSize: 20)),
                onPressed: () => _submit(),
                color: Colors.green[900],
                textColor: Colors.white,
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  uploadImage()async{
    _pregunta.foto = await camaraController.getImage();
    setState((){});
  }

  Container _createQuestion() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white.withOpacity(0.6),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          maxLength: 250,
          validator: (String text) {
            if (text.isEmpty)
              return 'Por favor completar el campo';
            this._pregunta.pregunta = text;
            return null;
          },
          style: TextStyle(fontSize: 18),
          maxLines: 7,
          decoration: InputDecoration(
            labelText: 'Pregunta a sugerir',
          ),
        ),
      ),
    );
  }

  Widget _createCorrects(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 42),
            BorderedText(
              strokeColor: Theme.of(context).primaryColor,
              child: Text(
                'Respuestas correctas',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () => _alerta(
                'Lorem ipsum\nejemplo'
              )
            )
          ],
        ),

        BorderedText(
          strokeColor: Theme.of(context).primaryColor,
          child: Text(
            'Debe ingresar al menos 1',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(height:12),
        MyInput(
          label: '1ra correcta',
          validator: (String text) {
            this._correctas[0] = text;
            return null;
          },
        ),
        SizedBox(height:12),
        MyInput(
          label: '2da correcta',
          validator: (String text) {
            this._correctas[1] = text;
            return null;
          },
        ),
        SizedBox(height:12),
        MyInput(
          label: '3ra correcta',
          validator: (String text) {
            this._correctas[2] = text;
            return null;
          },
        ),
        SizedBox(height:12),
        MyInput(
          label: '4ta correcta',
          validator: (String text) {
            this._correctas[3] = text;
            return null;
          },
        ),
        SizedBox(height:12),
        MyInput(
          label: '5ta correcta',
          validator: (String text) {
            this._correctas[4] = text;
            return null;
          },
        ),
      ],
    );
  }

  Widget _createIncorrects(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(width: 42),
            BorderedText(
              strokeColor: Theme.of(context).primaryColor,
              child: Text(
                'Respuestas incorrectas',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
            IconButton(
              icon: Icon(Icons.help_outline),
              onPressed: () => _alerta(
                'Lorem ipsum\nejemplo'
              )
            )
          ],
        ),

        BorderedText(
          strokeColor: Theme.of(context).primaryColor,
          child: Text(
            'Debe ingresar las 5\nEstas deben ser alucivas a la pregunta',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height:12),

        MyInput(
          label: '1ra incorrecta',
          validator: (String text) {
            if(text.isEmpty)
              return "Por favor llene este campo";
            this._incorrectas[0] = text;
            return null;
          },
        ),
        SizedBox(height:12),
        MyInput(
          label: '2da incorrecta',
          validator: (String text) {
            if(text.isEmpty)
              return "Por favor llene este campo";
            this._incorrectas[1] = text;
            return null;
          },
        ),
        SizedBox(height:12),
        MyInput(
          label: '3ra incorrecta',
          validator: (String text) {
            if(text.isEmpty)
              return "Por favor llene este campo";
            this._incorrectas[2] = text;
            return null;
          },
        ),
        SizedBox(height:12),
        MyInput(
          label: '4ta incorrecta',
          validator: (String text) {
            if(text.isEmpty)
              return "Por favor llene este campo";
            this._incorrectas[3] = text;
            return null;
          },
        ),
        SizedBox(height:12),
        MyInput(
          label: '5ta incorrecta',
          validator: (String text) {
            if(text.isEmpty)
              return "Por favor llene este campo";
            this._incorrectas[4] = text;
            return null;
          },
        ),
      ],
    );
  }

  _submit() async {
    if (!_isLoading) {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });

        //await CollabService().sendCollab(context,dni: PreferenciasUsuario().dni,sugerencia: _collab,idPregunta: 0);
        await Future.delayed(Duration(seconds: 3));

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _alerta(String texto) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(texto),
          actions: <Widget>[
            FlatButton(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}