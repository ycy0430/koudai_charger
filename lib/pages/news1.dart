import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:koudai_charger/pages/NewsView.dart';
import 'package:koudai_charger/pages/Theme.dart';

class News extends StatefulWidget {
  const News({Key key, this.data}) : super(key: key); //构造函数中增加参数
  final String data; //为参数分配空间
  @override
  _MyTabbedPageState createState() => new _MyTabbedPageState();
}

//定义TAB页对象，这样做的好处就是，可以灵活定义每个tab页用到的对象，可结合Iterable对象使用，以后讲
class NewsTab {
  String text;
  NewsList newsList;
  NewsTab(this.text, this.newsList);
}

class _MyTabbedPageState extends State<News>
    with SingleTickerProviderStateMixin {
  //将每个Tab页都结构化处理下，由于http的请求需要传入新闻类型的参数，因此将新闻类型参数值作为对象属性传入Tab中
  final List<NewsTab> myTabs = <NewsTab>[
    new NewsTab('Android', new NewsList(newsType: 'Android')),
    new NewsTab('IOS', new NewsList(newsType: 'iOS')),
    new NewsTab('Flutter', new NewsList(newsType: 'Flutter')),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  // @override
  // // 资源释放
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: themeColor,
        title: new TabBar(
          controller: _tabController,
          tabs: myTabs.map((NewsTab item) {
            //NewsTab可以不用声明
            return new Tab(text: item.text ?? '错误');
          }).toList(),
          indicatorColor: Colors.white,
          // labelColor: Colors.red, //选中字体颜色
          // unselectedLabelColor: Colors.red[250], // 未选中字体颜色
          isScrollable:
              true, //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: myTabs.map((item) {
          return item.newsList; //使用参数值
        }).toList(),
      ),
    );
  }
}

//新闻列表
class NewsList extends StatefulWidget {
  final String newsType; //新闻类型
  @override
  NewsList({Key key, this.newsType}) : super(key: key);

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<NewsList>
    with AutomaticKeepAliveClientMixin {
  final String _url = 'https://gank.io/api/v2/data/category/GanHuo/type/';
  List data;
  bool get wantKeepAlive => true;

  ///see AutomaticKeepAliveClientMixin
  //HTTP请求的函数返回值为异步控件Future
  Future<String> get(String category) async {
    var httpClient = new HttpClient();
    var request =
        await httpClient.getUrl(Uri.parse('$_url$category/page/1/count/10'));
    var response = await request.close();

    // Response response = await Dio().get('$_url$category/page/1/count/10');

    return await response.transform(utf8.decoder).join();
    // return await response.transform(utf8.decoder).join();
  }

  Future<Null> loadData() async {
    await get(widget.newsType); //注意await关键字
    if (!mounted) return; //异步处理，防止报错
    setState(() {}); //什么都不做，只为触发RefreshIndicator的子控件刷新
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return new RefreshIndicator(
      child: new FutureBuilder(
        //用于懒加载的FutureBuilder对象
        future: get(widget.newsType), //HTTP请求获取数据，将被AsyncSnapshot对象监视
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none: //get未执行时
            case ConnectionState.waiting: //get正在执行时
              return new Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(themeColor),
                ), //在页面中央显示正在加载
              );
            default:
              if (snapshot.hasError) //get执行完成但出现异常
                return new Text('Error: ${snapshot.error}');
              else //get正常执行完成
                // 创建列表，列表数据来源于snapshot的返回值，而snapshot就是get(widget.newsType)执行完毕时的快照
                // get(widget.newsType)执行完毕时的快照即函数最后的返回值。
                return createListView(context, snapshot);
          }
        },
      ),
      onRefresh: loadData,
    );
  }

  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List values;
    values = jsonDecode(snapshot.data)['data'] != null
        ? jsonDecode(snapshot.data)['data']
        : [''];
    switch (values.length) {
      case 1: //没有获取到数据，则返回请求失败的原因
        return new Center(
          child: new Card(
            child: new Text(jsonDecode(snapshot.data)['reason']),
          ),
        );
      default:
        return new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16.0),
            // itemCount: data == null ? 0 : data.length,
            itemCount: values == null ? 0 : values.length,
            itemBuilder: (context, i) {
              // return _newsRow(data[i]);//把数据项塞入ListView中
              return _newsRow(values[i]);
            });
    }
  }

  //新闻列表单个item
  Widget _newsRow(value) {
    return Card(
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(value["title"]),
            subtitle: Text(
              value["desc"],
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            leading: _generateItem(value),
            onTap: () {
              Navigator.push(context, new MaterialPageRoute(builder: (context) {
                return NewsViewPage(
                    arguments: {'id': value["_id"], 'title': value["title"]});
              }));
            },
          ),
        ],
      ),
    );
  }

  _generateItem(Map value) {
    if (value["images"].length != 0) {
      return Padding(
        padding: EdgeInsets.all(2),
        child: Image.network(
          value["images"][0],
          width: 80,
          fit: BoxFit.fill,
        ),
      );
    }
    print('0');
  }
}
