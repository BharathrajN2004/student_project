import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_project/providers/user_detail_provider.dart';
import 'package:student_project/providers/user_select_provider.dart';

import 'functions/firebase_auth.dart';

import 'pages/auth.dart';
import 'pages/navigation.dart';
import 'utilities/static_data.dart';

class AuthShifter extends ConsumerWidget {
  const AuthShifter({super.key});

  Future getRole(WidgetRef ref) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? roleStr = preferences.getString("role");
    Role? role = roleStr != null
        ? roleStr == Role.admin.name
            ? Role.admin
            : Role.evaluator
        : null;
    ref.read(userRoleProvider.notifier).setUserRole(role);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: AuthFB().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(snapshot.data!.email)
              .get()
              .then((value) {
            Map<String, dynamic> userData = value.data()!;
            userData.addAll({"email": value.id});
            ref.read(userDataProvider.notifier).addUserData(userData);
          });
          getRole(ref);
          return const Navigation();
        } else {
          return const MainAuthPage();
        }
      },
    );
  }
}
