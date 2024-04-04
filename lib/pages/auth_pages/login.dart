import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/auth/login_textfield.dart';
import '../../components/auth/loginsignup_shifter.dart';
import '../../components/common/back_button.dart';
import '../../components/common/footer.dart';
import '../../providers/user_select_provider.dart';
import '../../utilities/static_data.dart';
import '../../utilities/theme/size_data.dart';
import '../../functions/firebase_auth.dart';

import '../../components/common/text.dart';
import '../auth.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser(
      {required double textSize,
      required Color textColor,
      required Color backgroundColor,
      required Role role}) {
    AuthFB()
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      role: role,
    )
        .then((value) {
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: backgroundColor,
          content: CustomText(
            text: error.message.toString(),
            maxLine: 3,
            align: TextAlign.center,
            color: textColor,
            size: textSize,
            weight: FontWeight.w600,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Role? role = ref.watch(userRoleProvider);

    CustomSizeData sizeData = CustomSizeData.from(context);

    double width = sizeData.width;
    double height = sizeData.height;

    Color fontColor(double opacity) =>
        const Color(0XFF1C2136).withOpacity(opacity);
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    return Scaffold(
      backgroundColor: const Color(0xffDADEEC),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: height * 0.02,
              left: width * 0.04,
              child: const CustomBackButton(
                tomove: MainAuthPage(),
              ),
            ),
            Positioned(
              top: height * 0.05,
              right: 0,
              left: 0,
              child: Image(
                height: height * .13,
                image: const AssetImage("assets/images/logo.png"),
              ),
            ),
            Container(
              width: width,
              padding: EdgeInsets.only(
                  left: width * 0.05, right: width * 0.05, top: height * 0.225),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "Login",
                    size: sizeData.superHeader,
                    color: fontColor(1),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.01,
                  ),
                  CustomText(
                    text: "Please signin in to continue",
                    size: sizeData.header,
                    color: fontColor(.6),
                    weight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: height * 0.04,
                  ),
                  LoginTextField(
                    icon: Icons.email_outlined,
                    labelText: "EMAIL",
                    controller: emailController,
                    bottomMargin: 0.025,
                  ),
                  LoginTextField(
                    icon: Icons.password_rounded,
                    labelText: "PASSWORD",
                    controller: passwordController,
                    bottomMargin: 0.01,
                    isVisible: false,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      child: CustomText(
                        text: "Forget Password",
                        size: sizeData.medium,
                        color: primaryColors[0].withOpacity(.7),
                        weight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => loginUser(
                      textColor: fontColor(.8),
                      textSize: sizeData.regular,
                      backgroundColor: secondaryColor(1),
                      role: role!,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        margin: EdgeInsets.only(top: height * 0.04),
                        padding: EdgeInsets.symmetric(vertical: height * .0125),
                        width: width * 0.325,
                        decoration: BoxDecoration(
                          color: primaryColors[0].withOpacity(1),
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
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
                          ],
                        ),
                        alignment: Alignment.center,
                        child: CustomText(
                          weight: FontWeight.bold,
                          text: "LOGIN",
                          size: sizeData.medium,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  role != Role.admin
                      ? const LoginSingupShifter(shifter: LoginSignup.login)
                      : const SizedBox(),
                  const Footer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
