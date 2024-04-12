import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/components/common/datatable.dart';

import '../components/common/text.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class Export extends ConsumerStatefulWidget {
  const Export({super.key});
  @override
  ConsumerState<Export> createState() => ExportState();
}

class ExportState extends ConsumerState<Export> {
  Map<File, String> excelData = {};

  List<List<dynamic>> excelValues = [];

  void readExcelFile(File file) async {
    setState(() {
      excelValues = [];
    });
    var bytes = file.readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<List<Data?>> sheet = excel['Sheet1'].rows;

    for (var row in sheet) {
      List<String> rowStrings = [];
      for (var index = 0; index < 6; index++) {
        row[index] != null && row[index]!.value != null
            ? rowStrings.add(row[index]!.value.toString())
            : '';
      }
      setState(() {
        rowStrings.isNotEmpty ? excelValues.add(rowStrings) : null;
      });
    }
  }

  void uploadData() async {
    List<dynamic> header = excelValues[0];

    try {
      for (var i in excelValues.sublist(1)) {
        int SDGindex = header.indexOf("SDG");
        int titleIndex = header.indexOf("Title");
        int problemId = header.indexOf("Prob Id");
        int nameIndex = header.indexOf("Team Name");
        int leadIndex = header.indexOf("Team Leader");

        List teamMembers = [];
        teamMembers.add(i[leadIndex]);
        Map<String, dynamic> dataToUpload = {
          i[titleIndex].toString(): {
            "id": i[problemId],
            "name": i[nameIndex],
            "members": teamMembers,
          }
        };

        await FirebaseFirestore.instance
            .collection("data")
            .doc("goal ${i[SDGindex]}")
            .set({"projects": dataToUpload}, SetOptions(merge: true));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(child: Text("Data uploaded successfully")),
        ),
      );
      setState(() {
        excelData.clear();
        excelValues.clear();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Center(
            child: Text("Error on uploading the data"),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    // double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        CustomText(
          text: "PROCESS DATA",
          size: sizeData.header,
          weight: FontWeight.w800,
          color: colorData.fontColor(.8),
        ),
        SizedBox(height: height * 0.04),
        Row(
          children: [
            CustomText(
              text: "Upload projects data",
              size: sizeData.medium,
            ),
            SizedBox(width: width * 0.1),
            GestureDetector(
              onTap: () async {
                FilePickerResult? excelSheetResult =
                    await FilePicker.platform.pickFiles(
                  allowMultiple: false,
                  allowedExtensions: ["csv", "xlsx", "xls", "gsheet"],
                  type: FileType.custom,
                  allowCompression: true,
                );
                if (excelSheetResult != null) {
                  PlatformFile excelSheet = excelSheetResult.files.first;
                  File fileData = File(excelSheet.path.toString());
                  String name = excelSheet.name.toString();
                  Map<File, String> file = {fileData: name};
                  setState(() {
                    excelData = file;
                    readExcelFile(file.keys.first);
                  });
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * 0.01,
                  horizontal: width * 0.03,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorData.secondaryColor(.5),
                ),
                child: const CustomText(
                  text: "IMPORT",
                  weight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: height * 0.01),
        excelData.isNotEmpty
            ? Row(
                children: [
                  CustomText(
                    text: "File Uploaded: ",
                    size: sizeData.small,
                    color: colorData.fontColor(.5),
                  ),
                  SizedBox(width: width * 0.04),
                  CustomText(
                    text: excelData.values.first,
                    color: colorData.fontColor(.7),
                  ),
                ],
              )
            : const SizedBox(),
        SizedBox(height: excelData.isNotEmpty ? height * 0.02 : 0),
        excelValues.isNotEmpty
            ? SizedBox(
                height: height * 0.5, child: DataPreview(data: excelValues))
            : const SizedBox(),
        SizedBox(height: excelData.isNotEmpty ? height * 0.02 : 0),
        excelValues.isNotEmpty
            ? Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => uploadData(),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.03,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colorData.secondaryColor(.5),
                    ),
                    child: const CustomText(
                      text: "UPLOAD",
                      weight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

