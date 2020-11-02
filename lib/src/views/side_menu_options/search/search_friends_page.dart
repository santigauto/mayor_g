import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';

import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/services/commons/friend_selector_service.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart';
//import 'package:mayor_g/src/utils/search_delegate.dart';
import 'package:mayor_g/src/views/question_page.dart';

import 'package:mayor_g/src/widgets/background_widget.dart';



class BlocFriends{
  StreamController<Map<String,dynamic>> _controller = StreamController.broadcast();

  Function get streamSink => _controller.sink.add;
  Stream<Map<String,dynamic>> get streamStream => _controller.stream;
  void disposeStreams(){
    _controller.close();
  }
}

class FriendsPage extends StatelessWidget {
  final List<Map<String,dynamic>> gente = [
    {'nombre':'Carlos','grado':'VS'}, 
    {'nombre':'Raul','grado':'CT'}, 
    {'nombre':'Octavio','grado':'SG'}, 
    {'nombre':'Jose','grado':'TT'}
  ];
  final BlocFriends bloc = new BlocFriends();
  final PreferenciasUsuario prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {

    
    gente.forEach((persona){
      persona.addAll({'seleccion':false});
    });
    final size = MediaQuery.of(context).size;
    return StreamBuilder<Object>(
      stream: bloc.streamStream,
      builder: (context, snapshot) {
        return Scaffold(
          body: Stack(
            children: <Widget>[
              BackgroundWidget(),
              _listItem(context, snapshot.data, bloc),
            ]),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            width: size.width,
            height: 59,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                _playMatchButton(context, snapshot.data),
                Positioned(
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.search), 
                    onPressed: ()async{
                      //await GetFriendsService().registrarMilitar(context, dni: 41215183, password: 'asdasd', deviceId: prefs.deviceId, deviceName: prefs.deviceName, deviceVersion: prefs.deviceVersion, esMilitar: true);
                      //await GetFriendsService().registrarCivil(context,dni: 21796938, password: 'asdasd123123', deviceId: prefs.deviceId.toString(), deviceName: prefs.deviceName.toString(), deviceVersion: prefs.deviceVersion.toString(), nickname: 'Dieguito',mail: 'asd@gmail.com');
                      //await GetFriendsService().reportarFalla(context,dni: prefs.dni, deviceId: prefs.deviceId, descripcion: 'reporte', preguntaId: '05C7818D-617F-43C0-8A9F-AC20562EDCC1');
                      //await GetFriendsService().enviarAporte(dni: prefs.dni, deviceId: prefs.deviceId, texto: 'hola');
                      //await GetFriendsService().obtenerUsuarioDatos(datos: 'Gauto');
                      //print('ID ${prefs.deviceId} Name ${prefs.deviceName} Version${prefs.deviceVersion}');
                      //await GetFriendsService().generarUserDevice(context,dni: 41215183, deviceId: prefs.deviceId, deviceName: prefs.deviceName, deviceVersion: prefs.deviceVersion);
                      //await GetFriendsService().enviarSolicitud(dni: 34495248, dniAmigo: 41215183);
                      //await GetFriendsService().solicitudesPendientes(dni: 41215183);
                      //await GetFriendsService().rechazarSolicitud(idSolicitud: '777881a2-6a19-47f5-bb07-8c7d377b3133');
                      //await GetFriendsService().aprobarSolicitud(idSolicitud: '777881a2-6a19-47f5-bb07-8c7d377b3133');
                      await GetFriendsService().obtenerAmigos(context,dni: 41215183);
                      //await GetFriendsService().eliminarAmistad(dni: 41215183, dniAmigo: 34495248);
                      //await GetFriendsService().cambiarNick(dni: 41215183, deviceId: 'f14e204a6ee07d70', nickname: 'Santigol');
                      //showSearch(context: context, delegate: DataSearch(gente));
                      //await GetFriendsService().iniciarJuego(dni: prefs.dni, deviceId: prefs.deviceId);*
                    }),
                ),
              ],
            ),
          )
        );
      }
    );

  }
  Widget _listItem(BuildContext context,Map<String,dynamic> data, BlocFriends bloc){
    return ListView.builder(
      itemCount: gente.length,
      itemBuilder: (context, x){
        return _item(x, data, bloc);
      });
  }
  Widget _item(int x, Map<String,dynamic> data, bloc){
    return Container(
      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
      child: RadioListTile(
        controlAffinity: ListTileControlAffinity.trailing,
        value: gente[x],
        groupValue: data,
        onChanged: (value){
          for(var i = 0; i < gente.length; i++ ){gente[i]['seleccion']=false;}
          gente[x]['seleccion']=true;
          bloc.streamSink(gente[x]);
        },
        title: Text(gente[x]['grado'] + ' ' + gente[x]['nombre']),
        selected: gente[x]['seleccion'],
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
