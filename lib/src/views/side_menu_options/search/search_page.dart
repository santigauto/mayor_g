import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mayor_g/src/views/side_menu_options/search/search_friends_page.dart';
import 'package:mayor_g/src/views/side_menu_options/search/search_people_page.dart';
import 'package:mayor_g/src/views/side_menu_options/search/solicitudes_pendientes_page.dart';
import 'package:mayor_g/src/widgets/background_widget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{

  TabController _tabController;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final Map mapa = ModalRoute.of(context).settings.arguments;
    print(mapa['index'].toString());
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          child: Stack(
            children: [
              DefaultTabController(
                length: 3,
                initialIndex: mapa['index'],
                child: Container(
                  color: Theme.of(context).primaryColor,
                  child: Column(
                    children: [
                      TabBar(
                        labelPadding: EdgeInsets.all(5.0),
                        tabs: [
                          Tab(icon: Icon(Icons.search),text: 'Buscar',),
                          Tab(icon: Icon(Icons.group_add),text: 'Solicitudes',),
                          Tab(icon: Icon(Icons.tag_faces),text: 'Amigos',),
                        ],
                        controller: _tabController,
                        indicatorColor: Colors.white,
                        indicatorSize: TabBarIndicatorSize.tab,
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            SearchPeoplePage(),
                            SolicitudesPendientesPage(),
                            FriendsPage(),
                          ],
                          controller: _tabController,
                        ),
                      ),
                  ],
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

