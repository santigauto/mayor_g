import 'dart:async';
import 'package:flutter/material.dart';

import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/models/solicitudes_model.dart';

import 'package:mayor_g/src/services/commons/friend_selector_service.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart';
import 'package:mayor_g/src/utils/search_delegate.dart';

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
                      showSearch(context: context, delegate: DataSearch(personas));
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
        return _item(context, x, data, bloc,streamSnapshot);
      }): ListTile(title: Center(child: Text("Aún no tienes amigos en MayorG", style: TextStyle(color: Colors.white),)),);
  }
  Widget _item(BuildContext context, int x,List<Solicitud> data, bloc, streamSnapshot){
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
        title: (data.isNotEmpty || data != [])
          ?Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data[x].jugador),
              /*TODO: cambiar el servicio de eliminar amistad (cambiar parametro dniAmigo por IdAmigo desde el backend)*/
              RaisedButton(onPressed: () async{
                await GetFriendsService().eliminarAmistad(context, dni: prefs.dni, dniAmigo: 44000111, deviceId: prefs.deviceId);
                bloc.streamSink(0);
                }
              )
            ]
          )
          : Container(),
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
