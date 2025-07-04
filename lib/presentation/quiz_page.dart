import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: theme.colors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('QuizPage', style: TextStyle(color: Colors.grey)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            const Text('1번', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),

            // 이미지 영역
            Container(
              width: 260,
              height: 260,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Center(child: Text('이미지 추가')),
            ),
            const SizedBox(height: 20),

            // O / X 버튼
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<PageProvider>().setPage('quiz_answer1');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.blueButton,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 6,
                  ),
                  child: const Text('O', style: TextStyle(fontSize: 28, color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () {
                    context.read<PageProvider>().setPage('quiz_answer2');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.yellowButton,
                    padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 6,
                  ),
                  child: const Text('X', style: TextStyle(fontSize: 28, color: Colors.black)),
                ),
              ],
            ),

            const Spacer(),

            // 하단 배너
            Container(
              color: const Color(0xFF333333),
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '“고시 딥페이크 합성물” 제작·유포한 10대 집행유예 | 2025.05.22 | MBC 뉴스',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
