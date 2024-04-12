import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';

class DataPreview extends ConsumerWidget {
  const DataPreview({
    super.key,
    required this.data,
  });

  final List<List<dynamic>> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorData.secondaryColor(.3),
      ),
      padding: EdgeInsets.symmetric(
        vertical: height * 0.01,
        horizontal: width * 0.02,
      ),
      height: height * 0.3,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: DataTable(
              dataRowMaxHeight: height * 0.06,
              dataRowMinHeight: height * 0.06,
              columnSpacing: width * 0.05,
              dividerThickness: .3,
              headingRowHeight: height * 0.06,
              headingRowColor:
                  MaterialStatePropertyAll(colorData.backgroundColor(1)),
              dataTextStyle: TextStyle(
                fontSize: sizeData.regular,
                fontWeight: FontWeight.w600,
                color: colorData.fontColor(.6),
              ),
              headingTextStyle: TextStyle(
                fontSize: sizeData.regular,
                fontWeight: FontWeight.w800,
                color: colorData.fontColor(.8),
              ),
              columns: data.first
                  .map((e) => DataColumn(
                        label: Text(
                          e.toString(),
                        ),
                      ))
                  .toList(),
              rows: List.generate(
                data.length - 1,
                (index) {
                  return DataRow(
                    cells: data[index + 1].map((cellValue) {
                      return DataCell(
                        Text(cellValue.toString()),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
