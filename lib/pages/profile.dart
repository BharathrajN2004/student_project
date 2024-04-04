import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../components/common/network_image.dart';
import '../providers/user_detail_provider.dart';
import '../components/profile/color_palette.dart';
import '../components/profile/theme_toggle.dart';
import '../functions/firebase_auth.dart';
import '../utilities/theme/color_data.dart';
import '../utilities/theme/size_data.dart';

import '../components/common/back_button.dart';
import '../components/common/text.dart';
import '../components/profile/profile_tile.dart';

class Profile extends ConsumerWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Map<String, dynamic> userData = {};
    CustomSizeData sizeData = CustomSizeData.from(context);
    CustomColorData colorData = CustomColorData.from(ref);

    double height = sizeData.height;
    double width = sizeData.width;
    double aspectRatio = sizeData.aspectRatio;

    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(
            left: width * 0.04,
            right: width * 0.04,
            top: height * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomBackButton(),
                  ThemeToggle(),
                ],
              ),
              SizedBox(
                height: height * 0.02,
              ),
              CustomNetworkImage(size: aspectRatio * 250, radius: 500),
              SizedBox(height: height * 0.02),
              CustomText(
                text: "sdfasdf",
                //  userData["name"],
                size: sizeData.header,
                weight: FontWeight.w800,
                color: colorData.fontColor(.8),
              ),
              SizedBox(height: height * 0.005),
              CustomText(
                text: "wersdfdf@gmail.com",
                // userData["email"],
                size: sizeData.regular,
                color: colorData.fontColor(.6),
              ),
              SizedBox(height: height * 0.05),
              ProfileTile(
                  text: 'Edit Profile', icon: Icons.edit_outlined, todo: () {}),
              SizedBox(
                height: height * 0.03,
              ),
              ProfileTile(
                  text: 'Help', icon: Icons.help_outline_outlined, todo: () {}),
              SizedBox(
                height: height * 0.03,
              ),
              ProfileTile(text: 'History', icon: Icons.history, todo: () {}),
              SizedBox(
                height: height * 0.03,
              ),
              ProfileTile(
                text: 'Logout',
                icon: Icons.logout_outlined,
                todo: () {
                  AuthFB().signOut();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
