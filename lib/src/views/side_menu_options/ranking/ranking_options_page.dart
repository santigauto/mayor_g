

import 'package:flutter/material.dart';
import 'package:mayor_g/src/models/profileInfo.dart';
import 'package:mayor_g/src/views/side_menu_options/ranking/friends_rank_page.dart';
import 'package:mayor_g/src/views/side_menu_options/ranking/global_page.dart';
import 'package:mayor_g/src/views/side_menu_options/ranking/level_page.dart';
import 'package:mayor_g/src/views/side_menu_options/ranking/ranking_page.dart';
import 'package:mayor_g/src/widgets/custom_widgets.dart';

class RankingOptionsPage extends StatefulWidget {
  @override
  _RankingOptionsPageState createState() => _RankingOptionsPageState();
}

class _RankingOptionsPageState extends State<RankingOptionsPage> with SingleTickerProviderStateMixin{

  TabController _tabController;
  ImagenPerfil profilePic;
  PreferenciasUsuario _prefs = PreferenciasUsuario();

  @override
  void initState() {
    
    profilePic = ImagenPerfil(photoData: _prefs.foto,radius: 30,);
    
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final Map mapa = ModalRoute.of(context).settings.arguments;
    print(mapa['index'].toString());
    _tabController = new TabController(length: 4, vsync: this,initialIndex: mapa['index']);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Hero(tag:1,child: GestureDetector(onTap:()=>Navigator.pop(context),child: ImagenPerfil(photoData: _prefs.foto)))
        ),
        title: Text('${_prefs.apellido}, ${_prefs.nombre}'),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          labelPadding: EdgeInsets.all(0),
          tabs: [
            Tab(icon: Icon(Icons.person),text: 'Mi Nivel',),
            Tab(icon: Icon(Icons.insert_chart),text: 'Estadísticas',),
            Tab(icon: Icon(Icons.tag_faces),text: 'Amigos',),
            Tab(icon: Icon(Icons.public),text: 'Global',),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          LevelPage(),
          RankingPage(),
          FriendsRankPage(),
          GlobalPage()
        ],
        controller: _tabController,
      ),
    );
  }

}
