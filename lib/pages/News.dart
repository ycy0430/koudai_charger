import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:koudai_charger/entity/news.dart';
import 'dart:async';
import 'package:koudai_charger/pages/NewsView.dart';
import 'package:koudai_charger/pages/NewsView_Mk.dart';
import 'package:koudai_charger/pages/Theme.dart';
import 'package:koudai_charger/widgets/Loading.dart';

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

NewsData newsmodel1 = new NewsData(title: "1");
NewsData newsmodel2 = new NewsData(title: "2");
//加载更多开关
bool _swch = false;

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
  bool get wantKeepAlive => true;
  List<NewsData> datas = []; //初始化列表数据源
  int currentpage = 1; //默认当前页

  int pageSize = 10; //每页加载数据

  Dio dio = new Dio(); //第三方网络加载库
  ScrollController _scrollController;

  //滑动到底了自动加载更多
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _swch = false;
      _loadMoreData();
    }
  }

//页面初始化时加载数据并实例化ScrollController
  @override
  void initState() {
    super.initState();
    _refreshData();
    _scrollController = new ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var content;
    if (datas.isEmpty) {
      content = new Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation(themeColor),
      ));
    } else {
      content = new ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: datas.length,
        controller: _scrollController,
        itemBuilder: buildCardItem,
      );
    }

    var _refreshIndicator = new RefreshIndicator(
      onRefresh: _refreshData,
      child: content,
    );
    return _refreshIndicator;
  }

  Widget buildCardItem(BuildContext context, int index) {
    // final String url = datas[index].url;

    if (index == datas.length - 1) {
      return Offstage(
        child: buildIsLoading(),
        offstage: _swch,
      );
    } else {
      return Card(
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text(datas[index].title),
              subtitle: Text(
                datas[index].desc,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              leading: _generateItem(datas[index].images),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) {
                  return NewsViewMkPage(arguments: {
                    'id': datas[index].sId,
                    'title': datas[index].title,
                    'author': datas[index].author,
                    'createdAt': datas[index].createdAt,
                  });
                }));
              },
            ),
          ],
        ),
      );
    }
  }

  _generateItem(var value) {
    if (value.length != 0) {
      return Padding(
        padding: EdgeInsets.all(2),
        child: Image.network(
          value[0],
          width: 80,
          fit: BoxFit.fill,
        ),
      );
    }
    print('0');
  }

  //刷新时调用
  Future<Null> _refreshData() {
    final Completer<Null> completer = new Completer<Null>();
    currentpage = 1;
    feach(currentpage, pageSize).then((list) {
      setState(() {
        datas = list;
      });
    }).catchError((error) {
      // print(error);
    });
    completer.complete(null);

    return completer.future;
  }

  //加载更多时调用
  Future<Null> _loadMoreData() {
    final Completer<Null> completer = new Completer<Null>();

    feach(currentpage, pageSize).then((list) {
      setState(() {
        datas.addAll(list);
      });
    }).catchError((error) {
      // print(error);
    });
    completer.complete(null);

    return completer.future;
  }

  Future<List<NewsData>> feach(int pageNum, int pageSize) {
    return _getDate(pageNum, pageSize);
  }

  Future<List<NewsData>> _getDate(int pageNum, int pageSize) async {
    List flModels;
    String url =
        'https://gank.io/api/v2/data/category/GanHuo/type/${widget.newsType}/page/$pageNum/count/$pageSize';

    Response response = await dio.get(url);

    if (response.statusCode == 200) {
      //响应成功
      flModels = (response.data)['data'];
      currentpage = currentpage + 1; //加载成功后才可加载下一页
    } else {
      //出问题
    }

    if (flModels
            .map((model) {
              return new NewsData.fromJson(model);
            })
            .toList()
            .length ==
        0) {
      setState(() {
        _swch = true;
      });
      Fluttertoast.showToast(
          msg: "没有更多了",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM, // 消息框弹出的位置
          // timeInSecForIos: 1, // 消息框持续的时间（目前的版本只有ios有效）
          backgroundColor: Colors.black45,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return flModels.map((model) {
      return new NewsData.fromJson(model);
    }).toList();
  }
}
