//TODO: fijar el esquema de sugerencias a los inputfields para pasar al post


import 'dart:convert';
import 'package:flutter/material.dart';

//paquetes de 3ros
import 'package:auto_size_text/auto_size_text.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/models/suggest_model.dart';

//servicios
import 'package:mayor_g/src/services/commons/camara.dart';

import 'package:mayor_g/src/widgets/custom_widgets.dart';

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
      respuestaCorrecta: 0,
      respuestas: ["","","",""],
      unirConFlechas: false,
      verdaderoFalso: false,
    )
  );

  String auxArma;
  String auxMateria;
  String auxColegio;
  String auxCurso;

  var i = 0;
  bool _isLoading = false;
  TextStyle titleStyle;
  
  Camara camaraController = new Camara();
  Camara camaraRespuesta1Controller = new Camara();
  Camara camaraRespuesta2Controller = new Camara();
  Camara camaraRespuesta3Controller = new Camara();
  Camara camaraRespuesta4Controller = new Camara();
  int groupValue = 0;
  Size size;

  TextEditingController textPreguntaController;

  bool aux = true;
  int currentStep = 0;
  bool complete = false;
  bool completed = true;
  List<int> currentError = [10,10];


  next(){
    goTo(currentStep + 1);
  }
  goTo(int step){
    setState(() {
      currentStep = step;
      if (currentStep == 2) complete = true;
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
        respuestaCorrecta: 0,
        respuestas: ["","","",""],
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

    _back(){
    if(currentStep != 0){
      cancel();
    }
    else Navigator.pop(context);
    }
    auxArma = prefs.arma;
    auxMateria = prefs.materia;
    auxColegio = prefs.colegio;
    auxCurso = prefs.curso;

    sugerencia.sugerencia.arma = prefs.arma;
    sugerencia.sugerencia.curso = prefs.curso;
    sugerencia.sugerencia.materia = prefs.materia;
    sugerencia.sugerencia.organismo = prefs.colegio;

    sugerencia.dni = prefs.dni;
    size = MediaQuery.of(context).size;
    titleStyle = Theme.of(context).textTheme.headline6;

    return WillPopScope(
      onWillPop: _back,
      child: Container(
        child: Scaffold(
          appBar: AppBar(title: Text('Sugerir pregunta')),
          body: Stack(
            children: <Widget>[
              BackgroundWidget(),
              _suggestQuestionPageBody(),
            ],
          ),
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
                type: StepperType.horizontal,
                physics: BouncingScrollPhysics(),
                currentStep: currentStep,
                onStepTapped: (step)=> goTo(step),
                onStepCancel: cancel,
                onStepContinue: next,
                controlsBuilder: (BuildContext context, { VoidCallback onStepContinue, VoidCallback onStepCancel }) {
                  return  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: [
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
                steps: [
                  Step(
                    state: (currentStep == 0) ? StepState.indexed  :  StepState.complete ,
                    isActive: currentStep == 0,
                    title: (currentStep == 0) ? _titulo('Filtros'): Container(), 
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[
                        Text('Seleccione la especialidad a la que pertenece esta pregunta',style: TextStyle(color: Colors.white),maxLines: 2,),
                        FiltrosWidget(),]),
                  ),
                  Step(
                    state: (currentStep <= 1 ) ? StepState.indexed  :  StepState.complete ,
                    isActive: currentStep == 1,
                    title: (currentStep == 1) ? _titulo('Tipo de pregunta'): Container(), 
                    content: Column(children:_listaRadio(['Multiple Choice','Multiple Choice con Imagenes','Verdadero o Falso','Unir con Flechas']),),
                  ),
                  Step(
                    state: (currentStep <= 2 ) ? StepState.indexed  : ((2 == currentError[2])? StepState.error : StepState.complete ),
                    isActive: currentStep == 2,
                    title: (currentStep == 2) ?  _titulo('Fábrica'):  Container(), 
                    content: Column(
                      children: [
                        _createQuestion(),
                        _createAnswers(),
                      ],
                    ),
                  ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagenEncabezado(String image){
    print(image);
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Container(
          width: size.width * 0.5,
          child: Image.memory(
            base64Decode(image), fit: BoxFit.cover,
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

 uploadImage(int i)async{
    switch (i) {
      case 0:
        sugerencia.sugerencia.imagen = await camaraController.getImage();
        break;
      case 1:
        sugerencia.sugerencia.respuestas[0] = await camaraRespuesta1Controller.getImage();
        break;
      case 2:
        sugerencia.sugerencia.respuestas[1] = await camaraRespuesta2Controller.getImage();
        break;
      case 3:
        sugerencia.sugerencia.respuestas[2] = await camaraRespuesta3Controller.getImage();
        break;
      case 4:
        sugerencia.sugerencia.respuestas[3] = await camaraRespuesta4Controller.getImage();
        break;
    }
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
            color: Colors.grey[100],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: size.height * 0.2,
                child: TextFormField(
                  controller: textPreguntaController,
                  onChanged: (text){
                    sugerencia.sugerencia.pregunta = text;
                  },
                  initialValue: sugerencia.sugerencia.pregunta,
                  maxLength: 100,
                  validator: (String text) {
                    if (text.isEmpty || text == null){
                      setState(() {
                        currentError[0] = 0;
                      });
                      return 'Por favor completar el campo';
                    } else if(text.length > 101){
                      setState(() {
                        currentError[0] = 0;
                      });
                      return 'Mucho texto';
                    }
                    setState(() {
                        currentError[0] = 3;
                      });
                    this.sugerencia.sugerencia.pregunta = text;
                    return null;
                  },
                  style: TextStyle(fontSize: 18,color: Colors.grey[700]),
                  maxLines: 7,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(color:Colors.grey),
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
                  sugerencia.sugerencia.imagen == null || sugerencia.sugerencia.imagen.isEmpty || sugerencia.sugerencia.imagen == "" ? Container() : _imagenEncabezado(sugerencia.sugerencia.imagen),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                          child: IconButton(
                            icon: Icon(Icons.camera_alt),
                            onPressed: () =>uploadImage(0),
                            color: Colors.grey[100],
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

  Widget _createAnswers(){
    switch (groupValue) {

      // CASO 0 = MULTIPLE CHOICE / CASO 1 = MULT CHOICE CON IMAGENES / CASO 2 = V o F / CASO 3 = UNIR CON FLECHAS

      case 0:   // --multiple choice--

        return Padding(
          padding: const EdgeInsets.symmetric(vertical:15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: lista('correcta',1, true)
          ),
        );
        break;

      case 1: // ---multiple choice con imagenes---

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            AutoSizeText(
              '*La imagen de marco verde será la correcta', maxLines: 2,
              style: TextStyle(color: Colors.white),
            ),
            
            Container(
              height: 360,
              // GRID DE IMAGENES
              child: GridView.count(
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                children: List.generate(4, (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () => uploadImage(index+1),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          border: Border.all(
                            color: index == 0 ? Theme.of(context).primaryColor : Colors.red,
                            width: 2.5
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Stack(
                          children: [
                            sugerencia.sugerencia.respuestas[index] == null || sugerencia.sugerencia.respuestas[index].isEmpty || sugerencia.sugerencia.respuestas[index] == "" 
                              ? Container() 
                              : _imagenEncabezado(sugerencia.sugerencia.respuestas[index]),
                            Center(child: Icon(Icons.camera_alt, color: Colors.grey,)),
                          ],
                        )
                      ),
                    ),
                  );
                }),
              ),
            ),
            (completed)?Container():Text('Llene todas las imagenenes', style: TextStyle(color:Colors.red),)
          ],
        );
        break;

      case 2: // ---VERDADERO O FALSO---
        return Padding(
          padding: const EdgeInsets.symmetric(vertical:15.0),
          child: Column(
            children: [
              RadioListTile(
                value: 0, 
                groupValue: i, 
                onChanged: (value){
                  setState((){
                    sugerencia.sugerencia.respuestas = ["true"];
                    i = value;
                  });
                  print(sugerencia.sugerencia.respuestas[0]);
                },
                controlAffinity: ListTileControlAffinity.trailing,
                title: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  disabledColor: Theme.of(context).primaryColor.withOpacity(0.3),
                  color: Theme.of(context).primaryColor,
                  onPressed: i == 0 ?(){sugerencia.sugerencia.respuestas = ["true"];} : null,
                    child: Container(
                      height: size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text('Verdadero',style: TextStyle(color:Colors.white),)),
                        ],
                  ),
                )),
              ),
              ),
              RadioListTile(
                value: 1, 
                groupValue: i, 
                onChanged: (value){
                  setState((){
                    sugerencia.sugerencia.respuestas = ["false"];
                    i = value;
                  });
                  print(sugerencia.sugerencia.respuestas[0]);
                },
                controlAffinity: ListTileControlAffinity.trailing,
                title: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: MaterialButton(
                  disabledColor: Colors.red.withOpacity(0.3),
                  color: Colors.red,
                  onPressed: i == 1 ?(){sugerencia.sugerencia.respuestas = ["false"];} : null,
                    child: Container(
                      height: size.height * 0.1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text('Falso',style: TextStyle(color:Colors.white),)),
                        ],
                  ),
                )),
              ),
              ),
            ],
          ),
        );
      
      case 3: // --- unir con flechas ---

        return Padding(
          padding: const EdgeInsets.symmetric(vertical:15.0),
          child: Column(children: _listaUnir(sugerencia.sugerencia.respuestas)),
        );

     default:
        return Container(child: Text('data'),width: 100,height: 100, color: Colors.blue,);
    }
    
  }

  List<Widget>_listaUnir(listaRespuestas){
    List<Widget> lista = [];
    for (var i = 0; i < 4; i++) {
      lista.add(Row(
        children: [
          Expanded(
            child: Material(
              child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal:15, vertical: 10),
                height: size.height*0.1,
                color: Colors.grey[100],
                child: Center(
                  child: TextFormField(
                    validator: (String text) {
                      if(text.isEmpty){
                        setState(() {});
                        return 'Llene  este campo';
                      }
                      sugerencia.sugerencia.respuestas[i] = text;
                      return null;
                    },
                    style: TextStyle(color:Colors.grey[700]),
                    maxLines: 2,
                    maxLength: 35,
                    cursorColor: Colors.grey[700],
                    decoration: InputDecoration.collapsed(
                      hintText: 'union ${i+1}, parte 1',
                      hintStyle: TextStyle(color:Colors.grey),
                      ),
                    onChanged:(value) => listaRespuestas[i] = value
                  )
                  ),
                )
              ),
            ),
          ),
          Container(
            child: Icon(Icons.arrow_forward,color: Colors.grey[100],),
          ),
          Expanded(
            child: Material(
              child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal:15, vertical: 10),
                height: size.height*0.1,
                color: Colors.grey[100],
                child: Center(
                  child: TextFormField(
                    validator: (String text) {
                      if(text.isEmpty){
                        setState(() {});
                        return 'Llene  este campo';
                      }
                      sugerencia.sugerencia.respuestas[i] = sugerencia.sugerencia.respuestas[i].replaceFirst(
                        RegExp(sugerencia.sugerencia.respuestas[i]), 
                        '{'+sugerencia.sugerencia.respuestas[i].trim()+":"+text.trim()+'}');
                      return null;
                    },
                    style: TextStyle(color:Colors.grey[700]),
                    maxLines: 2,
                    maxLength: 35,
                    decoration: InputDecoration.collapsed(hintText: 'union ${i+1}, parte 2',hintStyle:TextStyle(color:Colors.grey) ),
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

  List<Widget> lista( String label, int stepItem, bool isCorrect ){
    List<Widget> _lista =[];
    for (var i = 0; i < 4; i++) {
      _lista.add(SizedBox(height:12),);
      _lista.add(
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(
              color: i == 0 ? Theme.of(context).primaryColor : Colors.red,
              width: 4
            ),
            borderRadius: BorderRadius.circular(20)
          ),
          child: MyInput(
            label: i == 0 ? 'Respuesta Correcta' : 'Respuesta Incorrecta',
            validator: (String text) {
              if(text.isEmpty){
                setState(() {
                  currentError[stepItem] = stepItem;
                });
                return "Por favor llene este campo";
              }
              print('pasa por aca');
              setState(() {
                  currentError[stepItem] = 10;
                });
              sugerencia.sugerencia.respuestas[i] = text;
              return null;
            },
          ),
        ),
      );
    }
    return _lista;
  }

  _submit() async {
    completed=true;
    if (!_isLoading) {
      if(groupValue == 1){
        sugerencia.sugerencia.respuestas.forEach((element) {
          if (element.isEmpty || element == "") completed = false;
        });
      }
      if (_formKey.currentState.validate() && completed) {
        setState(() {
          aux = false;
          _isLoading = true;
        });

        prefs.arma = auxArma;
        prefs.materia = auxMateria;
        prefs.colegio = auxColegio;
        prefs.curso = auxCurso;
        /* print(sugerencia.sugerencia.pregunta);
        sugerencia.sugerencia.respuestas.forEach((element) {
          print('respuesta:$element');
        });
        print('organismo: '+ sugerencia.sugerencia.organismo.toString());
        print('materia '+ sugerencia.sugerencia.materia);
        print('curso '+ sugerencia.sugerencia.curso);
        print('arma '+ sugerencia.sugerencia.arma);
        print('es unir con flechas?: '+ sugerencia.sugerencia.unirConFlechas.toString());
        print('es vof?: '+ sugerencia.sugerencia.verdaderoFalso.toString()); */
        
        await Future.delayed(Duration(seconds: 2));

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
                MaterialButton(
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