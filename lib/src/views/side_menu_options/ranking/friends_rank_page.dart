import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:mayor_g/src/widgets/background_widget.dart';

class FriendsRankPage extends StatelessWidget {

  final List<Map<String,dynamic>> gente = [{'nombre':'Raul','grado':'CT'}, {'nombre':'Octavio','grado':'SG'}, {'nombre':'Jose','grado':'TT'},{'nombre':'Santiago Tomas','grado':'VS'}];

  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:12.0),
              child: _people(context, gente)
            ),
          ],
        ),
      ),
    );
  }

Widget _people(BuildContext context, gente){

  return ListView.builder(
      itemCount: gente.length,
      itemBuilder: (context, x){
        return _person(x, context);
      });
}

Widget _person(int x, BuildContext context){

  Color color;

  switch (x) {
    case 0:
      color = Colors.amber[300];
      break;
    case 1:
      color = Colors.grey[300];
      break;
    case 2:
      color = Colors.orange[300];
      break;
    default: color = Theme.of(context).primaryColor;
  }

  return Column(
    children: <Widget>[
      Divider(),
      Container(
        decoration: BoxDecoration(
          color: (gente[x]['nombre'] == PreferenciasUsuario().nombre) ? Theme.of(context).primaryColor.withOpacity(0.7) : Color(0xFF838547).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15)
        ),
        child: ListTile(
          title: Text('${gente[x]['grado']} ${gente[x]['nombre']}', style: TextStyle(color: Colors.white),),
          leading: CircleAvatar(
            backgroundColor: color,
            child: Text('${x+1}°'),
          ),
        ),
      ),
      
    ],
  );
}
}
