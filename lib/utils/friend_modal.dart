import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Modal{

  List<Map<String,dynamic>> gente = [{'nombre':'Carlos','grado':'VS'}, {'nombre':'Raul','grado':'CT'}, {'nombre':'Octavio','grado':'SG'}, {'nombre':'Jose','grado':'TT'}];
  bool _isSelected = false;

  mainBottomSheet (BuildContext context){
    gente.forEach((persona){
      persona.addAll({'seleccion':false});
    });

    showModalBottomSheet(
      context: context, 
      builder: (context){
        return Scaffold(
          appBar: 
              AppBar(
                title: Text('amigos'),
              ),
          body: listItem(context, gente)
        );
      });
  }
  Widget listItem(context, gente){
    return ListView.builder(
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