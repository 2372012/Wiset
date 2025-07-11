import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/provider/token_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:client/constants.dart';

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
  bool isIdChecked = false;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final token = context.read<TokenProvider>().token;
    if (token == null) {
      _showDialog("오류", "로그인이 필요합니다.");
      return;
    }

    final url = Uri.parse('${Constants.baseUrl}/users/me');
    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        setState(() {
          nameController.text = data['name'] ?? '';
          userIdController.text = data['userId'] ?? '';
          phoneController.text = data['phone'] ?? '';
          emailController.text = data['email'] ?? '';
          gender = data['gender'];
        });
      } else {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        _showDialog("오류", data['message'] ?? "사용자 정보를 불러오지 못했습니다.");
      }
    } catch (e) {
      print('유저 정보 불러오기 오류: $e');
      _showDialog("오류", "네트워크 오류가 발생했습니다.");
    }
  }

  @override
  void dispose() {
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
                    _buildTextFieldRow(
                      label: '이름',
                      controller: nameController,
                      fillColor: theme.textFieldColor,
                    ),
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
                    _buildTextFieldRow(
                      label: '아이디',
                      controller: userIdController,
                      buttonLabel: '중복확인',
                      onButtonPressed: _checkDuplicateId,
                      fillColor: theme.textFieldColor,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(
                      label: '비밀번호',
                      controller: passwordController,
                      fillColor: theme.textFieldColor,
                      obscure: true,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(
                      label: '비밀번호 확인',
                      controller: passwordConfirmController,
                      fillColor: theme.textFieldColor,
                      obscure: true,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(
                      label: '전화번호',
                      controller: phoneController,
                      fillColor: theme.textFieldColor,
                    ),
                    const SizedBox(height: 12),
                    _buildTextFieldRow(
                      label: '이메일',
                      controller: emailController,
                      fillColor: theme.textFieldColor,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _askPasswordThenSubmit,
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
    VoidCallback? onButtonPressed,
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
          TextButton(
            onPressed: onButtonPressed,
            child: Text(buttonLabel),
          ),
        ],
      ],
    );
  }

  Future<void> _checkDuplicateId() async {
    final id = userIdController.text.trim();
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("아이디를 입력해주세요.")),
      );
      return;
    }

    final url = Uri.parse('${Constants.baseUrl}/auth/check-user-id?user_id=$id');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("사용 가능한 아이디입니다.")),
        );
        setState(() => isIdChecked = true);
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("이미 존재하는 아이디입니다.")),
        );
        setState(() => isIdChecked = false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오류 발생: ${response.statusCode}")),
        );
        setState(() => isIdChecked = false);
      }
    } catch (e) {
      print("중복확인 에러: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("네트워크 오류가 발생했습니다.")),
      );
      setState(() => isIdChecked = false);
    }
  }

  Future<void> _askPasswordThenSubmit() async {
    String currentPassword = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('비밀번호 확인'),
        content: TextField(
          obscureText: true,
          decoration: const InputDecoration(hintText: '현재 비밀번호 입력'),
          onChanged: (value) => currentPassword = value,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("취소")),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("확인")),
        ],
      ),
    );

    if (currentPassword.isEmpty) return;

    final loginId = context.read<TokenProvider>().loginId ?? '';
    final url = Uri.parse('${Constants.baseUrl}/auth/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'loginId': loginId, 'password': currentPassword}),
    );

    if (response.statusCode == 200) {
      final token = context.read<TokenProvider>().token;
      if (token == null) {
        _showDialog("오류", "토큰 정보가 없습니다. 다시 로그인해주세요.");
        return;
      }
      await _submitUpdate(token);
    } else {
      final resData = jsonDecode(response.body);
      _showDialog("오류", resData['message'] ?? "비밀번호가 일치하지 않습니다.");
    }
  }

  Future<void> _submitUpdate(String token) async {
    final Map<String, String> data = {};

    data['name'] = nameController.text;
    data['phone'] = phoneController.text;
    data['email'] = emailController.text;

    if (gender != null) data['gender'] = gender!;
    if (userIdController.text.isNotEmpty && isIdChecked) {
      data['userId'] = userIdController.text;
    }
    if (passwordController.text.isNotEmpty && passwordConfirmController.text.isNotEmpty) {
      data['password'] = passwordController.text;
      data['passwordConfirm'] = passwordConfirmController.text;
    }

    final res = await http.put(
      Uri.parse('${Constants.baseUrl}/users/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    final resData = jsonDecode(utf8.decode(res.bodyBytes));

    if (res.statusCode == 200) {
      _showDialog("성공", resData['message'] ?? "정보가 수정되었습니다.");
      setState(() {
        passwordController.clear();
        passwordConfirmController.clear();
      });
    } else {
      _showDialog("오류", resData['message'] ?? "업데이트에 실패했습니다.");
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