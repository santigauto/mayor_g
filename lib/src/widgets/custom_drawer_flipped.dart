import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/services/auth_service.dart';
import 'package:mayor_g/src/services/commons/drawer_service.dart';
import 'package:mayor_g/src/utils/icon_string_util.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';

import 'imagen_perfil.dart';

class CustomFlippedDrawer extends StatefulWidget {
  final Widget child;

  const CustomFlippedDrawer({Key key, this.child}) : super(key: key);

  static CustomFlippedDrawerState of(BuildContext context) =>
      context.findAncestorStateOfType<CustomFlippedDrawerState>();

  @override
  CustomFlippedDrawerState createState() => new CustomFlippedDrawerState();
}

class CustomFlippedDrawerState extends State<CustomFlippedDrawer>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  Animation rotation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350),
    );

    rotation = Tween( begin: 0.0, end: math.pi/2).animate(CurvedAnimation(parent:animationController, curve: Curves.bounceIn));

  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragStart: _onDragStart,
      onHorizontalDragUpdate: _onDragUpdate,
      onHorizontalDragEnd: _onDragEnd,
      behavior: HitTestBehavior.translucent,
      onTap: toggle,
      child: AnimatedBuilder(
        animation: animationController,
        builder: (context, _) {
          return Material(
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                BackgroundWidget(),
                Positioned(
                  top: MediaQuery.of(context).size.height*0.25,
                  left: animationController.value * maxSlide /2,
                  child: Transform.rotate(
                    angle:rotation.value,
                    child: Container(
                      height: 310,
                      width: 250,
                      child: Image.asset(
                        'assets/MayorGAnimaciones/MayorG-Fumando.gif',
                      ),),
                    ),
                ),
                Transform.translate(
                  offset: Offset(maxSlide * (animationController.value - 1), 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi / 2 * (1 - animationController.value)),
                    alignment: Alignment.centerRight,
                    child: MyDrawer(),
                  ),
                ),
                Transform.translate(
                  offset: Offset(maxSlide * animationController.value, 0),
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(-math.pi * animationController.value / 2),
                    alignment: Alignment.centerLeft,
                    child: widget.child,
                  ),
                ),
                Positioned(
                  top: 4.0 + MediaQuery.of(context).padding.top,
                  left: 4.0 + animationController.value * maxSlide,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: toggle,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

class MyDrawer extends StatelessWidget {
  final prefs = new PreferenciasUsuario();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      child: Column(
        children: <Widget>[
          _drawerProfile(context,prefs),
          Container(child: _lista(), color: Colors.white,),
          Expanded(child: Container(color: Colors.white,)),
          Container(
            color: Theme.of(context).primaryColor,
            child: ListTile(
              leading: Icon(
                Icons.power_settings_new,
                color: Colors.red,
              ),
              title: Text('Log Out', style: TextStyle(color: Colors.white)),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: (){AuthService().logout(context: context);},
            ),
          )
        ],
      ),
    );
  }

  Widget _drawerProfile(BuildContext context, prefs) {

    return Container(
      height: 152,
      color: Colors.white,
      child: DrawerHeader(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 32,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/mayorG@3x.png'))),
            ),
            Row(
              children: <Widget>[
                ImagenPerfil(photoData: prefs.foto,radius: 20,),
                SizedBox(width: 7,),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  //nombre de usuario
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      prefs.apellido,
                      style: TextStyle(fontSize: 15, color: Colors.white)),
                    Text(
                      prefs.nombre,
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    )
                  ],
                ),
                Expanded(child: Container()),
              ],
            ), 
          ],
        ),
      ),
    );
  }

  Widget _lista() {
    return FutureBuilder(
      future: menuProvider.cargarData(),
      initialData: [],
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Column(children: _crearItems(snapshot.data, context));
      },
    );
  }

  List<Widget> _crearItems(List<dynamic> data, BuildContext context) {
    final List<Widget> opciones = [];

    data.forEach((item) {
      final widgetTemp = ListTile(
        title: Text(item['texto']),
        leading: getIcon(item['icon']),
        trailing: Icon(Icons.keyboard_arrow_right),
        onTap: () {
          Navigator.pushNamed(context, item['ruta']);
        },
      );
      opciones..add(widgetTemp);
    });

    return opciones;
  }
}
