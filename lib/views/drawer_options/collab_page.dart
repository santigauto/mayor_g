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
  @override
  Widget build(BuildContext context) {
    
    String aux;
    if(widget.collabOrReport == null){
      setState(() {
      aux = 'colaborar';
      });
    }else aux = widget.collabOrReport.toLowerCase();

    var size = MediaQuery.of(context).size;

    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text(aux.replaceFirst(aux[0],aux[0].toUpperCase()))),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            _collabPageBody(size, aux)
          ],
        ),
      ),
    );
  }

Widget _collabPageBody(Size size, String text){
  return Center(
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:20.0),
            child: BorderedText(
              strokeColor: Theme.of(context).primaryColor,
              child: Text(
                'Si desea $text en algo, por favor deje su propueata en la caja de comentarios',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          SizedBox(height: 20,),
          Container(
            width: size.width*0.9,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withOpacity(0.6),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                style: TextStyle(fontSize: 18),
                maxLines: 7,
                decoration: InputDecoration(
                  hintText: 'Comente aquí',
                  ),
              ),
            ),
          ),
          SizedBox(height:25),
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
              CollabService().sendCollab(context,dni: PreferenciasUsuario().dni,sugerencia: 'hola',idPregunta: 0);
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
  );
}


}
