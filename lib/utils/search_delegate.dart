import 'package:flutter/material.dart';



class DataSearch extends SearchDelegate{

List<Map<String,dynamic>> gente = [
  {'nombre':'Carlos','grado':'VS'}, 
  {'nombre':'Raul','grado':'CT'}, 
  {'nombre':'Octavio','grado':'SG'}, 
  {'nombre':'Jose','grado':'TT'}];

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
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final _dataSuggested = (query.isEmpty) 
      ? gente 
      : gente.where( (data) => 
              data['nombre'].toLowerCase().startsWith(query.toLowerCase()) ).toList();
    return ListView.builder(
      itemCount: _dataSuggested.length,
      itemBuilder: (context, index){
        return ListTile(
          leading: Icon(Icons.person),
          title: Text('${_dataSuggested[index]['grado']} ${_dataSuggested[index]['nombre']}'),
        );
      });
  }

}