
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/app_constants.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> login(String employeeId, String password);
  Future<void> logout();
  Future<bool> isLoggedIn();
  Future<UserModel?> getPersistedUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Box userBox;

  AuthLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.userBox,
  });

  @override
  Future<UserModel?> login(String employeeId, String password) async {
    // Static dummy credentials check
    if (employeeId.trim().toLowerCase() == AppConstants.demoEmployeeId.toLowerCase() &&
        password == AppConstants.demoPassword) {
      final user = const UserModel(
        employeeId: AppConstants.demoEmployeeId,
        name: AppConstants.demoEmployeeName,
        email: AppConstants.demoEmail,
        designation: AppConstants.demoDesignation,
        department: AppConstants.demoDepartment,
        isLoggedIn: true,
      );

      await userBox.put(AppConstants.keyCurrentUser, user.toMap());
      await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, true);
      return user;
    }

    return null;
  }

  @override
  Future<void> logout() async {
    await userBox.delete(AppConstants.keyCurrentUser);
    await sharedPreferences.setBool(AppConstants.keyIsLoggedIn, false);
  }


  @override
  Future<bool> isLoggedIn() async {
    return sharedPreferences.getBool(AppConstants.keyIsLoggedIn) ?? false;
  }

  @override
  Future<UserModel?> getPersistedUser() async {
    final userData = userBox.get(AppConstants.keyCurrentUser);
    if (userData != null) {
      return UserModel.fromMap(Map<String, dynamic>.from(userData));
    }
    return null;
  }
}
