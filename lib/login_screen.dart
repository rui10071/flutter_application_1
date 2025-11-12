import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main_screen.dart';
import 'theme.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kPrimaryColor.withOpacity(0.5), kBackgroundDark],
                stops: [0.0, 0.4],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  Spacer(flex: 2),
                  Image.asset(
                    "assets/images/Benchpress_logo.jpg",
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 24),
                  Text(
                    "MIRRORSENSEへようこそ",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    "AIフォームトレーナーで\nあなたのトレーニングを最適化",
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      height: 1.4
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Spacer(flex: 3),
                  _buildTextField(
                    context,
                    hint: "メールアドレス",
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress
                  ),
                  SizedBox(height: 16),
                  _buildTextField(
                    context,
                    hint: "パスワード",
                    icon: Icons.lock_outline,
                    obscureText: true
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                    child: Text("ログイン"),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text("または", style: TextStyle(color: Colors.white70)),
                      ),
                      Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildSocialButton(
                    context,
                    text: "Googleでログイン",
                    iconUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                  ),
                  SizedBox(height: 16),
                  _buildSocialButton(
                    context,
                    text: "Appleでログイン",
                    iconUrl: "https://upload.wikimedia.org/wikipedia/commons/3/31/Apple_logo_white.svg",
                    isApple: true,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    }
                  ),
                  Spacer(flex: 2),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpScreen()),
                      );
                    },
                    child: Text(
                      "アカウントをお持ちでないですか？ 新規登録",
                      style: TextStyle(color: theme.primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "利用規約とプライバシーポリシー",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(BuildContext context, {required String hint, required IconData icon, bool obscureText = false, TextInputType? keyboardType}) {
    return TextField(
      style: TextStyle(color: Colors.white),
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kTextDarkSecondary),
        prefixIcon: Icon(icon, color: kTextDarkSecondary, size: 20),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, {required String text, required String iconUrl, bool isApple = false, required VoidCallback onPressed}) {
    Color backgroundColor = isApple ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.05);
    Color borderColor = isApple ? Colors.black.withOpacity(0.7) : Colors.white.withOpacity(0.1);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: borderColor, width: 1)
        ),
        elevation: 0,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(
            iconUrl, 
            height: 24, 
            width: 24, 
            color: isApple ? Colors.white : null
          ),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}

