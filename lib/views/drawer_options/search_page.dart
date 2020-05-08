import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:mayor_g/views/drawer_options/search_people_page.dart';

import 'search_friends_page.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}
SwiperController swiperController = new SwiperController();
final List<Widget> _widgetOptions = [FriendsPage(), SearchPeoplePage()];
final List<Icon> _iconos = [Icon(Icons.tag_faces), Icon(Icons.person_add)];
final List<String> _names = ['Amigos', 'Busqueda'];
int _selectedIndex = 0;

class _SearchPageState extends State<SearchPage> {

void _onItemSwipped(int index) {
  setState(() {
    _selectedIndex = index;
  });   
  
}
void _onButtonTapped(int index) {
  setState(() {
    swiperController.move(index);
    });}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Swiper(
        controller: swiperController,
        itemCount: _widgetOptions.length,
        onIndexChanged: _onItemSwipped,
        itemBuilder: (BuildContext context, _selectedIndex){
          return  _widgetOptions.elementAt(_selectedIndex);
        },
      ),
    bottomNavigationBar: buttonNavBar(_widgetOptions, _selectedIndex, _iconos, _names)
  );
  }

Widget buttonNavBar(List<Widget> data, int selectedIndex, List<Widget> iconos, List<String> names) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).primaryColor,
      items: listaItems(data, iconos, names),
      currentIndex: selectedIndex,
      selectedItemColor: Colors.white,
      onTap: _onButtonTapped, 
    );   
    
  }

  List<BottomNavigationBarItem> listaItems(List<Widget> data, List<Widget> iconos, List<String> names) {
    final List<BottomNavigationBarItem> botones = [];
    int n = 0;
    data.forEach((opt) {
      final widgetTemp = BottomNavigationBarItem(
        icon: iconos[n],
        title: Text(
          names[n]
        ),
      );
      botones.add(widgetTemp);
      n++;
    });
    return botones;
  }
}
