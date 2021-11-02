import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/project_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/projects_bloc.dart';
import 'package:forest_tracker/logic_layer/events/project_event.dart';
import 'package:forest_tracker/logic_layer/events/projects_event.dart';
import 'package:forest_tracker/logic_layer/states/projects_state.dart';
import 'package:forest_tracker/presentation_layer/pages/project_page.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';

class FavProjectScreen extends StatefulWidget {
  static const String id = 'fav_project_screen';
  @override
  _FavProjectScreenState createState() => _FavProjectScreenState();
}

class _FavProjectScreenState extends State<FavProjectScreen> {

  void _onPressed(project) {
    BlocProvider.of<ProjectsBloc>(context).add(ViewMore(projectId: project.projectID));
    Navigator.pushNamed(context, ProjectPage.id, arguments: project);
  }

  void _onDismiss(project,direction){
    final bloc = context.read<ProjectBloc>();
    bloc.add(FavProject(projectId: project.projectID, isFavourite: false));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Project remove from the favourites'),
      duration: Duration(seconds: 1),
    ));
    }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('Fav Projects'),),
      body: BlocBuilder<ProjectsBloc, ProjectsStates>(
        buildWhen: (prevState,state){
          if(state is FavProjectsLoading || state is FavProjectsLoaded || state is ProjectErrors ){
            return true;
          }
          return false;
        },
        // ignore: missing_return
        builder: (context,state){
          if(state is FavProjectsLoading){
            return Center(child: CircularProgressIndicator());
          }
          else if(state is FavProjectsLoaded){
            return ListView.builder(
              itemCount: state.projects.length,
              itemBuilder: (context, project) {
                print(project);
                  return Dismissible(
                    key: UniqueKey(),
                    child: customCard(customTile(state.projects[project], _onPressed,noIcon: true)),
                    onDismissed:(direction)=> _onDismiss(state.projects[project],direction),
                    background: Container(color: Colors.greenAccent,)
                  );}
            );
          }
          else if(state is ProjectErrors){
            print(state.error);
          }
          else{
            throw ('undefine state');
          }}
      )
    );
  }
}
