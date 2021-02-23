import 'package:flutter/material.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de nosotros'),
      ),
      body: Stack(
        children: [
          BackgroundWidget(),
          ListView(
            physics: BouncingScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Entidad',style: Theme.of(context).textTheme.headline4.copyWith(color:Colors.white,fontWeight: FontWeight.bold),),
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.asset('assets/CPS-LOGO.png'),
                    ),
                    Text('Centro de Producción de Software (CPS)',style: TextStyle(color: Colors.white),),
                    
                    SizedBox(height: 25,),
                    Text('Propósito',style: Theme.of(context).textTheme.headline4.copyWith(color:Colors.white,fontWeight: FontWeight.bold),),
                    Text(
                      ' Esta aplicación es un proyecto elaborado por el Centro de Producción de Software del Ejército Argentino en conjunto con los colegios militares, todo con el objetivo de contar con otra herramienta didáctica, práctica y moderna.',
                      style: TextStyle(color: Colors.white),
                    ),

                    SizedBox(height: 25,),
                    Text('Personal',style: Theme.of(context).textTheme.headline4.copyWith(color:Colors.white,fontWeight: FontWeight.bold),),
                    Text('Encargado del proyecto: CT Gabriel Viola',style: TextStyle(color: Colors.white),),
                    Text('Interfáz: VS Santiago Gauto',style: TextStyle(color: Colors.white),),
                    Text('Servicios web: AC Santiago Tessara',style: TextStyle(color: Colors.white),),
                    Text('Auxiliares: VP Brian Jalfón',style: TextStyle(color: Colors.white),),
                    Text('Diseñadores: VP Juan Pizarro, VS Nahuel Guzmán',style: TextStyle(color: Colors.white),),

                    SizedBox(height: 25,),
                    Text('Implementaciones',style: Theme.of(context).textTheme.headline4.copyWith(color:Colors.white,fontWeight: FontWeight.bold),),
                    Text('Desarrollado con Flutter y ASP.Net Core 2',style: TextStyle(color: Colors.white),)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}