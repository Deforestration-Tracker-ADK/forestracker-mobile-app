import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/article.dart';

abstract class NewsState extends Equatable{
}

class NewsLoading extends NewsState{
  @override
  List<Object> get props => [];
}

class ArticleLoading extends NewsState{
  @override
  List<Object> get props => [];
}

class NewsLoaded extends NewsState{
  final List<Article> articles;

  NewsLoaded({this.articles});
  @override
  List<Article> get props => articles;
}

class ArticleLoaded extends NewsState{
  final Article article;

  ArticleLoaded({this.article});
  @override
  List<Article> get props => [article];
}

class LoadingError extends NewsState{
  final String errorMsg;

  LoadingError({this.errorMsg});

  @override
  List<String> get props => [errorMsg];

}