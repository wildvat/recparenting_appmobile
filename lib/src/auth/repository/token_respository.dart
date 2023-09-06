import 'package:recparenting/src/auth/models/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as developer;

class TokenRepository {
  TokenRepository();

  void initializeTokens(TokenModel tokens) {
    String accessToken = tokens.accessToken;
    String refreshToken = tokens.refreshToken;
    setToken(accessToken);
    setRefreshToken(refreshToken);
  }

  Future<String> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('LastToken');
      return (token != null && token != '') ? token : '';
    } catch (error) {
      developer.log('TokenRepository getToken $error');
      return '';
    }
  }

  Future<bool> setToken(token) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString('LastToken', token);
    } catch (error) {
      developer.log('TokenRepository setToken $error');
      return false;
    }
  }

  Future<bool> setRefreshToken(refreshToken) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return await prefs.setString('LastRefreshToken', refreshToken);
    } catch (error) {
      developer.log('TokenRepository setRefreshToken $error');
      return false;
    }
  }

  Future<String> getRefreshToken() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? refreshToken = prefs.getString('LastRefreshToken');
      return (refreshToken != null && refreshToken != '') ? refreshToken : '';
    } catch (error) {
      developer.log('TokenRepository clearTokens $error');
      return '';
    }
  }

  Future<void> clearTokens() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('LastRefreshToken', '');
      await prefs.setString('LastToken', '');
    } catch (error) {
      developer.log('TokenRepository clearTokens $error');
      return;
    }
  }
}
