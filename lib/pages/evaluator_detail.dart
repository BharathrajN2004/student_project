// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/components/common/photo_picker.dart';
import 'package:student_project/functions/create/evaluator.dart';
import 'package:student_project/functions/update/update_evaluatordata.dart';
import 'package:student_project/utilities/static_data.dart';

import '../components/common/back_button.dart';
import '../components/common/text.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class EvaluatorDetail extends ConsumerStatefulWidget {
  const EvaluatorDetail(
      {super.key,
      required this.from,
      this.data,
      required this.goal,
      required this.eventName});

  final From from;
  final Map<String, dynamic>? data;
  final String goal;
  final String eventName;

  @override
  ConsumerState<EvaluatorDetail> createState() => _EvaluatorDetailState();
}

class _EvaluatorDetailState extends ConsumerState<EvaluatorDetail> {
  TextEditingController nameCtr = TextEditingController();
  TextEditingController specializationCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController phoneNoCtr = TextEditingController();

  Map<File, String> photo = {};
  String? photoUrl;

  void setPhoto(File photo, String photoName) {
    setState(() {
      this.photo = {photo: photoName};
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.from == From.edit) {
      emailCtr.text = widget.data!["email"];
      nameCtr.text = widget.data!["name"];
      specializationCtr.text = widget.data!["specialization"];
      phoneNoCtr.text = widget.data!["phoneNo"];
      photoUrl = widget.data!["profile"];
    }
  }

  @override
  void dispose() {
    nameCtr.dispose();
    specializationCtr.dispose();
    emailCtr.dispose();
    phoneNoCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

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
              SizedBox(height: height * 0.04),
              PhotoPicker(
                from: widget.from,
                setter: setPhoto,
                photoURL: photoUrl,
              ),
              SizedBox(height: height * 0.04),
              Row(
                children: [
                  CustomText(
                    text: "Name:",
                    weight: FontWeight.w700,
                    color: colorData.fontColor(.6),
                    size: sizeData.medium,
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorData.secondaryColor(.5),
                        border: Border.all(
                            color: colorData.secondaryColor(.8), width: 2),
                      ),
                      height: height * 0.04,
                      child: TextField(
                        controller: nameCtr,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: sizeData.subHeader,
                          fontWeight: FontWeight.w600,
                          color: colorData.fontColor(.8),
                          height: 1,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the Evaluator Name",
                          hintStyle: TextStyle(
                            fontSize: sizeData.medium,
                            color: colorData.fontColor(.6),
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  CustomText(
                    text: "Specialization:",
                    weight: FontWeight.w700,
                    color: colorData.fontColor(.6),
                    size: sizeData.medium,
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorData.secondaryColor(.5),
                        border: Border.all(
                            color: colorData.secondaryColor(.8), width: 2),
                      ),
                      height: height * 0.08,
                      child: TextField(
                        controller: specializationCtr,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: sizeData.subHeader,
                          fontWeight: FontWeight.w600,
                          color: colorData.fontColor(.8),
                          height: 1.25,
                        ),
                        maxLines: 3,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the Evaluator Specialization",
                          hintStyle: TextStyle(
                            fontSize: sizeData.medium,
                            color: colorData.fontColor(.6),
                            height: 1.25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  CustomText(
                    text: "Email ID:",
                    weight: FontWeight.w700,
                    color: colorData.fontColor(.6),
                    size: sizeData.medium,
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorData.secondaryColor(.5),
                        border: Border.all(
                            color: colorData.secondaryColor(.8), width: 2),
                      ),
                      height: height * 0.04,
                      child: TextField(
                        readOnly: widget.from == From.edit,
                        controller: emailCtr,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: sizeData.subHeader,
                          fontWeight: FontWeight.w600,
                          color: colorData.fontColor(.8),
                          height: 1,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the Evaluator Email ID",
                          hintStyle: TextStyle(
                            fontSize: sizeData.medium,
                            color: colorData.fontColor(.6),
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.02),
              Row(
                children: [
                  CustomText(
                    text: "Phone No:",
                    weight: FontWeight.w700,
                    color: colorData.fontColor(.6),
                    size: sizeData.medium,
                  ),
                  SizedBox(width: width * 0.02),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: width * 0.02),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorData.secondaryColor(.5),
                        border: Border.all(
                            color: colorData.secondaryColor(.8), width: 2),
                      ),
                      height: height * 0.04,
                      child: TextField(
                        controller: phoneNoCtr,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: sizeData.subHeader,
                          fontWeight: FontWeight.w600,
                          color: colorData.fontColor(.8),
                          height: 1,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter the Evaluator Phone No",
                          hintStyle: TextStyle(
                            fontSize: sizeData.medium,
                            color: colorData.fontColor(.6),
                            height: 1,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height * 0.08),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () async {
                    if (widget.from == From.add) {
                      if (nameCtr.text.isNotEmpty &&
                          emailCtr.text.isNotEmpty &&
                          phoneNoCtr.text.isNotEmpty &&
                          specializationCtr.text.isNotEmpty) {
                        await createEvaluator(
                          {
                            "profile": photo.keys.first,
                            "name": nameCtr.text,
                            "email": emailCtr.text,
                            "phoneNo": phoneNoCtr.text,
                            "specialization": specializationCtr.text,
                            "goal": widget.goal,
                            "event": widget.eventName
                          },
                          widget.eventName,
                        ).then((value) =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Center(
                                  child: Text(
                                      "Evaluator details saved successfully"),
                                ),
                              ),
                            ));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text("Kindly enter all the data"),
                            ),
                          ),
                        );
                      }
                    } else {
                      print(widget.data!['name']);
                      print(nameCtr.text.isEmpty);
                      print(nameCtr.text);
                      await updateEvaluatorData(
                        {
                          "profile": photo.keys.isEmpty
                              ? widget.data!['profile']
                              : photo.keys.first,
                          "name": nameCtr.text.isEmpty
                              ? widget.data!['name']
                              : nameCtr.text,
                          "email": widget.data!['email'],
                          "phoneNo": phoneNoCtr.text.isEmpty
                              ? widget.data!['phoneNo']
                              : phoneNoCtr.text,
                          "specialization": specializationCtr.text.isEmpty
                              ? widget.data!['specialization']
                              : specializationCtr.text,
                        },
                        photo.keys.isEmpty ? "firebasepath" : "filepath",
                      ).then(
                        (value) => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Center(
                              child: Text(
                                  "Evaluator details updated successfully"),
                            ),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    }

                    // if (nameCtr.text.isNotEmpty &&
                    //     emailCtr.text.isNotEmpty &&
                    //     phoneNoCtr.text.isNotEmpty &&
                    //     specializationCtr.text.isNotEmpty) {
                    //   bool check;
                    //   if (widget.from == From.add) {
                    //     check = await createEvaluator(
                    //       {
                    //         "profile": photo.keys.first,
                    //         "name": nameCtr.text,
                    //         "email": emailCtr.text,
                    //         "phoneNo": phoneNoCtr.text,
                    //         "specialization": specializationCtr.text,
                    //         "goal": widget.goal,
                    //         "event": widget.eventName
                    //       },
                    //       widget.eventName,
                    //     );
                    //   } else {
                    //     print('Updation');
                    //     check = await updateEvaluatorData(
                    //       {
                    //         "profile": photo.keys.isEmpty
                    //             ? widget.data!['profile']
                    //             : photo.keys.first,
                    //         "name": nameCtr.text.isEmpty
                    //             ? widget.data!['name']
                    //             : nameCtr.text,
                    //         "email": widget.data!['email'],
                    //         "phoneNo": phoneNoCtr.text.isEmpty
                    //             ? widget.data!['phoneNo']
                    //             : phoneNoCtr.text,
                    //         "specialization": specializationCtr.text.isEmpty
                    //             ? widget.data!['specialization']
                    //             : specializationCtr.text,
                    //       },
                    //     );
                    //   }
                    //   if (check) {
                    //     Navigator.pop(context);
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Center(
                    //             child: Text(
                    //                 "Evaluator details saved successfully")),
                    //       ),
                    //     );
                    //   } else {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(
                    //         content: Center(
                    //             child: Text("Kindly enter all the data")),
                    //       ),
                    //     );
                    //   }
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content:
                    //           Center(child: Text("Kindly enter all the data")),
                    //     ),
                    //   );
                    // }
                  },
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
                      text: widget.from == From.add ? "SAVE" : "UPDATE",
                      size: sizeData.medium,
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
