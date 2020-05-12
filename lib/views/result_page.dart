import 'dart:ui';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/views/drawer_options/collab_page.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class ResultPage extends StatefulWidget {
  final bool resultado;
  ResultPage({Key key, this.resultado}) : super(key: key);

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String imagen;
  @override
  void initState() {
    super.initState();
    if(widget.resultado){imagen = 'assets/mayorContento.gif';} 
    else imagen = 'assets/mayorEnojado.gif';
  }


Future<bool> _back(){
  return showDialog(
    context: context,
    builder: (context)=>AlertDialog(
        title: Text('Quieres realmente salir de Mayor G'),
        actions: <Widget>[
          FlatButton(
            onPressed: (){Navigator.pop(context,true);},
            child: Text('Salir')),
          FlatButton(
            onPressed: (){Navigator.pop(context,false);}, 
            child: Text('Cancelar'))
        ],
      )
    );
}

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
          onWillPop: _back,
          child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushReplacementNamed(context, 'question');
          },
          label: Text('Seguir'),
          icon: Icon(Icons.keyboard_arrow_right),
          ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: false, 
          actions: <Widget>[
            MaterialButton(
            child: Text('Salir',style: TextStyle(color: Colors.white),),
            onPressed: (){
              Navigator.pushReplacementNamed(context, '/');
            },
            ),
            Expanded(child: Container()),
            MaterialButton(
              child: Text('Reportar',style: TextStyle(color: Colors.white)),
              onPressed: (){
                var route = MaterialPageRoute(builder: (context){return CollabPage(collabOrReport: 'Reportar', id: 3);});
                Navigator.push(context, route);
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              children: <Widget>[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage(imagen)),
                    border: Border(bottom: BorderSide(color: Colors.black,width: 6))
                  ),
                ),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    //image: DecorationImage(image: AssetImage('assets/bgCopia6.png'),fit: BoxFit.fitWidth),
                    color: Theme.of(context).primaryColor.withOpacity(0.8),
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.black,width: 6)
                        )
                  ),
                  child: Center(
                    child: ListTile(
                      title: _resultadoText(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

Widget _resultadoText(){
 if (widget.resultado) {
   return  BorderedText(
        strokeColor: Colors.green,
        child: Text('¡Correcto!', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30,color: Colors.white)),
   );}
 else {
   return BorderedText(
        strokeColor: Colors.red,
        child: Text('Incorrecto', 
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 30,color: Colors.white),),
   );}
}

}