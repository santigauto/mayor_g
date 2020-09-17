import 'package:mayor_g/src/models/question_model.dart';

class ArgumentosPreguntas {
  final ListaPreguntasNuevas questions;
  final int n;

  ArgumentosPreguntas(this.questions, this.n);
}

class ArgumentosResultado {
  final bool resultado;
  final int n;
  final ListaPreguntasNuevas questions;

  ArgumentosResultado(this.resultado,this.n,this.questions);
}