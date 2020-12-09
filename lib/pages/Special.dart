import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:koudai_charger/entity/photo.dart';
import 'package:koudai_charger/pages/PhotoView.dart';
import 'package:koudai_charger/pages/Theme.dart';
import 'package:koudai_charger/widgets/Loading.dart';
import 'Home.dart';

class SpecialPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('福利中心'),
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
      body: new MeziList(),
    );
  }
}

class MeziList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MeziSateList();
  }
}

bool _swch = false;

class MeziSateList extends State<MeziList> {
  List<PhotoData> datas = []; //初始化列表数据源
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

  void _showPhoto(String url) {
    Navigator.of(context).push(new FadeRoute(
        page: PhotoViewSimpleScreen(
      imageProvider: NetworkImage(url),
      heroTag: 'simple',
      imgurl: url,
    )));
  }

  Widget buildCardItem(BuildContext context, int index) {
    final String url = datas[index].url;

    if (index == datas.length - 1) {
      return Offstage(
        child: buildIsLoading(),
        offstage: _swch,
      );
    } else {
      return new GestureDetector(
        //点击事件
        onTap: () {
          _showPhoto(url);
        },
        child: new Card(
          child: new Container(
            padding: EdgeInsets.all(10.0),
            child: new Image.network(url),
          ),
        ),
      );
    }
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

  Future<List<PhotoData>> feach(int pageNum, int pageSize) {
    return _getDate(pageNum, pageSize);
  }

  Future<List<PhotoData>> _getDate(int pageNum, int pageSize) async {
    List flModels;
    String url =
        'https://gank.io/api/v2/data/category/Girl/type/Girl/page/$pageNum/count/$pageSize';
    // print(url);
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
              return new PhotoData.fromJson(model);
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
      return new PhotoData.fromJson(model);
    }).toList();
  }
}
