import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'common_widgets.dart';
import 'repositories.dart';
import 'providers.dart';
import 'email_login_screen.dart';
import 'onboarding_profile_screen.dart'; 


class EmailSignupScreen extends ConsumerStatefulWidget {
  @override
  _EmailSignupScreenState createState() => _EmailSignupScreenState();
}


class _EmailSignupScreenState extends ConsumerState<EmailSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;
  bool _isLoading = false;
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();


  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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


  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return '確認のためパスワードを再入力してください';
    }
    if (value != _passwordController.text) {
      return 'パスワードが一致しません';
    }
    return null;
  }


  void _validateForm() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }


  Future<void> _handleSignup() async {
    FocusScope.of(context).unfocus();


    setState(() {
      _isLoading = true;
    });


    try {
      await ref.read(authRepositoryProvider).signUpWithEmail(
        _identifierController.text,
        _passwordController.text,
      );
      if (!mounted) return;
      showSnackBar(context, "登録が完了しました！", isError: false);
      
      // 変更: 登録後はオンボーディング（身長体重入力）へ
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OnboardingProfileScreen()),
      );


    } catch (e) {
      if (!mounted) return;
      showErrorDialog(context, "登録失敗", "すでに登録済みのユーザーか、登録に失敗しました。\n($e)");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      if (!mounted) return;
      showSnackBar(context, "ページを開けませんでした", isError: true);
    }
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
                          "アカウントを作成",
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontFamily: 'Lexend',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "メールアドレスまたは電話番号で新しいアカウントを作成しましょう。",
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
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "パスワード（確認用）",
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
                          validator: _validateConfirmPassword,
                          onChanged: (value) => _validateForm(),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            onPressed: (_isButtonEnabled && !_isLoading) ? _handleSignup : null,
                            child: Text("次へ"),
                          ),
                        ),
                        SizedBox(height: 24),
                        
                        Center(
                          child: TextButton(
                            onPressed: () {
                              _launchURL('https://google.com'); 
                            },
                            style: TextButton.styleFrom(
                              minimumSize: Size(100, 48),
                            ),
                            child: Text(
                              "利用規約とプライバシーポリシー",
                              style: TextStyle(color: Colors.white54, fontSize: 12),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),


                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "すでにアカウントをお持ちですか？ ",
                                style: TextStyle(fontSize: 14, color: Colors.white70),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EmailLoginScreen()),
                                  );
                                },
                                child: Text(
                                  "ログイン",
                                  style: TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
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
}


