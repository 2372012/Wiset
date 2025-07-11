import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/provider/detection_provider.dart';
import 'package:client/provider/token_provider.dart'; // ✅ 추가됨

// 인증 & 계정 관련
import 'presentation/login.dart';
import 'presentation/sign_up.dart';
import 'presentation/find_account.dart';
import 'presentation/change_pw.dart';
import 'presentation/consent_form.dart';

// 메인 UI + 마이페이지
import 'presentation/main_page.dart';
import 'presentation/mypage.dart';
import 'presentation/information.dart';
import 'presentation/myclass.dart';

// 탐지 관련
import 'presentation/detect.dart';
import 'presentation/detect_result1.dart';
import 'presentation/loading.dart';

// 퀴즈 관련
import 'presentation/quiz_page.dart';
import 'presentation/quiz_answer1.dart';
import 'presentation/quiz_answer2.dart';
import 'presentation/quiz_result.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PageProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => DetectionProvider()),
        ChangeNotifierProvider(create: (_) => TokenProvider()), // ✅ 추가됨
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colors = themeProvider.colors;

    return MaterialApp(
      title: '통합 Flutter 앱',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'TmoneyRoundWind',
        scaffoldBackgroundColor: colors.background,
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: colors.base,
            foregroundColor: Colors.black,
            shadowColor: Colors.black26,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: const TextStyle(fontSize: 16),
          ),
        ),
      ),
      home: Consumer<PageProvider>(
        builder: (context, pageProvider, _) {
          switch (pageProvider.currentPage) {
          // 인증 & 계정 관련
            case 'signup':
              return const SignUpPage();
            case 'find':
              return const FindAccountPage();
            case 'change_pw':
              return const ChangePwPage();
            case 'consent':
              return const ConsentFormPage();

          // 메인 UI & 마이페이지
            case 'main':
              return const MainPage();
            case 'mypage':
              return const MyPage();
            case 'information':
              return const InformationPage();
            case 'myclass':
              return const MyClassPage();

          // 탐지 관련
            case 'detect':
              return const DetectPage();
            case 'detect_result1':
              return const DetectResult1();
            case 'loading':
              return const LoadingPage();

          // 퀴즈 관련
            case 'quiz':
              return const QuizPage();
            case 'quiz_answer1':
              return const QuizAnswer1();
            case 'quiz_answer2':
              return const QuizAnswer2();
            case 'quiz_result':
              return const QuizResult();

          // 기본 로그인 페이지
            case 'login':
            default:
              return const LoginPage();
          }
        },
      ),
    );
  }
}
