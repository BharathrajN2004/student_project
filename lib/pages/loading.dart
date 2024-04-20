import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/shimmer_box.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

class Loading extends ConsumerWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.06,
            right: width * 0.06,
            top: height * 0.02,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ShimmerBox(height: sizeData.header, width: width * .4),
                  ShimmerBox(height: width * 0.11, width: width * 0.11),
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
                  child: ShimmerBox(height: height * 0.045, width: width)),
              SizedBox(height: height * 0.04),
              Expanded(
                  child: ListView.builder(
                itemCount: 17,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerBox(height: sizeData.medium, width: width * 0.2),
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
                                color: colorData.secondaryColor(1),
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.all(3),
                            margin: EdgeInsets.only(right: width * 0.04),
                            child: ShimmerBox(
                              height: aspectRatio * 120,
                              width: aspectRatio * 120,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: aspectRatio * 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                itemBuilder: (context, index) => Container(
                                    width: width * .4,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width * 0.015,
                                        vertical: height * 0.001),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: colorData.secondaryColor(.2),
                                    ),
                                    margin:
                                        EdgeInsets.only(right: width * 0.03),
                                    alignment: Alignment.center,
                                    child: ShimmerBox(
                                      height: aspectRatio * 120,
                                      width: width * .4,
                                    )),
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
              )),
            ],
          ),
        ),
      ),
    );
  }
}
