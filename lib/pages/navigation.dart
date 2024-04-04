import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';
import 'Home.dart';
import 'evaluator.dart';
import 'export.dart';

class Navigation extends ConsumerStatefulWidget {
  const Navigation({super.key});
  @override
  ConsumerState<Navigation> createState() => _NavigationState();
}

class _NavigationState extends ConsumerState<Navigation> {
  final List<Widget> widgetList = const [
    Evaluators(),
    Home(),
    Export(),
  ];

  int index = 1;

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double width = sizeData.width;
    double height = sizeData.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: index,
          onTap: (value) {
            setState(() {
              index = value;
            });
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedIconTheme: const IconThemeData(size: 38),
          unselectedIconTheme: const IconThemeData(size: 36),
          items: [
            navBarItem(
              icon: Icons.person_pin_rounded,
              state: 0,
              tooltip: "Evaluator",colorData: colorData
            ),
            navBarItem(
              icon: Icons.home_rounded,
              state: 1,
              tooltip: 'Home',colorData: colorData
            ),
            navBarItem(
              icon: Icons.label_important_rounded,
              state: 2,
              tooltip: "Export",colorData: colorData
            ),
          ]),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.06,
            right: width * 0.06,
            top: height * 0.02,
          ),
          child: widgetList[index]
        ),
      ),
    );
  }

  BottomNavigationBarItem navBarItem({
    required IconData icon,
    required int state,
    required String tooltip,
    required CustomColorData colorData,
  }) {
    return BottomNavigationBarItem(
      tooltip: tooltip,
      icon: ShaderMask(
        shaderCallback: (Rect rect) {
          if (state == index) {
            return activeGradient.createShader(rect);
          } else {
            return const LinearGradient(colors: [Colors.white, Colors.white])
                .createShader(rect);
          }
        },
        child: Icon(
          icon,
          color: state == index
              ? Colors.white
              : colorData.secondaryColor(1),
        ),
      ),
      label: '',
    );
  }
}
