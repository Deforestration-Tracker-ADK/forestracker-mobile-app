import 'package:equatable/equatable.dart';

class Project extends Equatable{
  int projectID;
  String projectName;
  String organization;
  String onDate;
  String publishedDate;
  String description;
  String location;
  bool isFav;
  bool isApplied;
  static List<int> appliedProjects = [];
  static List<int> favProjects = [];

  Project({this.projectID,this.projectName, this.organization, this.onDate, this.publishedDate,this.description, this.location,this.isFav,this.isApplied});

  factory Project.fromJson(Map<String,dynamic> jsonData){
    return Project(
        projectID: jsonData['projectID'] as int,
        projectName: jsonData['projectName'] as String,
        organization : jsonData['organization'] as String,
        onDate :jsonData['onDate'] as String ,
        publishedDate :jsonData['publishedDate'] as String,
        description :jsonData['description'] as String,
        location :jsonData['location'] as String,
        isFav: jsonData['isFav'] as bool,
        isApplied: jsonData['isApplied'] as bool,
    );
  }

  @override
  List<Object> get props => [projectID,projectName,organization,onDate,publishedDate,description,location,isApplied];





}