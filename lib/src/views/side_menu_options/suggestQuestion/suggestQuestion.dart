//TODO: fijar el esquema de sugerencias a los inputfields para pasar al post

import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/models/suggest_model.dart';


import 'package:mayor_g/src/services/commons/camara.dart';


import 'package:mayor_g/src/widgets/myInput.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';
import 'package:mayor_g/src/widgets/pulse_animator.dart';

class SuggestQuestionPage extends StatefulWidget {
  SuggestQuestionPage({Key key}) : super(key: key);

  @override
  _SuggestQuestionPageState createState() => _SuggestQuestionPageState();
}

class _SuggestQuestionPageState extends State<SuggestQuestionPage> {

  final _formKey = GlobalKey<FormState>();
  PreferenciasUsuario prefs = PreferenciasUsuario();
  Sugerencia sugerencia = new Sugerencia(
    sugerencia: SugerenciaClass(
      pregunta: "",
      imagen: "",
      respuestasCorrectas: ["","","",""],
      respuestasIncorrectas: ["","","",""],
      unirConFlechas: false,
      verdaderoFalso: false,
    )
  );
  
  var i = 0;
  bool _isLoading = false;
  TextStyle titleStyle;
  Camara camaraController = new Camara();
  int groupValue = 0;
  Size size;

  TextEditingController textPreguntaController;

  bool aux = true;
  int currentStep = 0;
  bool complete = false;
  List<int> currentError = [10,10,10,10];

  next(){
    goTo(currentStep + 1);
  }
  goTo(int step){
    setState(() {
      currentStep = step;
      if (currentStep == 3) complete = true;
      else complete = false;
    });
  }
  cancel(){
    if(currentStep > 0){
      goTo(currentStep -1);
    }
  }
  setSelectedRadio(int val){
    sugerencia = new Sugerencia(
      sugerencia: SugerenciaClass(
        pregunta: "",
        imagen: "",
        respuestasCorrectas: ["","","","",],
        respuestasIncorrectas: ["","","","",],
        unirConFlechas: false,
        verdaderoFalso: false,
      )
    );
    switch (val) {
      case 2:
        sugerencia.sugerencia.unirConFlechas = false;
        sugerencia.sugerencia.verdaderoFalso = true;
        break;
      case 3:
        sugerencia.sugerencia.unirConFlechas = true;
        sugerencia.sugerencia.verdaderoFalso = false;
        break;
      default:
        sugerencia.sugerencia.unirConFlechas = false;
        sugerencia.sugerencia.verdaderoFalso = false;
    }
    setState(() {
      groupValue = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    sugerencia.dni = prefs.dni;
    size = MediaQuery.of(context).size;
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
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            Expanded(
              child: Stepper(
                physics: ClampingScrollPhysics(),
                currentStep: currentStep,
                onStepCancel: cancel,
                onStepContinue: next,
                controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
                  return  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
                        currentStep != 0 ?Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 200,
                              color: Theme.of(context).primaryColor,
                                child: ListTile(
                                  title: AutoSizeText("Atrás", maxLines: 1,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                  onTap: onStepCancel,
                              ),
                            ),
                          ),
                        ): Container(),
                        SizedBox(width: 10,),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              width: 200,
                              color: Theme.of(context).primaryColor,
                              child: !complete 
                              ?ListTile(
                                title: AutoSizeText("Continuar", maxLines: 1,style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                                onTap: onStepContinue,
                              )
                              :ListTile(
                                title: PulseAnimatorWidget(
                                  begin:0.5,
                                  child: AutoSizeText("Enviar", style: Theme.of(context).textTheme.headline5.copyWith(color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,)),
                                onTap: () => _submit(),
                              ),
                          ),
                        ),)
                      ],
                    ));
                  },
                onStepTapped: (step)=> goTo(step),
                type: StepperType.horizontal,
                steps: [
                  Step(
                    state: (0 == currentError[0]) ? StepState.error : (currentStep == 0 || aux ) ? StepState.indexed  :  StepState.complete ,
                    isActive: currentStep == 0,
                    title: (currentStep == 0) ? _titulo('Tipo de pregunta'): Container(), 
                    content: Column(children:_listaRadio(['Multiple Choice','Multiple Choice con Imagenes','Verdadero o Falso','Unir con Flechas']),),
                  ),
                  Step(
                    state: (currentStep == 1 || aux ) ? StepState.indexed  : ((1 == currentError[1])? StepState.error : StepState.complete ),
                    isActive: currentStep == 1,
                    title: (currentStep == 1) ?  _titulo('Pregunta o Encabezado'):  Container(), 
                    content: _createQuestion(),
                  ),
                  Step(
                    state: (currentStep == 2 || aux ) ? StepState.indexed  : ((2 == currentError[2])? StepState.error : StepState.complete ),
                    title: (currentStep == 2)?_titulo('Respuestas correctas'):Container(), content: _createCorrects(sugerencia.sugerencia.respuestasCorrectas),isActive: currentStep == 2,),
                  Step(
                    state: (currentStep == 3 || aux ) ? StepState.indexed  : ((3 == currentError[3])? StepState.error : StepState.complete ),
                    title: (currentStep == 3)?_titulo('Respuestas Incorrectas'):Container(), content: _createIncorrects(sugerencia.sugerencia.respuestasIncorrectas),isActive: currentStep == 3,)
              ]),
            ),
          ],
        ),
      ),
    );
  }

  _imagenEncabezado(){
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            width: size.width * 0.5,
            child: Image.memory(
              base64Decode(sugerencia.sugerencia.imagen), fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

_titulo(String text){
  return AutoSizeText(
    text,
    maxLines: 1,
    style: TextStyle(fontSize: 13, color: Colors.white),
  );
}
  uploadImage()async{
    sugerencia.sugerencia.imagen = await camaraController.getImage();
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
          setSelectedRadio(value);
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
          padding: EdgeInsets.all(10),
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
                  controller: textPreguntaController,
                  onChanged: (text){
                    sugerencia.sugerencia.pregunta = text;
                  },
                  initialValue: sugerencia.sugerencia.pregunta,
                  maxLength: 250,
                  validator: (String text) {
                    if (textPreguntaController.text.isEmpty){
                      setState(() {
                        currentError[0] = 0;
                      });
                      return 'Por favor completar el campo';
                    }
                    setState(() {
                        currentError[0] = 3;
                      });
                    this.sugerencia.sugerencia.pregunta = text;
                    return null;
                  },
                  style: TextStyle(fontSize: 18),
                  maxLines: 7,
                  decoration: InputDecoration(
                    labelText: 'Pregunta a sugerir',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical:8.0),
                child: sugerencia.sugerencia.imagen == null || sugerencia.sugerencia.imagen.isEmpty ? Text('¿Desea agregar imagen?',style: TextStyle(color:Theme.of(context).primaryColor),):Container(),
              ),
              Stack(
                children: [
                  sugerencia.sugerencia.imagen == null || sugerencia.sugerencia.imagen.isEmpty ? Container() : _imagenEncabezado(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
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
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _createCorrects(List listaCorrectas){
    
    switch (groupValue) {
      case 0:   //multiple choice
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              'Debe ingresar al menos 1', maxLines: 2,
              style: TextStyle(color: Colors.white),
            ),
            Column(children:lista(listaCorrectas, 'correcta',1, true))
          ],
        );
        break;
      case 1: //multiple choice con imagenes
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoSizeText(
              '*Debe ingresar al menos 1', maxLines: 2,
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    color: Colors.white,
                    child: Center(
                      child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: uploadImage,
                          color: Colors.grey,
                          splashColor: Colors.grey,
                        ),
                    )
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    color: Colors.white,
                    child: Center(
                      child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: uploadImage,
                          color: Colors.grey,
                          splashColor: Colors.grey,
                        ),
                    )
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    color: Colors.white,
                    child: Center(
                      child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: uploadImage,
                          color: Colors.grey,
                          splashColor: Colors.grey,
                        ),
                    )
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                    color: Colors.white,
                    child: Center(
                      child: IconButton(
                          icon: Icon(Icons.camera_alt),
                          onPressed: uploadImage,
                          color: Colors.grey,
                          splashColor: Colors.grey,
                        ),
                    )
                  ),
                ),
              ],
            )
          ],
        );
      case 2:
        return Column(
          children: [
            RadioListTile(
              title: Text("Verdadero"),
              value: 0, 
              groupValue: i, 
              onChanged: (value){
                setState(() => i = value);
                sugerencia.sugerencia.respuestasCorrectas[0] = "true";
              }),
            RadioListTile(
              title: Text("Falso"),
              value: 1, 
              groupValue: i, 
              onChanged: (value){
                setState(() => i = value);
                sugerencia.sugerencia.respuestasCorrectas[0] = "false";
              }
              ),
          ],
        );
      case 3:
        return Column(children: _listaUnir(sugerencia.sugerencia.respuestasCorrectas, sugerencia.sugerencia.respuestasIncorrectas));
      default:
        return Container(child: Text('data'),width: 100,height: 100, color: Colors.blue,);
    }
    
  }

  List<Widget>_listaUnir(List listaRespuestas, listaRespuestasDos){
    List<Widget> lista = new List<Widget>();
    for (var i = 0; i < listaRespuestas.length; i++) {
      lista.add(Row(
        children: [
          Expanded(
            child: Material(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:15, vertical: 10),
                  height: size.height*0.1,
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: TextField(
                      maxLines: 2,
                      maxLength: 35,
                      decoration: InputDecoration.collapsed(hintText: null),
                      onChanged:(value) => listaRespuestas[i] = value
                    )
                    ),
                )
              ),
            ),
          ),
          Expanded(
            child: Material(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal:15, vertical: 10),
                  height: size.height*0.1,
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: TextField(
                      maxLines: 2,
                      maxLength: 35,
                      decoration: InputDecoration.collapsed(hintText: null),
                      onChanged:(value) => listaRespuestas[i] = value
                    )
                    ),
                )
              ),
            ),
          ),
        ],
      ));
    lista.add(SizedBox(height: 10,));
    }
    return lista;
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

  Widget _createIncorrects(List listaIcorrectas){
    switch (groupValue) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AutoSizeText(
              'Debe ingresar las 5. Estas deben ser alusivas a la pregunta',maxLines: 2,
              style: TextStyle(color: Colors.white),
            ),
            Column(children:lista(listaIcorrectas, 'incorrecta',2, false))
          ],
        );
        break;
      case 1: 
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  color: Colors.white,
                  child: Center(
                    child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: uploadImage,
                        color: Colors.grey,
                        splashColor: Colors.grey,
                      ),
                  )
                ),
                Container(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  color: Colors.white,
                  child: Center(
                    child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: uploadImage,
                        color: Colors.grey,
                        splashColor: Colors.grey,
                      ),
                  )
                ),
            ],
          ),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  color: Colors.white,
                  child: Center(
                    child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: uploadImage,
                        color: Colors.grey,
                        splashColor: Colors.grey,
                      ),
                  )
                ),
                Container(
                  width: size.width * 0.4,
                  height: size.width * 0.4,
                  color: Colors.white,
                  child: Center(
                    child: IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: uploadImage,
                        color: Colors.grey,
                        splashColor: Colors.grey,
                      ),
                  )
                ),
            ],
          )
        ],
      );
      break;
      default: return Container();
    }
    
  }

  _submit() async {
    if (!_isLoading) {
      if (_formKey.currentState.validate()) {
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