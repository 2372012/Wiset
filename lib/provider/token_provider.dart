import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider extends ChangeNotifier {
  String? _token;
  String? _loginId; // ✅ 추가

  String? get token => _token;
  String? get loginId => _loginId; // ✅ 추가

  /// 토큰을 설정하고 필요한 경우 SharedPreferences에 저장
  Future<void> setToken(String token, {bool saveToLocal = false}) async {
    _token = token;
    notifyListeners();

    if (saveToLocal) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }
  }

  /// 로그인 ID를 설정하고 필요한 경우 SharedPreferences에 저장
  Future<void> setLoginId(String loginId, {bool saveToLocal = false}) async {
    _loginId = loginId;
    notifyListeners();

    if (saveToLocal) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loginId', loginId);
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

  /// 저장된 loginId 로딩
  Future<void> loadLoginId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLoginId = prefs.getString('loginId');

    if (storedLoginId != null) {
      _loginId = storedLoginId;
      notifyListeners();
    }
  }

  /// 로그아웃 처리 및 저장된 토큰/아이디 삭제
  Future<void> clearToken() async {
    _token = null;
    _loginId = null; // ✅ 함께 초기화
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('loginId'); // ✅ 함께 삭제
  }

  /// 로그인 상태 확인
  bool get isLoggedIn => _token != null;
}

/*import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenProvider extends ChangeNotifier {
  String? _token = 'temp_token'; // ✅ 임시 토큰으로 초기화 (추가됨)
  String? _loginId = 'temp_loginId'; // ✅ 임시 loginId로 초기화 (추가됨)

  String? get token => _token;
  String? get loginId => _loginId;

  /// 토큰을 설정하고 필요한 경우 SharedPreferences에 저장
  Future<void> setToken(String token, {bool saveToLocal = false}) async {
    _token = token;
    notifyListeners();

    if (saveToLocal) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
    }
  }

  /// 로그인 ID를 설정하고 필요한 경우 SharedPreferences에 저장
  Future<void> setLoginId(String loginId, {bool saveToLocal = false}) async {
    _loginId = loginId;
    notifyListeners();

    if (saveToLocal) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loginId', loginId);
    }
  }

  /// 저장된 토큰 로딩 (앱 시작 시 호출)
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final storedToken = prefs.getString('token');

    if (storedToken != null) {
      _token = storedToken;
      notifyListeners();
    } else {
      _token = 'temp_token'; // ✅ 임시 토큰 지정 (추가됨)
      notifyListeners();
    }
  }

  /// 저장된 loginId 로딩
  Future<void> loadLoginId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedLoginId = prefs.getString('loginId');

    if (storedLoginId != null) {
      _loginId = storedLoginId;
      notifyListeners();
    } else {
      _loginId = 'temp_loginId'; // ✅ 임시 loginId 지정 (추가됨)
      notifyListeners();
    }
  }

  /// 로그아웃 처리 및 저장된 토큰/아이디 삭제
  Future<void> clearToken() async {
    _token = null;
    _loginId = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('loginId');
  }

  /// 로그인 상태 확인
  bool get isLoggedIn => _token != null;
}
*/
