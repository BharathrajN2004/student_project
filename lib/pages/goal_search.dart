import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/back_button.dart';
import '../components/common/icon.dart';
import '../components/common/text.dart';
import '../utilities/static_data.dart';
import '../model/goaldata.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class GoalWiseSearch extends ConsumerStatefulWidget {
  const GoalWiseSearch({
    super.key,
    required this.goalData,
  });

  final GoalData goalData;

  @override
  ConsumerState<GoalWiseSearch> createState() => GoalWiseSearchState();
}

class GoalWiseSearchState extends ConsumerState<GoalWiseSearch> {
  TextEditingController searchCtr = TextEditingController();

  ProjectData? selectedProject;
  String? selectedEvaluator;

  String selectedSearchField = searchFields[0];

  @override
  void initState() {
    super.initState();
    searchCtr.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    List<ProjectData> searchedProjects = searchCtr.text.isNotEmpty
        ? widget.goalData.projectData != null
            ? widget.goalData.projectData!.where((element) {
                if (selectedSearchField == searchFields[0]) {
                  return element.idea
                      .toLowerCase()
                      .startsWith(searchCtr.text.trim());
                } else if (selectedSearchField == searchFields[1]) {
                  return element.name
                      .toLowerCase()
                      .startsWith(searchCtr.text.trim());
                } else {
                  return element.id
                      .toLowerCase()
                      .startsWith(searchCtr.text.trim());
                }
              }).toList()
            : []
        : widget.goalData.projectData ?? [];

    List<String> members = [];
    List<String> evaluators = [];
    Map<String, Map<String, dynamic>>? allMarkData = {};
    Map<String, dynamic> allMarkValue =
        validationMap.map((key, value) => MapEntry(key, 0));
    Map<String, dynamic>? evaluatorMarkData = {};

    if (selectedProject != null) {
      members = selectedProject!.members;
      evaluators = widget.goalData.evaluators;
      allMarkData = selectedProject!.marks;

      allMarkData?.entries.forEach((e) {
        Map<String, dynamic> values = Map<String, dynamic>.from(e.value);
        values.forEach((key, value) {
          allMarkValue[key] += value;
        });
      });
      evaluatorMarkData = selectedEvaluator != null &&
              allMarkData != null &&
              allMarkData[selectedEvaluator] != null
          ? Map<String, dynamic>.from(allMarkData[selectedEvaluator]!)
          : null;
    }

    List<Widget> widgetList = selectedProject != null
        ? [
            Row(
              children: [
                CustomText(
                  text: "Name:",
                  weight: FontWeight.w600,
                  color: colorData.fontColor(.6),
                  size: sizeData.medium,
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: CustomText(
                    text: selectedProject!.name,
                    size: sizeData.medium,
                    maxLine: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.015),
            Row(
              children: [
                CustomText(
                  text: "Title:",
                  weight: FontWeight.w700,
                  color: colorData.fontColor(.6),
                  size: sizeData.medium,
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: CustomText(
                    text: selectedProject!.idea,
                    size: sizeData.medium,
                    maxLine: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.015),
            Row(
              children: [
                CustomText(
                  text: "Members:",
                  weight: FontWeight.w700,
                  color: colorData.fontColor(.6),
                  size: sizeData.medium,
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: SizedBox(
                    height: height * 0.04,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: members.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(right: width * 0.02),
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03, vertical: height * 0.01),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorData.secondaryColor(.3),
                        ),
                        child: CustomText(text: members[index]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.015),
            Row(
              children: [
                CustomText(
                  text: "Selected:",
                  weight: FontWeight.w700,
                  color: colorData.fontColor(.6),
                  size: sizeData.medium,
                ),
                SizedBox(width: width * 0.02),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    CustomText(
                      text: selectedEvaluator ?? "All",
                      size: sizeData.medium,
                      maxLine: 2,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: height * 0.015),
            Row(
              children: [
                CustomText(
                  text: "Evaluators:",
                  weight: FontWeight.w700,
                  color: colorData.fontColor(.6),
                  size: sizeData.medium,
                ),
                SizedBox(width: width * 0.02),
                Expanded(
                  child: SizedBox(
                    height: height * 0.04,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: evaluators.length,
                        itemBuilder: (context, index) {
                          bool isSelected =
                              selectedEvaluator == evaluators[index];
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (isSelected) {
                                selectedEvaluator = null;
                              } else {
                                selectedEvaluator = evaluators[index];
                              }
                            }),
                            child: Container(
                              margin: EdgeInsets.only(right: width * 0.02),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.01),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: colorData
                                    .secondaryColor(isSelected ? .8 : .3),
                              ),
                              child: CustomText(text: evaluators[index]),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
            SizedBox(height: height * 0.015),
            CustomText(
              text: "Evaluated Values:",
              size: sizeData.medium,
              weight: FontWeight.bold,
              color: colorData.fontColor(.6),
            ),
            SizedBox(height: height * 0.01),
            allMarkData != null
                ? selectedEvaluator != null
                    ? evaluatorMarkData != null
                        ? Column(
                            children:
                                List.generate(validationMap.length, (index) {
                              String criteria =
                                  evaluatorMarkData!.keys.toList()[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: height * 0.01),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 8,
                                      child: CustomText(
                                        text: criteria,
                                        size: sizeData.medium,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        height: height * 0.04,
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.03,
                                            vertical: height * 0.01),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          color: colorData.secondaryColor(.5),
                                        ),
                                        child: CustomText(
                                          text: evaluatorMarkData[criteria]
                                              .toString(),
                                          size: sizeData.medium,
                                          weight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          )
                        : Center(
                            child: CustomText(
                                align: TextAlign.center,
                                maxLine: 3,
                                text:
                                    "$selectedEvaluator have not yet evaluated this team!"),
                          )
                    : Column(
                        children: List.generate(validationMap.length, (index) {
                          String criteria = allMarkValue.keys.toList()[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: height * 0.01),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 8,
                                  child: CustomText(
                                    text: criteria,
                                    size: sizeData.medium,
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: height * 0.04,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.03,
                                        vertical: height * 0.01),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: colorData.secondaryColor(.5),
                                    ),
                                    child: CustomText(
                                      text: allMarkValue[criteria].toString(),
                                      size: sizeData.medium,
                                      weight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      )
                : const Center(
                    child: CustomText(
                        text: "Evaluation has not yet begun for this team."),
                  ),
            SizedBox(height: height * 0.015),
            allMarkData != null
                ? CustomText(
                    text:
                        "Only ${allMarkData.keys.toString()} has evaluated this team.",
                    size: sizeData.small,
                    maxLine: 3,
                  )
                : const SizedBox(),
            SizedBox(height: height * 0.015),
            allMarkData != null
                ? Row(
                    children: [
                      CustomText(
                        text: "Total Mark:",
                        weight: FontWeight.w700,
                        color: colorData.fontColor(.6),
                        size: sizeData.medium,
                      ),
                      SizedBox(width: width * 0.02),
                      Expanded(
                        child: CustomText(
                          text: selectedProject!.totalMarks != null
                              ? selectedProject!.totalMarks.toString()
                              : "",
                          size: sizeData.subHeader,
                          weight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                : const SizedBox(),
            SizedBox(height: height * 0.02),
          ]
        : [
            const Center(
              child:
                  CustomText(text: "Kindly select a project to view the data!"),
            )
          ];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomBackButton(),
              SizedBox(height: height * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  searchFields.length,
                  (index) => GestureDetector(
                    onTap: () => setState(() {
                      selectedSearchField = searchFields[index];
                    }),
                    child: Container(
                      margin: EdgeInsets.only(right: width * 0.02),
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.03,
                        vertical: height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          right: index != 2
                              ? BorderSide(
                                  color: colorData.secondaryColor(1), width: 3)
                              : BorderSide.none,
                        ),
                      ),
                      child: CustomText(
                        text: searchFields[index],
                        color: selectedSearchField == searchFields[index]
                            ? colorData.fontColor(.8)
                            : colorData.fontColor(.5),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: height * 0.045,
                margin: EdgeInsets.only(top: height * 0.02),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: colorData.secondaryColor(.3),
                  border: Border.all(
                    color: colorData.secondaryColor(.8),
                  ),
                ),
                child: TextField(
                  onTap: () => setState(() {
                    selectedEvaluator = null;
                  }),
                  controller: searchCtr,
                  scrollPadding: EdgeInsets.zero,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      left: width * 0.02,
                      right: width * 0.02,
                    ),
                    border: InputBorder.none,
                    hintText: "Search Project by $selectedSearchField",
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
              searchedProjects.isEmpty && searchCtr.text.isNotEmpty
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
                        itemCount: searchedProjects.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => setState(() {
                              if (selectedProject == searchedProjects[index]) {
                                selectedProject = null;
                              } else {
                                selectedProject = searchedProjects[index];
                              }
                              searchCtr.clear();
                              searchedProjects =
                                  widget.goalData.projectData ?? [];
                              FocusScope.of(context).requestFocus(FocusNode());
                            }),
                            child: Container(
                              margin: EdgeInsets.only(right: width * 0.03),
                              padding: EdgeInsets.symmetric(
                                  vertical: height * 0.005,
                                  horizontal: width * 0.02),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color:
                                    selectedProject == searchedProjects[index]
                                        ? colorData.secondaryColor(.5)
                                        : colorData.secondaryColor(.1),
                                border: Border.all(
                                  color:
                                      selectedProject == searchedProjects[index]
                                          ? colorData.secondaryColor(.8)
                                          : colorData.secondaryColor(.4),
                                  width: 2,
                                ),
                              ),
                              alignment: Alignment.center,
                              child: CustomText(
                                text: selectedSearchField == searchFields[0]
                                    ? searchedProjects[index].idea
                                    : selectedSearchField == searchFields[1]
                                        ? searchedProjects[index].name
                                        : searchedProjects[index].id,
                                color: colorData.fontColor(
                                    selectedProject == searchedProjects[index]
                                        ? 1
                                        : .7),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              SizedBox(height: height * 0.02),
              Expanded(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: widgetList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
