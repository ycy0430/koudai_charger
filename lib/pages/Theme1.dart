import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:koudai_charger/common/app_provider.dart';
import 'package:provider/provider.dart';
import 'Home.dart';

class Themepage extends StatefulWidget {
  Themepage({
    Key key,
  }) : super(key: key);
  @override
  _ThemepageState createState() => _ThemepageState();
}

class _ThemepageState extends State<Themepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("主题切换"),
      ),
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
