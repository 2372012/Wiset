import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/provider/token_provider.dart';
import 'package:client/constants.dart';

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  // 사용자 이름, 학교명 가져오기
  Future<Map<String, dynamic>> getMyInfo(BuildContext context) async {
    final token = context.read<TokenProvider>().token;
    final url = Uri.parse('${Constants.baseUrl}/users/me');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('사용자 정보를 불러오지 못했습니다.');
    }
  }

  // 학년, 반, 점수 가져오기
  Future<Map<String, dynamic>> getMyClassRank(BuildContext context) async {
    final token = context.read<TokenProvider>().token;
    final url = Uri.parse('${Constants.baseUrl}/users/me/classRank');

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      return {
        'grade': data['classInfo']['grade'],
        'classNumber': data['classInfo']['classNumber'],
        'score': data['myRank']['score'],
      };
    } else {
      throw Exception('학급 정보를 불러오지 못했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: const Text('mypage', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.read<PageProvider>().setPage('main'),
        ),
        elevation: 0,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          getMyInfo(context),
          getMyClassRank(context),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('에러 발생: ${snapshot.error}'));
          }

          final userInfo = snapshot.data![0] as Map<String, dynamic>;
          final classRank = snapshot.data![1] as Map<String, dynamic>;

          final name = userInfo['name'] ?? '이름 없음';
          final schoolName = userInfo['schoolName'] ?? '';
          final grade = classRank['grade'].toString().padLeft(2, '0');
          final classNumber = classRank['classNumber'].toString().padLeft(2, '0');
          final score = classRank['score'];

          final schoolDisplay = '$schoolName ${grade}학년 ${classNumber}반';

          return SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(height: 30),

                  // 고양이 이미지
                  CircleAvatar(
                    radius: 72,
                    backgroundColor: colors.base,
                    child: const CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage('assets/images/cat.png'),
                      backgroundColor: Colors.transparent,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 사용자 정보
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: colors.midContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(schoolDisplay, style: const TextStyle(fontSize: 16, color: Colors.white)),
                        const SizedBox(height: 6),
                        Text(name,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // 내 정보 바꾸기 버튼
                  Padding(
                    padding: const EdgeInsets.only(right: 24),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.read<PageProvider>().setPage('information'),
                        child: const Text('내 정보 바꾸기', style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),

                  // 내 점수 박스
                  Container(
                    width: 280,
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: colors.midContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('내 점수', style: TextStyle(fontSize: 16, color: Colors.white)),
                        Text(
                          '$score 점',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 우리 반 등수 버튼
                  SizedBox(
                    width: 280,
                    child: ElevatedButton(
                      onPressed: () => context.read<PageProvider>().setPage('myclass'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colors.base,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        child: Text('우리 반 등수', style: TextStyle(fontSize: 18, color: Colors.black)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  const _ThemeSelector(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector();

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();

    final List<AppTheme> themeList = [
      AppTheme.yellow,
      AppTheme.pink,
      AppTheme.purple,
      AppTheme.blue,
      AppTheme.green,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: themeList.map((theme) {
        final themeColors = ThemeProvider.getThemeColors(theme);

        return GestureDetector(
          onTap: () => themeProvider.setTheme(theme),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: themeColors.background,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black26),
            ),
          ),
        );
      }).toList(),
    );
  }
}
