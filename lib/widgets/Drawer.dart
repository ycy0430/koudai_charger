import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:koudai_charger/common/app_provider.dart';
import 'package:koudai_charger/pages/About.dart';
import 'package:koudai_charger/pages/Collect.dart';
import 'package:koudai_charger/pages/Home.dart';
import 'package:koudai_charger/pages/Special.dart';
import 'package:koudai_charger/pages/Theme.dart';
import 'package:koudai_charger/pages/Theme1.dart';
import 'package:provider/provider.dart';

class HomeDrawer extends StatelessWidget {
  @override
  Widget build(
    BuildContext context,
  ) {
    return Drawer(
      child: Column(
        children: [
          Container(
            child: buildLogo(),
          ),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.home),
            ),
            title: Text('我的收藏'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CollectPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.people),
            ),
            title: Text('福利中心'),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) {
              //   return SpecialPage();
              // }));

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SpecialPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.settings),
            ),
            title: Text('切换主题'),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) {
              //   return ThemePage();
              // }));

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Themepage()));
            },
          ),
          // Divider(),
          // ListTile(
          //   leading: CircleAvatar(
          //     child: Icon(Icons.people),
          //   ),
          //   title: Text('刷新主题'),
          //   onTap: () {
          //     // Navigator.pop(context);
          //     // Navigator.push(context,
          //     //     new MaterialPageRoute(builder: (context) {
          //     //   return AboutPage();
          //     // }));
          //     // Provider.of<AppInfoProvider>(context, listen: false)
          //     //     .setTheme(colorKey);
          //   },
          // ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.people),
            ),
            title: Text('关于我们'),
            onTap: () {
              // Navigator.pop(context);
              // Navigator.push(context,
              //     new MaterialPageRoute(builder: (context) {
              //   return AboutPage();
              // }));

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AboutPage()));
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
