import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/text.dart';
import '../utilities/static_data.dart';

import '../components/auth/user_select.dart';
import '../utilities/theme/size_data.dart';
import '../pages/auth_pages/login.dart';

class MainAuthPage extends ConsumerStatefulWidget {
  const MainAuthPage({super.key});

  @override
  ConsumerState<MainAuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends ConsumerState<MainAuthPage> {
  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;
    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.04,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                "assets/images/evaluate.png",
                height: height * 0.4,
                fit: BoxFit.fitHeight,
              ),
              SizedBox(
                width: width * .9,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          text: "Welcome To ",
                          color: fontColor(.8),
                          weight: FontWeight.w700,
                          size: sizeData.superHeader,
                        ),
                        ShaderMask(
                          shaderCallback: (Rect rect) => const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 60, 0, 200),
                                Color.fromARGB(255, 99, 82, 255)
                              ]).createShader(rect),
                          child: CustomText(
                            text: "StudentProject",
                            color: Colors.white,
                            weight: FontWeight.w800,
                            size: sizeData.superHeader,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: CustomText(
                  text:
                      'Unlocking the hidden potential and insights within every project, evaluation is an art of uncovering value',
                  size: sizeData.medium,
                  color: fontColor(.6),
                  weight: FontWeight.w700,
                  maxLine: 3,
                  align: TextAlign.center,
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.06),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color.fromARGB(153, 240, 240, 246),
                ),
                child: const UserSelect(
                  togo: Login(),
                  role: Role.evaluator,
                  text: "Evaluator",
                  shaderColors: [
                    Color(0XFF5D44F8),
                    Colors.blue,
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  UserSelect(
                    togo: const Login(),
                    role: Role.admin,
                    size: sizeData.medium,
                    hpad: 0,
                    text: "...for ADMIN",
                    shaderColors: const [
                      Color.fromARGB(255, 194, 13, 1),
                      Colors.pink
                    ],
                  ),
                  CustomText(
                    text: "🥷🏻  ",
                    size: sizeData.medium,
                    weight: FontWeight.bold,
                  ),
                ],
              ),
              Column(
                children: [
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Container(
                    width: width * .8,
                    height: 3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(colors: [
                          Colors.white,
                          fontColor(.4),
                          Colors.white
                        ])),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  CustomText(
                    text: "By StudentProject",
                    color: fontColor(.8),
                    weight: FontWeight.w800,
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
