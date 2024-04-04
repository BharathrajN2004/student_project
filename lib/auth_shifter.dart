import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'functions/firebase_auth.dart';

import 'pages/auth_pages/login.dart';
import 'pages/navigation.dart';

class AuthShifter extends ConsumerWidget {
  const AuthShifter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder(
      stream: AuthFB().authStateChanges,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.hasData) {
          return const Navigation();
        } else {
          return const Login();
        }
      },
    );
  }
}
