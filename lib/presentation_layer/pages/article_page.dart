import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/article.dart';
import 'package:forest_tracker/logic_layer/blocs/news_bloc.dart';
import 'package:forest_tracker/logic_layer/states/news_state.dart';
import 'package:forest_tracker/presentation_layer/utilities/components.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';

class ViewArticle extends StatelessWidget {
  static const String id = 'article_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Page'),
      ),
      body: BlocBuilder<NewsBloc,NewsState>(
        buildWhen: (prevState,state){
          if(state is ArticleLoading || state is ArticleLoaded){
            return true;
          }
          return false;
        },
        builder: (context,state){
          if(state is ArticleLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          else if(state is ArticleLoaded){
            return customCard(customArticleTile(state.article));
          }
          else{
            throw('undefined article state');
          }
        }
      )
    );
  }
}
Widget customArticleTile(Article article) => Column(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(article.urlToImage), fit: BoxFit.cover),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            topRight: Radius.circular(12)),
      ),
    ),
    SizedBox(
      height: 8.0,
    ),
    Padding(
      padding: EdgeInsets.only(left: 10.0, right: 5.0),
      child: Text(
        article.title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    ),
    Divider(thickness: 4,),
    Padding(
      padding: EdgeInsets.only(left: 10.0, right: 5.0),
      child: Text(
        article.description,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
        ),
      ),
    ),
    Divider(thickness: 4,),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 5.0),
          child: Text(
            article.author,
            style: TextFontDecoration.copyWith(fontSize: 10)
          ),
        ),
        SizedBox(width: 10,),
        Padding(
          padding: EdgeInsets.only(left: 10.0, right: 5.0),
          child: Text(
            article.publishedAt,
            style: TextFontDecoration.copyWith(fontSize: 10),
          ),
        )
      ],
    )
  ],
);