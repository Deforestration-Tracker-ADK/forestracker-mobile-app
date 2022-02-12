import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/news_bloc.dart';
import 'package:forest_tracker/logic_layer/events/news_event.dart';
import 'package:forest_tracker/logic_layer/states/news_state.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    context.read<NewsBloc>().add(LoadAllNews());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Forest Tracker"),
        ),
        body: BlocConsumer<NewsBloc, NewsState>(
            listenWhen: (prevState, state) {
              if (state is LoadingError) {
                return true;
              }
              return false;
            },
            listener: (context, state) {
              if(state is LoadingError){
                errorPopUp(context, (){
                  context.read<NewsBloc>().add(LoadAllNews());
                  Navigator.pop(context);
                });
              }
            },
            buildWhen: (prevState, state) {
              if (state is NewsLoading || state is NewsLoaded) {
                return true;
              }
              return false;
            },
            builder: (context, state) {
              if (state is NewsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is NewsLoaded) {
                return ListView.builder(
                  itemCount: state.articles.length,
                  itemBuilder: (context, index) => customCard(
                      customNewsTile(state.articles[index], context)),
                );
              } else {
                throw ('Error loading news');
              }
            }));
  }

  @override
  bool get wantKeepAlive => true;
}
