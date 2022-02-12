import 'package:equatable/equatable.dart';
import 'package:forest_tracker/data_layer/models/article.dart';

abstract class NewsEvent extends Equatable{
}

class LoadAllNews extends NewsEvent{
  @override
  List<Object> get props => [];
}
