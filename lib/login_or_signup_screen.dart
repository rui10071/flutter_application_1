import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'email_login_screen.dart';
import 'email_signup_screen.dart';
import 'onboarding_profile_screen.dart';
import 'common_widgets.dart';


class LoginOrSignupScreen extends StatefulWidget {
  @override
  _LoginOrSignupScreenState createState() => _LoginOrSignupScreenState();
}


class _LoginOrSignupScreenState extends State<LoginOrSignupScreen> {
  bool _isLoading = false;


  Future<void> _handleMockSocialSignup() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;
    setState(() => _isLoading = false);


    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OnboardingProfileScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.height < 700;


    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [kPrimaryColor, kBackgroundDark],
                  stops: [0.0, 0.8],
                ),
              ),
            ),
            Positioned(
              top: -120,
              right: -80,
              child: Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: isSmallScreen ? 20 : 40),
                      
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            "assets/images/Benchpress_logo.jpg",
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "MIRRORSENSE",
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "AIで理想のフォームへ。\n今すぐトレーニングを始めましょう。",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          height: 1.5,
                        ),
                      ),
                      
                      SizedBox(height: isSmallScreen ? 24 : 40),
                      
                      _buildSocialButton(
                        context,
                        text: "Googleで登録",
                        iconUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
                        onPressed: _handleMockSocialSignup,
                      ),
                      SizedBox(height: 12),
                      _buildSocialButton(
                        context,
                        text: "Appleで登録",
                        iconUrl: "https://upload.wikimedia.org/wikipedia/commons/3/31/Apple_logo_white.svg",
                        isApple: true,
                        onPressed: _handleMockSocialSignup,
                      ),
                      SizedBox(height: 16), 
                      
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.white24)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text("または", style: TextStyle(color: Colors.white54, fontSize: 12)),
                          ),
                          Expanded(child: Divider(color: Colors.white24)),
                        ],
                      ),
                      SizedBox(height: 16), 
                      
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 8,
                            shadowColor: kPrimaryColor.withOpacity(0.4),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmailSignupScreen()),
                            );
                          },
                          child: Text(
                            "メールアドレスで作成",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      
                      SizedBox(height: 16),
                      
                      GestureDetector(
                        onTap: () async {
                          final Uri url = Uri.parse('https://google.com');
                          if (!await launchUrl(url)) {
                            print("Could not launch $url");
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "アカウントを作成することにより、当社の利用規約、プライバシーポリシー、Cookieの使用に同意したものとみなされます。",
                            style: TextStyle(color: Colors.white38, fontSize: 10, height: 1.4),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),


                      SizedBox(height: isSmallScreen ? 16 : 32),
                      Divider(color: Colors.white12),
                      SizedBox(height: 8),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("すでにアカウントをお持ちですか？", style: TextStyle(color: Colors.white60, fontSize: 13)),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EmailLoginScreen()),
                              );
                            },
                            child: Text("ログイン", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSocialButton(BuildContext context, {required String text, required String iconUrl, bool isApple = false, required VoidCallback onPressed}) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.white.withOpacity(0.05),
        side: BorderSide(color: Colors.white24),
        minimumSize: Size(double.infinity, 52), 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(iconUrl, height: 20, width: 20, color: isApple ? Colors.white : null),
          SizedBox(width: 12),
          Text(text, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}


