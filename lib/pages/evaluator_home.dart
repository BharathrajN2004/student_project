import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/icon.dart';
import '../components/common/network_image.dart';
import '../components/common/text.dart';
import '../model/goaldata.dart';
import '../providers/data_provider.dart';
import '../providers/user_detail_provider.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';
import 'evaluation.dart';
import 'profile.dart';

class EvaluatorHome extends ConsumerStatefulWidget {
  const EvaluatorHome({super.key});

  @override
  ConsumerState<EvaluatorHome> createState() => EvaluatorHomeState();
}

class EvaluatorHomeState extends ConsumerState<EvaluatorHome> {
  TextEditingController searchCtr = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchCtr.addListener(() {
      setState(() {});
    });
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

    EventData userEventData = allEventData.firstWhere((element) =>
        element.name.toLowerCase() ==
        userData["event"].toString().toLowerCase());

    List<GoalData> userGoalDataList = userEventData.goalData
        .where((element) => element.evaluators.contains(userData["email"]))
        .toList();

    userGoalDataList.sort((a, b) => int.parse(a.name.split(" ")[1])
        .compareTo(int.parse(b.name.split(" ")[1])));

    List<ProjectData> searchedProjects = searchCtr.text.isNotEmpty
        ? userGoalDataList
            .map((e) {
              List<ProjectData> projectData = [];
              if (e.projectData != null) {
                projectData = e.projectData!
                    .where((element) => element.idea
                        .toLowerCase()
                        .startsWith(searchCtr.text.trim()))
                    .toList();
              }
              return projectData;
            })
            .toList()
            .expand((innerList) => innerList)
            .toList()
        : [];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.06,
            right: width * 0.06,
            top: height * 0.02,
          ),
          child: Column(
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
                  controller: searchCtr,
                  scrollPadding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: width * 0.02,
                      right: width * 0.02,
                    ),
                    border: InputBorder.none,
                    hintText: "Search Teams by name",
                    hintStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: colorData.fontColor(.3),
                        fontSize: sizeData.regular),
                    suffixIcon: CustomIcon(
                      size: aspectRatio * 50,
                      icon: Icons.search,
                      color: colorData.fontColor(.5),
                    ),
                  ),
                ),
              ),
              searchCtr.text.isNotEmpty
                  ? Container(
                      height: height * 0.04,
                      width: width,
                      margin: EdgeInsets.only(top: height * 0.01),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: searchedProjects.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => setState(() {
                              searchCtr.clear();
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EvaluationPage(
                                    goal: userGoalDataList
                                        .firstWhere((element) =>
                                            element.projectData != null
                                                ? element.projectData!.contains(
                                                    searchedProjects[index])
                                                : false)
                                        .name,
                                    projectData: searchedProjects[index],
                                  ),
                                ),
                              );
                            }),
                            child: Container(
                              margin: EdgeInsets.only(right: width * 0.03),
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.005,
                                  horizontal: width * 0.02),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: colorData.secondaryColor(.1),
                                border: Border.all(
                                  color: colorData.secondaryColor(.4),
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: CustomText(
                                text: searchedProjects[index].idea,
                                color: colorData.fontColor(.7),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
              SizedBox(height: height * 0.04),
              Expanded(
                child: ListView.builder(
                  itemCount: userGoalDataList.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: userGoalDataList[index].name[0].toUpperCase() +
                              userGoalDataList[index].name.substring(1),
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
                                    width: 2),
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
                                child: userGoalDataList.isNotEmpty &&
                                        userGoalDataList.length > index &&
                                        userGoalDataList[index].projectData !=
                                            null &&
                                        userGoalDataList[index]
                                            .projectData!
                                            .isNotEmpty
                                    ? ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: userGoalDataList[index]
                                            .projectData!
                                            .length,
                                        itemBuilder: (context, projectIndex) {
                                          String projectTitle =
                                              userGoalDataList[index]
                                                  .projectData![projectIndex]
                                                  .idea;
                                          return GestureDetector(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    EvaluationPage(
                                                  goal: userGoalDataList[index]
                                                      .name,
                                                  projectData:
                                                      userGoalDataList[index]
                                                              .projectData![
                                                          projectIndex],
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
