import 'package:flutter/material.dart';
import 'package:koudai_charger/pages/Home.dart';
import 'package:koudai_charger/pages/Theme.dart';
import 'package:koudai_charger/routes/Routes.dart';
import 'package:provider/provider.dart';

import 'common/app_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Color _themeColor;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AppInfoProvider())],
      child: Consumer<AppInfoProvider>(
        builder: (context, appInfo, _) {
          String colorKey = appInfo.themeColor;
          if (themeColorMap[colorKey] != null) {
            _themeColor = themeColorMap[colorKey];
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme:
                ThemeData(primaryColor: _themeColor, accentColor: _themeColor),
            title: 'Material App',
            home: HomePage(),
            // initialRoute: '/',
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}
