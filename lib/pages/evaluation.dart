import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/model/goaldata.dart';
import 'package:student_project/providers/user_detail_provider.dart';
import 'package:student_project/utilities/static_data.dart';

import '../components/common/back_button.dart';
import '../components/common/text.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class EvaluationPage extends ConsumerStatefulWidget {
  const EvaluationPage(
      {super.key, required this.projectData, required this.goal});

  final ProjectData projectData;
  final String goal;

  @override
  ConsumerState<EvaluationPage> createState() => _EvaluationPageState();
}

class _EvaluationPageState extends ConsumerState<EvaluationPage> {
  bool firstTime = false;
  Map<String, int> evaluationData = validationMap.map(
    (key, value) => MapEntry(key, 0),
  );

  @override
  void initState() {
    super.initState();
    firstTime = true;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> userData = ref.watch(userDataProvider)!;
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    List<String> members = widget.projectData.members;

    Map<String, Map<String, dynamic>>? allMarkData = widget.projectData.marks;

    Map<String, dynamic>? evaluatorMarkData = userData["email"] != null &&
            allMarkData != null &&
            allMarkData[userData["email"]] != null
        ? Map<String, dynamic>.from(allMarkData[userData["email"]]!)
        : null;

    if (evaluatorMarkData != null) {
      evaluationData.forEach((key, value) {
        evaluationData[key] = evaluatorMarkData[key];
      });
    }

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
                    text: "Team Name:",
                    weight: FontWeight.w700,
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
              Expanded(
                flex: 8,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: validationMap.length,
                    itemBuilder: (context, index) {
                      String criteria = validationMap.keys.toList()[index];
                      return Container(
                        margin: EdgeInsets.only(bottom: height * 0.01),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: CustomText(
                                text: validationMap.keys.toList()[index],
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
                                child: TextFormField(
                                  readOnly: evaluatorMarkData != null,
                                  initialValue: evaluatorMarkData != null
                                      ? evaluatorMarkData[criteria].toString()
                                      : null,
                                  onChanged: (value) {
                                    setState(() {
                                      int mark = int.parse(value);
                                      if (mark >= 0 &&
                                          mark <= validationMap[criteria]!) {
                                        evaluationData[criteria] = mark;
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Center(
                                                child: Text(
                                                    "Kindly enter the value with in the range 0 to ${validationMap[validationMap.keys.toList()[index]]!}")),
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                    fontSize: sizeData.medium,
                                    color: colorData.fontColor(.8),
                                    height: .5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText:
                                        "0 - ${validationMap.values.toList()[index]}",
                                    hintStyle: TextStyle(
                                      fontSize: sizeData.regular,
                                      color: colorData.fontColor(.6),
                                      height: .5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(height: height * 0.015),
              Row(
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
                      text: evaluationData.values
                          .fold(0, (previous, current) => previous + current)
                          .toString(),
                      size: sizeData.subHeader,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Visibility(
                visible: evaluatorMarkData == null,
                child: GestureDetector(
                  onTap: () {
                    try {
                      FirebaseFirestore.instance
                          .collection("events")
                          .doc(userData["event"])
                          .set({
                        widget.goal: {
                          "projects": {
                            widget.projectData.idea: {
                              "marks": {userData["email"]: evaluationData},
                              "total": FieldValue.increment(
                                  evaluationData.values.fold(
                                      0,
                                      (previous, current) =>
                                          previous + current)),
                            }
                          }
                        },
                      }, SetOptions(merge: true));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child: Text("Successfuly updated the data"),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                              child: Text("The mark updation is unsuccessful")),
                        ),
                      );
                    }
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width * 0.1, vertical: height * 0.015),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorData.secondaryColor(.5),
                        border: Border.all(
                            color: colorData.secondaryColor(.8), width: 2),
                      ),
                      child: CustomText(
                        text: "SAVE MARKS",
                        size: sizeData.medium,
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
