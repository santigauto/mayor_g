
import 'package:mayor_g/src/models/filters/curso_model.dart';
import 'package:mayor_g/src/services/commons/filter_service.dart';

class CursoService extends ServiceFiltros{
  CursoService();

  @override
  final apiRoute = 'api/Json/Obtener_Cursos';
  
  @override
  List getLista(_decodedData) {
    final listaCurso = ListaCurso.fromJsonList(_decodedData);
    return listaCurso.cursos;
  }
}