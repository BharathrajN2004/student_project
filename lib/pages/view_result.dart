import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/components/common/back_button.dart';
import 'package:student_project/components/common/text.dart';

import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class ViewResult extends ConsumerStatefulWidget {
  const ViewResult({super.key});

  ConsumerState<ViewResult> createState() => ViewResultState();
}

class ViewResultState extends ConsumerState<ViewResult> {
  String? selectedStaff;

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

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
                      text: "Name of the team",
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
                      text: "The title of the project",
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
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(right: width * 0.02),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.03,
                              vertical: height * 0.01),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorData.secondaryColor(.3),
                          ),
                          child: CustomText(text: "Member $index"),
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
                    text: "Staff:",
                    weight: FontWeight.w700,
                    color: colorData.fontColor(.6),
                    size: sizeData.medium,
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: CustomText(
                      text: selectedStaff ?? "All",
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
                    text: "Staffs:",
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
                          itemBuilder: (context, index) {
                            bool isSelected = selectedStaff == "staff $index";
                            return GestureDetector(
                              onTap: () => setState(() {
                                if (isSelected) {
                                  selectedStaff = null;
                                } else {
                                  selectedStaff = "staff $index";
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
                                child: CustomText(text: "Staff $index"),
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
              Expanded(
                flex: 8,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(bottom: height * 0.01),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: CustomText(
                                text: "Productable",
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
                                  text: "22",
                                  size: sizeData.medium,
                                  weight: FontWeight.bold,
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
                      text: "220",
                      size: sizeData.subHeader,
                      weight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}


// TextField(
//                                   keyboardType: TextInputType.number,
//                                   style: TextStyle(
//                                     fontSize: sizeData.medium,
//                                     height: .5,
//                                   ),
//                                   decoration: InputDecoration(
//                                     border: InputBorder.none,
//                                     hintText: "0 - 30",
//                                     hintStyle: TextStyle(
//                                       fontSize: sizeData.regular,
//                                       color: colorData.fontColor(.6),
//                                       height: .5,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),