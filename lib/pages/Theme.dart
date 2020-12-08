import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:koudai_charger/common/app_provider.dart';
// import 'package:koudai_charger/pages/Home.dart';
import 'package:provider/provider.dart';

Color themeColor;
String themeColor1;
String colorKey;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await SpUtil.getInstance();
    colorKey = SpUtil.getString('key_theme_color', defValue: 'blue');
    // 设置初始化主题颜色
    Provider.of<AppInfoProvider>(context, listen: false).setTheme(colorKey);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: AppInfoProvider())],
      child: Consumer<AppInfoProvider>(
        builder: (context, appInfo, _) {
          String colorKey = appInfo.themeColor;
          if (themeColorMap[colorKey] != null) {
            themeColor = themeColorMap[colorKey];
          }

          return MaterialApp(
            theme: ThemeData(primaryColor: themeColor, accentColor: themeColor
                // floatingActionButtonTheme:
                //     FloatingActionButtonThemeData(backgroundColor: _themeColor,foregroundColor: Colors.white),
                ),
            home: buildmain(context),
          );
        },
      ),
    );
  }

  Widget buildmain(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("主题切换"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.push(context, new MaterialPageRoute(builder: (context) {
              //   return HomePage();
              // }));
              Navigator.pop(context);
            },
          )),
      body: Center(
          child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: themeColorMap.keys.map((key) {
            Color value = themeColorMap[key];
            return InkWell(
              onTap: () {
                setState(() {
                  colorKey = key;
                  themeColor1 =
                      Provider.of<AppInfoProvider>(context, listen: false)
                          .themeColor;
                  print(themeColor1);
                });
                SpUtil.putString('key_theme_color', key);
                Provider.of<AppInfoProvider>(context, listen: false)
                    .setTheme(key);
                setState(() {});
                // Navigator.pushAndRemoveUntil(
                //   context,
                //   new MaterialPageRoute(builder: (BuildContext context) {
                //     return HomePage();
                //   }),
                //   (Route<dynamic> route) => false,
                // );
              },
              child: Container(
                width: 340,
                height: 40,
                color: value,
                child: colorKey == key
                    ? Icon(
                        Icons.done,
                        color: Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      )),
    );
  }
}
