abstract class ProjectsEvents {
  final int projectId;
  ProjectsEvents({this.projectId});
}

class LoadProjects extends ProjectsEvents {}

class ViewMore extends ProjectsEvents {
  ViewMore({int projectId}) : super(projectId: projectId);

  ViewMore copyWith({int projectId}){
    return ViewMore(projectId: projectId??this.projectId);
  }
}

class GetAllFavProjects extends ProjectsEvents {
}

class GetAllAppliedProjects extends ProjectsEvents {
}
