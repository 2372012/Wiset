import 'package:flutter/material.dart';

/// 앱에서 사용 가능한 테마 타입
enum AppTheme {
  yellow,
  pink,
  purple,
  blue,
  green,
}

/// 하나의 테마에 들어가는 4가지 주요 색상 정의
class ThemeColors {
  final Color background;         // 가장 연한 배경
  final Color base;               // 고양이 배경, 기본 버튼
  final Color midContainer;       // 중간 창
  final Color strongContainer;    // 진한 창

  const ThemeColors({
    required this.background,
    required this.base,
    required this.midContainer,
    required this.strongContainer,
  });

  static const yellow = ThemeColors(
    background: Color(0xFFFFFEE3),
    base: Color(0xFFFFEBAF),
    midContainer: Color(0xFFFFD49A),
    strongContainer: Color(0xFFE3A584),
  );
  static const pink = ThemeColors(
    background: Color(0xFFF3E9E5),
    base: Color(0xFFFFDAD9),
    midContainer: Color(0xFFB8A6A5),
    strongContainer: Color(0xFF6A5A59),
  );
  static const purple = ThemeColors(
    background: Color(0xFFD8C5D9),
    base: Color(0xFFAD91B0),
    midContainer: Color(0xFFAD91B0),
    strongContainer: Color(0xFF6B516E),
  );
  static const blue = ThemeColors(
    background: Color(0xFFC8E3F6),
    base: Color(0xFF91ACBE),
    midContainer: Color(0xFF698394),
    strongContainer: Color(0xFF3E5767),
  );
  static const green = ThemeColors(
    background: Color(0xFFD0D3C5),
    base: Color(0xFFA4AFA4),
    midContainer: Color(0xFF7B8C88),
    strongContainer: Color(0xFF566A70),
  );
}

/// Provider 클래스
class ThemeProvider with ChangeNotifier {
  AppTheme _currentTheme = AppTheme.yellow;

  AppTheme get currentTheme => _currentTheme;
  ThemeColors get colors => getThemeColors(_currentTheme);

  // 주요 색상 getter (편의성 향상용)
  Color get backgroundColor => colors.background;
  Color get baseColor => colors.base;
  Color get midContainerColor => colors.midContainer;
  Color get strongContainerColor => colors.strongContainer;
  Color get textFieldColor => colors.strongContainer;

  // 공통 컬러 (모든 테마에 공통 적용)
  Color get blueButton => const Color(0xFF9CC2DB);
  Color get yellowButton => const Color(0xFFF2CF74);
  Color get borderColor => const Color(0xFFF2CF74);

  void setTheme(AppTheme theme) {
    _currentTheme = theme;
    notifyListeners();
  }

  /// 내부 전용: 테마 객체 매핑
  static ThemeColors getThemeColors(AppTheme theme) {
    switch (theme) {
      case AppTheme.yellow:
        return ThemeColors.yellow;
      case AppTheme.pink:
        return ThemeColors.pink;
      case AppTheme.purple:
        return ThemeColors.purple;
      case AppTheme.blue:
        return ThemeColors.blue;
      case AppTheme.green:
        return ThemeColors.green;
    }
  }
}

/// 외부에서도 쉽게 쓰도록 제공되는 색상 Map
final Map<AppTheme, Map<String, Color>> themeColorMap = {
  AppTheme.yellow: {
    'background': ThemeColors.yellow.background,
    'base': ThemeColors.yellow.base,
    'midContainer': ThemeColors.yellow.midContainer,
    'strongContainer': ThemeColors.yellow.strongContainer,
  },
  AppTheme.pink: {
    'background': ThemeColors.pink.background,
    'base': ThemeColors.pink.base,
    'midContainer': ThemeColors.pink.midContainer,
    'strongContainer': ThemeColors.pink.strongContainer,
  },
  AppTheme.purple: {
    'background': ThemeColors.purple.background,
    'base': ThemeColors.purple.base,
    'midContainer': ThemeColors.purple.midContainer,
    'strongContainer': ThemeColors.purple.strongContainer,
  },
  AppTheme.blue: {
    'background': ThemeColors.blue.background,
    'base': ThemeColors.blue.base,
    'midContainer': ThemeColors.blue.midContainer,
    'strongContainer': ThemeColors.blue.strongContainer,
  },
  AppTheme.green: {
    'background': ThemeColors.green.background,
    'base': ThemeColors.green.base,
    'midContainer': ThemeColors.green.midContainer,
    'strongContainer': ThemeColors.green.strongContainer,
  },
};
