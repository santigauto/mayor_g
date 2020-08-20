import 'package:flutter/material.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';



class DataSearch extends SearchDelegate{

List<Map<String,dynamic>> gente;

DataSearch(this.gente);

  @override
    String get searchFieldLabel => 'Buscar';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }
  
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: (){
          query = '';
        })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation), 
      onPressed: (){close(context, null);});
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _dataSuggested = (query.isEmpty) 
      ? gente 
      : gente.where( (data) => 
              data['nombre'].toLowerCase().startsWith(query.toLowerCase()) ).toList();
    return Stack(
      children: <Widget>[
        BackgroundWidget(),
        ListView.builder(
          itemCount: _dataSuggested.length,
          itemBuilder: (context, index){
            return Container(
              decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
              child: ListTile(
                leading: Icon(Icons.person),
                title: Text('${_dataSuggested[index]['grado']} ${_dataSuggested[index]['nombre']}'),
                onTap: (){},
              ),
            );
          }),
      ],
    );
  }

}