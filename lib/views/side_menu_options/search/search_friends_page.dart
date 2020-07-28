import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mayor_g/models/profileInfo.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/services/commons/questions_service.dart';
import 'package:mayor_g/utils/search_delegate.dart';
import 'package:mayor_g/widgets/background_widget.dart';



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


  @override
  Widget build(BuildContext context) {

    BlocFriends bloc = new BlocFriends();
    ListaPreguntas preguntas;

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
                _playMatchButton(context, snapshot.data, preguntas),
                Positioned(
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.search), 
                    onPressed: (){
                      showSearch(context: context, delegate: DataSearch(gente));
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

  Widget _playMatchButton(BuildContext context, data, ListaPreguntas preguntas,){
    if (data != null){
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: ()async{
        //LLEVAR A PAGINA DE 'QUESTION' CON PARAMETROS CORRESPONDIENTES DE DUELO
        preguntas = await QuestionsService().getQuestions(context, dni: PreferenciasUsuario().dni);
        Navigator.pushReplacementNamed(context, 'question',arguments: {'n': 0,'questions': preguntas});
      }, 
      label: Text('¡Comenzar Duelo!'));
    }else return Container();
  }





}
