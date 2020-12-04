import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/models/solicitudes_model.dart';
import 'package:mayor_g/src/services/commons/friend_selector_service.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart';
import 'package:mayor_g/src/utils/search_delegate.dart';
//import 'package:mayor_g/src/utils/search_delegate.dart';
import 'package:mayor_g/src/views/question_page.dart';

import 'package:mayor_g/src/widgets/background_widget.dart';



class BlocFriends{
  StreamController<Solicitud> _controller = StreamController.broadcast();

  Function get streamSink => _controller.sink.add;
  Stream<Solicitud> get streamStream => _controller.stream;
  void disposeStreams(){
    _controller.close();
  }
}

class FriendsPage extends StatelessWidget {
  final BlocFriends bloc = new BlocFriends();
  final PreferenciasUsuario prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    List<Solicitud> personas =[];
    final size = MediaQuery.of(context).size;
        return Scaffold(
          body: Stack(
            children: <Widget>[
              BackgroundWidget(),
              FutureBuilder(
                future: GetFriendsService().obtenerAmigos(context, dni: prefs.dni, deviceId: prefs.deviceId),
                builder: (context, futureSnapshot) {
                  if(futureSnapshot.hasData) personas = futureSnapshot.data;
                  return (futureSnapshot.hasData)
                      ? StreamBuilder<Object>(
                          stream: bloc.streamStream,
                          builder: (context, streamSnapshot) {
                            return _listItem(context, futureSnapshot.data, bloc, streamSnapshot.data);
                          }
                        )
                      : Center(child: CircularProgressIndicator());
                }
              ),
            ]),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            width: size.width,
            height: 59,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                StreamBuilder<Object>(
                  stream: bloc.streamStream,
                  builder: (context, streamSnapshot) {
                    return _playMatchButton(context, streamSnapshot.data);
                  }
                ),
                Positioned(
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.search), 
                    onPressed: ()async{
                      /* await GetFriendsService().sugerirPregunta(context,arma: 'General', organismo: 'General', verdaderoFalso: false,deviceId: prefs.deviceId,dni: prefs.dni,imagenPregunta: false,imagenRespuesta: false,nombreArchivoImagen: null,materia: null,curso: null,pregunta: '¿Que es esto?',
                       respuestas: ["una lata","una botella","un vaso","una copa"],respuestaCorrecta: 1,unirConFlechas: false,
                       imagen: null); */
                      //await GetFriendsService().registrarMilitar(context, dni: 41215183, password: 'asdasd', deviceId: prefs.deviceId, deviceName: prefs.deviceName, deviceVersion: prefs.deviceVersion, esMilitar: true);
                      //await GetFriendsService().registrarCivil(context,dni: 21796938, password: 'asdasd123123', deviceId: prefs.deviceId.toString(), deviceName: prefs.deviceName.toString(), deviceVersion: prefs.deviceVersion.toString(), nickname: 'Dieguito',mail: 'asd@gmail.com');
                      //await GetFriendsService().reportarFalla(context,dni: prefs.dni, deviceId: prefs.deviceId, descripcion: 'reporte', preguntaId: '05C7818D-617F-43C0-8A9F-AC20562EDCC1');
                      //await GetFriendsService().enviarAporte(dni: prefs.dni, deviceId: prefs.deviceId, texto: 'hola');
                      //await GetFriendsService().obtenerUsuarioDni(context, dni: 41215183, deviceId: prefs.deviceId,dniBusqueda: 41215183);
                      //print('ID ${prefs.deviceId} Name ${prefs.deviceName} Version${prefs.deviceVersion}');
                      //await GetFriendsService().generarUserDevice(context,dni: 41215183, deviceId: prefs.deviceId, deviceName: prefs.deviceName, deviceVersion: prefs.deviceVersion);
                      //await GetFriendsService().enviarSolicitud(dni: 34495248, dniAmigo: 41215183);
                      //await GetFriendsService().solicitudesPendientes(dni: 41215183);
                      //await GetFriendsService().rechazarSolicitud(idSolicitud: '777881a2-6a19-47f5-bb07-8c7d377b3133');
                      //await GetFriendsService().aprobarSolicitud(idSolicitud: '777881a2-6a19-47f5-bb07-8c7d377b3133');
                      //await GetFriendsService().obtenerAmigos(context,dni: 41215183);
                      //await GetFriendsService().eliminarAmistad(dni: 41215183, dniAmigo: 34495248);
                      //await GetFriendsService().cambiarNick(dni: 41215183, deviceId: prefs.deviceId, nickname: 'Santigol');
                      showSearch(context: context, delegate: DataSearch(personas));
                      //await GetFriendsService().iniciarJuego(dni: prefs.dni, deviceId: prefs.deviceId);*
                    }),
                ),
              ],
            ),
          )
        );

  }
  Widget _listItem(BuildContext context,List<Solicitud> data, BlocFriends bloc,streamSnapshot){
    return(data.length != 0)? ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, x){
        return _item(x, data, bloc,streamSnapshot);
      }): ListTile(title: Center(child: Text("Aún no tienes amigos en MayorG", style: TextStyle(color: Colors.white),)),);
  }
  Widget _item(int x,List<Solicitud> data, bloc, streamSnapshot){
    return Container(
      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
      child: RadioListTile(
        controlAffinity: ListTileControlAffinity.trailing,
        value: data[x],
        groupValue: (streamSnapshot != null)?streamSnapshot: "",
        onChanged: (value){
          for(var i = 0; i < data.length; i++ ){data[i].esSeleccionado=false;}
          data[x].esSeleccionado = true;
          bloc.streamSink(value);
        },
        title: (data.isNotEmpty || data != [])?Text(data[x].jugador): Container(),
        selected: data[x].esSeleccionado,
      ),
    );
  }

  Widget _playMatchButton(BuildContext context, data){
    if (data != null){
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: ()async{
        //LLEVAR A PAGINA DE 'QUESTION' CON PARAMETROS CORRESPONDIENTES DE DUELO
        ListaPreguntasNuevas preguntas = await QuestionServicePrueba().getNewQuestions(context, cantidad: 10);
        var route = new MaterialPageRoute(builder: (BuildContext context)=> QuestionPage(n: 0,questions: preguntas,));
        Navigator.pushReplacement(context, route);
      }, 
      label: Text('¡Comenzar Duelo!'));
    }else return Container();
  }





}
