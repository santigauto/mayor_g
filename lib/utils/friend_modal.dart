import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/models/profileInfo.dart';
import 'package:mayor_g/models/question_model.dart';
import 'package:mayor_g/services/commons/questions_service.dart';
import 'package:mayor_g/widgets/background_widget.dart';




//              ------------ MODAL -------------


class Modal{

  
  List<Map<String,dynamic>> gente = [   // AUXILIAR HARCODEADO(NO SE VAN A USAR) 
    {'nombre':'Carlos','grado':'VS'}, 
    {'nombre':'Raul','grado':'CT'}, 
    {'nombre':'Octavio','grado':'SG'}, 
    {'nombre':'Jose','grado':'TT'},
    {'nombre':'Ramon','grado':'VS'},
    {'nombre':'Oscar','grado':'VS'}, 
    {'nombre':'Miguel','grado':'CT'}, 
    {'nombre':'Pedro','grado':'SG'}, 
    {'nombre':'Uriel','grado':'TT'},];
  bool _isSelected = false;                                            // BANDERA QUE HABILITARA EL FOOTER DE SELECCION DE PERSONA
  Map<String,dynamic> _personaSeleccionada = {'nombre':'','grado':''}; // CONTENEDOR DEL MAPA DE PERSONA


//--- PATRON BLOC PARA MANEJO EN DIRECTO DE LOS WIDGETS DEL MODAL ---

  StreamController _controller = StreamController.broadcast();

    Function get streamSink => _controller.sink.add;

    Stream get streamStream => _controller.stream;

    void disposeStreams(){
      _controller.close();
    }
  


//---MAIN---
  mainBottomSheet (BuildContext context, ListaPreguntas preguntas){
    
//---AGREGO AL MAPA LA KEY BOOLEANA 'SELECCION'--- 
    gente.forEach((persona){
      persona.addAll({'seleccion':false});
    });
    double _height = MediaQuery.of(context).size.height*0.3;
    IconData _iconData = Icons.keyboard_arrow_up;
//---CUERPO DEL MODAL---
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return StreamBuilder<Object>(
          stream: streamStream,
          builder: (context, snapshot) {
            return Container(
              height: _height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(20) ,topLeft: Radius.circular(20) ,),
                color: Theme.of(context).primaryColor
              ),
              child: Stack(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Container(
                        child: ListTile(
                          title: Text('Amigos',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                          trailing: IconButton(icon: Icon(Icons.person_add,color: Colors.white,), onPressed: (){Navigator.popAndPushNamed(context, 'search');}),
                          leading: IconButton(icon: Icon(_iconData,color: Colors.white,), onPressed: (){
                            if(_height < MediaQuery.of(context).size.height){
                              _height = MediaQuery.of(context).size.height;
                              _iconData = Icons.keyboard_arrow_down;
                            }else{
                              _height = MediaQuery.of(context).size.height*0.3;
                              _iconData = Icons.keyboard_arrow_up;
                            }
                            streamSink(_personaSeleccionada);
                          }),
                        )
                        ),
                      Expanded(
                        child: Stack(
                          children: <Widget>[
                            BackgroundWidget(),
                            listItem(context, gente),
                          ],
                        ),
                      )
                    ],
                  ),
                _selecionado(context, preguntas)  
                ],
              ),
            );
          }
        );
      });
  }

//---WIDGET LISTA DE AMIGOS---
  Widget listItem(context, gente){
    return 
        ListView.builder(
          itemCount: gente.length,
          itemBuilder: (context, x){
            return _listItem(x);
          });
  }

//---WIDGETS ITEMS DE LA LISTA---
  Widget _listItem(int x){
    
    return Container(
      decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.5),
      border:BorderDirectional(bottom: BorderSide(color: Colors.black))),
      child: RadioListTile(
        controlAffinity: ListTileControlAffinity.trailing,
        groupValue: _personaSeleccionada,
        onChanged: (value){
          for(var i = 0; i < gente.length; i++ ){
                gente[i]['seleccion']=false;
              }
              gente[x]['seleccion']=true;
              _isSelected = gente[x]['seleccion'];
              _personaSeleccionada=gente[x];
              streamSink(_personaSeleccionada);
        },
        value: gente[x],
        title: Text(gente[x]['grado'] + ' ' + gente[x]['nombre']),
        selected: gente[x]['seleccion'],
      ),
    );
  }

//---WIDGET ITEM (AMIGO) SELECCIONADO---
Widget _selecionado(BuildContext context, ListaPreguntas preguntas){

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
                _personaSeleccionada['seleccion']=false;
                _personaSeleccionada={'nombre':'','grado':'','seleccion':false};
                streamSink(_personaSeleccionada);
                _isSelected=false;}
            ),
            title: Text(_personaSeleccionada['nombre'],textAlign: TextAlign.center,style: TextStyle(color:Colors.white),),
            trailing: IconButton(icon: Icon(Icons.check_circle), onPressed: ()async{
              //LLEVAR A PAGINA DE 'QUESTION' CON PARAMETROS CORRESPONDIENTES DE DUELO
              preguntas = await QuestionsService().getQuestions(context, dni: PreferenciasUsuario().dni);
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, 'question',arguments: {'n': 0,'questions': preguntas});
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