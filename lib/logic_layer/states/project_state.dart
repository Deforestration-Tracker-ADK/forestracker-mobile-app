abstract class ProjectState{}

class LoadingState extends ProjectState{}

class ProjectFav extends ProjectState{
  bool isFav;
  int id;
  ProjectFav({this.isFav,this.id});
}


class AppliedState extends ProjectState{
}

class CanceledState extends ProjectState{
}
class BlockButton extends ProjectState{
  bool isBlocked;
  BlockButton({this.isBlocked});
}

class ProjectError extends ProjectState{
  String error;
  ProjectError({this.error});
}