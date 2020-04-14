import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({Key key}) : super(key: key);

  @override
  _NewMatchPageState createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> {

  bool _modoClasico = true;
  bool _modoDuelo = true;
  bool _selecOponente = false;
  bool _selecAlAzar = false;
  bool _canPlay = false;


  void _playAction(){
    if(_canPlay == true){
      setState(() {
        Navigator.pushNamed(context, 'question');
      });
  }
}




  @override
  Widget build(BuildContext context) {
  Color _noSeleccionado = Theme.of(context).primaryColor.withOpacity(0.2);
  Color _seleccionado = Theme.of(context).primaryColor;
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
                  _modoDeJuego(_seleccionado,_noSeleccionado),
                  SizedBox(
                    height: 20,
                  ),
                  _seleccionOponente(_seleccionado,_noSeleccionado)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _initMatchButton(context) {
    if (_canPlay){
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
      onPressed: _playAction,
      shape: CircleBorder(),
    );
    }else{
      return Container();
    }
  }

  Widget _modoDeJuego(Color colorSelec, Color colorNoSelec) {
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
              color: (_modoClasico) ? colorSelec : colorNoSelec,
              onPressed: () {
                  setState(() {
                _canPlay = true;
                _modoClasico = true;
                _modoDuelo = false;});
              },
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
              color: (_modoDuelo) ? colorSelec : colorNoSelec,
              onPressed: () {
                  setState(() {
                    _canPlay=false;
                _modoDuelo = true;
                _modoClasico=false;
                  });
              },
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

  Widget _seleccionOponente(Color colorSelec, Color colorNoSelec) {
    if(_modoDuelo && !_modoClasico){return Column(
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
              color: (_modoClasico == false) ? colorSelec : colorNoSelec,
              onPressed: () {
                setState(() {
                  _canPlay = true;
                });
              },
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
              color: (_modoClasico==false) ? colorSelec : colorNoSelec,
              onPressed: () {
                setState(() {
                  _canPlay = true;
                });
              },
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
  }else{
    return Container();
  }
}
}
/*
I hate this front faucking end xD
*/