import 'package:equatable/equatable.dart';

class Source extends Equatable{
  final String id;
  final String name;

  Source({this.id,this.name});

  factory Source.fromJson(Map <String,dynamic> jsonData){
    return Source(
      id: jsonData['id'] as String,
      name: jsonData['name'] as String,
    );
  }

  @override
  List<String> get props => [id,name];
}


class Article extends Equatable{
  final Source source;
  final String author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String publishedAt;
  final String content;

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

  @override
  List<Object> get props => [source,author,title,description,url,urlToImage,publishedAt,content];
}

