import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';

class QuizAnswerPage extends StatelessWidget {
  final bool isCorrect; // 정답 여부
  final bool isLastQuestion; // 마지막 문제 여부

  const QuizAnswerPage({
    super.key,
    required this.isCorrect,
    required this.isLastQuestion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('QuizAnswerPage', style: TextStyle(color: Colors.grey)),
      ),
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
                      backgroundColor: theme.baseColor,
                    ),
                    const SizedBox(height: 16),

                    Text(
                      isCorrect ? '정답입니다!' : '오답입니다!',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),

                    // 정답 설명 박스
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

                    // 다음 문제 or 결과 보기 버튼
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: isLastQuestion ? 240 : 160,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (isLastQuestion) {
                                context.read<PageProvider>().setPage('quiz_result');
                              } else {
                                context.read<PageProvider>().setPage('quiz');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.yellowButton,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              isLastQuestion ? '결과 보기' : '다음 문제로 넘어가기',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // 하단 배너
            Container(
              color: const Color(0xFF333333),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    '“고시 딥페이크 합성물” 제작·유포한 10대 집행유예 | 2025.05.22 | MBC 뉴스',
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
