import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'main_screen.dart';
import 'theme.dart';
import 'forgot_password_screen.dart';
import 'common_widgets.dart';
import 'repositories.dart';
import 'providers.dart';
import 'email_signup_screen.dart';


class EmailLoginScreen extends ConsumerStatefulWidget {
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}


class _EmailLoginScreenState extends ConsumerState<EmailLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();


  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  String? _validateIdentifier(String? value) {
    if (value == null || value.isEmpty) {
      return 'メールアドレスまたは電話番号を入力してください';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');


    if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value.replaceAll(RegExp(r'\s|-'), ''))) {
      return '有効なメールアドレスまたは電話番号を入力してください';
    }
    return null;
  }


  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'パスワードを入力してください';
    }
    if (value.length < 6) {
      return 'パスワードは6文字以上で入力してください';
    }
    return null;
  }


  void _validateForm() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }


  Future<void> _handleLogin() async {
    FocusScope.of(context).unfocus();


    setState(() {
      _isLoading = true;
    });


    try {
      await ref.read(authRepositoryProvider).signInWithEmail(
        _identifierController.text,
        _passwordController.text,
      );
      if (!mounted) return;


      ref.read(mainNavIndexProvider.notifier).state = 0;


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (route) => false,
      );


    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, "ログイン失敗", "入力情報またはパスワードが間違っています。\n($e)");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  Future<void> _handleMockSocialLogin() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(Duration(seconds: 1));
    if (!mounted) return;
    
    setState(() {
      _isLoading = false;
    });


    ref.read(mainNavIndexProvider.notifier).state = 0;


    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (route) => false,
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;


    return LoadingOverlay(
      isLoading: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [kPrimaryColor.withOpacity(0.3), kBackgroundDark],
                  stops: [0.0, 0.9],
                ),
              ),
            ),
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor.withOpacity(0.1),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.2),
                      blurRadius: 100,
                      spreadRadius: 20,
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height * 0.02),
                        Text(
                          "ログイン",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "アカウントにログインして、トレーニングを再開しましょう。",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            height: 1.5,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 48),
                        TextFormField(
                          controller: _identifierController,
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "メールアドレスまたは電話番号",
                            hintStyle: TextStyle(color: Colors.white38),
                            prefixIcon: Icon(Icons.person_outline, color: Colors.white70, size: 20),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.08),
                            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: kPrimaryColor, width: 2),
                            ),
                            errorStyle: TextStyle(color: kHighlight),
                          ),
                          validator: _validateIdentifier,
                          onChanged: (value) => _validateForm(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "パスワード",
                            hintStyle: TextStyle(color: Colors.white38),
                            prefixIcon: Icon(Icons.lock_outline, color: Colors.white70, size: 20),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.08),
                            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide(color: kPrimaryColor, width: 2),
                            ),
                            errorStyle: TextStyle(color: kHighlight),
                          ),
                          validator: _validatePassword,
                          onChanged: (value) => _validateForm(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                              );
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "パスワードをお忘れですか？",
                              style: TextStyle(color: Colors.white60, fontSize: 12),
                            ),
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: (_isButtonEnabled && !_isLoading) ? kPrimaryColor.withOpacity(0.3) : Colors.transparent,
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (_isButtonEnabled && !_isLoading) ? kPrimaryColor : Colors.grey[600],
                              foregroundColor: Colors.white,
                              minimumSize: Size(double.infinity, 56),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              elevation: 0,
                              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
                            ),
                            onPressed: (_isButtonEnabled && !_isLoading) ? _handleLogin : null,
                            child: Text("ログイン"),
                          ),
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text("または", style: TextStyle(color: Colors.white70, fontSize: 12)),
                            ),
                            Expanded(child: Divider(color: Colors.white.withOpacity(0.3))),
                          ],
                        ),
                        SizedBox(height: 24),
                        _buildSocialButton(
                          context,
                          text: "Googleでログイン",
                          iconUrl: "https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg",
                          onPressed: _handleMockSocialLogin,
                        ),
                        SizedBox(height: 12),
                        _buildSocialButton(
                          context,
                          text: "Appleでログイン",
                          iconUrl: "https://upload.wikimedia.org/wikipedia/commons/3/31/Apple_logo_white.svg",
                          isApple: true,
                          onPressed: _handleMockSocialLogin,
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "アカウントをお持ちでないですか？ ",
                              style: TextStyle(fontSize: 14, color: Colors.white70),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EmailSignupScreen()),
                                );
                              },
                              child: Text(
                                "新規登録",
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
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
    Color backgroundColor = Colors.transparent;
    Color borderColor = Colors.white.withOpacity(0.25);


    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor,
        side: BorderSide(color: borderColor),
        minimumSize: Size(double.infinity, 56),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.network(
            iconUrl,
            height: 22,
            width: 22,
            color: isApple ? Colors.white : null
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}


