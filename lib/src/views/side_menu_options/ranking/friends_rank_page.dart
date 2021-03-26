import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/friends/friend_selector_service.dart';

import 'package:mayor_g/src/widgets/custom_widgets.dart';

class FriendsRankPage extends StatelessWidget {

  final GetFriendsService service = new GetFriendsService();
  final PreferenciasUsuario prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    service.obtenerAmigos(context, dni: prefs.dni, deviceId: prefs.deviceId);
    List amigos = [];
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:12.0),
              child: _people(context, amigos)
            ),
          ],
        ),
      ),
    );
  }

Widget _people(BuildContext context, List amigos){

  return StreamBuilder(
    stream: service.streamSolicitudes,
    builder: (context, snapshot) {
      print('amigos = ' + amigos.toString());

      if(snapshot.hasData){
        amigos= snapshot.data;
        return ListView.builder(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: amigos.length,
          itemBuilder: (context, x){
            return (amigos.length > 0) 
              ? _person(x, context, amigos)
              : ListTile(title: Center(child: Text("Aún no tienes amigos en MayorG", style: TextStyle(color: Colors.white),)),);
          });}
      else{
        return Center(child:CircularProgressIndicator());
      }

    }
  );
}

Widget _person(int x, BuildContext context, List amigos){

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
          color: (amigos[x].nickname == prefs.nickname || amigos[x].nickname == '${prefs.nombre} ${prefs.apellido}' ) ? Theme.of(context).primaryColor.withOpacity(0.7) : Color(0xFF838547).withOpacity(0.5),
          borderRadius: BorderRadius.circular(15)
        ),
        child: ListTile(
          title: Text('${amigos[x].nickname}', style: TextStyle(color: Colors.white),),
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
