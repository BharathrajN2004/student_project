// import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/goaldata.dart';

class DataProvider extends StateNotifier<List<EventData>?> {
  DataProvider() : super(null);

  void addGoalData(EventData data) {
    List<EventData> list = state ?? [];
    list.add(data);
    state = list;
  }

  void fetchGoalData(List<QueryDocumentSnapshot<Map<String, dynamic>>> data) {
    List<EventData> eventsData = [];

    for (QueryDocumentSnapshot<Map<String, dynamic>> snapshot in data) {
      List<GoalData> allGoalData = [];

      Map<String, dynamic> eventMap = snapshot.data();

      eventMap.forEach((key, value) {
        String goalName = key;
        List<String> evaluators = value["evaluators"] != null
            ? List<String>.from(value["evaluators"])
            : [];

        Map<String, dynamic>? projectData = value["projects"] != null
            ? Map<String, dynamic>.from(value["projects"])
            : null;
        List<ProjectData> allProjects = [];

        if (projectData != null) {
          projectData.forEach((key, value) {
            Map<String, dynamic> projectDataMap =
                Map<String, dynamic>.from(value);
            String idea = key;
            String name = projectDataMap["name"];
            String id = projectDataMap["id"];
            String teamLead = projectDataMap["teamLead"] ?? "";
            List<String> members = List<String>.from(projectDataMap["members"]);
            Map<String, Map>? marksMap = projectDataMap["marks"] != null
                ? Map<String, Map>.from(projectDataMap["marks"])
                : null;

            Map<String, Map<String, dynamic>>? completeMarksMap =
                marksMap != null
                    ? Map<String, Map<String, dynamic>>.from(marksMap)
                    : null;

            int? totalMarks = projectDataMap["total"] != null
                ? int.parse(projectDataMap["total"].toString())
                : null;

            allProjects.add(ProjectData(
                idea: idea,
                members: members,
                marks: completeMarksMap,
                id: id,
                name: name,
                teamLead: teamLead,
                totalMarks: totalMarks));
          });
        }

        allGoalData.add(GoalData(
            name: goalName, evaluators: evaluators, projectData: allProjects));

        // if (evaluators.isNotEmpty) {
        //   print("$goalName  :  ${snapshot.id}");
        //   print(evaluators);
        // }
      });

      EventData event = EventData(name: snapshot.id, goalData: allGoalData);

      eventsData.add(event);
    }
    state = eventsData;
  }
}

final dataProvider = StateNotifierProvider<DataProvider, List<EventData>?>(
    (ref) => DataProvider());
