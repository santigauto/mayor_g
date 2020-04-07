import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  List<Map<String,dynamic>> gente = [{'nombre':'Carlos','grado':'VS'}, {'nombre':'Raul','grado':'CT'}, {'nombre':'Octavio','grado':'SG'}, {'nombre':'Jose','grado':'TT'}];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Friends')),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            ListView(
              children: _listaAmigos(),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: (){}, 
          label: Text('¡Comenzar Duelo!')),
      ),
    );

  }
    List<Widget> _listaAmigos() {
      final List<Widget> lista = [];

      gente.forEach((persona) {
        lista.add(Container(
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              border:
                  BorderDirectional(bottom: BorderSide(color: Colors.black))),
          child: ListTile(
            onTap: () {},
            title: Text(persona['grado'] + ' ' + persona['nombre']),
            leading: Icon(Icons.face),
            trailing: Container(
              height: 25,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: FlatButton(
                onPressed: null,
                child:
                    Text('Seleccionar', style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          )
        );
      });
      return lista;
    }
}
