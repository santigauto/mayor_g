//ESTA PAGINA MOSTRARA LA PREGUNTA, EL RELOJ, LA IMAGEN (OPCIONAL) Y LAS OPCIONES
import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class QuestionPage extends StatelessWidget {
  const QuestionPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Question Page'),
        ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
          ],
        ),
      ),
    );
  }
}