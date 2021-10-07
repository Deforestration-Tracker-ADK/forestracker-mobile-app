import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/project.dart';
import 'package:forest_tracker/logic_layer/blocs/project_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/projects_bloc.dart';
import 'package:forest_tracker/logic_layer/events/project_event.dart';
import 'package:forest_tracker/logic_layer/states/project_state.dart';
import 'package:forest_tracker/logic_layer/states/projects_state.dart';
import 'package:forest_tracker/presentation_layer/widgets/widgets.dart';

class ProjectPage extends StatefulWidget {
  static const String id = 'project_page';

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  bool isLoading = false;
  bool isApplied = false;

  Future<dynamic> dialogMsg(BuildContext context) {
    return showDialog(context: context,
        barrierDismissible: false,
        builder: (_)=>AlertDialog(
          title: Text('Please wait...'),
          content: Center(child: CircularProgressIndicator()),
          elevation: 3,
          scrollable: true,
          actionsAlignment: MainAxisAlignment.center,
        ));
  }
  Widget customActionButton(BuildContext context, Project project) {
    return customButton(
        onPressed: isLoading
            ? null
            : () async {
          final bloc = context.read<ProjectBloc>();
          if(isApplied){
            bloc.add(CancelProject(
                projectId: project.projectID, userId: 1));
          }
          else if(!isApplied){
            bloc.add(ApplyProject(
                projectId: project.projectID, userId: 1));
          }
        },
        text: isApplied ? 'Cancel' : 'Apply',
        style: TextStyle(fontSize: 20),
        color: isApplied? Colors.red:Colors.blue);
  }
  @override
  Widget build(BuildContext context) {
    Project project = ModalRoute.of(context).settings.arguments as Project;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Project'),
        ),
        body: BlocBuilder<ProjectsBloc, ProjectsStates>(
          buildWhen: (prevState,state){
            if(state is ProjectLoading || state is ProjectLoaded || state is ProjectErrors ){
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is ProjectLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ProjectLoaded) {
              isApplied = state.applied;
              return SingleChildScrollView(
                  padding: EdgeInsets.all(5),
                  child: customCard(builderPage(project), border: 10)
              );
            } else {
              print(state);
              throw ('error');
            }
          },
        ),
      ),
    );
  }

  Widget builderPage(Project project) {
    return WillPopScope(
      onWillPop: () async=> !isLoading,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8, top: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Center(child: badgeIcon(width: 100, height: 100)),
            SizedBox(height: 30),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(project.projectName, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400),),
                  SizedBox(height: 8,),
                  Text(project.organization, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                  SizedBox(height: 8,),
                  Text('Location : ${project.location}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                  SizedBox(height: 8,),
                  Text(project.onDate, style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                  SizedBox(height: 8,),
                  Text('Description : ${project.description}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                  SizedBox(height: 8,),
                  Text('Published Date : ${project.publishedDate}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                  SizedBox(height: 8,),
                  Text('Project Name : ${project.projectName}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400)),
                  SizedBox(height: 8,),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            BlocConsumer<ProjectBloc, ProjectState>(
              listener: (context, state) {
                if (state is LoadingState) {
                  isLoading = true;
                  dialogMsg(context);
                }
                else if (state is AppliedState) {
                  isLoading = false;
                  isApplied = true;
                  Navigator.pop(context);
                }

                else if (state is CanceledState) {
                  isLoading = false;
                  isApplied = false;
                  Navigator.pop(context);
                }
              },
              builder: (context, state) => customActionButton(context, project)
            )
          ],
        ),
      ),
    );
  }

}
