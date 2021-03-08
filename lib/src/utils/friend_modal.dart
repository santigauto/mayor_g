import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/models/solicitudes_model.dart';
import 'package:mayor_g/src/services/commons/questions_service.dart';
import 'package:mayor_g/src/services/friends/friend_selector_service.dart';
import 'package:mayor_g/src/views/question_page.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';




//              ------------ MODAL -------------


class Modal{

  
  bool _isSelected = false;                                            // BANDERA QUE HABILITARA EL FOOTER DE SELECCION DE PERSONA
  Solicitud _personaSeleccionada; // CONTENEDOR DEL MAPA DE PERSONA


//--- PATRON BLOC PARA MANEJO EN DIRECTO DE LOS WIDGETS DEL MODAL ---

  StreamController _controller = StreamController.broadcast();

    Function get streamSink => _controller.sink.add;

    Stream get streamStream => _controller.stream;

    void disposeStreams(){
      _controller.close();
    }
  


//---MAIN---
  mainBottomSheet (BuildContext context, ListaPreguntasNuevas preguntas){
    
//---AGREGO AL MAPA LA KEY BOOLEANA 'SELECCION'---
  PreferenciasUsuario prefs = new PreferenciasUsuario();
    GetFriendsService service = new GetFriendsService();
    service.obtenerAmigos(context, dni: prefs.dni, deviceId: prefs.deviceId);

//---CUERPO DEL MODAL---
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (context){
        return StreamBuilder<Object>(
          stream: streamStream,
          builder: (context, snapshot) {
            return DraggableAnimatedModal(
              modalBody:Container(
                color: Colors.transparent,
                child: Stack(
                  children: [
                    BackgroundWidget(),
                    StreamBuilder(
                      stream: service.streamSolicitudes,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return list(context, snapshot.data);                          
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      }
                    ),
                    _selecionado(context, preguntas)
                  ],
                )
              ),
              trailing: IconButton(
                iconSize: 30,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                ),
                onPressed: ()=> Navigator.pop(context),
              ),
              leading: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                onPressed: () =>Navigator.popAndPushNamed(context, 'search', arguments: {'index':0})
              ),
              title: Text(
                'Amigos',
                style: TextStyle(color: Colors.white,fontSize: Theme.of(context).textTheme.headline6.fontSize),
              ),);
          }
        );});
  }

//---WIDGET LISTA DE AMIGOS---
  Widget list(context,List data){

    return(data.length != 0)
    ? ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, x){
          return _listItem(x, data);
      })
    : ListTile(title: Center(child: Text("Aún no tienes amigos en MayorG", style: TextStyle(color: Colors.white),)),);
  }

//---WIDGETS ITEMS DE LA LISTA---
  Widget _listItem(int x, List gente){
    
    return Container(
      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
      child: RadioListTile(
        controlAffinity: ListTileControlAffinity.trailing,
        groupValue: _personaSeleccionada,
        onChanged: (value){
          for(var i = 0; i < gente.length; i++ ){
            gente[i].seleccionado=false;
          }
          gente[x].seleccionado=true;
          _isSelected = gente[x].seleccionado;
          _personaSeleccionada=gente[x];
          streamSink(_personaSeleccionada);
        },
        value: gente[x],
        title: Text(gente[x].jugador),
        selected: gente[x].seleccionado,
      ),
    );
  }

//---WIDGET ITEM (AMIGO) SELECCIONADO---
Widget _selecionado(BuildContext context, ListaPreguntasNuevas preguntas){

  if(_isSelected){
    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        Container(
          color:Theme.of(context).primaryColor, 
          child: ListTile(
            leading: IconButton(
              icon: Icon(Icons.cancel), 
              onPressed: (){
                _personaSeleccionada.seleccionado=false;
                _personaSeleccionada=null;
                streamSink(_personaSeleccionada);
                _isSelected=false;}
            ),
            title: Text(_personaSeleccionada.jugador,textAlign: TextAlign.center,style: TextStyle(color:Colors.white),),
            trailing: IconButton(icon: Icon(Icons.check_circle), onPressed: ()async{
              //LLEVAR A PAGINA DE 'QUESTION' CON PARAMETROS CORRESPONDIENTES DE DUELO
              preguntas = await QuestionServicePrueba().getNewQuestions(context, cantidad: 5);
              Navigator.pop(context);
              var route = MaterialPageRoute(builder: (BuildContext context) => QuestionPage(n: 0,questions: preguntas,));
              Navigator.pushReplacement(context, route);
            }),
          )
        )
      ],
    );
  }else{
    return Container();
  }

}

}