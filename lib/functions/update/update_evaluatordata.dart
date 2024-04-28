import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<bool> updateEvaluatorData(
    Map<String, dynamic> data, String filetype) async {
  try {
    if (filetype == "filepath") {
      File profile = data["profile"];
      UploadTask uploadTask = FirebaseStorage.instance
          .ref("evaluator/${data["email"]}/profile.png")
          .putFile(profile);
      TaskSnapshot onCompleted = await uploadTask.whenComplete(() {});
      String profileUrl = await onCompleted.ref.getDownloadURL();

      data.addAll({"profile": profileUrl});
    }

    await FirebaseFirestore.instance
        .collection("users")
        .doc(data["email"])
        .set(data, SetOptions(merge: true));

    return true;
  } catch (error) {
    return false;
  }
}
