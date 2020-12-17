import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:bordered_text/bordered_text.dart';

import 'package:mayor_g/src/services/commons/camara.dart';

import 'package:mayor_g/src/widgets/background_widget.dart';

import 'package:mayor_g/src/models/question_model.dart';
import 'package:mayor_g/src/widgets/myInput.dart';
import 'package:mayor_g/src/widgets/pulse_animator.dart';

class SuggestQuestionPage extends StatefulWidget {
  SuggestQuestionPage({Key key}) : super(key: key);

  @override
  _SuggestQuestionPageState createState() => _SuggestQuestionPageState();
}

class _SuggestQuestionPageState extends State<SuggestQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  TextStyle titleStyle;
  Camara camaraController = new Camara();
  int groupValue = 0;

  PreguntaNueva _pregunta = new PreguntaNueva();
  List<String> _correctas = ['','','','',''];
  List<String> _incorrectas = ['','','','',''];
  bool aux = true;
  int currentStep = 0;
  List<int> currentError = [10,20,10];
  @override
  Widget build(BuildContext context) {
    titleStyle = Theme.of(context).textTheme.headline6;
    return Container(
      child: Scaffold(
        appBar: AppBar(title: Text('Sugerir pregunta')),
        body: Stack(
          children: <Widget>[
            BackgroundWidget(),
            _suggestQuestionPageBody(),
          ],
        ),
      ),
    );
  }

  Widget _suggestQuestionPageBody() {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              Stepper(
                physics: ClampingScrollPhysics(),
                currentStep: currentStep,
                controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
                  return Container();},
                onStepTapped: (step){
                  setState(() {
                    currentStep = step;
                  });
                },
                type: StepperType.vertical,
                steps: [
                  Step(
                    state: (currentStep == 0 || aux ) ? StepState.indexed  : (0 == currentError[0])? StepState.error : StepState.complete ,
                    isActive: currentStep == 0,
                    title: (currentStep == 0) ? _titulo('Seleccione tipo de pregunta'): Container(), 
                    content: Column(children:_listaRadio(['Multiple Choice','Multiple Choice con Imagenes','Verdadero o Falso','Unir con Flechas']),),
                  ),
                  Step(
                    state: (currentStep == 1 || aux ) ? StepState.indexed  : ((1 == currentError[1])? StepState.error : StepState.complete ),
                    isActive: currentStep == 1,
                    title: (currentStep == 1) ?  _titulo('Pregunta o Encabezado'):  Container(), 
                    content: Column( children:
                      [_createQuestion(),
                      _pregunta.imagen == null || _pregunta.imagen.isEmpty ? Container() : Image.memory(
                        base64Decode(_pregunta.imagen), fit: BoxFit.cover,
                      ),
                      SizedBox(height: 25)
                      ]
                  )),
                  Step(
                    state: (currentStep == 2 || aux ) ? StepState.indexed  : ((2 == currentError[2])? StepState.error : StepState.complete ),
                    title: (currentStep == 2)?_titulo('Respuestas correctas'):Container(), content: _createCorrects(),isActive: currentStep == 2,),
                  Step(
                    state: (currentStep == 3 || aux ) ? StepState.indexed  : ((3 == currentError[3])? StepState.error : StepState.complete ),
                    title: (currentStep == 3)?_titulo('Respuestas Incorrectas'):Container(), content: _createIncorrects(),isActive: currentStep == 3,)
              ]),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: ListTile(
                      title: PulseAnimatorWidget(
                        begin:0.5,
                        child: AutoSizeText("Enviar", style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                      onTap: () => _submit(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

_titulo(String text){
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: BorderedText(
        strokeColor: Theme.of(context).primaryColor,
        child: Text(
          text,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
  );
}
  uploadImage()async{
    _pregunta.imagen = await camaraController.getImage();
    setState((){});
  }

 List<Widget> _listaRadio(List<String>listaOpciones){
   List<Widget> lista = [];
    int aux = 0;
    listaOpciones.forEach((element) {
      lista.add(RadioListTile(
        title: Text(listaOpciones[aux], style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
        value: aux, 
        groupValue: groupValue, 
        onChanged: (value){
          setState(() {
            groupValue = value;
          }); 
        }
      ));
      aux = aux+1;
    });
    
   return lista;
 }
  
  Column _createQuestion() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.6),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  maxLength: 250,
                  validator: (String text) {
                    if (text.isEmpty){
                      setState(() {
                        currentError[0] = 0;
                      });
                      return 'Por favor completar el campo';
                    }
                    setState(() {
                        currentError[0] = 3;
                      });
                    this._pregunta.pregunta = text;
                    return null;
                  },
                  style: TextStyle(fontSize: 18),
                  maxLines: 7,
                  decoration: InputDecoration(
                    labelText: 'Pregunta a sugerir',
                  ),
                ),
              ),
              Text('¿Desea agregar imagen?',style: TextStyle(color:Theme.of(context).primaryColor),),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: uploadImage,
                        color: Colors.white,
                        splashColor: Colors.grey,
                      ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createCorrects(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(
          'Debe ingresar al menos 1', maxLines: 2,
          style: TextStyle(color: Colors.white),
        ),
        Column(children:lista(this._correctas, 'correcta',1, true))
        
      ],
    );
  }

  List<Widget> lista( List listString, String label, int stepItem, bool isCorrect ){
    List<Widget> _lista =[];
    for (var i = 0; i < listString.length; i++) {
      _lista.add(SizedBox(height:12),);
      _lista.add(
        MyInput(
          label: '${i+1}° $label',
          validator: (String text) {
            if(text.isEmpty || (isCorrect && listString[0] == '')){
              setState(() {
                currentError[stepItem] = stepItem;
              });
              return "Por favor llene este campo";
            }
            setState(() {
                currentError[stepItem] = 10;
              });
            listString[i] = text;
            return null;
          },
        ),
      );
    }
    return _lista;
  }

  Widget _createIncorrects(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AutoSizeText(
          'Debe ingresar las 5. Estas deben ser alusivas a la pregunta',maxLines: 2,
          style: TextStyle(color: Colors.white),
        ),
        Column(children:lista(_incorrectas, 'incorrecta',2, false))
      ],
    );
  }

  _submit() async {
    if (!_isLoading) {
      if (_formKey.currentState.validate()) {
        print('hola');
        setState(() {
          aux = false;
          _isLoading = true;
        });
        await Future.delayed(Duration(seconds: 3));

        await _sended();
        setState(() {
          _isLoading = false;
        });
      } 
    }else{setState(() {
      print('object');
        
      });}
  }

  Future<void> _sended() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return AlertDialog(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.yellow)
          ),
          title: Text('¡Muchas gracias por su aporte!',textAlign: TextAlign.center,style: TextStyle(color: Colors.white),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 200,
                child: Image.asset('assets/capa53x.png')),
                RaisedButton(
                child: Text("Continuar", style: TextStyle(fontSize: 20)),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                splashColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.black),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}