import 'dart:convert';
import 'package:forest_tracker/data_layer/models/article.dart';
import 'package:http/http.dart' as http;


class NewsAPI{
  static final String _apiKey = 'api';
  final uri = Uri.parse('https://newsapi.org/v2/everything?domains=wsj.com&apiKey=$_apiKey');

  Future getArticles() async {
    var res = await http.get(uri);

    if(res.statusCode == 200){
      Map<String,dynamic> jSonData = json.decode(res.body);
      List<dynamic> jSonBody = jSonData['articles'];

      List<Article> articles = jSonBody.map((dynamic data) => Article.fromJson(data)).toList();

      return articles;
    }
    else{
      throw('Articles can not be loaded....');
    }
  }

}