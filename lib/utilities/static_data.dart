import 'package:flutter/material.dart';

enum From { edit, add }

enum Role { admin, evaluator }

enum LoginSignup { login, signup }

const List<String> searchFields = ["Project Name", "Team Name", "Project ID"];

Map<String, int> validationMap = {
  "Productable": 30,
  "Opportunity": 10,
  "Sustainable": 10,
  "Information": 10,
  "Technology": 10,
  "Intellectual": 10,
  "Viability": 10,
  "Ethics": 10
};

const emojis = {
  "0": "🤩",
  "1": "😇",
  "2": "😎",
  "3": "🥶",
  "4": "😢",
  "5": "🥵",
  "6": "🤕",
};

const List<Color> primaryColors = [
  Color(0XFF5D44F8),
  Color(0XFFFA61D7),
  Color(0XFFFFAA57),
  Color(0XFF2ADDC7),
];
