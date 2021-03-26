
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/persona_model.dart';

import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:mayor_g/src/services/friends/friend_selector_service.dart';

import 'package:mayor_g/src/utils/search_delegate.dart';

import 'package:mayor_g/src/widgets/custom_widgets.dart';


class FriendsPage extends StatelessWidget {

  final PreferenciasUsuario prefs = new PreferenciasUsuario();
  

  @override
  Widget build(BuildContext context) {

    final GetFriendsService service = new GetFriendsService();
    service.obtenerAmigos(context, dni: prefs.dni, deviceId: prefs.deviceId);

    List personas =[];
    //final size = MediaQuery.of(context).size;

    return Scaffold(
      //CUERPO
      body: Stack(
        children: <Widget>[
          BackgroundWidget(),
          StreamBuilder(
            stream: service.streamSolicitudes,
            builder: (context,streamSnapshot) {
              if(streamSnapshot.hasData){
                personas = streamSnapshot.data;
                return _listItem(context, streamSnapshot.data);
              }else{
                return Center(child: CircularProgressIndicator());
              }
            }
          )
        ]),
      //FLOATING BUTTON
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.search), 
        onPressed: ()async{
          showSearch(context: context, delegate: DataSearch(personas));
      })

    );

  }


  Widget _listItem(BuildContext context,List data){
    return(data.length != 0)
    ? ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, x){
          return _item(context, x, data);
      })
    : ListTile(title: Center(child: Text("Aún no tienes amigos en MayorG", style: TextStyle(color: Colors.white),)),);
  }


  Widget _item(BuildContext context, int x,List data){
    return Container(
      decoration: BoxDecoration(
      color: Colors.white,
      border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
      child: ListTile(
        title: (data.isNotEmpty || data != [])
          ?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data[x].nickname),
              IconButton(icon: Icon(Icons.more_vert_rounded), onPressed:()=> showDialog(context: context,builder:(_)=> _showAlertDialog(context, data, x)))
            ]
          )
          : Container(),
      ),
    );
  }

Widget _showAlertDialog(context, List listaAmigos, int indexAmigo){
  Persona user = listaAmigos[indexAmigo];
  return AlertaOpcionesWidget(
    title: user.nickname,
    children: [
      ListTile(
        title: Center(child: Text('Retar a Duelo')),
        onTap: null,
        //TODO: accion retar a duelo
      ),
      Divider(height: 1,),
      ListTile(
        title: Center(child: Text('Eliminar de Amigos')),
        onTap: (){
          GetFriendsService().eliminarAmistad(context, dni: prefs.dni, dniAmigo: user.dni, deviceId: prefs.deviceId);
          Navigator.pop(context);
        },
        /*TODO: cambiar el servicio de eliminar amistad (cambiar parametro dniAmigo por IdAmigo desde el backend)*/
      )
    ],
  );
}
}
