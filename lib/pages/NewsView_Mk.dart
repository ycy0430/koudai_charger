import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:markdown/markdown.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:koudai_charger/entity/news.dart';
import 'package:koudai_charger/pages/Collect.dart';
import 'package:koudai_charger/pages/Theme.dart';

class NewsViewMkPage extends StatefulWidget {
  final arguments;
  bool isSelected;
  int newsindex;
  int index = news.length - 1;
  NewsViewMkPage(
      {Key key,
      @required this.arguments,
      this.isSelected = false,
      this.newsindex})
      : super(key: key);

  @override
  _NewsViewMkPageState createState() => _NewsViewMkPageState();
}

// ignore: camel_case_types
class _NewsViewMkPageState extends State<NewsViewMkPage> {
  bool isLoading = true; // 设置状态

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("${widget.arguments['title']}——${widget.arguments['author']}"),
        leading: new IconButton(
          tooltip: '返回上一页',
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop("refresh");
            //_nextPage(-1);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: widget.isSelected ? Colors.red : Colors.white,
            ),
            onPressed: () {
              NewsData newsmodel2 = new NewsData(
                title: "${widget.arguments['title']}",
                sId: widget.arguments['id'],
                author: widget.arguments['author'],
                createdAt: widget.arguments['createdAt'],
              );
              print(news);
              setState(() {
                if (widget.isSelected) {
                  widget.isSelected = false;
                  news.removeAt(widget.newsindex);
                  print(widget.newsindex);
                } else {
                  widget.isSelected = true;
                  news.add(newsmodel2);
                  widget.newsindex = news.length - 1;
                }
              });
            },
          )
        ],
      ),
      body: Newsvalue(
        id: widget.arguments['id'],
        title: widget.arguments['title'],
        author: widget.arguments['author'],
        createdAt: widget.arguments['createdAt'],
      ),
    );
  }
}

class Newsvalue extends StatefulWidget {
  Newsvalue({Key key, this.id, this.title, this.author, this.createdAt})
      : super(key: key);
  String id;
  String title;
  String author;
  String createdAt;

  @override
  _NewsvalueState createState() => _NewsvalueState();
}

class _NewsvalueState extends State<Newsvalue> {
  Dio dio = new Dio(); //第三方网络加载库

  var result;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
              child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: _getDate(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Markdown(
                        data: snapshot.data,
                      );
                    } else {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return Center(
                          child: Text("当前文章没有Markdown数据！"),
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(themeColor),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          )),
        )
      ],
    );
  }

  Widget _buildImage(String url) {
    Image image = Image.network(url);
    ImageStream stream = image.image.resolve(ImageConfiguration.empty);
    stream.addListener(ImageStreamListener((image, synchronousCall) {},
        onError: (exception, stackTrace) {
      print('enter onError start');
      print(exception);
      print(stackTrace);
      print('enter onError end');
    }));
    return image;
  }

  @override
  void initState() {
    super.initState();
    _getDate();
  }

  Future _getDate() async {
    String url = 'https://gank.io/api/v2/post/${this.widget.id}';

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      //响应成功
      result = (response.data)['data'];
    }
    // print(result['markdown']);
    return result['markdown'];
  }
}
