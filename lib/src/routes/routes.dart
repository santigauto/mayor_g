//IMPORTS
import 'package:flutter/material.dart';
import 'package:mayor_g/src/views/notifications_page.dart';
//PAGINAS
import 'package:mayor_g/src/views/side_menu_options/suggestQuestion/suggestQuestion.dart';
import 'package:mayor_g/src/views/side_menu_options/ranking/ranking_options_page.dart';
import 'package:mayor_g/src/views/side_menu_options/search/search_friends_page.dart';
import 'package:mayor_g/src/views/side_menu_options/search/search_people_page.dart';
import 'package:mayor_g/src/views/side_menu_options/ranking/ranking_page.dart';
import 'package:mayor_g/src/views/side_menu_options/search/search_page.dart';
import 'package:mayor_g/src/views/side_menu_options/ajustes_page.dart';
import 'package:mayor_g/src/views/side_menu_options/collab_page.dart';

import 'package:mayor_g/src/views/new_match_page.dart';
import 'package:mayor_g/src/views/question_page.dart';
import 'package:mayor_g/src/views/result_page.dart';
import 'package:mayor_g/src/views/splash_page.dart';
import 'package:mayor_g/src/views/login_page.dart';
import 'package:mayor_g/src/views/menu_page.dart';
import 'package:mayor_g/src/widgets/custom_drawer_flipped.dart';


Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    '/'               : (BuildContext context) => CustomFlippedDrawer(child: MenuPage(),),
    'menu'            : (BuildContext context) => CustomFlippedDrawer(child: MenuPage(),),
    'new_match'       : (BuildContext context) => NewMatchPage(),
    'ranking'         : (BuildContext context) => RankingOptionsPage(),
    'rank'            : (BuildContext context) => RankingPage(),
    'collab'          : (BuildContext context) => CollabPage(),
    'friends'         : (BuildContext context) => FriendsPage(),
    'splash'          : (BuildContext context) => SplashPage(),
    'login'           : (BuildContext context) => LoginPage(),
    'question'        : (BuildContext context) => QuestionPage(),
    'search'          : (BuildContext context) => SearchPage(),
    'search_people'   : (BuildContext context) => SearchPeoplePage(),
    'result'          : (BuildContext context) => ResultPage(),
    'suggestQuestion' : (BuildContext context) => SuggestQuestionPage(),
    'ajustes'         : (BuildContext context) => AjustesPartidaPage(),
    'notifications'   : (BuildContext context) => NotificationsPage(),
  };
}

//ESTA PAGINA SE ENCARGA DE ASIGNAR LAS RUTAS DEL JSON Y DEMAS PAGINAS DE LA APP
