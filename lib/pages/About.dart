import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关于我们'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            // Navigator.push(context, new MaterialPageRoute(builder: (context) {
            //   return HomePage();
            // }));
            // Navigator.pop(context);
            // Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            buildLogo(),
            main(),
          ],
        ),
      ),
    );
  }
}

// logo
Widget buildLogo() {
  return Container(
    width: 110,
    margin: EdgeInsets.only(top: 84),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 76,
          width: 76,
          margin: EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                left: 0,
                top: 0,
                right: 0,
                child: Container(
                  height: 76,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      Shadows.primaryShadow,
                    ],
                    borderRadius: BorderRadius.all(Radius.circular(38) //父容器的50%
                        ),
                  ),
                  child: Container(),
                ),
              ),
              Positioned(
                top: 13,
                child: Image.asset(
                  "assets/images/logo.png",
                  fit: BoxFit.none,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 15),
          child: Text(
            "口袋充电站",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              fontSize: 20,
              height: 1,
            ),
          ),
        ),
        // Text(
        //   "v1.0.0",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(
        //     color: Colors.black,
        //     fontFamily: "Avenir",
        //     fontWeight: FontWeight.w400,
        //     fontSize: 16,
        //     height: 1,
        //   ),
        // ),
      ],
    ),
  );
}

Widget main() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 50,
        ),
        Container(
          padding: EdgeInsets.all(5.0),
          child: Text(
              "一款基于Flutter技术开发的资讯APP，主要包括Android、iOS、Flutter前沿技术。具有收藏、福利中心、主题切换等功能。"),
          width: 260,
        ),
        SizedBox(
          height: 250,
        ),
        Text('作者：YCY',
            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal)),
        Container(
          padding: EdgeInsets.all(5.0),
        ),
        Container(
          padding: EdgeInsets.all(5.0),
        ),
        GestureDetector(
          child: Text(
            'Github：https://github.com/ycy0430',
            style: TextStyle(
                color: Colors.blueAccent,
                decoration: TextDecoration.combine([TextDecoration.underline])),
          ),
        )
      ],
    ),
  );
}

class Shadows {
  static const BoxShadow primaryShadow = BoxShadow(
    color: Color.fromARGB(38, 27, 27, 29),
    offset: Offset(0, 5),
    blurRadius: 10,
  );
}
