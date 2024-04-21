import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/components/auth/login_textfield.dart';
import 'package:student_project/functions/create/create_userData.dart';
import 'package:student_project/pages/goal_search.dart';
import 'package:student_project/providers/data_provider.dart';
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

  EventData? selectedEvent;

  List<EventData> searchedEvents = [];
  bool showContainer = false;
  TextEditingController eventController = TextEditingController();

  @override
  void dispose() {
    eventCtr.dispose();
    eventController.dispose();
    super.dispose();
  }

  Future<void> generateEventData(int numEvents, int minProjectsPerGoal) async {
    final Random random = Random();

    Map<String, Map<String, Map<String, dynamic>>> eventData = {};

    List<String> events = [
      "Inovathon",
      "Ideathon",
      "Inspireathon",
      "Solvathon"
    ];

    for (int i = 1; i <= numEvents; i++) {
      events.shuffle();
      String eventName = "${events[0]} $i.0";
      Map<String, Map<String, dynamic>> eventDetails = {};

      // Generate goals
      for (int j = 1; j <= 17; j++) {
        String goalName = "goal $j";
        Map<String, dynamic> goalDetails = {};

        // // Generate evaluators
        // List<String> evaluators = [];
        // for (int k = 0; k < 2; k++) {
        //   evaluators.add("evaluator${random.nextInt(50)}@example.com");
        // }
        // goalDetails["evaluators"] = evaluators;

        // Generate projects
        Map<String, Map<String, dynamic>> projects = {};
        for (int l = 1; l <= minProjectsPerGoal; l++) {
          String projectName =
              "Project ${String.fromCharCode(65 + random.nextInt(26))}${String.fromCharCode(65 + random.nextInt(26))}${random.nextInt(100)} $l";
          Map<String, dynamic> projectDetails = {
            "id": l.toString(),
            "members": ["Member 1", "Member 2", "Member 3"],
            "name":
                "Team ${String.fromCharCode(65 + random.nextInt(26))}${String.fromCharCode(65 + random.nextInt(26))}${random.nextInt(100)}"
          };
          projects[projectName] = projectDetails;
        }
        goalDetails["projects"] = projects;

        eventDetails[goalName] = goalDetails;
      }

      eventData[eventName] = eventDetails;
      await FirebaseFirestore.instance
          .collection("events")
          .doc(eventName)
          .set(eventDetails, SetOptions(merge: true));
    }
  }

  void updateSearchedEvents(List<EventData> allEventData) {
    setState(() {
      if (eventCtr.text.isNotEmpty) {
        searchedEvents = allEventData
            .where((element) => element.name
                .toLowerCase()
                .startsWith(eventCtr.text.trim().toLowerCase()))
            .toList();
      } else {
        searchedEvents = allEventData;
      }
    });
  }

  bool checkForProject(int index) {
    return selectedEvent != null &&
        selectedEvent!.goalData.isNotEmpty &&
        selectedEvent!.goalData.length > index &&
        selectedEvent!.goalData[index].projectData != null &&
        selectedEvent!.goalData[index].projectData!.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    eventCtr.addListener(() {
      setState(() {});
    });
    // generateEventData(10, 6);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData = ref.watch(userDataProvider) ?? {};
    List<EventData> allEventData = ref.watch(dataProvider) ?? [];

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    searchedEvents = allEventData
        .where((element) => eventCtr.text.isNotEmpty
            ? element.name
                .toLowerCase()
                .startsWith(eventCtr.text.trim().toLowerCase())
            : true)
        .toList();

    selectedEvent?.goalData.sort((a, b) => int.parse(a.name.split(" ")[1])
        .compareTo(int.parse(b.name.split(" ")[1])));

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
        SizedBox(height: height * 0.02),
        Align(
          alignment: Alignment.topLeft,
          child: Row(
            children: [
              CustomText(
                text: "Create Event",
                size: sizeData.header,
                weight: FontWeight.w700,
                color: colorData.fontColor(.8),
              ),
              const SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showContainer = !showContainer;
                  });
                },
                child: Container(
                  width: width * 0.08,
                  height: height * 0.035,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: colorData.primaryColor(.3),
                  ),
                  child: CustomIcon(
                    size: aspectRatio * 50,
                    icon: showContainer ? Icons.remove : Icons.add,
                    color: colorData.fontColor(.5),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: height * 0.02),
        showContainer
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: height * 0.04,
                    width: width * 0.6,
                    child: Container(
                      alignment: Alignment.center,
                      height: height * 0.045,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorData.secondaryColor(.3),
                        border: Border.all(
                          color: colorData.secondaryColor(.8),
                        ),
                      ),
                      child: TextField(
                        controller: eventController,
                        scrollPadding: EdgeInsets.zero,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            left: width * 0.02,
                            right: width * 0.02,
                            bottom: width * 0.02,
                          ),
                          border: InputBorder.none,
                          hintText: "Type the Event name",
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: colorData.fontColor(.3),
                            fontSize: sizeData.regular,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      createEvent(eventname: eventController.text.trim());
                      eventController.clear();
                    },
                    child: Container(
                      height: height * 0.04,
                      width: width * 0.2,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: colorData.primaryColor(.3),
                      ),
                      child: Row(
                        children: [
                          CustomIcon(
                            size: aspectRatio * 50,
                            icon: Icons.upload,
                            color: colorData.fontColor(.5),
                          ),
                          const CustomText(
                            text: "Update",
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              )
            : const SizedBox(),
        showContainer ? SizedBox(height: height * 0.02) : const SizedBox(),
        searchedEvents.isEmpty && eventCtr.text.isNotEmpty
            ? Center(
                child: CustomText(
                  text: "No event's are available with this name",
                  color: colorData.fontColor(.7),
                  weight: FontWeight.w600,
                ),
              )
            : SizedBox(
                height: height * 0.04,
                width: width,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: searchedEvents.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => setState(() {
                        if (selectedEvent == searchedEvents[index]) {
                          selectedEvent = null;
                        } else {
                          selectedEvent = searchedEvents[index];
                        }
                        eventCtr.clear();
                        searchedEvents = allEventData;
                        FocusScope.of(context).requestFocus(FocusNode());
                      }),
                      child: Container(
                        margin: EdgeInsets.only(right: width * 0.03),
                        padding: EdgeInsets.symmetric(
                            vertical: height * 0.005, horizontal: width * 0.02),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: selectedEvent == searchedEvents[index]
                              ? colorData.secondaryColor(.5)
                              : colorData.secondaryColor(.1),
                          border: Border.all(
                            color: selectedEvent == searchedEvents[index]
                                ? colorData.secondaryColor(.8)
                                : colorData.secondaryColor(.4),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          text: searchedEvents[index].name,
                          color: colorData.fontColor(
                              selectedEvent == searchedEvents[index] ? 1 : .7),
                        ),
                      ),
                    );
                  },
                ),
              ),
        SizedBox(height: height * 0.02),
        selectedEvent != null
            ? CustomText(
                text: selectedEvent!.name.toUpperCase(),
                size: sizeData.medium,
                weight: FontWeight.w800,
                color: colorData.fontColor(1),
              )
            : const SizedBox(),
        SizedBox(height: selectedEvent != null ? height * 0.01 : 0),
        Expanded(
          child: selectedEvent != null
              ? ListView.builder(
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
                            GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => GoalWiseSearch(
                                          goalData:
                                              selectedEvent!.goalData[index]))),
                              child: Container(
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
                            ),
                            Expanded(
                              child: SizedBox(
                                height: aspectRatio * 120,
                                child: checkForProject(index)
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: selectedEvent!
                                            .goalData[index]
                                            .projectData!
                                            .length,
                                        itemBuilder: (context, projectIndex) {
                                          String projectTitle = selectedEvent!
                                              .goalData[index]
                                              .projectData![projectIndex]
                                              .idea;
                                          return GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ViewResult(
                                                  projectData: selectedEvent!
                                                          .goalData[index]
                                                          .projectData![
                                                      projectIndex],
                                                  evaluators: selectedEvent!
                                                      .goalData[index]
                                                      .evaluators,
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
                )
              : Center(
                  child: CustomText(
                      text: "Select a Event to view the projects!",
                      size: sizeData.medium,
                      weight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
