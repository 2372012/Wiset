import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart'; // 테마 프로바이더 추가

class QuizAnswer1 extends StatelessWidget {
  const QuizAnswer1({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: theme.backgroundColor, // 연한 배경
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 고양이 이미지 원
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: const AssetImage('assets/images/cat.png'),
                      backgroundColor: theme.baseColor, // 원 배경
                    ),
                    const SizedBox(height: 16),

                    const Text(
                      '정답',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // 정답 박스
                    Container(
                      width: 250,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          '(각 문제에 해당하는 정답 표시)',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 다음 문제 버튼
                    SizedBox(
                      width: 240,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PageProvider>().setPage('quiz');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.yellowButton, // 노랑 버튼
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          '다음 문제로 넘어가기',
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
              color: Colors.grey[700],
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
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
