// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/goaldata.dart';

class DataProvider extends StateNotifier<List<GoalData>?> {
  DataProvider() : super(null);

  void addGoalData(GoalData goalData) {
    List<GoalData> list = state ?? [];
    list.add(goalData);
    state = list;
  }

  void fetchGoalData(Map<String, Map<String, dynamic>> data) {
    List<GoalData> allGoalData = [];
    data.forEach((String key, Map<String, dynamic> value) {
      String goalName = key;
      List<String> evaluators = List<String>.from(value["evaluators"]);

      Map<String, dynamic>? projectData = value["projects"] != null
          ? Map<String, dynamic>.from(value["projects"])
          : null;
      List<ProjectData> allProjects = [];

      if (projectData != null) {
        projectData.forEach((key, value) {
          Map<String, dynamic> projectDataMap =
              Map<String, dynamic>.from(value);
          String idea = key;
          // String name = projectDataMap["name"];
          List<String> members = List<String>.from(projectDataMap["members"]);
          Map<String, dynamic>? marksMap = projectDataMap["marks"] != null
              ? Map<String, dynamic>.from(projectDataMap["marks"])
              : null;

          Map<String, Map<String, int>>? completeMarksMap = marksMap != null
              ? Map<String, Map<String, int>>.from(marksMap)
              : null;

          allProjects.add(ProjectData(
              idea: idea, members: members, marks: completeMarksMap));
        });
      }

      allGoalData.add(GoalData(
          name: goalName, evaluators: evaluators, projectData: allProjects));
    });

    state = allGoalData;
  }
}

final dataProvider = StateNotifierProvider<DataProvider, List<GoalData>?>(
    (ref) => DataProvider());
