import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';
import 'package:client/constants.dart';

class FindAccountPage extends StatefulWidget {
  const FindAccountPage({super.key});

  @override
  State<FindAccountPage> createState() => _FindAccountPageState();
}

class _FindAccountPageState extends State<FindAccountPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        backgroundColor: colors.base,
        title: const Text('아이디/비밀번호 찾기', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.read<PageProvider>().setPage('login'),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
            decoration: BoxDecoration(
              color: colors.base,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              indicator: BoxDecoration(
                color: colors.midContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              tabs: const [
                Tab(text: '아이디 찾기'),
                Tab(text: '비밀번호 찾기'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _FindIdContainer(),
                _FindPwContainer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ----------------- 아이디 찾기 -----------------
class _FindIdContainer extends StatefulWidget {
  const _FindIdContainer();

  @override
  State<_FindIdContainer> createState() => _FindIdContainerState();
}

class _FindIdContainerState extends State<_FindIdContainer> {
  final nameController = TextEditingController();
  final schoolCodeController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  String? gender;
  String result = "";

  final String baseUrl = "${Constants.baseUrl}"; // TODO: 실제 API 주소로 바꾸기

  Future<void> findId() async {
    final url = Uri.parse('$baseUrl/auth/findId');

    final body = {
      "name": nameController.text,
      "gender": gender ?? "",
      "schoolCode": schoolCodeController.text,
      "phone": phoneController.text,
      "email": emailController.text,
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          result = "${nameController.text}님의 아이디는\n${data['id']}입니다.";
        });
      } else {
        setState(() {
          result = "일치하는 계정을 찾을 수 없습니다.";
        });
      }
    } catch (e) {
      setState(() {
        result = "요청 중 오류가 발생했습니다.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final theme = context.watch<ThemeProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.base,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('이름', controller: nameController),
            _buildGenderField(),
            _buildField('학교코드', controller: schoolCodeController),
            _buildField('전화번호', controller: phoneController),
            _buildField('이메일', controller: emailController),
            const SizedBox(height: 16),
            _buildButton('아이디 찾기', theme, findId),
            const SizedBox(height: 24),
            if (result.isNotEmpty) _buildResult(result, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const Text('성별'),
          const SizedBox(width: 20),
          Row(
            children: [
              Radio<String>(
                value: 'F',
                groupValue: gender,
                onChanged: (val) => setState(() => gender = val),
              ),
              const Text('여성'),
            ],
          ),
          Row(
            children: [
              Radio<String>(
                value: 'M',
                groupValue: gender,
                onChanged: (val) => setState(() => gender = val),
              ),
              const Text('남성'),
            ],
          ),
        ],
      ),
    );
  }
}

// ----------------- 비밀번호 찾기 -----------------
class _FindPwContainer extends StatefulWidget {
  const _FindPwContainer();

  @override
  State<_FindPwContainer> createState() => _FindPwContainerState();
}

class _FindPwContainerState extends State<_FindPwContainer> {
  final loginIdController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  String result = "";

  final String baseUrl = "https://wiset-deepfake-server.onrender.com"; // TODO: 실제 API 주소로 바꾸기

  Future<void> findPw() async {
    final url = Uri.parse('$baseUrl/auth/findPw');

    final body = {
      "loginId": loginIdController.text,
      "phone": phoneController.text,
      "email": emailController.text,
    };

    try {
      final res = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          result = "${loginIdController.text}님의 비밀번호는\n${data['password']}입니다.";
        });
      } else {
        setState(() {
          result = "일치하는 사용자를 찾을 수 없습니다.";
        });
      }
    } catch (e) {
      setState(() {
        result = "요청 중 오류가 발생했습니다.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final theme = context.watch<ThemeProvider>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.base,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildField('아이디', controller: loginIdController),
            _buildField('전화번호', controller: phoneController),
            _buildField('이메일', controller: emailController),
            const SizedBox(height: 16),
            _buildButton('비밀번호 찾기', theme, findPw),
            const SizedBox(height: 24),
            if (result.isNotEmpty) _buildResult(result, theme),
          ],
        ),
      ),
    );
  }
}

// ----------------- 공통 위젯 빌더 -----------------
Widget _buildField(String label, {TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}

Widget _buildButton(String label, ThemeProvider theme, VoidCallback onPressed) {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.yellowButton,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Text(label, style: const TextStyle(fontSize: 16)),
    ),
  );
}

Widget _buildResult(String text, ThemeProvider theme) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: theme.yellowButton,
      borderRadius: BorderRadius.circular(12),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.4),
          blurRadius: 4,
          offset: const Offset(2, 2),
        )
      ],
    ),
    child: Text(text, style: const TextStyle(fontSize: 16)),
  );
}
