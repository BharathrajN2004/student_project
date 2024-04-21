import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/model/goaldata.dart';
import 'package:student_project/pages/evaluator_detail.dart';
import 'package:student_project/utilities/static_data.dart';

import '../components/common/icon.dart';
import '../components/common/network_image.dart';
import '../components/common/text.dart';
import '../providers/data_provider.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class Evaluators extends ConsumerStatefulWidget {
  const Evaluators({super.key});

  ConsumerState<Evaluators> createState() => EvaluatorState();
}

class EvaluatorState extends ConsumerState<Evaluators> {
  TextEditingController eventCtr = TextEditingController();

  EventData? selectedEvent;

  List<EventData> searchedEvents = [];

  @override
  void dispose() {
    eventCtr.dispose();
    super.dispose();
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

  bool checkForEvaluators(int index) {
    return selectedEvent != null &&
        selectedEvent!.goalData.isNotEmpty &&
        selectedEvent!.goalData.length > index &&
        selectedEvent!.goalData[index].evaluators.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    eventCtr.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
        CustomText(
          text: "EVALUATORS DATA",
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
                size: aspectRatio * 50,
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
                                  builder: (context) => EvaluatorDetail(
                                    from: From.add,
                                    goal: "goal ${index + 1}",
                                    eventName: selectedEvent!.name,
                                  ),
                                ),
                              ),
                              child: Container(
                                height: aspectRatio * 100,
                                width: aspectRatio * 100,
                                margin: EdgeInsets.only(right: width * 0.04),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorData.secondaryColor(.6),
                                ),
                                child: CustomIcon(
                                  icon: Icons.add,
                                  size: aspectRatio * 60,
                                  color: colorData.fontColor(.8),
                                ),
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                height: aspectRatio * 120,
                                child: checkForEvaluators(index)
                                    ? StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection("users")
                                            .snapshots(),
                                        builder: (context, snapshot) {
                                          List<Map<String, dynamic>>
                                              evaluatorData = [];
                                          if (snapshot.hasData &&
                                              snapshot.data!.docs.isNotEmpty) {
                                            evaluatorData = snapshot.data!.docs
                                                .where((element) =>
                                                    selectedEvent!
                                                        .goalData[index]
                                                        .evaluators
                                                        .contains(element.id))
                                                .map((e) {
                                              Map<String, dynamic> data =
                                                  e.data();
                                              data.addAll({"email": e.id});
                                              return data;
                                            }).toList();
                                          }

                                          return ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: evaluatorData.length,
                                              itemBuilder:
                                                  (context, evaluatorIndex) {
                                                return GestureDetector(
                                                  onTap: () => Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          EvaluatorDetail(
                                                        from: From.edit,
                                                        goal:
                                                            "goal ${index + 1}",
                                                        data: evaluatorData[
                                                            evaluatorIndex],
                                                        eventName:
                                                            selectedEvent!.name,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal:
                                                                width * 0.015,
                                                            vertical:
                                                                height * 0.001),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: colorData
                                                          .secondaryColor(.2),
                                                    ),
                                                    margin: EdgeInsets.only(
                                                        right: width * 0.03),
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      children: [
                                                        CustomNetworkImage(
                                                          size:
                                                              aspectRatio * 120,
                                                          radius: 8,
                                                          url: evaluatorData[
                                                                  evaluatorIndex]
                                                              ["profile"],
                                                        ),
                                                        SizedBox(
                                                            width:
                                                                width * 0.02),
                                                        CustomText(
                                                          text: evaluatorData[
                                                                  evaluatorIndex]
                                                              ["name"],
                                                          align:
                                                              TextAlign.center,
                                                          maxLine: 3,
                                                          size:
                                                              sizeData.regular,
                                                          weight:
                                                              FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        })
                                    : const Center(
                                        child: CustomText(
                                            text:
                                                "No Evaluators have been added yet"),
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
                      text: "Select a Event to view the evaluators!",
                      size: sizeData.medium,
                      weight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
