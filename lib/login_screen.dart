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
    // Dividerやテキストの色をテーマに合わせて調整
    final dividerColor = isDark ? Colors.grey[700] : Colors.grey[300];
    final secondaryTextColor = isDark ? Colors.grey[400] : Colors.grey[600];


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 24),
                Image.asset(
                  "assets/images/Benchpress_logo.jpg",
                  height: 180,
                  width: 180,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 16),
                Text(
                  "ようこそ",
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "MIRRORSENSEへ",
                  style: theme.textTheme.titleLarge
                      ?.copyWith(color: kTextDarkSecondary),
                ),
                SizedBox(height: 48),

                // --- メールアドレスとパスワードの入力欄 ---
                TextField(
                  decoration: InputDecoration(
                    labelText: "メールアドレス",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "パスワード",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
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
                    textStyle: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Lexend'),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                  child: Text("ログイン"),
                ),

                // --- ここからが追加・変更した部分 ---
                // スペースを確保し、区切り線とテキストを配置
                SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(child: Divider(color: dividerColor, thickness: 1)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "または",
                        style: TextStyle(color: secondaryTextColor),
                      ),
                    ),
                    Expanded(child: Divider(color: dividerColor, thickness: 1)),
                  ],
                ),
                SizedBox(height: 32),
                // --- ここまで ---

                // --- アカウント連携ログイン欄 ---
                _buildSocialButton(
                    context,
                    text: "Googleでログイン",
                    iconUrl:
                        "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
                    isDark: isDark,
                    onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                }),
                SizedBox(height: 16),
                _buildSocialButton(
                    context,
                    text: "Appleでログイン",
                    iconUrl:
                        "https://upload.wikimedia.org/wikipedia/commons/3/31/Apple_logo_white.svg",
                    isDark: isDark,
                    isApple: true,
                    onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
                  );
                }),

                SizedBox(height: 40),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text(
                    "アカウントをお持ちでないですか？ 新規登録",
                    style: TextStyle(
                        color: theme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 8),
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

  Widget _buildSocialButton(BuildContext context,
      {required String text,
      required String iconUrl,
      required bool isDark,
      bool isApple = false,
      required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            isApple ? Colors.black : (isDark ? Colors.grey[800] : Colors.grey[100]),
        foregroundColor:
            isApple ? Colors.white : (isDark ? Colors.white : Colors.black),
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: isApple
                ? BorderSide.none
                : BorderSide(
                    color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 1)),
        elevation: 0,
        textStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(iconUrl,
              height: 24, width: 24, color: isApple ? Colors.white : null),
          SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }
}