
import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:mayor_g/src/services/friends/friend_selector_service.dart';

import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:mayor_g/src/utils/search_delegate.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';


class SolicitudesPendientesPage extends StatelessWidget {

  final PreferenciasUsuario prefs = new PreferenciasUsuario();

  @override
  Widget build(BuildContext context) {
    
    final GetFriendsService service = new GetFriendsService();
    service.solicitudesPendientes(context, dni: prefs.dni, deviceId: prefs.deviceId);

    List personas;
    Size size = MediaQuery.of(context).size;

    return Scaffold(

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(Icons.search),
        onPressed: () async {
          showSearch(context: context, delegate: DataSearch(personas));
      }),

      body: Stack(
        children: <Widget>[

          BackgroundWidget(),

          StreamBuilder<Object>(
            stream: service.streamSolicitudes,
            builder: (context, futureSnapshot) {
              if(futureSnapshot.hasData) personas = futureSnapshot.data;
              return (futureSnapshot.hasData)
                ? _listItem(context, futureSnapshot.data, Theme.of(context).primaryColor, size, service)
                : Center(child: CircularProgressIndicator());
          })

      ]),
    );
  }



  Widget _listItem(BuildContext context,List data, Color color, Size size, GetFriendsService service){
    return (data.length != 0)
      ? ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, x){
          return _item(context,x, data, color, size,service);
        })
      : ListTile(title: Center(child: AutoSizeText("No hay solicitudes pendientes en este momento", maxLines: 1, style: TextStyle(color:Colors.white),)),);
  }

  Widget _item(BuildContext context, int posicion,List data, Color color, Size size, GetFriendsService service){
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: size.width * 0.5,
              child: AutoSizeText('${data[posicion].jugador}', maxLines: 1, minFontSize: 15, overflow: TextOverflow.ellipsis,)),
            Expanded(child: Container()),
            Container(
              width: size.width * 0.15,
              child: MaterialButton(
                color: color,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                onPressed: () {
                  service.sinkSolicitudes([]);
                  service.aprobarSolicitud(context, idSolicitud: data[posicion].id, deviceId: prefs.deviceId,dni: prefs.dni);
                },
                child: Icon(Icons.thumb_up),
              ),
            ),
            SizedBox(width: 10,),
            Container(
              width: size.width * 0.15,
              child: MaterialButton(
                color: color,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                onPressed: () {
                  service.sinkSolicitudes([]);
                  service.rechazarSolicitud(context, idSolicitud: data[posicion].id, dni: prefs.dni,deviceId: prefs.deviceId);
                },
                child: Icon(Icons.thumb_down),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
