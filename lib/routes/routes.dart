//IMPORTS
import 'package:flutter/material.dart';
//PAGINAS
import 'package:mayor_g/views/side_menu_options/collab_page.dart';
import 'package:mayor_g/views/side_menu_options/ranking/ranking_options_page.dart';
import 'package:mayor_g/views/side_menu_options/ranking/ranking_page.dart';
import 'package:mayor_g/views/side_menu_options/search/search_friends_page.dart';
import 'package:mayor_g/views/side_menu_options/search/search_page.dart';
import 'package:mayor_g/views/side_menu_options/search/search_people_page.dart';
import 'package:mayor_g/views/side_menu_options/suggestQuestion/suggestQuestion.dart';
import 'package:mayor_g/views/login_page.dart';
import 'package:mayor_g/views/menu_page.dart';
import 'package:mayor_g/views/question_page.dart';
import 'package:mayor_g/views/result_page.dart';
import 'package:mayor_g/views/splash_page.dart';


Map<String, WidgetBuilder> getApplicationRoutes(){
  return <String, WidgetBuilder>{
    '/'       : (BuildContext context) => MenuPage(),
    'menu'    : (BuildContext context) => MenuPage(),
    'ranking' : (BuildContext context) => RankingOptionsPage(),
    'rank'    : (BuildContext context) => RankingPage(),
    'collab'  : (BuildContext context) => CollabPage(),
    'friends' : (BuildContext context) => FriendsPage(),
    'splash'  : (BuildContext context) => SplashPage(),
    'login'   : (BuildContext context) => LoginPage(),
    'question': (BuildContext context) => QuestionPage(),
    'search'  : (BuildContext context) => SearchPage(),
    'search_people'  : (BuildContext context) => SearchPeoplePage(),
    'result'  : (BuildContext context) => ResultPage(),
    'suggestQuestion' : (BuildContext context) => SuggestQuestionPage(),
  };
}

//ESTA PAGINA SE ENCARGA DE ASIGNAR LAS RUTAS DEL JSON Y DEMAS PAGINAS DE LA APP
