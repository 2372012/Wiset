import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart'; // 테마 추가

class QuizAnswer2 extends StatelessWidget {
  const QuizAnswer2({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 고양이 이미지 (동그란 배경 포함)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.baseColor,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          )
                        ],
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundImage: AssetImage('assets/1.png'),
                        backgroundColor: Colors.transparent,
                      ),
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      '정답',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // 정답 박스
                    Container(
                      width: 260,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        '(각 문제에 해당하는 정답 표시)',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 결과 보기 버튼
                    SizedBox(
                      width: 260,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PageProvider>().setPage('quiz_result');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.yellowButton,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 6,
                        ),
                        child: const Text(
                          '결과 보기',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 하단 배너
            Container(
              width: double.infinity,
              color: const Color(0xFF333333), // 고정 다크 배경
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 2,
                      offset: Offset(1, 1),
                    )
                  ],
                ),
                child: const Center(
                  child: Text('배너 내용', style: TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
