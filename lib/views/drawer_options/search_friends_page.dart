import 'package:flutter/material.dart';
import 'package:mayor_g/utils/search_delegate.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String,dynamic>> gente = [{'nombre':'Carlos','grado':'VS'}, {'nombre':'Raul','grado':'CT'}, {'nombre':'Octavio','grado':'SG'}, {'nombre':'Jose','grado':'TT'}];
  bool _isSelected = false;

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
        appBar: AppBar(
          title: Text('Friends'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search), 
              onPressed: (){
                showSearch(context: context, delegate: DataSearch(gente));
              }),
          ],
          ),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              children: <Widget>[
                listItem(context, gente),
                NavigationToolbar(
                  leading: Icon(Icons.clear),
                ),
              ],
            )
              //children: _listaAmigos(), 
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _playMatchButton()
      ),
    );

  }
  Widget listItem(context, gente){
    return ListView.builder(
      itemCount: gente.length,
      itemBuilder: (context, x){
        return _listItem(x);
      });
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
        trailing: Checkbox(
          value: gente[x]['seleccion'], 
          onChanged: (boolean){
            setState(() {
              for(var i = 0; i < gente.length; i++ ){
                gente[i]['seleccion']=false;
              }
              gente[x]['seleccion']=boolean;
              _isSelected = gente[x]['seleccion'];
            });
        }),
      ),
    );
  }

  Widget _playMatchButton(){
    if (_isSelected){
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: (){
        //LLEVAR A PAGINA DE 'QUESTION' CON PARAMETROS CORRESPONDIENTES DE DUELO
        Navigator.popAndPushNamed(context, 'question');
      }, 
      label: Text('¡Comenzar Duelo!'));
    }else return Container();
  }


//void _funcion(){
 ///_isSelected = persona
//}

}
