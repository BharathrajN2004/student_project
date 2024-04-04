import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:student_project/pages/evaluator_detail.dart';

import '../components/common/icon.dart';
import '../components/common/network_image.dart';
import '../components/common/text.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class Evaluators extends ConsumerWidget {
  const Evaluators({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(
              text: "EVALUATORS DATA",
              size: sizeData.header,
              weight: FontWeight.w800,
              color: colorData.fontColor(.8),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                vertical: height * 0.01,
                horizontal: width * 0.03,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: colorData.secondaryColor(.5),
              ),
              child: const CustomText(
                text: "EXPORT",
                weight: FontWeight.bold,
              ),
            ),
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
            scrollPadding: EdgeInsets.zero,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                left: width * 0.02,
                right: width * 0.02,
              ),
              border: InputBorder.none,
              hintText: "Search Evaluator by name",
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
        SizedBox(height: height * 0.04),
        Expanded(
          child: ListView.builder(
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
                      Container(
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
                      Expanded(
                        child: SizedBox(
                          height: aspectRatio * 120,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const EvaluatorDetail(),
                                ),
                              ),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.015,
                                    vertical: height * 0.001),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorData.secondaryColor(.2),
                                ),
                                margin: EdgeInsets.only(right: width * 0.03),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    CustomNetworkImage(
                                        size: aspectRatio * 120, radius: 8),
                                    SizedBox(width: width * 0.02),
                                    CustomText(
                                      text: "Evaluator Name ${index + 1}",
                                      align: TextAlign.center,
                                      maxLine: 3,
                                      size: sizeData.regular,
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
    );
  }
}
