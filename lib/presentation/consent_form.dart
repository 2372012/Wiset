import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:client/provider/page_provider.dart';
import 'package:client/provider/theme_provider.dart';

class ConsentFormPage extends StatefulWidget {
  const ConsentFormPage({super.key});

  @override
  State<ConsentFormPage> createState() => _ConsentFormPageState();
}

class _ConsentFormPageState extends State<ConsentFormPage> {
  bool agreeTerms = false;
  bool agreePersonal = false;
  bool agreeOptional = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<ThemeProvider>().colors;
    final theme = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colors.base,
        title: const Text('정보 동의서', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Provider.of<PageProvider>(context, listen: false).setPage('signup'),
        ),
      ),
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildScrollableSection(
              title: '[1] 이용약관 동의 (필수)',
              content: '''제1조 목적
이 약관은 티페이크 감지 교육용 애플리케이션(이하 "서비스")의 이용과 관련하여 회사와 이용자 간의 권리, 의무 및 책임의 사항을 규정함을 목적으로 합니다.

제2조 이용자 정의
이 약관에서 "이용자"란, 본 약관에 따라 서비스에 가입하여 교육 콘텐츠를 이용하는 자를 말합니다.

제3조 서비스 내용
서비스는 티페이크 감지에 대한 교육 콘텐츠 제공, 실습 기능, 퀴즈, 피드백 등의 기능을 포함합니다.

제4조 이용자의 의무
이용자는 다음 행위를 하여서는 안 됩니다:
- 타인의 정보 도용
- 교육 목적 외 콘텐츠 활용

제5조 계약 해지 및 제한
이용자가 본 약관을 위반한 경우, 서비스 이용이 제한되거나 계정이 삭제될 수 있습니다.''',
            ),
            const SizedBox(height: 12),
            _buildScrollableSection(
              title: '[2] 개인정보 수집 및 이용 동의 (필수)',
              content: '''1. 수집 항목
- 필수: 이름, 이메일, 학교, 학년, 비밀번호
- 선택: 관심 분야, 지식 수준

2. 수집 목적
- 서비스 이용자 식별 및 가입 절차 진행
- 교육 콘텐츠 제공 및 학습 분석
- 공지사항 전달 및 문의 대응

3. 보유 및 이용 기간
회원 탈퇴 또는 목적 달성 후 즉시 파기합니다. 단, 관련 법령에 따라 보관이 필요한 정보는 해당 기간 동안 보관됩니다.''',
            ),
            const SizedBox(height: 12),
            _buildScrollableSection(
              title: '[3] 교육 콘텐츠 수신 동의 (선택)',
              content: '''이메일을 통해 교육 콘텐츠 업데이트, 이벤트, 퀴즈 안내 등의 정보를 수신합니다. 언제든 설정을 통해 수신을 거부할 수 있습니다.''',
            ),
            const SizedBox(height: 24),
            CheckboxListTile(
              value: agreeTerms,
              onChanged: (val) {
                setState(() => agreeTerms = val ?? false);
              },
              title: const Text('(필수) 이용약관에 동의합니다.'),
            ),
            CheckboxListTile(
              value: agreePersonal,
              onChanged: (val) {
                setState(() => agreePersonal = val ?? false);
              },
              title: const Text('(필수) 개인정보 수집 및 이용에 동의합니다.'),
            ),
            CheckboxListTile(
              value: agreeOptional,
              onChanged: (val) {
                setState(() => agreeOptional = val ?? false);
              },
              title: const Text('(선택) 교육 콘텐츠 관련 정보 수신에 동의합니다.'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (agreeTerms && agreePersonal) {
                  Provider.of<PageProvider>(context, listen: false).setPage('main');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('필수 항목에 동의해주세요.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.yellowButton,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('다음으로'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollableSection({required String title, required String content}) {
    final colors = context.read<ThemeProvider>().colors;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.base,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SizedBox(
            height: 140,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(height: 1.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
