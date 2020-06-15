import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mayor_g/models/profileInfo.dart';
import 'package:mayor_g/views/side_menu_options/ranking/friends_rank_page.dart';
import 'package:mayor_g/views/side_menu_options/ranking/global_page.dart';
import 'package:mayor_g/views/side_menu_options/ranking/level_page.dart';
import 'package:mayor_g/views/side_menu_options/ranking/ranking_page.dart';

class RankingOptionsPage extends StatefulWidget {
  @override
  _RankingOptionsPageState createState() => _RankingOptionsPageState();
}

class _RankingOptionsPageState extends State<RankingOptionsPage> with SingleTickerProviderStateMixin{

  TabController _tabController;
  PreferenciasUsuario _prefs = PreferenciasUsuario();  

  @override
  void initState() {
    _tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: imagen(),
            backgroundColor: Color(0xFF838547),
          ),
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


 ImageProvider imagen(){// Hacerla GLOBAL!!
    if(_prefs.foto == null || _prefs.foto == 'null'){
      return AssetImage('assets/soldier.png');
    }else return MemoryImage(
      base64Decode(_prefs.foto),
    );
  }
}
