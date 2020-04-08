import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          leading: MaterialButton(
            child: Text('Volver al Menu'),
            onPressed: (){},
            ),
          actions: <Widget>[
            MaterialButton(
              child: Text('Reportar'),
              onPressed: (){},
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              children: <Widget>[
                Image.asset(imagen)
              ],
            ),
          ],
        ),
      ),
    );
  }
}