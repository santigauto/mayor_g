import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class CollabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Collab')),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal:20.0),
                  child: BorderedText(
                    strokeColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Si desea colaborar en algo, por favor deje su propueata en la caja de comentarios',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 25,),
                Container(
                  width: size.width*0.9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
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
            )
          ],
        ),
      ),
    );
  }
}
