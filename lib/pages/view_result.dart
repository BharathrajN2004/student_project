import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/back_button.dart';
import '../components/common/text.dart';
import '../utilities/static_data.dart';
import '../model/goaldata.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class ViewResult extends ConsumerStatefulWidget {
  const ViewResult({
    super.key,
    required this.projectData,
    required this.evaluators,
  });

  final ProjectData projectData;
  final List<String> evaluators;

  @override
  ConsumerState<ViewResult> createState() => ViewResultState();
}

class ViewResultState extends ConsumerState<ViewResult> {
  String? selectedEvaluator;

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    List<String> members = widget.projectData.members;
    List<String> evaluators = widget.evaluators;

    Map<String, Map<String, dynamic>>? allMarkData = widget.projectData.marks;

    Map<String, dynamic> allMarkValue =
        validationMap.map((key, value) => MapEntry(key, 0));
    allMarkData?.entries.forEach((e) {
      Map<String, dynamic> values = Map<String, dynamic>.from(e.value);
      values.forEach((key, value) {
        allMarkValue[key] += value;
      });
    });

    Map<String, dynamic>? evaluatorMarkData = selectedEvaluator != null &&
            allMarkData != null &&
            allMarkData[selectedEvaluator] != null
        ? Map<String, dynamic>.from(allMarkData[selectedEvaluator]!)
        : null;

    return Scaffold(
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
              SizedBox(height: height * 0.02),
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
                      text: widget.projectData.name,
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
                      text: widget.projectData.idea,
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
                              horizontal: width * 0.03,
                              vertical: height * 0.01),
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
                  Expanded(
                    child: CustomText(
                      text: selectedEvaluator ?? "All",
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
                          ? Expanded(
                              flex: 8,
                              child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: evaluatorMarkData.length,
                                  itemBuilder: (context, index) {
                                    String criteria =
                                        evaluatorMarkData.keys.toList()[index];
                                    return Container(
                                      margin: EdgeInsets.only(
                                          bottom: height * 0.01),
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
                                                color: colorData
                                                    .secondaryColor(.5),
                                              ),
                                              child: CustomText(
                                                text:
                                                    evaluatorMarkData[criteria]
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
                      : Expanded(
                          flex: 8,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: allMarkValue.length,
                              itemBuilder: (context, index) {
                                String criteria =
                                    allMarkValue.keys.toList()[index];
                                return Container(
                                  margin:
                                      EdgeInsets.only(bottom: height * 0.01),
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
                                            text: allMarkValue[criteria]
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
                            text: widget.projectData.totalMarks != null
                                ? widget.projectData.totalMarks.toString()
                                : "",
                            size: sizeData.subHeader,
                            weight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
