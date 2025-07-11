import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/token_provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:client/constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<String, String> buttonUrls = {};
  List<Map<String, String>> youtubeBanners = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMainPageData();
  }

 Future<void> loadMainPageData() async {
    final token = context.read<TokenProvider>().token;
    if (token == null) {
      print("❌ 토큰이 없습니다. 로그인 페이지로 이동하세요.");
      return;
    }

    final uri = Uri.parse('${Constants.baseUrl}/mainPage');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        buttonUrls = Map<String, String>.from(data['buttons']);
        youtubeBanners = List<Map<String, String>>.from(
          data['youtubeBanner'].map((item) => Map<String, String>.from(item)),
        );
        isLoading = false;
      });
    } else {
      print('❌ 메인 페이지 API 호출 실패: ${response.statusCode}');
    }
  }

  /*Future<void> loadMainPageData() async {
    final token = context.read<TokenProvider>().token;
    if (token == null) {
      print("❌ 토큰이 없습니다. 로그인 페이지로 이동하세요.");
      setState(() {
        isLoading = false; // ✅ 로딩 종료 추가
      });
      return;
    }

    final uri = Uri.parse('${Constants.baseUrl}/mainPage');
    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        buttonUrls = Map<String, String>.from(data['buttons']);
        youtubeBanners = List<Map<String, String>>.from(
          data['youtubeBanner'].map((item) => Map<String, String>.from(item)),
        );
        isLoading = false;
      });
    } else {
      print('❌ 메인 페이지 API 호출 실패: ${response.statusCode}');

      // ✅ 임시 데이터 설정 및 로딩 종료 처리
      setState(() {
        buttonUrls = {
          "button1": "https://example.com/button1",
          "button2": "https://example.com/button2",
        };
        youtubeBanners = [
          {"title": "임시 유튜브 배너1", "url": "https://youtube.com/example1"},
          {"title": "임시 유튜브 배너2", "url": "https://youtube.com/example2"},
        ];
        isLoading = false; // ✅ API 실패 시에도 로딩 종료
      });
    }
  }*/

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.background,
        elevation: 0,
        toolbarHeight: 70,
        leading: GestureDetector(
          onTap: () {
            context.read<PageProvider>().setPage('mypage');
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/images/my.png',
              width: 165,
              height: 165,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: const Text(
          'main_page',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'TmoneyRoundWind',
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 90,
                    backgroundColor: colors.base,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/cat.png',
                        width: 140,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PageProvider>().setPage('detect');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.blueButton,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('탐지', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<PageProvider>().setPage('quiz');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.yellowButton,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('퀴즈', style: TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: colors.midContainer,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, -2),
                )
              ],
            ),
            padding: const EdgeInsets.all(12),
            child: youtubeBanners.isEmpty
                ? const Center(child: Text('추천 영상이 없습니다', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: youtubeBanners.length,
              itemBuilder: (context, index) {
                final banner = youtubeBanners[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Column(
                    children: [
                      Image.network(
                        banner['thumbnailUrl'] ?? '',
                        width: 100,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        banner['title'] ?? '',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
