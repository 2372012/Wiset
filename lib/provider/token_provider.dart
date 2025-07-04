import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  /// 토큰을 설정하고 필요한 경우 SharedPreferences에 저장
  Future<void> setToken(String token, {bool saveToLocal = false}) async {
    _token = token;
    notifyListeners();

    if (saveToLocal) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }
  }

  /// 저장된 토큰 로딩 (앱 시작 시 호출)
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');

    if (storedToken != null) {
      _token = storedToken;
      notifyListeners();
    }
  }

  /// 로그아웃 처리 및 저장된 토큰 삭제
  Future<void> clearToken() async {
    _token = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  /// 로그인 상태 확인
  bool get isLoggedIn => _token != null;
}
