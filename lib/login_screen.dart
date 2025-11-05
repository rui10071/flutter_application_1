import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'main_screen.dart';
import 'theme.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.asset(
                    "assets/images/burpee.jpg",
                    height: 64,
                    width: 64,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "ようこそ",
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "AIフォームトレーナーへ",
                  style: theme.textTheme.titleMedium?.copyWith(color: kTextDarkSecondary),
                ),
                SizedBox(height: 48),
                
                _buildSocialButton(
                  context,
                  text: "Googleでログイン",
                  iconUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
                  isDark: isDark,
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
                  isDark: isDark,
                  isApple: true,
                  onPressed: () {
                     Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  }
                ),
                
                SizedBox(height: 24),
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
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "利用規約とプライバシーポリシー",
                    style: TextStyle(color: kTextDarkSecondary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, {required String text, required String iconUrl, required bool isDark, bool isApple = false, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isApple ? Colors.black : (isDark ? Colors.grey[800] : Colors.grey[100]),
        foregroundColor: isApple ? Colors.white : (isDark ? Colors.white : Colors.black),
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: isApple ? BorderSide.none : BorderSide(color: isDark ? Colors.grey[700]! : Colors.grey[300]!, width: 1)
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

