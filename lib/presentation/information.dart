import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/provider/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InformationPage extends StatefulWidget {
  const InformationPage({super.key});

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final nameController = TextEditingController();
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String? gender;

  @override
  void dispose() {
    // 입력값 해제
    nameController.dispose();
    userIdController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final colors = theme.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('information'),
        backgroundColor: colors.base,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.read<PageProvider>().setPage('mypage');
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.topLeft,
                child: Image.asset('assets/images/cat.png', width: 100),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: colors.midContainer,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(2, 2)),
                  ],
                ),
                child: Column(
                  children: [
                    _buildTextFieldRow(label: '이름', controller: nameController, fillColor: theme.textFieldColor),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const SizedBox(width: 80, child: Text('성별', style: TextStyle(fontSize: 16))),
                        Row(
                          children: [
                            Checkbox(
                              value: gender == 'F',
                              onChanged: (_) => setState(() => gender = 'F'),
                            ),
                            const Text('여성'),
                            const SizedBox(width: 10),
                            Checkbox(
                              value: gender == 'M',
                              onChanged: (_) => setState(() => gender = 'M'),
                            ),
                            const Text('남성'),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(label: '아이디', controller: userIdController, buttonLabel: '중복확인', fillColor: theme.textFieldColor),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(label: '비밀번호', controller: passwordController, fillColor: theme.textFieldColor, obscure: true),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(label: '비밀번호 확인', controller: passwordConfirmController, fillColor: theme.textFieldColor, obscure: true),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(label: '전화번호', controller: phoneController, fillColor: theme.textFieldColor),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(label: '이메일', controller: emailController, fillColor: theme.textFieldColor),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitUpdate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.base,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Colors.black12),
                          ),
                          elevation: 4,
                        ),
                        child: const Text('변경하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldRow({
    required String label,
    String? buttonLabel,
    required TextEditingController controller,
    bool obscure = false,
    Color fillColor = Colors.white,
  }) {
    return Row(
      children: [
        SizedBox(width: 80, child: Text(label, style: const TextStyle(fontSize: 16))),
        Expanded(
          child: TextField(
            controller: controller,
            obscureText: obscure,
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              border: const OutlineInputBorder(),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
            ),
          ),
        ),
        if (buttonLabel != null) ...[
          const SizedBox(width: 8),
          TextButton(onPressed: () {
            // TODO: 중복확인 API 연결 필요
            _showDialog("안내", "중복확인 기능은 아직 구현되지 않았습니다.");
          }, child: Text(buttonLabel)),
        ],
      ],
    );
  }

  Future<void> _submitUpdate() async {
    final token = context.read<TokenProvider>().token;
    if (token == null) {
      _showDialog("오류", "로그인 정보가 없습니다. 다시 로그인해주세요.");
      return;
    }

    // ✅ 비밀번호 일치 여부 확인
    if (passwordController.text != passwordConfirmController.text) {
      _showDialog("오류", "비밀번호와 비밀번호 확인이 일치하지 않습니다.");
      return;
    }

    final uri = Uri.parse('https://your-api.com/users/me'); // 변경 필요
    final Map<String, String> data = {};

    if (nameController.text.isNotEmpty) data['name'] = nameController.text;
    if (gender != null) data['gender'] = gender!;
    if (userIdController.text.isNotEmpty) data['userId'] = userIdController.text;
    if (passwordController.text.isNotEmpty) data['password'] = passwordController.text;
    if (passwordConfirmController.text.isNotEmpty) data['passwordConfirm'] = passwordConfirmController.text;
    if (phoneController.text.isNotEmpty) data['phone'] = phoneController.text;
    if (emailController.text.isNotEmpty) data['email'] = emailController.text;

    try {
      final res = await http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      final resData = jsonDecode(res.body);

      if (res.statusCode == 200) {
        _showDialog("성공", resData['message'] ?? '정보가 수정되었습니다.');

        // ✅ 입력값 초기화
        setState(() {
          nameController.clear();
          userIdController.clear();
          passwordController.clear();
          passwordConfirmController.clear();
          phoneController.clear();
          emailController.clear();
          gender = null;
        });
      } else {
        _showDialog("실패", resData['message'] ?? '오류가 발생했습니다.');
      }
    } catch (e) {
      _showDialog("에러", "요청에 실패했습니다: $e");
    }
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
