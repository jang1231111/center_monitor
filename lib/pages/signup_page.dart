import 'package:center_monitor/models/user/user.dart';
import 'package:center_monitor/pages/signin_page.dart';
import 'package:center_monitor/providers/user/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static const String routeName = '/signup';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final password = _passwordController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;

      print('회원가입 정보: 이름: $name, 비밀번호: $password 이메일: $email, 전화번호: $phone');

      await context.read<UserProvider>().addUser(
          User(name: name, password: password, email: email, phone: phone));

      Navigator.pushNamed(context, SigninPage.routeName);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('전화번호로 로그인해주세요.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6F9), // 부드러운 배경색
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 로고 및 제목
                Column(
                  children: [
                    Image.asset(
                      'assets/images/background.jpeg',
                      width: 80,
                      height: 80,
                    ),
                    SizedBox(height: 10),
                    Icon(
                      Icons.account_circle,
                      size: 70,
                      color: Color.fromRGBO(38, 94, 176, 1),
                    ),
                    SizedBox(height: 15),
                    Text(
                      '회원가입 정보를 입력하세요.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                // 회원가입 폼
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTextField(
                            controller: _nameController,
                            label: "이름",
                            icon: Icons.person,
                          ),
                          SizedBox(height: 15),
                          _buildTextField(
                            controller: _phoneController,
                            label: "전화번호",
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 15),
                          _buildTextField(
                            controller: _passwordController,
                            label: "비밀번호",
                            icon: Icons.lock,
                            obscureText: true,
                          ),
                          SizedBox(height: 15),
                          _buildTextField(
                            controller: _emailController,
                            label: "이메일",
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 25),
                          Center(
                            child: ElevatedButton(
                              onPressed: _signUp,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromRGBO(38, 94, 176, 1), // 주황색 배경
                                foregroundColor: Colors.white, // 글씨색
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12), // 둥근 모서리
                                ),
                                elevation: 8, // 그림자 효과 추가
                                shadowColor:
                                    Color.fromRGBO(241, 140, 31, 1), // 블루 그림자
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '회원가입',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(Icons.arrow_forward,
                                      color: Colors.white), // 진행 아이콘 추가
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // 로그인 이동 버튼
                TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, "/signin");
                  },
                  icon: Icon(Icons.login, color: Colors.blueAccent),
                  label: Text(
                    '로그인 하러가기',
                    style: TextStyle(
                        fontSize: 16, color: Color.fromRGBO(38, 94, 176, 1)),
                  ),
                ),
                SizedBox(height: 20),

                // 회사 정보
                Column(
                  children: [
                    Text(
                      '(주)옵티로',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    Text(
                      '인천광역시 연수구 송도미래로 30 스마트밸리 D동',
                      style: TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                    Text(
                      'H : www.optilo.net  T : 070-5143-8585',
                      style: TextStyle(fontSize: 14, color: Colors.black45),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 공통 입력 필드 위젯
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: Color.fromRGBO(38, 94, 176, 1),
        ),
        border: UnderlineInputBorder(),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label을 입력하세요.';
        }
        return null;
      },
    );
  }
}
