import 'package:flutter/material.dart';
import 'package:mayor_g/utils/search_delegate.dart';
import 'package:mayor_g/widgets/background_widget.dart';


class SearchPeoplePage extends StatefulWidget {
  SearchPeoplePage({Key key}) : super(key: key);

  @override
  _SearchPeoplePageState createState() => _SearchPeoplePageState();
}

class _SearchPeoplePageState extends State<SearchPeoplePage> {
  List<Map<String,dynamic>> gente = [
    {'nombre': 'Mara'  ,'grado':'VP'}, 
    {'nombre':'Esteban','grado':'CT'}, 
    {'nombre': 'Juan'  ,'grado':'SP'}, 
    {'nombre': 'Roger' ,'grado':'TC'}, 
    {'nombre':'Rodrigo','grado':'CI'}];

@override
  void initState() {
    gente.forEach((persona){
      persona.addAll({'seleccion':false});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            ListView.builder(
              itemCount: gente.length,
              itemBuilder: (context, x){
                return _listItem(x);
              },
              //children: _listaAmigos(),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child:Icon(Icons.search), 
          onPressed: (){showSearch(context: context, delegate: DataSearch(gente));})
      ),
    );

  }
  Widget _listItem(int x){
    return Container(
      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
      child: ListTile(
        onTap: () {},
        title: Text(gente[x]['grado'] + ' ' + gente[x]['nombre']),
        leading: Icon(Icons.face),
        trailing: FlatButton(
          color: Theme.of(context).primaryColor,
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          onPressed: () {
            /*...*/
          },
          child: Text("Invitar",),
        ),
      ),
    );
  }


//void _funcion(){
 ///_isSelected = persona
//}

}