import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forest_tracker/data_layer/models/project.dart';
import 'package:forest_tracker/data_layer/roughData.dart';
import 'package:forest_tracker/logic_layer/blocs/project_bloc.dart';
import 'package:forest_tracker/logic_layer/blocs/projects_bloc.dart';
import 'package:forest_tracker/logic_layer/events/project_event.dart';
import 'package:forest_tracker/logic_layer/events/projects_event.dart';
import 'package:forest_tracker/logic_layer/states/project_state.dart';
import 'package:forest_tracker/logic_layer/states/projects_state.dart';
import 'package:forest_tracker/presentation_layer/pages/project_page.dart';
import 'package:forest_tracker/presentation_layer/widgets/components.dart';
import 'package:forest_tracker/presentation_layer/widgets/widgets.dart';
import 'applied_projects_screen.dart';
import 'fav_projects_screen.dart';

class ProjectScreen extends StatefulWidget {
  static const String id = 'project_screen';

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> with AutomaticKeepAliveClientMixin {

  @override
  void initState() {
    context.read<ProjectsBloc>().add(LoadProjects());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    super.build(context);
    void _onPressed(project) {
      BlocProvider.of<ProjectsBloc>(context).add(ViewMore(projectId: project.projectID));
      Navigator.pushNamed(context, ProjectPage.id, arguments: project);
    }

    void _onIconTap(project) {
      bool isFav = project.isFav;
      final bloc = context.read<ProjectBloc>();
      if (!isFav) {
        bloc.add(FavProject(projectId: project.projectID, isFavourite: true));
      } else {
        bloc.add(FavProject(projectId: project.projectID, isFavourite: false));
      }
    }

    void _onTap(String selected) {
      if (selected == Constant.props[0]) {
        BlocProvider.of<ProjectsBloc>(context).add(GetAllFavProjects());
        Navigator.pushNamed(context, FavProjectScreen.id);
      } else {
        BlocProvider.of<ProjectsBloc>(context).add(GetAllAppliedProjects());
        Navigator.pushNamed(context, AppliedProjectScreen.id);
      }
    }

    Widget projectCard(Project project) {
      return BlocConsumer<ProjectBloc, ProjectState>(
          listener: (context, state) => {
                if (state is ProjectFav){
                  projects[state.id - 1].isFav = state.isFav
                }
              },
          builder: (context, state) =>
              customTile(project, _onPressed, onTap: _onIconTap));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Project Page'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return Constant.props
                  .map((selected) => PopupMenuItem(
                        value: selected,
                        child: Text(selected),
                      ))
                  .toList();
            },
            onSelected: _onTap,
          )
        ],
      ),
      body: BlocBuilder<ProjectsBloc, ProjectsStates>(
        // ignore: missing_return
        buildWhen: (prevState,state){
          if(state is ProjectsLoading||state is ProjectsLoaded || state is ProjectErrors ){
            return true;
          }
          return false;
        },
        // ignore: missing_return
        builder: (context, state) {
          if (state is ProjectsLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProjectsLoaded) {
            return ListView.builder(
              itemCount: state.projects.length,
              itemBuilder: (context, project) =>
                  customCard(projectCard(state.projects[project])),
            );
          }
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
