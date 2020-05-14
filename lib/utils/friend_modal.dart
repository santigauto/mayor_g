import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/widgets/background_widget.dart';

class Modal{

  List<Map<String,dynamic>> gente = [{'nombre':'Carlos','grado':'VS'}, {'nombre':'Raul','grado':'CT'}, {'nombre':'Octavio','grado':'SG'}, {'nombre':'Jose','grado':'TT'},{'nombre':'Carlos','grado':'VS'},{'nombre':'Carlos','grado':'VS'},];
  bool _isSelected = false;

  mainBottomSheet (BuildContext context){
    gente.forEach((persona){
      persona.addAll({'seleccion':false});
    });

    showModalBottomSheet(
      context: context, 
      builder: (context){
        return Container(
          height: MediaQuery.of(context).size.height*0.6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(topRight: Radius.circular(20) ,topLeft: Radius.circular(20) ,),
            color: Theme.of(context).primaryColor
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height*0.1,
                child: ListTile(
                  title: Text('Amigos',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
                )
                ),
              Container(
                color: Colors.blue,
                height: MediaQuery.of(context).size.height*0.462,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    BackgroundWidget(),
                    listItem(context, gente),
                  ],
                ),
              )
            ],
          ),
        );
      });
  }
  Widget listItem(context, gente){
    return 
        ListView.builder(
          itemCount: gente.length,
          itemBuilder: (context, x){
            return _listItem(x);
          });
  }

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
          onChanged: (boolean){},
          ),
      ),
    );
  }

}