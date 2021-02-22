import 'package:flutter/material.dart';
import 'package:mayor_g/src/views/side_menu_options/search/search_friends_page.dart';
import 'package:mayor_g/src/views/side_menu_options/search/search_people_page.dart';
import 'package:mayor_g/src/views/side_menu_options/search/solicitudes_pendientes_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Map mapa = ModalRoute.of(context).settings.arguments;
    print(mapa['index'].toString());
    _tabController = new TabController(length: 3, vsync: this,initialIndex: mapa['index']);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscador"),
        automaticallyImplyLeading: true,
        bottom: TabBar(
          labelPadding: EdgeInsets.all(0),
          tabs: [
            Tab(icon: Icon(Icons.search),text: 'Buscar',),
            Tab(icon: Icon(Icons.group_add),text: 'Solicitudes',),
            Tab(icon: Icon(Icons.tag_faces),text: 'Amigos',),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          SearchPeoplePage(),
          SolicitudesPendientesPage(),
          FriendsPage(),
        ],
        controller: _tabController,
      ),
    );
  }
}

