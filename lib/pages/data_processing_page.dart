import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart' as Excel;
import 'package:csv/csv.dart';
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/components/common/datatable.dart';

import '../components/common/icon.dart';
import '../components/common/text.dart';
import '../model/goaldata.dart';
import '../providers/data_provider.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class DataProcessingPage extends ConsumerStatefulWidget {
  const DataProcessingPage({super.key});
  @override
  ConsumerState<DataProcessingPage> createState() => DataProcessingPageState();
}

class DataProcessingPageState extends ConsumerState<DataProcessingPage> {
  TextEditingController eventCtr = TextEditingController();

  EventData? selectedEvent;

  List<EventData> searchedEvents = [];

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

  @override
  void initState() {
    super.initState();
    eventCtr.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    eventCtr.dispose();
    super.dispose();
  }

  Map<File, String> excelData = {};

  List<List<dynamic>> excelValues = [];

  Future<String> generateExcelFile({List<List>? bodyData}) async {
    List<List> body = [];
    List<String> header = [
      'SDG',
      'Title',
      'Prob Id',
      'Team Name',
      'Team Learder',
      'Team Members',
    ];
    body.add(header);
    if (bodyData != null) {
      body.addAll(bodyData);
    } else {
      body.add([
        '1',
        'Project title',
        '2314',
        'Team xxyyzz',
        'Leader YYY',
        'member1, member2, member3',
      ]);
    }

    // exportCSV.myCSV(header, body);
    String csv = const ListToCsvConverter().convert(body);

    String fileName = bodyData != null ? selectedEvent!.name : "sample_import";

    final directoryPath = await getExternalStorageDirectory();
    final path = "${directoryPath!.path}/$fileName.csv";
    final File file = File(path);
    await file.writeAsString(csv);
    return file.path;
  }

  void readExcelFile(File file) async {
    setState(() {
      excelValues = [];
    });
    var bytes = file.readAsBytesSync();
    var excel = Excel.Excel.decodeBytes(bytes);

    List<List<Excel.Data?>> sheet = excel['Sheet1'].rows;

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
    List<dynamic> header =
        excelValues[0].map((e) => e.toString().toLowerCase()).toList();

    try {
      for (var i in excelValues.sublist(1)) {
        int SDGindex = header.indexOf("sdg");
        int titleIndex = header.indexOf("title");
        int problemId = header.indexOf("prob id");
        int nameIndex = header.indexOf("team name");
        int leadIndex = header.indexOf("team leader");
        int membersIndex = header.indexOf("team members");

        Set teamMembers = Set.from(
            i[membersIndex].toString().trim().split(",").map((e) => e.trim()));
        teamMembers.add(i[leadIndex]);

        Map<String, dynamic> dataToUpload = {
          i[titleIndex].toString(): {
            "id": i[problemId],
            "name": i[nameIndex],
            "members": teamMembers,
            "leader": i[leadIndex],
          }
        };

        await FirebaseFirestore.instance
            .collection("data")
            .doc(selectedEvent!.name)
            .set({
          "goal ${i[SDGindex]}": {"projects": dataToUpload}
        }, SetOptions(merge: true));
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
    List<EventData> allEventData = ref.watch(dataProvider) ?? [];

    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    // double aspectRatio = sizeData.aspectRatio;

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
        CustomText(
          text: "PROCESS DATA",
          size: sizeData.header,
          weight: FontWeight.w800,
          color: colorData.fontColor(.8),
        ),
        SizedBox(height: height * 0.04),
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
                size: sizeData.aspectRatio * 50,
                icon: Icons.search,
                color: colorData.fontColor(.5),
              ),
            ),
          ),
        ),
        SizedBox(height: height * 0.02),
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
        SizedBox(height: selectedEvent != null ? height * 0.02 : height * 0.01),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    CustomText(
                      text: "Upload projects data",
                      size: sizeData.medium,
                    ),
                    SizedBox(width: width * 0.1),
                    GestureDetector(
                      onTap: () async {
                        if (selectedEvent != null) {
                          FilePickerResult? excelSheetResult =
                              await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            allowedExtensions: ["csv", "xlsx", "xls", "gsheet"],
                            type: FileType.custom,
                            allowCompression: true,
                          );
                          if (excelSheetResult != null) {
                            PlatformFile excelSheet =
                                excelSheetResult.files.first;
                            File fileData = File(excelSheet.path.toString());
                            String name = excelSheet.name.toString();
                            Map<File, String> file = {fileData: name};
                            setState(() {
                              excelData = file;
                              readExcelFile(file.keys.first);
                            });
                          }
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Center(
                            child: CustomText(
                              text:
                                  "Kindly choose a event to upload project data!",
                              color: Colors.white,
                            ),
                          )));
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
                        child: CustomText(
                          text: "IMPORT",
                          weight: FontWeight.bold,
                          color: selectedEvent == null
                              ? colorData.fontColor(.3)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.01),
                GestureDetector(
                  onTap: () async {
                    String filePath = await generateExcelFile();
                    OpenFile.open(filePath);
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: "Click to Download the sample Excel sheet",
                      size: sizeData.regular,
                      color: colorData.primaryColor(.6),
                      weight: FontWeight.w600,
                      maxLine: 2,
                    ),
                  ),
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
                        height: height * 0.5,
                        child: DataPreview(data: excelValues))
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
                SizedBox(
                    height:
                        excelValues.isNotEmpty ? height * 0.03 : height * .2),
                Row(
                  children: [
                    CustomText(
                      text: "Export projects data",
                      size: sizeData.medium,
                    ),
                    SizedBox(width: width * 0.1),
                    GestureDetector(
                      onTap: () async {
                        if (selectedEvent != null) {
                          List<List> excelData =
                              selectedEvent!.goalData.map((goalData) {
                            int goalNo = int.parse(goalData.name.split(" ")[1]);
                            if (goalData.projectData != null) {
                              return goalData.projectData!.map((projectData) {
                                return [
                                  goalNo,
                                  projectData.idea,
                                  projectData.id,
                                  projectData.name,
                                  projectData.teamLead,
                                  projectData.members.join(","),
                                ];
                              }).toList();
                            } else {
                              return [];
                            }
                          }).toList();

                          generateExcelFile(bodyData: excelData);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                                  content: Center(
                            child: CustomText(
                              text:
                                  "Kindly choose a event to upload project data!",
                              color: Colors.white,
                            ),
                          )));
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
                        child: CustomText(
                          text: "EXPORT",
                          weight: FontWeight.bold,
                          color: selectedEvent == null
                              ? colorData.fontColor(.3)
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
