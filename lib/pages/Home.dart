import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:koudai_charger/common/app_provider.dart';
import 'package:koudai_charger/pages/News.dart';
import 'package:koudai_charger/pages/Theme.dart';
import 'package:koudai_charger/widgets/Drawer.dart';
import 'package:provider/provider.dart';

// String colorKey;
String colorKey;

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _initAsync();
  }

  Future<void> _initAsync() async {
    await SpUtil.getInstance();
    colorKey = SpUtil.getString('key_theme_color', defValue: 'red');
    // 设置初始化主题颜色
    Provider.of<AppInfoProvider>(context, listen: false).setTheme(colorKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('口袋充电站'),
        // backgroundColor: themeColor,
      ),
      drawer: HomeDrawer(),
      // body: WDefaultTab(),
      // body: new News(data: '参数值'),
      body: new News(data: '参数值'),
    );
  }
}
