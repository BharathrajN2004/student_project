import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme_provider.dart';

LinearGradient activeGradient = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color.fromRGBO(233, 210, 149, 1),
      Color.fromRGBO(255, 170, 87, 1),
      Color.fromRGBO(250, 97, 215, 1),
      Color.fromRGBO(253, 127, 176, 1)
    ]);

class CustomColorData {
  final Color Function(double) fontColor;
  final Color Function(double) primaryColor;
  final Color Function(double) secondaryColor;
  final Color Function(double) backgroundColor;

  final Color Function(double) sideBarTextColor;

  CustomColorData({
    required this.fontColor,
    required this.primaryColor,
    required this.secondaryColor,
    required this.backgroundColor,
    required this.sideBarTextColor,
  });

  factory CustomColorData.from(WidgetRef ref) {
    Map<ThemeMode, Color> themeMap = ref.watch(themeProvider);
    ThemeMode themeMode = themeMap.keys.first;
    bool isDark = themeMode == ThemeMode.dark;
    Color statePrimaryColor = themeMap.values.first;

    Color fontColor(double opacity) => isDark
        ? const Color(0XFFEFF1FF).withOpacity(opacity)
        : const Color(0XFF1C2136).withOpacity(opacity);

    Color primaryColor(double opacity) =>
        statePrimaryColor.withOpacity(opacity);

    Color secondaryColor(double opacity) => isDark
        ? const Color(0XFF333354).withOpacity(opacity)
        : const Color.fromARGB(255, 243, 243, 255).withOpacity(opacity);

    Color backgroundColor(double opacity) =>
        isDark ? const Color(0XFF22223D) : Colors.white;

    Color sideBarTextColor(double opacity) => Colors.white.withOpacity(opacity);

    return CustomColorData(
      fontColor: fontColor,
      primaryColor: primaryColor,
      secondaryColor: secondaryColor,
      backgroundColor: backgroundColor,
      sideBarTextColor: sideBarTextColor,
    );
  }
}
