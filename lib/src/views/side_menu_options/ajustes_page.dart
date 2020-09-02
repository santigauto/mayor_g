import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';

Map<String,dynamic> jsonExample = {
  
    'armas':['General','Caballeria','Artilleria','Comunicaciones'],
    'colegios':['DEOP','EM Formosa', 'EM Mendoza'],
    'cursos':['1er Año','2do Año','3er Año','4to Año'],
    'materias':['matematias','fisica','quimica','historia','contabilidad']
  
};


class AjustesPartidaPage extends StatefulWidget {
  @override
  _AjustesPartidaPageState createState() => _AjustesPartidaPageState();
}

class _AjustesPartidaPageState extends State<AjustesPartidaPage> {

final prefs = new PreferenciasUsuario();
String selectedArma;
String selectedMateria;
String selectedColegio;
String selectedCurso;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; 
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes de Partida'),
      ),
      body: Stack(
        children: <Widget>[
          BackgroundWidget(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SafeArea(child:Container()),
                Row(
                  children: <Widget>[
                    Text('Filtros',style: TextStyle(fontSize:Theme.of(context).textTheme.headline4.fontSize, color: Colors.white, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                    Icon(Icons.tune, color: Colors.white,)
                  ],
                ),
                Text('Aquí podrá fitrar a su criterio las características de las preguntas', style: TextStyle(color:Colors.white),), 
                _opciones(size),
              ],
            ),
          )
        ],
      ),
    );
  }


Widget _opciones(Size size){
  return Column(
    children: <Widget>[
      Divider(color:Colors.white.withOpacity(0.2)),
      _getDropdown(
        size: size, title:'Arma', jsonFrac:'armas', selectedValues: selectedArma, hint: prefs.arma,
        onChanged: (value){
          setState(() {
            selectedArma = value;
            prefs.arma = value;
          });
        },
      ),
      _getDropdown(
        size: size, title:'Colegio', jsonFrac:'colegios', selectedValues: selectedColegio, hint: prefs.colegio,
        onChanged: (value){
          setState(() {
            selectedColegio = value;
            prefs.colegio = value;
          });
        },
      ),
      _getDropdown(
        size: size, title:'Curso', jsonFrac:'cursos', selectedValues: selectedCurso, hint: prefs.curso,
        onChanged: (value){
          setState(() {
            selectedCurso = value;
            prefs.curso = value;
          });
        },
      ),
      _getDropdown(
        size: size, title:'Materia', jsonFrac:'materias', selectedValues: selectedMateria, hint: prefs.arma,
        onChanged: (value){
          setState(() {
            selectedMateria = value;
            prefs.materia = value;  
          });
        },
      ),
      Divider(color:Colors.white.withOpacity(0.2)),
    ],
  );
}

Widget _getDropdown({String title, String jsonFrac, Function onChanged, Size size, String selectedValues, String hint }){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical:8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
        child: Container(
          color: Theme.of(context).primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical:20),
              width: size.width * 0.3,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color:Colors.black.withOpacity(0.4)))
              ),
              child: Center(child: Text(title,style: TextStyle(color: Theme.of(context).primaryColor, fontSize:Theme.of(context).textTheme.headline6.fontSize,fontWeight: FontWeight.bold) ))
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: DropdownButton(
                style: TextStyle(color:Colors.white),
                iconEnabledColor: Colors.white,
                hint: DropdownMenuItem(child: Text(hint, style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))),
                underline: Container(),
                dropdownColor: Theme.of(context).primaryColor,
                value: selectedValues,
                items: getItems(jsonFrac, hint),
                onChanged: onChanged
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

List<DropdownMenuItem<String>> getItems(String jsonFrac, String hint){
  List<DropdownMenuItem<String>> lista = new List();
  lista.add(
    DropdownMenuItem(child: Text(hint, style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.white))),
  );

  jsonExample[jsonFrac].forEach((item){
    lista.add(DropdownMenuItem(
      value: item,
      child: Center(child: Container(
        width: 200,
        child: Text(item, style: TextStyle(fontSize:Theme.of(context).textTheme.headline6.fontSize),textAlign: TextAlign.center,)))));
  });
return lista;
} 
}