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
        bottom: TabBar(
          tabs: [
            Tab(icon: Icon(Icons.tag_faces)),
            Tab(icon: Icon(Icons.person_add),),
          ],
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.tab,
        ),
        bottomOpacity: 1,
      ),
      body: TabBarView(
        children: [
          FriendsPage(),
          SearchPeoplePage(),
        ],
        controller: _tabController,
      ),
    );
  }
}

