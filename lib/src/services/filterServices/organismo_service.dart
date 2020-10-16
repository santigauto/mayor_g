
import 'package:mayor_g/src/models/filters/organismo_model.dart';
import 'package:mayor_g/src/services/commons/filter_service.dart';

class OrganismoService extends ServiceFiltros{

  OrganismoService();

  @override
  final apiRoute = '/api/Json/Obtener_Organismos';

  @override
  List getLista(_decodedData) {
    final listaOrganismos = ListaOrganismo.fromJsonList(_decodedData);
    return listaOrganismos.organismos;
  }

}