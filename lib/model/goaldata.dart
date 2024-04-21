class EventData {
  String name;
  List<GoalData> goalData;

  EventData({
    required this.name,
    required this.goalData,
  });
}

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
  String name;
  String id;
  List<String> members;
  String teamLead;
  Map<String, Map<String, dynamic>>? marks;
  int? totalMarks;

  ProjectData({
    required this.idea,
    required this.name,
    required this.id,
    required this.members,
    required this.teamLead,
    this.totalMarks,
    this.marks,
  });
}
