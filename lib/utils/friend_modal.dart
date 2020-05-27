import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

//--- PATRON BLOC PARA MANEJO EN DIRECTO DE LOS WIDGETS DEL MODAL ---
class Bloc{
  StreamController _controller = StreamController.broadcast();

  Function get streamSink => _controller.sink.add;

  Stream get streamStream => _controller.stream;

  void disposeStreams(){
    _controller.close();
  }

}

//              ------------ MODAL -------------


class Modal{

  
  List<Map<String,dynamic>> gente = [   // AUXILIAR HARCODEADO(NO SE VAN A USAR) 
    {'nombre':'Carlos','grado':'VS'}, 
    {'nombre':'Raul','grado':'CT'}, 
    {'nombre':'Octavio','grado':'SG'}, 
    {'nombre':'Jose','grado':'TT'},
    {'nombre':'Carlos','grado':'VS'},
    {'nombre':'Carlos','grado':'VS'}, 
    {'nombre':'Raul','grado':'CT'}, 
    {'nombre':'Octavio','grado':'SG'}, 
    {'nombre':'Jose','grado':'TT'},];
  bool _isSelected = false;                                            // BANDERA QUE HABILITARA EL FOOTER DE SELECCION DE PERSONA
  Map<String,dynamic> _personaSeleccionada = {'nombre':'','grado':''}; // CONTENEDOR DEL MAPA DE PERSONA

  mainBottomSheet (BuildContext context){
    
//---AGREGO AL MAPA LA KEY BOOLEANA 'SELECCION'--- 
    gente.forEach((persona){
      persona.addAll({'seleccion':false});
    });

//---CUERPO DEL MODAL---
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height*0.5,
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
                      leading: IconButton(icon: Icon(Icons.keyboard_arrow_up,color: Colors.white,), onPressed: (){print(_personaSeleccionada);}),
                    )
                    ),
                  Expanded(
                    child: Container(
                      child: Stack(
                        children: <Widget>[
                          BackgroundWidget(),
                          listItem(context, gente),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            _selecionado(context)  
            ],
          ),
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
      child: ListTile(
        onTap: () {},
        title: Text(gente[x]['grado'] + ' ' + gente[x]['nombre']),
        leading: Icon(Icons.face),
        trailing: Checkbox(
          value: gente[x]['seleccion'], 
          onChanged: (boolean){
              for(var i = 0; i < gente.length; i++ ){
                gente[i]['seleccion']=false;
              }
              gente[x]['seleccion']=boolean;
              _isSelected = gente[x]['seleccion'];
              _personaSeleccionada=gente[x];
          },
          ),
      ),
    );
  }

//---WIDGET ITEM (AMIGO) SELECCIONADO---
Widget _selecionado(BuildContext context){

  if(_isSelected){
    return Column(
      children: <Widget>[
        Expanded(child: Container()),
        Container(
          color:Theme.of(context).primaryColor, 
          child: ListTile(
            leading: IconButton(icon: Icon(Icons.cancel), onPressed: null),
            title: Text(_personaSeleccionada['nombre'],textAlign: TextAlign.center,style: TextStyle(color:Colors.white),),
            trailing: IconButton(icon: Icon(Icons.check_circle), onPressed: (){}),
          )
        )
      ],
    );
  }else{
    return Container();
  }

}

}