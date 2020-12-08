import 'package:flutter/material.dart';
import 'package:koudai_charger/entity/news.dart';

Map<String, Color> themeColorMap = {
  'gray': Colors.grey,
  'blue': Colors.blue,
  'cyan': Colors.cyan,
  'deepOrange': Colors.orange,
  'green': Colors.green,
  'indigo': Colors.indigo,
  'orange': Colors.orange,
  'purple': Colors.purple,
  'pink': Colors.pink,
  'red': Colors.red,
  'teal': Colors.teal,
};

class AppInfoProvider with ChangeNotifier {
  String _themeColor = '';

  String get themeColor => _themeColor;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}
