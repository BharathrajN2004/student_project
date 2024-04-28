
// ignore_for_file: avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth_shifter.dart';
import '../../components/common/text.dart';
import '../../providers/user_select_provider.dart';
import '../../utilities/static_data.dart';
import '../firebase_auth.dart';

Future createUser({
  required WidgetRef ref,
  required String email,
  required String password,
  required Map<String, dynamic> generatedData,
  required BuildContext context,
}) async {
  Role role = ref.watch(userRoleProvider)!;
  AuthFB()
      .createUserWithEmailAndPassword(
    email: email,
    password: password,
    role: role,
  )
      .then((value) {
    Map<String, dynamic> userData = {
      "role": role.name,
      "email": generatedData["email"],
      "name": generatedData["name"],
      "password": password,
      "phoneNo": generatedData["phoneNo"],
      "specialization": generatedData["specialization"],
    };
    FirebaseFirestore.instance
        .collection('users')
        .doc(email)
        .set(userData, SetOptions(merge: true));

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const AuthShifter()));
  }).catchError((error) {
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: secondaryColor(1),
        content: CustomText(
          text: error.message.toString(),
          maxLine: 3,
          align: TextAlign.center,
        ),
      ),
    );
  });
}

Future createEvent({required String eventname}) async {
  try {
    FirebaseFirestore.instance
        .collection("events")
        .doc(eventname[0].toUpperCase() + eventname.substring(1).toLowerCase())
        .set({}, SetOptions(merge: true));
  } catch (e) {
    print(e);
  }
}
