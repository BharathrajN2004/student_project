// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/common/text.dart';
import '../../providers/user_select_provider.dart';
import '../../utilities/static_data.dart';

Future<Map<String, dynamic>?> getUserData({
  required WidgetRef ref,
  required BuildContext context,
  required String email,
}) async {
  Role role = ref.watch(userRoleProvider)!;
  String colName = "users";
  QuerySnapshot<Map<String, dynamic>> queryData = await FirebaseFirestore
      .instance
      .collection(colName)
      .where("email", isEqualTo: email.toLowerCase())
      .get();
  if (queryData.docs.isNotEmpty) {
    Map<String, dynamic> userData =
        Map.fromEntries(queryData.docs.first.data().entries);
    userData.addAll({"email": queryData.docs.first.id});
    return userData;
  } else {
    Color secondaryColor(double opacity) => Colors.white.withOpacity(opacity);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: secondaryColor(1),
        content: CustomText(
          text:
              "The Provided ${role.name.toString().toUpperCase()} ID is not available!",
          maxLine: 3,
          align: TextAlign.center,
        ),
      ),
    );
  }
  return null;
}
