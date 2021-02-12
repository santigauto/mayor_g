
import 'package:mayor_g/src/models/filters/arma_model.dart';
import 'package:mayor_g/src/services/commons/filter_service.dart';

class ArmaService extends ServiceFiltros{

  ArmaService();

  @override
  final apiRoute = '/api/Json/Obtener_Armas';

  @override
  List getLista(_decodedData) {
    final listaArmas = ListaArma.fromJsonList(_decodedData);
    return listaArmas.listaArma;
  }
}