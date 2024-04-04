import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

import 'Navigation.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: AnimatedSplashScreen(
        splashIconSize: height,
        splash: SizedBox(
          width: width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: width * 0.3,
              ),
              SizedBox(
                height: height * 0.1,
              ),
              RichText(
                text: TextSpan(children: [
                  TextSpan(
                    text: 'Student',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: width * 0.07),
                  ),
                  TextSpan(
                      text: 'Projects',
                      style: TextStyle(
                          color: const Color.fromARGB(255, 99, 82, 255),
                          fontWeight: FontWeight.w800,
                          fontSize: width * 0.08))
                ]),
              )
            ],
          ),
        ),
        pageTransitionType: PageTransitionType.fade,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(milliseconds: 500),
        duration: 3000,
        backgroundColor: Colors.grey.shade50,
        nextScreen: const Navigation(),
      ),
    );
  }
}
