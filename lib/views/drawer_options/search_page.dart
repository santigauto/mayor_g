import 'package:flutter/material.dart';
import 'package:mayor_g/views/drawer_options/search_friends_page.dart';
import 'package:mayor_g/views/drawer_options/search_people_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin{

  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscador"),
        automaticallyImplyLeading: true,
        bottom: TabBar(
          labelPadding: EdgeInsets.all(0),
          tabs: [
            Tab(icon: Icon(Icons.person_add),text: 'Buscar',),
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
          FriendsPage(),
        ],
        controller: _tabController,
      ),
    );
  }
}

