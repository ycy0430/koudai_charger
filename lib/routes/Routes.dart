import 'package:flutter/material.dart';
import 'package:koudai_charger/pages/About.dart';
import 'package:koudai_charger/pages/Collect.dart';
import 'package:koudai_charger/pages/Home.dart';
import 'package:koudai_charger/pages/NewsView.dart';
import 'package:koudai_charger/pages/NewsView_Mk.dart';
import 'package:koudai_charger/pages/Special.dart';
import 'package:koudai_charger/pages/Theme.dart';

final routes = {
  // '/': (context, {arguments}) => CollectPage(),
  '/': (context, {arguments}) => HomePage(),
  // '/': (context) => NewsViewMkPage(
  // arguments: null,
  // ),
  '/about': (context) => AboutPage(),
  // '/collect': (context) => CollectPage(),
  '/special': (context) => SpecialPage(),
  // '/theme': (context) => ThemePage(),
  '/newsview': (context, {arguments}) => NewsViewPage(arguments: arguments),
};
// ignore: top_level_function_literal_block
var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(
          builder: (context) =>
              pageContentBuilder(context, arguments: settings.arguments));
      return route;
    } else {
      final Route route =
          MaterialPageRoute(builder: (context) => pageContentBuilder(context));
      return route;
    }
  }
};
