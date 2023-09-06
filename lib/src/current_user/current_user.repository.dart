import 'dart:convert';
import 'package:recparenting/_shared/models/user.model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class CurrentUserRepository {
  static const String _name = 'User';

  CurrentUserRepository();

  Future<bool> setPreferences(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.setString(_name, jsonEncode(user.toJson()));
    } catch (error) {
      developer.log(
          '$error CurrentUserRepository setPreferences lib/src/user/repository/current_user.repository.dart:15');
      return false;
    }
  }

  Future<User?> getPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = prefs.getString(_name);
      /*
      if(user != null && user != '') {

        print(UserWithSettings.fromJsonLocal(jsonDecode(user)));
      }
       */
      return (user != null && user != '')
          ? User.fromJson(jsonDecode(user))
          : null;

      //return null;
    } catch (error) {
      developer.log(
          '$error CurrentUserRepository getPreferences lib/src/user/repository/current_user.repository.dart:15');
      return null;
    }
  }

  Future<void> clearCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_name, "");
      getPreferences();
      return;
    } catch (error) {
      developer.log('CurrentUserRepository clearCurrentUser $error');
      return;
    }
  }
}
