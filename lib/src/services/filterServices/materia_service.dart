
import 'package:mayor_g/src/models/filters/materia_model.dart';
import 'package:mayor_g/src/services/commons/filter_service.dart';



class Materia2Service extends ServiceFiltros{
  Materia2Service();

  @override
  final apiRoute = 'api/Json/Obtener_Materias';

  @override
  List getLista(_decodedData) {
    final listaMaterias = ListaMateria.fromJsonList(_decodedData);
    print(listaMaterias.materias[0].nombre);
    return listaMaterias.materias;
  }
}


