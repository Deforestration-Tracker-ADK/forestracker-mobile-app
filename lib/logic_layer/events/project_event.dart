abstract class ProjectEvent{
  int projectId;
}
class FavProject extends ProjectEvent {
  bool isFavourite;
  int projectId;
  FavProject({this.projectId, this.isFavourite}) ;

  FavProject copyWith(projectId, isFavourite){
    return FavProject(projectId: projectId??this.projectId,isFavourite: isFavourite??this.isFavourite);
  }
}

class ApplyProject extends ProjectEvent{
  final int projectId;
  final int userId;
  ApplyProject({this.projectId,this.userId});

  ApplyProject copyWith({int projectID,int userID}){
    return ApplyProject(
      userId: userId?? this.userId,
      projectId: projectId?? this.projectId,
    );
  }
}

class CancelProject extends ProjectEvent{
  final int projectId;
  final int userId;
  CancelProject({this.projectId,this.userId});

  CancelProject copyWith({int projectID,int userID}){
    return CancelProject(
      userId: userId?? this.userId,
      projectId: projectId?? this.projectId,
    );
  }
}

