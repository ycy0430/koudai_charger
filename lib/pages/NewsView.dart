import 'package:flutter/material.dart';
import 'package:koudai_charger/entity/news.dart';
import 'package:koudai_charger/pages/Collect.dart';
import 'package:koudai_charger/pages/Theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class NewsViewPage extends StatefulWidget {
  final arguments;
  NewsViewPage({Key key, @required this.arguments}) : super(key: key);

  @override
  _NewsViewPageState createState() => _NewsViewPageState();
}

class _NewsViewPageState extends State<NewsViewPage> {
  bool isLoading = true; // 设置状态

  @override
  Widget build(BuildContext context) {
    String url = "https://gank.io/post/${widget.arguments['id']}";
    return Scaffold(
      appBar: AppBar(
        title: Text("文章详情"),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              NewsData newsmodel2 = new NewsData(
                  title: "${widget.arguments['title']}",
                  sId: widget.arguments['id']);
              news.add(newsmodel2);
              print(news);
            },
          )
        ],
      ),
      body: Stack(
        children: [
          WebView(
            initialUrl: url,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              var url = request.url;
              print("visit $url");
              setState(() {
                isLoading = true; // 开始访问页面，更新状态
              });

              return NavigationDecision.navigate;
            },
            onPageFinished: (String url) {
              setState(() {
                isLoading = false; // 页面加载完成，更新状态
              });
            },
          ),
          isLoading
              ? Container(
                  child: Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(themeColor),
                  ),
                ))
              : Container(),
        ],
      ),
    );
  }
}
