// import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utilities/static_data.dart';

class UserRoleNotifier extends StateNotifier<Role?> {
  UserRoleNotifier() : super(null);

  void setUserRole(Role? userRole) {
    state = userRole;
  }
}

final userRoleProvider =
    StateNotifierProvider<UserRoleNotifier, Role?>(
        (ref) => UserRoleNotifier());
