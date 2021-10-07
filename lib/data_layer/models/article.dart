class Source{
  String id;
  String name;

  Source({this.id,this.name});

  factory Source.fromJson(Map <String,dynamic> jsonData){
    return Source(
      id: jsonData['id'] as String,
      name: jsonData['name'] as String,
    );
  }
}


class Article{
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  Article({this.source, this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});

  factory Article.fromJson(Map<String,dynamic> jsonData){
    return Article(
      source: Source.fromJson(jsonData['source']),
      author: jsonData['author'] as String,
      title: jsonData['title'] as String,
      description: jsonData['description'] as String,
      url: jsonData['url'] as String,
      urlToImage: jsonData['urlToImage'] as String,
      publishedAt: jsonData['publishedAt'] as String,
      content: jsonData['content'] as String,);
  }
}

