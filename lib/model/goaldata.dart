class GoalData {
  String name;
  List<String> evaluators;
  List<ProjectData>? projectData;

  GoalData({
    required this.name,
    required this.evaluators,
    this.projectData,
  });
}

class ProjectData {
  String idea;
  // String name;
  List<String> members;
  Map<String, Map<String, dynamic>>? marks;

  ProjectData({
    required this.idea,
    // required this.name,
    required this.members,
    this.marks,
  });
}
