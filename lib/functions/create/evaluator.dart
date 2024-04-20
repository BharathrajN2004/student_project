import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

Future<bool> createEvaluator(
    Map<String, dynamic> data, String eventName) async {
  try {
    File profile = data["profile"];
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("evaluator/${data["email"]}/profile.png")
        .putFile(profile);
    TaskSnapshot onCompleted = await uploadTask.whenComplete(() {});
    String profileUrl = await onCompleted.ref.getDownloadURL();

    data.addAll({"profile": profileUrl});

    await FirebaseFirestore.instance
        .collection("users")
        .doc(data["email"])
        .set(data, SetOptions(merge: true));

    await FirebaseFirestore.instance.collection("events").doc(eventName).set({
      data["goal"]: {
        "evaluators": FieldValue.arrayUnion([data["email"]])
      }
    }, SetOptions(merge: true));

    return true;
  } catch (error) {
    return false;
  }
}
