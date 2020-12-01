import 'dart:async';

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
      body: Stack(
        children: [
          BackgroundWidget(),
          StreamBuilder<Object>(
              stream: bloc.streamStream,
              builder: (context, streamSnapshot) {
                return Scaffold(
                    body: Stack(children: <Widget>[
                      BackgroundWidget(),
                      FutureBuilder(
                          future: GetFriendsService()
                              .solicitudesPendientes(context, dni: prefs.dni, deviceId: 'f14e204a6ee07d70'),
                          builder: (context, futureSnapshot) {
                            if(futureSnapshot.hasData) personas = futureSnapshot.data;
                            return (futureSnapshot.hasData)
                                ? _listItem(context, futureSnapshot.data, bloc, Theme.of(context).primaryColor)
                                : Center(child: CircularProgressIndicator());
                          }),
                    ]),
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
                                  /* await GetFriendsService().sugerirPregunta(context,arma: 'General', organismo: 'General', verdaderoFalso: false,deviceId: prefs.deviceId,dni: prefs.dni,imagenPregunta: false,imagenRespuesta: false,nombreArchivoImagen: null,materia: null,curso: null,pregunta: '¿Que es esto?',
                       respuestas: ["una lata","una botella","un vaso","una copa"],respuestaCorrecta: 1,unirConFlechas: false,
                       imagen: null); */
                                  //await GetFriendsService().registrarMilitar(context, dni: 41215183, password: 'asdasd', deviceId: prefs.deviceId, deviceName: prefs.deviceName, deviceVersion: prefs.deviceVersion, esMilitar: true);
                                  //await GetFriendsService().registrarCivil(context,dni: 21796938, password: 'asdasd123123', deviceId: prefs.deviceId.toString(), deviceName: prefs.deviceName.toString(), deviceVersion: prefs.deviceVersion.toString(), nickname: 'Dieguito',mail: 'asd@gmail.com');
                                  //await GetFriendsService().reportarFalla(context,dni: prefs.dni, deviceId: prefs.deviceId, descripcion: 'reporte', preguntaId: '05C7818D-617F-43C0-8A9F-AC20562EDCC1');
                                  //await GetFriendsService().enviarAporte(dni: prefs.dni, deviceId: prefs.deviceId, texto: 'hola');
                                  //await GetFriendsService().obtenerUsuarioDni(context, dni: 41215183, deviceId: 'f14e204a6ee07d70',dniBusqueda: 41215183);
                                  //print('ID ${prefs.deviceId} Name ${prefs.deviceName} Version${prefs.deviceVersion}');
                                  //await GetFriendsService().generarUserDevice(context,dni: 41215183, deviceId: prefs.deviceId, deviceName: prefs.deviceName, deviceVersion: prefs.deviceVersion);
                                  //await GetFriendsService().enviarSolicitud(dni: 34495248, dniAmigo: 41215183);
                                  //await GetFriendsService().solicitudesPendientes(dni: 41215183);
                                  //await GetFriendsService().rechazarSolicitud(idSolicitud: '777881a2-6a19-47f5-bb07-8c7d377b3133');
                                  //await GetFriendsService().aprobarSolicitud(idSolicitud: '777881a2-6a19-47f5-bb07-8c7d377b3133');
                                  //await GetFriendsService().obtenerAmigos(context,dni: 41215183);
                                  //await GetFriendsService().eliminarAmistad(dni: 41215183, dniAmigo: 34495248);
                                  //await GetFriendsService().cambiarNick(dni: 41215183, deviceId: 'f14e204a6ee07d70', nickname: 'Santigol');
                                  showSearch(context: context, delegate: DataSearch(personas));
                                  //await GetFriendsService().iniciarJuego(dni: prefs.dni, deviceId: prefs.deviceId);*
                                }),
                          ),
                        ],
                      ),
                    ));
              })
        ],
      ),
    );
  }
  Widget _listItem(BuildContext context,List data, bloc, Color color){
    return (data.length != 0)? ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, x){
        return _item(context,x, data, bloc, color);
      }): ListTile(title: Center(child: Text("No hay solicitudes pendientes en este momento", style: TextStyle(color:Colors.white),)),);
  }
  Widget _item(BuildContext context, int posicion, data, bloc, Color color){
    return Container(
      color: Colors.white.withOpacity(0.5),
      child: ListTile(
        title: Row(
          children: [
            Text(data[posicion].jugador),
            Expanded(child: Container()),
            FlatButton(
              color: color,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              onPressed: () {
                GetFriendsService().aprobarSolicitud(context, idSolicitud: data[posicion].id, deviceId: 'f14e204a6ee07d70',dni: prefs.dni);
              },
              child: Text("Aceptar",),
            ),
            SizedBox(width: 10,),
            FlatButton(
              color: color,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              onPressed: () {
                GetFriendsService().rechazarSolicitud(context, idSolicitud: data[posicion].id, dni: prefs.dni,deviceId: 'f14e204a6ee07d70');
                bloc.streamSink(data[posicion].id);
              },
              child: Text("Rechazar",),
            ),
          ],
        ),
      ),
    );
  }
}
