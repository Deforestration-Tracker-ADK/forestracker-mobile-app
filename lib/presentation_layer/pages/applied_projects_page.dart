import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/projects_bloc.dart';
import 'package:forest_tracker/logic_layer/events/projects_event.dart';
import 'package:forest_tracker/logic_layer/states/projects_state.dart';
import 'package:forest_tracker/presentation_layer/pages/project_page.dart';
import 'package:forest_tracker/presentation_layer/utilities/widgets.dart';

class AppliedProjectScreen extends StatefulWidget {
  static const String id = 'applied_project_screen';
  @override
  _AppliedProjectScreenState createState() => _AppliedProjectScreenState();
}

class _AppliedProjectScreenState extends State<AppliedProjectScreen> {

  void _onPressed(project) {
    BlocProvider.of<ProjectsBloc>(context).add(ViewMore(projectId: project.projectID));
    Navigator.pushNamed(context, ProjectPage.id, arguments: project);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Applied Projects'),),
      body: BlocBuilder<ProjectsBloc, ProjectsStates>(
          buildWhen: (prevState,state){
            if(state is AppliedProjectsLoading || state is AppliedProjectsLoaded || state is ProjectErrors ){
              return true;
            }
            return false;
          },
          // ignore: missing_return
          builder: (context,state){
            if(state is AppliedProjectsLoading){
              return Center(child: CircularProgressIndicator());
            }
            else if(state is AppliedProjectsLoaded){
              return ListView.builder(
                  itemCount: state.projects.length,
                  itemBuilder: (context, project) =>
                      customCard(customProjectTile(state.projects[project], _onPressed,noIcon: true))
              );
            }
            else if(state is ProjectErrors){
              print(state.error);
            }
            else{
              throw ('undefine state');
            }}
      ),
    );
  }
}
