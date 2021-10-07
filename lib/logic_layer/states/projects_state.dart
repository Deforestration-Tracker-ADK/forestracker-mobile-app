import 'package:forest_tracker/data_layer/models/project.dart';

abstract class ProjectsStates{
}

class ProjectsLoading extends ProjectsStates{
}
class ProjectLoading extends ProjectsStates{
}

class FavProjectsLoading extends ProjectsStates{
}

class AppliedProjectsLoading extends ProjectsStates{
}

class ProjectsLoaded extends ProjectsStates{
  List<Project> projects;
  ProjectsLoaded({this.projects});

  ProjectsLoaded copyWith({List<Project> projects}){
    return ProjectsLoaded(
      projects: projects ?? this.projects,
    );
  }
}

class FavProjectsLoaded extends ProjectsStates{
  List<Project> projects;
  FavProjectsLoaded({this.projects});

  FavProjectsLoaded copyWith({List<Project> projects}){
    return FavProjectsLoaded(
      projects: projects ?? this.projects,
    );
  }
}

class AppliedProjectsLoaded extends ProjectsStates{
  final List<Project> projects;
  AppliedProjectsLoaded({this.projects});

  AppliedProjectsLoaded copyWith({List<Project> projects}){
    return AppliedProjectsLoaded(
      projects: projects ?? this.projects,
    );
  }
}

class ProjectLoaded extends ProjectsStates{
  Project project;
  bool applied;
  ProjectLoaded({this.project,this.applied});

  ProjectLoaded copyWith({Project project,bool applied}){
    return ProjectLoaded(
      project: project??this.project,
      applied: applied??this.applied
    );
  }
}

class ProjectErrors extends ProjectsStates{
  String error;
  ProjectErrors({this.error});
}




