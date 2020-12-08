import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HomeNewsCell extends StatefulWidget {
  HomeNewsCell(this.url);
  final url;
  @override
  _HomeNewsCellState createState() => _HomeNewsCellState(this.url);
}

class _HomeNewsCellState extends State<HomeNewsCell> {
  List listData = [
    {
      "title": "高仿喜马拉雅Android客户端",
      "desc": "11",
      "images": ["https://gank.io/images/75f729c8a2ce44a2a68de71fd2574663"],
    }
  ];
  // String url;
  _HomeNewsCellState(this.url);
  final url;
  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    Response response = await Dio().get(url);
    print(response.data["data"]);
    setState(() {
      listData = response.data["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: listData.map((value) {
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
                leading: Padding(
                  padding: EdgeInsets.all(2),
                  child: Image.network(
                    value["images"][0],
                    height: 80,
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/newsview',
                      arguments: {'id': value["title"]});
                },
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
