class NewsValueData {
  String sId;
  String author;
  String category;
  String content;
  String createdAt;
  String desc;
  String email;
  List<String> images;
  int index;
  bool isOriginal;
  String license;
  int likeCounts;
  List likes;
  String markdown;
  String originalAuthor;
  String publishedAt;
  int stars;
  int status;
  List tags;
  String title;
  String type;
  String updatedAt;
  String url;
  int views;

  NewsValueData(
      {this.sId,
      this.author,
      this.category,
      this.content,
      this.createdAt,
      this.desc,
      this.email,
      this.images,
      this.index,
      this.isOriginal,
      this.license,
      this.likeCounts,
      this.likes,
      this.markdown,
      this.originalAuthor,
      this.publishedAt,
      this.stars,
      this.status,
      this.tags,
      this.title,
      this.type,
      this.updatedAt,
      this.url,
      this.views});

  NewsValueData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    author = json['author'];
    category = json['category'];
    content = json['content'];
    createdAt = json['createdAt'];
    desc = json['desc'];
    email = json['email'];
    images = json['images'].cast<String>();
    index = json['index'];
    isOriginal = json['isOriginal'];
    license = json['license'];
    likeCounts = json['likeCounts'];
    likes = json['like'].cast<String>();
    markdown = json['markdown'];
    originalAuthor = json['originalAuthor'];
    publishedAt = json['publishedAt'];
    stars = json['stars'];
    status = json['status'];
    tags = json['tags'].cast<String>();
    title = json['title'];
    type = json['type'];
    updatedAt = json['updatedAt'];
    url = json['url'];
    views = json['views'];
  }
}
