import 'package:mayor_g/models/question_model.dart';

class ArgumentosPreguntas {
  final ListaPreguntas preguntas;
  final int n;

  ArgumentosPreguntas({this.preguntas, this.n});
}

class ArgumentosResultado {
  final bool resultado;
  final int n;
  final ListaPreguntas preguntas;

  ArgumentosResultado({this.preguntas,this.n,this.resultado});
}