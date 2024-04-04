import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/icon.dart';
import '../components/common/network_image.dart';
import '../components/common/text.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';
import 'profile.dart';
import 'view_result.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorData.secondaryColor(.8),
                            border: Border.all(
                                color: colorData.secondaryColor(1), width: 2)),
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
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 10,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ViewResult(),
                                ),
                              ),
                              child: Container(
                                width: width * .4,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.015,
                                    vertical: height * 0.001),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: colorData.secondaryColor(.2),
                                ),
                                margin: EdgeInsets.only(right: width * 0.03),
                                alignment: Alignment.center,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: CustomText(
                                    text:
                                        "Team name $index\nTeam name with value",
                                    align: TextAlign.center,
                                    maxLine: 6,
                                    size: sizeData.regular,
                                    weight: FontWeight.w600,
                                  ),
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
