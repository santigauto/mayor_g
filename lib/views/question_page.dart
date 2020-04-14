//ESTA PAGINA MOSTRARA LA PREGUNTA, EL RELOJ, LA IMAGEN (OPCIONAL) Y LAS OPCIONES


import 'package:flutter/material.dart';
import 'package:mayor_g/views/result_page.dart';
import 'package:mayor_g/widgets/background_widget.dart';
import 'package:mayor_g/widgets/timer_widget.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> with TickerProviderStateMixin{

AnimationController controller;
List<Map<String,dynamic>> respuestas = [
  {'respuesta':'Respuesta 1','bool':false}, 
  {'respuesta':'respuesta 2','bool':false}, 
  {'respuesta':'respuesta 3','bool':true}, 
  {'respuesta':'Respuesta 4','bool':false}];

String imagen = '';
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds:5)
      );
    controller.reverse(from: controller.value == 0 ? 1 : controller.value,);
    //print(controller.value);
   if(controller.value==0.0){
      print(controller.value);
     // var route = MaterialPageRoute(builder: (context) => ResultPage(resultado:false));
      //Navigator.push(context, route);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            Column(
              children: <Widget>[
                SafeArea(child: Container()),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: size.height*0.12,
                    child: TimerWidget(controller: controller)),
                ),
                Container(height: (imagen == '') ? size.height*0.3 : size.height*0.15,
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Center(child: Text(
                      'Pregunta',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 22),)),
                  ),
                ),
                _foto(size),
                Expanded(child: Container(padding: EdgeInsets.symmetric(horizontal: 5),
                child:Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: _respuestas(),
                ),
                ))
              ],
            )
            
          ],
        ),
      ),
    );
  }

  Widget _foto(Size size){
    if(imagen == '' || imagen == null){
      return Container();
    }else 
      return Container(
       height:  size.height*0.28,
       decoration: BoxDecoration(
         image: DecorationImage(image: AssetImage(imagen)),
         shape: BoxShape.rectangle
       ),
     );
  }

  List<Widget> _respuestas(){
    final List<Widget> answers = [];

    respuestas.forEach((resp){
      answers.add(
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            border: Border.all(color: Theme.of(context).primaryColor,width: 5)
          ),
          child: ListTile(
            onTap: (){
              var route = MaterialPageRoute(builder: (context) => ResultPage(resultado:resp['bool']));
              Navigator.push(context, route);},
            title: Text(resp['respuesta'],textAlign: TextAlign.center,),),
        ));
    });
    return answers;
  }
}