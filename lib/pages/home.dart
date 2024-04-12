import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/providers/user_detail_provider.dart';

import '../components/common/icon.dart';
import '../components/common/network_image.dart';
import '../components/common/text.dart';
import '../model/goaldata.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';
import 'profile.dart';
import 'view_result.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => HomeState();
}

class HomeState extends ConsumerState<Home> {
  TextEditingController eventCtr = TextEditingController();

  String? selectedEvent;

  List<String> events = [
    "Invoathon 1.0",
    "Solvathon 2.0",
    "Ideathon 3.0",
    "Inspireathon 4.0",
    "Invoathon 5.0"
  ];

  List<String> searchedEvents = [];

  void setEvent(String event) {
    setState(() {
      eventCtr.text = event;
    });
  }

  @override
  void dispose() {
    eventCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData = ref.watch(userDataProvider) ?? {};
    List<GoalData> allGoalData = [];

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    eventCtr.addListener(() {
      setState(() {
        searchedEvents = events
            .where((element) => element
                .trim()
                .toLowerCase()
                .startsWith(eventCtr.text.trim().toLowerCase()))
            .toList();
      });
    });

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "STUDENT PROJECT",
              size: sizeData.header,
              weight: FontWeight.w800,
              color: colorData.fontColor(.8),
            ),
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Profile(),
                ),
              ),
              child: CustomNetworkImage(
                size: width * 0.11,
                radius: 8,
                url: userData["profile"],
              ),
            )
          ],
        ),
        SizedBox(height: height * 0.02),
        Container(
          height: height * 0.045,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: colorData.secondaryColor(.3),
            border: Border.all(
              color: colorData.secondaryColor(.8),
            ),
          ),
          child: TextField(
            onTap: () => setState(() {
              selectedEvent = null;
            }),
            controller: eventCtr,
            scrollPadding: EdgeInsets.zero,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: width * 0.02,
                right: width * 0.02,
              ),
              border: InputBorder.none,
              hintText: "Search Event by event name",
              hintStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: colorData.fontColor(.3),
                fontSize: sizeData.regular,
              ),
              suffixIcon: CustomIcon(
                size: aspectRatio * 50,
                icon: Icons.search,
                color: colorData.fontColor(.5),
              ),
            ),
          ),
        ),
        eventCtr.text != ""
            ? Container(
                height: height * 0.1,
                width: width,
                margin: EdgeInsets.only(top: height * 0.01),
                padding: EdgeInsets.only(
                    top: height * 0.01,
                    left: width * 0.04,
                    right: width * 0.04,
                    bottom: height * 0.005),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: colorData.secondaryColor(.3),
                  border:
                      Border.all(color: colorData.secondaryColor(1), width: 2),
                ),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: searchedEvents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        selectedEvent = searchedEvents[index];
                        eventCtr.clear();
                        searchedEvents.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                      }),
                      child: Container(
                        padding: EdgeInsets.only(bottom: height * 0.005),
                        color: Colors.transparent,
                        child: CustomText(
                          text: searchedEvents[index],
                          color: colorData.fontColor(.7),
                        ),
                      ),
                    );
                  },
                ),
              )
            : const SizedBox(),
        SizedBox(height: height * 0.03),
        selectedEvent != null
            ? CustomText(
                text: selectedEvent!.toUpperCase(),
                size: sizeData.medium,
                weight: FontWeight.w800,
                color: colorData.fontColor(1),
              )
            : const SizedBox(),
        SizedBox(height: selectedEvent != null ? height * 0.01 : 0),
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection("data").snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  allGoalData = [];
                  Map<String, Map<String, dynamic>> allData = {};
                  for (var element in snapshot.data!.docs) {
                    allData.addAll({element.id: element.data()});
                  }

                  allData.forEach((String key, Map<String, dynamic> value) {
                    String goalName = key;
                    List<String> evaluators =
                        List<String>.from(value["evaluators"]);

                    Map<String, dynamic>? projectData =
                        value["projects"] != null
                            ? Map<String, dynamic>.from(value["projects"])
                            : null;
                    List<ProjectData> allProjects = [];

                    if (projectData != null) {
                      projectData.forEach((key, value) {
                        Map<String, dynamic> projectDataMap =
                            Map<String, dynamic>.from(value);
                        String idea = key;
                        // String name = projectDataMap["name"];
                        List<String> members =
                            List<String>.from(projectDataMap["members"]);
                        Map<String, dynamic>? marksMap =
                            projectDataMap["marks"] != null
                                ? Map<String, dynamic>.from(
                                    projectDataMap["marks"])
                                : null;

                        Map<String, Map<String, dynamic>>? completeMarksMap =
                            marksMap != null
                                ? Map<String, Map<String, dynamic>>.from(
                                    marksMap)
                                : null;

                        allProjects.add(ProjectData(
                            idea: idea,
                            members: members,
                            marks: completeMarksMap));
                      });
                    }

                    allGoalData.add(GoalData(
                        name: goalName,
                        evaluators: evaluators,
                        projectData: allProjects));
                  });
                }

                return ListView.builder(
                  itemCount: 17,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: "Goal ${index + 1}",
                          weight: FontWeight.w800,
                          size: sizeData.medium,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: colorData.secondaryColor(.8),
                                border: Border.all(
                                  color: colorData.secondaryColor(1),
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(3),
                              margin: EdgeInsets.only(right: width * 0.04),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  "assets/images/sdg_goals/${index + 1}.png",
                                  height: aspectRatio * 120,
                                  width: aspectRatio * 120,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: aspectRatio * 120,
                                child: allGoalData.isNotEmpty &&
                                        allGoalData.length > index &&
                                        allGoalData[index].projectData !=
                                            null &&
                                        allGoalData[index]
                                            .projectData!
                                            .isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: allGoalData[index]
                                            .projectData!
                                            .length,
                                        itemBuilder: (context, projectIndex) {
                                          String projectTitle =
                                              allGoalData[index]
                                                  .projectData![projectIndex]
                                                  .idea;
                                          return GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewResult(
                                                  goal: allGoalData[index].name,
                                                  idea: projectTitle,
                                                ),
                                              ),
                                            ),
                                            child: Container(
                                              width: width * .4,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.015,
                                                  vertical: height * 0.001),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: colorData
                                                    .secondaryColor(.2),
                                              ),
                                              margin: EdgeInsets.only(
                                                  right: width * 0.03),
                                              alignment: Alignment.center,
                                              child: SingleChildScrollView(
                                                scrollDirection: Axis.vertical,
                                                child: CustomText(
                                                  text: projectTitle,
                                                  align: TextAlign.center,
                                                  maxLine: 6,
                                                  size: sizeData.regular,
                                                  weight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          );
                                        })
                                    : const Center(
                                        child: CustomText(
                                            text:
                                                "No projects have been added yet"),
                                      ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                      ],
                    );
                  },
                );
              }),
        ),
      ],
    );
  }
}
