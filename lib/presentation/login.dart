import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/provider/token_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  bool _autoLogin = false;
  bool _isLoading = false;

  Future<void> _login(BuildContext context) async {
    final id = _idController.text.trim();
    final pw = _pwController.text.trim();

    if (id.isEmpty || pw.isEmpty) return;

    setState(() => _isLoading = true);

    final url = Uri.parse('https://wiset-deepfake-server.onrender.com/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': id, 'password': pw}),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final userId = data['userId'];

      // TokenProvider에 저장
      context.read<TokenProvider>().setToken(token);

      // 자동 로그인 설정 시 저장
      if (_autoLogin) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
      }

      // 페이지 이동
      context.read<PageProvider>().setPage('main');
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('로그인 실패'),
          content: const Text('아이디 또는 비밀번호를 확인해주세요.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('확인'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                'assets/images/cat.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    _buildTextField('아이디', _idController, theme),
                    const SizedBox(height: 12),
                    _buildTextField('비밀번호', _pwController, theme, obscure: true),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _autoLogin,
                              onChanged: (value) {
                                setState(() => _autoLogin = value ?? false);
                              },
                            ),
                            const Text('자동 로그인'),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<PageProvider>().setPage('find');
                          },
                          child: const Text(
                            '아이디/비밀번호 찾기',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _login(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.yellowButton,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 6,
                          shadowColor: Colors.grey,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.black)
                            : const Text('로그인', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        context.read<PageProvider>().setPage('signup');
                      },
                      child: const Text(
                        '회원가입',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String hint, TextEditingController controller, ThemeProvider theme,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white),
        filled: true,
        fillColor: theme.textFieldColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
}
