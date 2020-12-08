import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:koudai_charger/entity/news.dart';
import 'package:koudai_charger/pages/NewsView.dart';

import 'NewsView_Mk.dart';

class CollectPage extends StatefulWidget {
  CollectPage({Key key}) : super(key: key);

  @override
  _CollectPageState createState() => _CollectPageState();
}

List<NewsData> news = [];

class _CollectPageState extends State<CollectPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('我的收藏'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigator.pushNamed(context, "/");
              // Navigator.push(context, new MaterialPageRoute(builder: (context) {
              //   return HomePage();
              // }));
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            // Container(
            //   child: collectHome(),
            // ),
            Expanded(
              child: showdata(),
            )
          ],
        ));
  }

  @override
  void initState() {
    super.initState();
    setState(() {});
    print(news);
    showdata();
  }

  Widget collectHome() {
    return Row(
      children: [
        RaisedButton(
          onPressed: () {
            // NewsData newsmodel2 = new NewsData(title: "4");
            // news.add(newsmodel2);

            setState(() {});
          },
          child: Text("刷新数据"),
        )
      ],
    );
  }

  Widget showdata() {
    return ListView(
      children: news.asMap().keys.map((item) {
        return Card(
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              InkWell(
                child: ListTile(
                  title: Text(news[item].title),
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) {
                      return NewsViewMkPage(
                        arguments: {
                          'id': news[item].sId,
                          'title': news[item].title,
                          'author': news[item].author,
                          'createdAt': news[item].createdAt,
                        },
                        newsindex: item,
                        isSelected: true,
                      );
                    })).then((data) => {
// 判断是否刷新
                          if (data == 'refresh')
                            // 刷新操作
                            setState(() {})
                        });
                  },
                  onLongPress: () {
                    print(item);
                    news.removeAt(item);
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
