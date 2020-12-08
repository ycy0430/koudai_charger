import 'package:local_cache_sync/local_cache_sync.dart';

class NewsData {
  String sId;
  String author;
  String category;
  String createdAt;
  String desc;
  List<String> images;
  int likeCounts;
  String publishedAt;
  int stars;
  String title;
  String type;
  String url;
  int views;
  bool iscollect = false;

  NewsData({
    this.sId,
    this.author,
    this.category,
    this.createdAt,
    this.desc,
    this.images,
    this.likeCounts,
    this.publishedAt,
    this.stars,
    this.title,
    this.type,
    this.url,
    this.views,
    this.iscollect,
  });

  NewsData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    author = json['author'];
    category = json['category'];
    createdAt = json['createdAt'];
    desc = json['desc'];
    images = json['images'].cast<String>();
    likeCounts = json['likeCounts'];
    publishedAt = json['publishedAt'];
    stars = json['stars'];
    title = json['title'];
    type = json['type'];
    url = json['url'];
    views = json['views'];
  }
}
