import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';

class QuizResult extends StatelessWidget {
  const QuizResult({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    // TODO: 아래 정보는 실제 사용자 이름, 점수로 동적으로 받아오도록 수정 필요
    final String userName = '홍길동'; // 예시
    final int correctCount = 7; // 예시
    final int totalCount = 10;

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
                    // 고양이 이미지
                    const CircleAvatar(
                      radius: 60,
                      backgroundImage: AssetImage('assets/images/cat.png'),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 16),

                    // 이름 박스
                    Container(
                      width: 160,
                      height: 40,
                      decoration: BoxDecoration(
                        color: theme.colors.midContainer,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          userName,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 점수 박스
                    Container(
                      width: 160,
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colors.strongContainer,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '$correctCount/$totalCount',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // 나가기 버튼
                    SizedBox(
                      width: 160,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PageProvider>().setPage('main');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.yellowButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          '나가기',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 하단 배너
            Container(
              color: const Color(0xFF333333),
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
                child: const Center(
                  child: Text(
                    '“고사 딥페이크 합성” 제작·유포한 10대 징역형 | 2025.05.22 | MBC 뉴스',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
