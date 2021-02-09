import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/utils/search_delegate.dart';
import 'package:mayor_g/src/models/solicitudes_model.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/services/commons/friend_selector_service.dart';


class BlocSolicitudes{
  StreamController<Solicitud> _controller = StreamController.broadcast();

  Function get streamSink => _controller.sink.add;
  Stream<Solicitud> get streamStream => _controller.stream;
  void disposeStreams(){
    _controller.close();
  }
}

class SolicitudesPendientesPage extends StatelessWidget {
  final PreferenciasUsuario prefs = new PreferenciasUsuario();
  final BlocSolicitudes bloc = new BlocSolicitudes();
  @override
  Widget build(BuildContext context) {
    List<Solicitud> personas;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: size.width,
        height: 59,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              right: 10,
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).primaryColor,
                child: Icon(Icons.search),
                onPressed: () async {
                  showSearch(context: context, delegate: DataSearch(personas));
                }),
            ),
          ],
        ),
      ),
      body: Stack(children: <Widget>[
        BackgroundWidget(),
        StreamBuilder<Object>(
          stream: bloc.streamStream,
          builder: (context, snapshot) {
            return FutureBuilder(
              future: GetFriendsService()
                  .solicitudesPendientes(context, dni: prefs.dni, deviceId: prefs.deviceId),
              builder: (context, futureSnapshot) {
                if(futureSnapshot.hasData) personas = futureSnapshot.data;
                return (futureSnapshot.hasData)
                  ? _listItem(context, futureSnapshot.data, bloc, Theme.of(context).primaryColor, size)
                  : Center(child: CircularProgressIndicator());
              });
          }
        ),
      ]),
    );
  }



  Widget _listItem(BuildContext context,List data, bloc, Color color, Size size){
    return (data.length != 0)? ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, x){
        return _item(context,x, data, bloc, color, size);
      }): ListTile(title: Center(child: AutoSizeText("No hay solicitudes pendientes en este momento", maxLines: 1, style: TextStyle(color:Colors.white),)),);
  }
  Widget _item(BuildContext context, int posicion,List data, bloc, Color color, Size size){
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: ListTile(
        title: Row(
          children: [
            Container(
              width: size.width * 0.5,
              child: AutoSizeText('${data[posicion].jugador}', maxLines: 1, minFontSize: 15, overflow: TextOverflow.ellipsis,)),
            Expanded(child: Container()),
            Container(
              width: size.width * 0.15,
              child: FlatButton(
                color: color,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                onPressed: () {
                  GetFriendsService().aprobarSolicitud(context, idSolicitud: data[posicion].id, deviceId: prefs.deviceId,dni: prefs.dni);
                  data.removeAt(posicion);
                  bloc.streamSink(data[posicion].id);
                },
                child: Icon(Icons.thumb_up),
              ),
            ),
            SizedBox(width: 10,),
            Container(
              width: size.width * 0.15,
              child: FlatButton(
                color: color,
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                onPressed: () {
                  GetFriendsService().rechazarSolicitud(context, idSolicitud: data[posicion].id, dni: prefs.dni,deviceId: prefs.deviceId);
                  data.removeAt(posicion);
                  bloc.streamSink(data[posicion].id);
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
