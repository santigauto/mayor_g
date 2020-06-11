import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/models/profileInfo.dart';
import 'package:mayor_g/services/commons/collab_service.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class CollabPage extends StatefulWidget {
  final String collabOrReport;
  final double id;
  CollabPage({Key key, this.collabOrReport, this.id});

  @override
  _CollabPageState createState() => _CollabPageState();
}

class _CollabPageState extends State<CollabPage> {
  final _formKey = GlobalKey<FormState>();
  var _collab;
  bool _isLoading = false;

  _submit() async {
    if (!_isLoading) {
      if (_formKey.currentState.validate()) {
        setState(() {
          _isLoading = true;
        });

        await CollabService().sendCollab(context,dni: PreferenciasUsuario().dni,sugerencia: _collab,idPregunta: 0);

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String aux;
    if (widget.collabOrReport == null) {
      setState(() {
        aux = 'colaborar';
      });
    } else
      aux = widget.collabOrReport.toLowerCase();

    var size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        appBar:
            AppBar(title: Text(aux.replaceFirst(aux[0], aux[0].toUpperCase()))),
        body: Stack(
          children: <Widget>[BackgroundWidget(), _collabPageBody(size, aux)],
        ),
      ),
    );
  }

  Widget _collabPageBody(Size size, String text) {
    return Form(
      key: _formKey,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: BorderedText(
                  strokeColor: Theme.of(context).primaryColor,
                  child: Text(
                    'Si desea $text en algo, por favor deje su propuesta en la caja de comentarios',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: size.width * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white.withOpacity(0.6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (String text) {
                      if (text.isEmpty) {
                        return 'Por favor completar el campo';
                      }
                      this._collab = text;
                      return null;
                    },
                    style: TextStyle(fontSize: 18),
                    maxLines: 7,
                    decoration: InputDecoration(
                      hintText: 'Comente aquí',
                    ),
                  ),
                ),
              ),
              SizedBox(height: 25),
              RaisedButton(
                child: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Enviar  ", style: TextStyle(fontSize: 20)),
                      Icon(Icons.mail_outline)
                    ],
                  ),
                ),
                onPressed: () {
                  _submit();
                  print(_collab);
                },
                color: Colors.green[900],
                textColor: Colors.white,
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
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
}
