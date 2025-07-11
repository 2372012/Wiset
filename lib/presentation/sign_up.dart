import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final String baseUrl = Constants.baseUrl;

  final usernameController = TextEditingController();
  final schoolCodeController = TextEditingController();
  final loginIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  String? gender;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> signUpUser() async {
    final url = Uri.parse('$baseUrl/auth/signup');

    final body = {
      "username": usernameController.text,
      "gender": gender ?? "",
      "schoolCode": schoolCodeController.text,
      "loginId": loginIdController.text,
      "password": passwordController.text,
      "passwordConfirm": confirmPasswordController.text,
      "phone": phoneController.text,
      "email": emailController.text,
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        print("회원가입 성공: ${data['loginId']}");
        context.read<PageProvider>().setPage('consent');  // 다음 페이지로 이동
      } else {
        print("회원가입 실패: ${response.statusCode} / ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("회원가입 실패: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("에러 발생: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("네트워크 오류가 발생했습니다.")),
      );
    }
  }

  Future<void> _checkDuplicateId(String loginId) async {
    if (loginId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("아이디를 입력해주세요.")),
      );
      return;
    }

    final url = Uri.parse('$baseUrl/auth/check-user-id?loginId=$loginId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final isDuplicate = data['isDuplicate'] as bool;

        if (isDuplicate) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("이미 존재하는 아이디입니다.")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("사용 가능한 아이디입니다.")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오류 발생: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("중복확인 에러: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("네트워크 오류가 발생했습니다.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDEB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE9D8B5),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.read<PageProvider>().setPage('login');
          },
        ),
        title: const Text('회원가입', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFF0B3),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
                  ],
                ),
                padding: const EdgeInsets.all(10),
                child: const CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/images/cat.png'),
                  backgroundColor: Colors.transparent,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9D8B5),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.grey.withOpacity(0.4), blurRadius: 4, offset: Offset(2, 2))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabelInput("이름", controller: usernameController),
                    _buildGenderInput(),
                    _buildLabelInput("학교코드", controller: schoolCodeController, suffixText: "(선택)"),
                    _buildLabelInput(
                      "아이디",
                      controller: loginIdController,
                      suffixButton: "중복확인",
                      onSuffixPressed: () => _checkDuplicateId(loginIdController.text),
                    ),
                    _buildLabelInput("비밀번호", controller: passwordController, obscure: true),
                    _buildLabelInput("비밀번호 확인", controller: confirmPasswordController, obscure: true),
                    _buildLabelInput("전화번호", controller: phoneController),
                    _buildLabelInput("이메일", controller: emailController),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: signUpUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEE8A5),
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black38,
                        ),
                        child: const Text('회원가입', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
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

  Widget _buildLabelInput(String label,
      {TextEditingController? controller,
        bool obscure = false,
        String? suffixText,
        String? suffixButton,
        VoidCallback? onSuffixPressed}) {
    bool isPassword = controller == passwordController;
    bool isConfirmPassword = controller == confirmPasswordController;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 90, child: Text(label, style: const TextStyle(fontSize: 16))),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure
                  ? (isPassword ? _obscurePassword : _obscureConfirmPassword)
                  : false,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                suffixText: suffixText,
                suffixIcon: obscure
                    ? IconButton(
                  icon: Icon(
                    (isPassword ? _obscurePassword : _obscureConfirmPassword)
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      if (isPassword) {
                        _obscurePassword = !_obscurePassword;
                      } else {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      }
                    });
                  },
                )
                    : (suffixButton != null
                    ? TextButton(
                    onPressed: onSuffixPressed, child: Text(suffixButton!))
                    : null),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const SizedBox(width: 90, child: Text("성별", style: TextStyle(fontSize: 16))),
          Expanded(
            child: Row(
              children: [
                Row(
                  children: [
                    Radio<String>(
                      value: "F",
                      groupValue: gender,
                      onChanged: (value) => setState(() => gender = value),
                    ),
                    const Text("여성"),
                  ],
                ),
                const SizedBox(width: 10),
                Row(
                  children: [
                    Radio<String>(
                      value: "M",
                      groupValue: gender,
                      onChanged: (value) => setState(() => gender = value),
                    ),
                    const Text("남성"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
