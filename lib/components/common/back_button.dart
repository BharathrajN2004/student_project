import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utilities/theme/color_data.dart';
import '../../utilities/theme/size_data.dart';
import 'icon.dart';

class CustomBackButton extends ConsumerWidget {
  final Function? method;
  final Widget? tomove;
  const CustomBackButton({super.key, this.method, this.tomove});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double aspectRatio = sizeData.aspectRatio;

    return GestureDetector(
      onTap: () {
        method != null ? method!() : null;
        tomove != null
            ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => tomove!,
                ),
              )
            : Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.all(aspectRatio * 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: colorData.primaryColor(.6),
        ),
        child: CustomIcon(
          icon: Icons.arrow_back_ios_new_rounded,
          color: colorData.sideBarTextColor(.85),
          size: aspectRatio * 55,
        ),
      ),
    );
  }
}
