import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/article.dart';
import 'package:forest_tracker/data_layer/services/news_services.dart';
import 'package:forest_tracker/logic_layer/events/news_event.dart';
import 'package:forest_tracker/logic_layer/states/news_state.dart';

class NewsBloc extends Bloc<NewsEvent,NewsState>{
  final NewsAPI newsAPI;
  NewsBloc({this.newsAPI}) : super(NewsLoading());

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    if(event is LoadAllNews){
      yield* _getAllNews(event);
    }
    else if(event is LoadArticle){
      yield* _viewArticle(event);
    }
  }

  Stream<NewsState> _getAllNews(NewsEvent event) async*{
    yield NewsLoading();
    try{
      List<Article> articles = await newsAPI.getArticles();
      yield NewsLoaded(articles: articles);
    }
    catch(e){
      yield LoadingError(errorMsg: e.toString());
    }
  }

  Stream<NewsState> _viewArticle(LoadArticle event) async*{
    yield ArticleLoading();
    if(event.article != null){
      yield ArticleLoaded(article: event.article);
    }
  }

}