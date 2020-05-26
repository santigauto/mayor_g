import 'package:mayor_g/models/question_model.dart';

class ArgumentosPreguntas {
  final ListaPreguntas questions;
  final int n;

  ArgumentosPreguntas(this.questions, this.n);
}

class ArgumentosResultado {
  final bool resultado;
  final int n;
  final ListaPreguntas questions;

  ArgumentosResultado(this.resultado,this.n,this.questions);
}