import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/provider/detection_provider.dart'; // ✅ 추가

class DetectResult1 extends StatefulWidget {
  const DetectResult1({super.key});

  @override
  State<DetectResult1> createState() => _DetectResult1State();
}

class _DetectResult1State extends State<DetectResult1> {
  String resultText = '결과를 불러오는 중...';
  String detailText = '잠시만 기다려주세요.';

  @override
  void initState() {
    super.initState();
    fetchDetectionResult();
  }

  Future<void> fetchDetectionResult() async {
    final detectionProvider = context.read<DetectionProvider>();
    final detectionId = detectionProvider.detectionId;
    final token = detectionProvider.token;

    final url = Uri.parse('https://wiset-deepfake-server.onrender.com/detections/result/$detectionId');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isDeepfake = data['result']['isDeepfake'] as bool;
        final confidence = (data['result']['confidence'] as num).toStringAsFixed(1);
        final details = data['result']['details'] as String;

        setState(() {
          resultText = '$confidence% ${isDeepfake ? "딥페이크입니다!" : "정상입니다!"}';
          detailText = details;
        });
      } else {
        setState(() {
          resultText = '탐지 결과를 불러올 수 없습니다.';
          detailText = '에러 코드: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        resultText = '탐지 결과 로딩 실패';
        detailText = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('탐지결과페이지'),
        backgroundColor: colors.base,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.read<PageProvider>().setPage('detect');
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: colors.base,
                backgroundImage: const AssetImage('assets/images/cat.png'),
              ),
              const SizedBox(width: 20),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.play_arrow, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: colors.midContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              resultText,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            width: 250,
            height: 250,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: const Offset(3, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                detailText,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 180,
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
                '완료',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            color: Colors.grey[700],
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '배너 내용',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
