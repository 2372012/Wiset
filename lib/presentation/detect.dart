import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:screenshot/screenshot.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/provider/detection_provider.dart';
import 'package:client/presentation/loading.dart';

class DetectPage extends StatefulWidget {
  const DetectPage({super.key});

  @override
  State<DetectPage> createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  final TextEditingController _urlController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  late final WebViewController _webViewController;
  String? _finalUrl;

  String? convertToEmbedUrl(String inputUrl) {
    final Uri? uri = Uri.tryParse(inputUrl.trim());
    if (uri == null) return null;

    if (uri.host.contains('youtube.com') && uri.queryParameters['v'] != null) {
      return 'https://www.youtube.com/embed/${uri.queryParameters['v']}';
    }

    if (uri.host.contains('youtu.be') && uri.pathSegments.isNotEmpty) {
      return 'https://www.youtube.com/embed/${uri.pathSegments[0]}';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(onPageFinished: (url) {
          print('Page loaded: $url');
        }),
      );
  }

  Future<void> sendImageToDetectionApi(Uint8List imageBytes, String token, String detectionId) async {
    final uri = Uri.parse('https://wiset-deepfake-server.onrender.com/detections/$detectionId/run');

    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['timestamp'] =
      (DateTime.now().millisecondsSinceEpoch ~/ 1000).toString()
      ..files.add(http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: 'screenshot.jpg',
      ));

    final response = await request.send();
    if (response.statusCode == 202) {
      print("탐지 요청 정상 전송됨");
    } else {
      print("탐지 실패: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final theme = context.watch<ThemeProvider>();
    final detectionProvider = context.read<DetectionProvider>();
    final token = detectionProvider.token;
    final detectionId = detectionProvider.detectionId;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('detect', style: TextStyle(color: Colors.black)),
        backgroundColor: colors.base,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.read<PageProvider>().setPage('main');
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text('URL', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _urlController,
                    decoration: InputDecoration(
                      hintText: "유튜브 링크 입력",
                      filled: true,
                      fillColor: colors.midContainer,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final embedUrl = convertToEmbedUrl(_urlController.text);
                    if (embedUrl != null) {
                      setState(() {
                        _finalUrl = embedUrl;
                        _webViewController.loadRequest(Uri.parse(_finalUrl!));
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('올바른 유튜브 링크를 입력해주세요')),
                      );
                    }
                  },
                  child: const Text("열기"),
                ),
              ],
            ),
          ),

          if (_finalUrl != null)
            Expanded(
              child: Screenshot(
                controller: _screenshotController,
                child: WebViewWidget(controller: _webViewController),
              ),
            )
          else
            const SizedBox(
              height: 250,
              child: Center(child: Text("유튜브 링크를 입력하고 '열기'를 눌러주세요")),
            ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoadingPage()));

              await _webViewController.runJavaScript(
                  "document.querySelector('video')?.pause();");

              final image = await _screenshotController.capture();
              if (image != null) {
                await sendImageToDetectionApi(image, token, detectionId);
              }

              if (context.mounted) {
                Navigator.pop(context);
                context.read<PageProvider>().setPage('detect_result1');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.yellowButton,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('여기를 캡쳐해서 탐지하기', style: TextStyle(fontSize: 18)),
          ),

          const SizedBox(height: 12),

          Container(
            color: Colors.grey[700],
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Container(
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
    );
  }
}
