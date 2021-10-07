import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/article.dart';

abstract class NewsEvent extends Equatable{
}

class LoadAllNews extends NewsEvent{
  @override
  List<Object> get props => [];
}

class ViewArticle extends NewsEvent{
  final Source source;

  ViewArticle({this.source});

  @override
  List<Object> get props => [source];
}