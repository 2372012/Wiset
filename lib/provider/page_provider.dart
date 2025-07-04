import 'package:flutter/material.dart';

class PageProvider with ChangeNotifier {
  /// 현재 선택된 페이지
  String _currentPage = 'login';

  /// Getter
  String get currentPage => _currentPage;

  /// 페이지 변경 메서드
  void setPage(String page) {
    _currentPage = page;
    notifyListeners();
  }

  /// 앱 실행 시 초기 페이지 판단용 메서드
  /// 예: 자동 로그인 되면 'main', 아니면 'login'으로 시작
  void initializePage({required bool isLoggedIn}) {
    _currentPage = isLoggedIn ? 'main' : 'login';
    notifyListeners();
  }

  /// 로그아웃 시 호출할 페이지 리셋 함수
  void resetToLogin() {
    _currentPage = 'login';
    notifyListeners();
  }
}
