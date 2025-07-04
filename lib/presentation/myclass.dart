import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/provider/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyClassPage extends StatefulWidget {
  const MyClassPage({super.key});

  @override
  State<MyClassPage> createState() => _MyClassPageState();
}

class _MyClassPageState extends State<MyClassPage> {
  Map<String, dynamic>? classInfo;
  Map<String, dynamic>? myRank;
  List<dynamic> rankingList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchRankingData();
  }

  Future<void> fetchRankingData() async {
    final token = context.read<TokenProvider>().token;
    if (token == null) {
      _showDialog("오류", "로그인 정보가 없습니다. 다시 로그인해주세요.");
      return;
    }

    try {
      final uri = Uri.parse('https://your-api.com/users/me/classRank'); // 🔁 실제 주소로 교체
      final response = await http.get(
        uri,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          classInfo = data['classInfo'];
          myRank = data['myRank'];
          rankingList = List.from(data['ranking']);
          isLoading = false;
        });
      } else {
        final error = jsonDecode(response.body);
        _showDialog("실패", error['message'] ?? "랭킹 정보를 불러오지 못했습니다.");
      }
    } catch (e) {
      _showDialog("에러", "네트워크 오류: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final bgColor = theme.backgroundColor;
    final boxColor = theme.midContainerColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.read<PageProvider>().setPage('main');
          },
        ),
        title: const Text(
          '우리 반 등수',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          const SizedBox(height: 10),
          Text(
            '${classInfo?["schoolName"] ?? "-"} '
                '${classInfo?["grade"] ?? "-"}학년 '
                '${classInfo?["classNumber"] ?? "-"}반',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: boxColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: rankingList.length,
                  itemBuilder: (context, index) {
                    final user = rankingList[index];
                    final isTop3 = index < 3;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          if (isTop3)
                            Image.asset(
                              'assets/images/${index + 1}.png',
                              width: 24,
                              height: 24,
                            )
                          else
                            const SizedBox(width: 24),
                          const SizedBox(width: 12),
                          Text(
                            '${user["rank"] ?? index + 1}',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            '${user["username"] ?? "이름 없음"}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: boxColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    myRank?["username"] ?? "내 이름",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _infoBox('내 등수', '${myRank?["rank"] ?? "-"} 등', color: theme.blueButton),
                      _infoBox('내 점수', '${myRank?["score"] ?? "-"} 점', color: theme.yellowButton),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _infoBox(String label, String value, {required Color color}) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 2,
              )
            ],
          ),
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인")),
        ],
      ),
    );
  }
}
