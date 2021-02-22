

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/filters/arma_service.dart';
import 'package:mayor_g/src/services/filters/curso_service.dart';
import 'package:mayor_g/src/services/filters/materia_service.dart';
import 'package:mayor_g/src/services/filters/organismo_service.dart';

import 'alert_opciones_widget.dart';

class FiltrosWidget extends StatefulWidget {

  @override
  _FiltrosWidgetState createState() => _FiltrosWidgetState();
}

class _FiltrosWidgetState extends State<FiltrosWidget> {
  final prefs = new PreferenciasUsuario();
  String selectedArma;
  String selectedMateria;
  String selectedColegio;
  String selectedCurso;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return _opciones(size);
  }

  Widget _opciones(Size size) {
    return Column(
      children: <Widget>[
        _getDropdown(
          size: size,
          title: 'Organismo',
          jsonFrac: 'colegios',
          selectedValues: selectedColegio,
          hint: prefs.colegio,
          future: OrganismoService().getAll(context, 'organismo'),
          onChanged: (value) {
            setState(() {
              selectedColegio = value;
              prefs.colegio = value;
            });
          },
        ),
        _getDropdown(
          size: size,
          title: 'Arma',
          jsonFrac: 'armas',
          selectedValues: selectedArma,
          hint: prefs.arma,
          future: ArmaService().getAll(context, 'arma'),
          onChanged: (value) {
            setState(() {
              selectedArma = value;
              prefs.arma = value;
            });
          },
        ),
        _getDropdown(
          size: size,
          title: 'Curso',
          jsonFrac: 'cursos',
          selectedValues: selectedCurso,
          hint: prefs.curso,
          future: CursoService().getAll(context, 'curso'),
          onChanged: (value) {
            setState(() {
              selectedCurso = value;
              prefs.curso = value;
            });
          },
        ),
        _getDropdown(
          size: size,
          title: 'Materia',
          jsonFrac: 'materias',
          selectedValues: selectedMateria,
          hint: prefs.materia,
          future: Materia2Service().getAll(context, 'materia'),
          onChanged: (value) {
            setState(() {
              selectedMateria = value;
              prefs.materia = value;
            });
          },
        ),
      ],
    );
  }

  Widget _getDropdown(
      {String title,
      String jsonFrac,
      Function onChanged,
      Size size,
      String selectedValues,
      String hint,
      Future future}) {
    int detalle = 0;
    if (title == 'Materia')
      detalle = 3;
    else if (title == 'Arma')
      detalle = 1;
    else if (title == 'Curso') detalle = 2;
    print(detalle);
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            width: size.width * 0.3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    right: BorderSide(
                                        color: Colors.black.withOpacity(0.4)))),
                            child: Center(
                                child: AutoSizeText(title,
                                    maxLines: 1,
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .fontSize,
                                        fontWeight: FontWeight.bold)))),
                        (snapshot.hasData)
                            ? Expanded(
                                child: Center(
                                    child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: AutoSizeText(
                                    hint,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )),
                              )
                            : CircularProgressIndicator(),
                        IconButton(
                          icon: Icon(Icons.list_rounded,color: Colors.white,), 
                          onPressed: () => showDialog(context: context, child: _showOpcionesDialog(_getItems(snapshot.data, hint, detalle), title))
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _showOpcionesDialog(List<Widget> listaOpciones, String title){
    return AlertaOpcionesWidget(
      title: title,
      children: listaOpciones,
    );
  }

  List<Widget> _getItems(data, String hint, int detalle) {
    List<Widget> lista = new List();

    if (data.isNotEmpty) {
      data.forEach((item) {
        lista.add(ListTile(
          contentPadding: EdgeInsets.all(0),
            onTap: () {
              switch (detalle) {
                case 0:
                  prefs.colegio = item.nombre;
                  break;
                case 1:
                  prefs.arma = item.nombre;
                  if (prefs.arma == 'General') {
                    prefs.curso = '';
                    prefs.materia = '';
                  }
                  break;
                case 2:
                  prefs.curso = item.nombre;
                  break;
                case 3:
                  prefs.materia = item.nombre;
                  break;
                default:
              }
              print(detalle);
              setState(() {});
              Navigator.pop(context);
            },
            title: Center(
                child: AutoSizeText(
                  item.nombre,
                  maxLines: 2,
                  style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize:
                          Theme.of(context).textTheme.headline6.fontSize),
                  textAlign: TextAlign.center,
                ))));
        lista.add(Divider(height: 1,));
      });
    }
    return lista;
  }
}