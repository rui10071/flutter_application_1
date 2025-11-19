import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'theme.dart';
import 'email_login_screen.dart';
import 'email_signup_screen.dart';
import 'onboarding_profile_screen.dart';
import 'common_widgets.dart';


class LoginOrSignupScreen extends StatefulWidget {
  @override
  _LoginOrSignupScreenState createState() => _LoginOrSignupScreenState();
}


class _LoginOrSignupScreenState extends State<LoginOrSignupScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  Future<void> _handleMockSocialSignup() async {
    setState(() => _isLoading = true);
    await Future.delayed(Duration(milliseconds: 800));
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
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=2940&auto=format&fit=crop",
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.black),
                errorWidget: (context, url, error) => Container(color: Color(0xFF122017)),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.0),
                      Colors.black.withOpacity(0.7),
                      Colors.black.withOpacity(1.0),
                    ],
                    stops: [0.0, 0.4, 0.7, 1.0],
                  ),
                ),
              ),
            ),
           
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(flex: 3),


                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: kPrimaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              "assets/images/Benchpress_logo.jpg",
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Center(
                        //child: Text(
                          //"MIRRORSENSE",
                          //style: TextStyle(
                            //fontFamily: 'Lexend',
                            //fontSize: 15,
                            //fontWeight: FontWeight.bold,
                            //letterSpacing: 2.0,
                            //color: Colors.white.withOpacity(0.95),
                          ),
                        //),
                      //),
                      SizedBox(height: isSmallScreen ? 32 : 48),


                      Text(
                        "理想のフォームを、\nAIと共に。",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontFamily: 'Noto Sans JP',
                          fontSize: isSmallScreen ? 36 : 44,
                          fontWeight: FontWeight.w800,
                          height: 1.15,
                          color: Colors.white,
                          letterSpacing: -1.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 20,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        "最新の骨格検知AIが、あなたのトレーニングをリアルタイムで解析。怪我を防ぎ、効率的なボディメイクをサポートします。",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                          height: 1.6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                     
                      Spacer(flex: 2),
                     
                      Row(
                        children: [
                          Expanded(
                            child: _buildSocialButton(
                              text: "Appleで登録",
                              iconUrl: "https://upload.wikimedia.org/wikipedia/commons/3/31/Apple_logo_white.svg",
                              isApple: true,
                              onPressed: _handleMockSocialSignup,
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _buildSocialButton(
                              text: "Googleで登録",
                              iconUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
                              onPressed: _handleMockSocialSignup,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),


                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor,
                            foregroundColor: Colors.black,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EmailSignupScreen()),
                            );
                          },
                          child: Text(
                            "メールアドレスで登録",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                     
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "すでにアカウントをお持ちですか？",
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                          SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => EmailLoginScreen()),
                              );
                            },
                            child: Text(
                              "ログイン",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                     
                      Spacer(flex: 1),
                     
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            final Uri url = Uri.parse('https://google.com');
                            if (!await launchUrl(url)) {}
                          },
                          child: Text(
                            "利用規約・プライバシーポリシー",
                            style: TextStyle(color: Colors.white24, fontSize: 10),
                          ),
                        ),
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


  Widget _buildSocialButton({required String text, required String iconUrl, bool isApple = false, required VoidCallback onPressed}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.network(
                      iconUrl,
                      height: 18,
                      width: 18,
                      color: isApple ? Colors.white : null,
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


