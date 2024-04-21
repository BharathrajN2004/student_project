import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/auth/loginsignup_shifter.dart';
import '../../components/common/back_button.dart';
import '../../components/common/footer.dart';
import '../../components/common/inputfield.dart';
import '../../functions/create/create_userData.dart';
import '../../functions/read/get_userdata.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';

import '../../components/common/text.dart';
import '../auth.dart';

class Signup extends ConsumerStatefulWidget {
  const Signup({super.key});

  @override
  ConsumerState<Signup> createState() => _SignupState();
}

class _SignupState extends ConsumerState<Signup> {
  TextEditingController phoneNoCtr = TextEditingController();
  TextEditingController nameCtr = TextEditingController();
  TextEditingController emailCtr = TextEditingController();
  TextEditingController passwordCtr = TextEditingController();

  Map<String, dynamic> generatedData = {};

  bool showPassword = false;

  @override
  void dispose() {
    emailCtr.dispose();
    passwordCtr.dispose();
    nameCtr.dispose();
    phoneNoCtr.dispose();
    super.dispose();
  }

  void _generateUserData() async {
    Map<String, dynamic>? userData = await getUserData(
        context: context, email: emailCtr.text.trim(), ref: ref);
    if (userData != null) {
      setState(() {
        generatedData = userData;
        emailCtr.text = userData["email"];
        nameCtr.text = userData["name"];
        phoneNoCtr.text = userData["phoneNo"];
      });
    }
  }

  void _createUser() async {
    setState(() {
      generatedData["name"] = nameCtr.text.trim();
      generatedData["password"] = passwordCtr.text.trim();
    });
    await createUser(
      ref: ref,
      email: emailCtr.text.trim(),
      password: passwordCtr.text.trim(),
      generatedData: generatedData,
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    String hintText = "Evaluator Email";

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffDADEEC),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
              left: width * 0.06, right: width * 0.06, top: height * 0.02),
          child: Stack(
            children: [
              const Positioned(
                top: 0,
                left: 0,
                child: CustomBackButton(
                  tomove: MainAuthPage(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image(
                      height: height * .125,
                      image: const AssetImage("assets/images/logo.png"),
                    ),
                  ),
                  SizedBox(height: height * 0.02),
                  CustomText(
                    text: "Signup",
                    size: sizeData.superHeader,
                    color: fontColor(1),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomText(
                    text: "Create a account to continue",
                    size: sizeData.header,
                    color: fontColor(.6),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CustomInputField(
                          icon: Icons.email_rounded,
                          controller: emailCtr,
                          hintText: hintText,
                          inputType: TextInputType.text,
                          bottomMar: 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _generateUserData(),
                        child: Container(
                          margin: EdgeInsets.only(left: width * 0.02),
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.008,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: secondaryColor(.5)),
                          child: CustomText(
                            text: "GENERATE",
                            weight: FontWeight.bold,
                            color: primaryColors[0],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: CustomText(
                      text: "Enter the $hintText and generate to signup!",
                      weight: FontWeight.w700,
                      color: const Color.fromARGB(255, 80, 143, 82),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  CustomInputField(
                    controller: nameCtr,
                    hintText: "NAME",
                    icon: Icons.person_rounded,
                    inputType: TextInputType.text,
                    readOnly: generatedData.isEmpty,
                  ),
                  CustomInputField(
                    controller: phoneNoCtr,
                    hintText: "PHONE NO",
                    icon: Icons.numbers_rounded,
                    inputType: TextInputType.number,
                    readOnly: true,
                  ),
                  CustomInputField(
                    controller: passwordCtr,
                    hintText: "PASSWORD",
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    suffixIconData: showPassword == true
                        ? Icons.remove_red_eye
                        : Icons.visibility_off,
                    icon: Icons.password_rounded,
                    inputType: TextInputType.visiblePassword,
                    readOnly: generatedData.isEmpty,
                    visibleText: showPassword,
                  ),
                  GestureDetector(
                    onTap:
                        generatedData.isNotEmpty ? () => _createUser() : () {},
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: AnimatedContainer(
                        duration: Durations.medium4,
                        margin: EdgeInsets.only(top: height * 0.04),
                        padding: EdgeInsets.symmetric(vertical: height * .0125),
                        width: width * 0.325,
                        decoration: BoxDecoration(
                          color: primaryColors[0]
                              .withOpacity(generatedData.isNotEmpty ? 1 : .5),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: generatedData.isNotEmpty
                              ? [
                                  BoxShadow(
                                    color: primaryColors[0].withOpacity(.2),
                                    blurRadius: 12,
                                    offset: const Offset(-4, -4),
                                  ),
                                  BoxShadow(
                                    color: primaryColors[0].withOpacity(.2),
                                    blurRadius: 16,
                                    offset: const Offset(4, 4),
                                  ),
                                ]
                              : [],
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          weight: FontWeight.bold,
                          text: "SIGNUP",
                          size: sizeData.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  const LoginSingupShifter(shifter: LoginSignup.signup),
                  const Footer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
