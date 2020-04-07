import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class NewMatchPage extends StatelessWidget {
  const NewMatchPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green[900],
          title: Text('New Match'),
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _initMatchButton(context),
                  SizedBox(
                    height: 20,
                  ),
                  _modoDeJuego(),
                  SizedBox(
                    height: 20,
                  ),
                  _seleccionOponente()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _initMatchButton(context) {
    return RaisedButton(
      child: Container(
        height: 200,
        width: 200,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage('assets/shape15.png'),
        )),
        child: Center(
            child: Text(
          '¡JUGAR!',
          style: TextStyle(fontSize: 35, color: Colors.white),
        )),
      ),
      onPressed: () {
        Navigator.pushNamed(context, 'question');
      },
      shape: CircleBorder(),
    );
  }

  Widget _modoDeJuego() {
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: BorderedText(
              strokeColor: Colors.white,
              child: Text(
                'Modo de Juego',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    decorationColor: Colors.white),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              child: Container(
                child: Text("CLÁSICO", style: TextStyle(fontSize: 20)),
              ),
              onPressed: () {},
              color: Colors.green[900],
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
            RaisedButton(
              child: Container(
                child: Text(" DUELO ", style: TextStyle(fontSize: 20)),
              ),
              onPressed: () {},
              color: Colors.green[900],
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _seleccionOponente() {
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: BorderedText(
              strokeColor: Colors.white,
              child: Text(
                'Oponente',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    decorationColor: Colors.white),
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              child: Container(
                child: Text("AMIGOS", style: TextStyle(fontSize: 20)),
              ),
              onPressed: () {},
              color: Colors.green[900],
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
            RaisedButton(
              child: Container(
                child: Text("AL AZAR", style: TextStyle(fontSize: 20)),
              ),
              onPressed: () {},
              color: Colors.green[900],
              textColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              splashColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(8.0),
                side: BorderSide(color: Colors.black),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
