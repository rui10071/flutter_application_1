import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'onboarding_goal_screen.dart';
import 'profile_screen.dart'; 


class OnboardingProfileScreen extends ConsumerStatefulWidget {
  @override
  _OnboardingProfileScreenState createState() => _OnboardingProfileScreenState();
}


class _OnboardingProfileScreenState extends ConsumerState<OnboardingProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  bool _isButtonEnabled = false;


  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }


  String? _validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '${fieldName}を入力してください';
    }
    if (double.tryParse(value) == null) {
      return '有効な数値を入力してください';
    }
    return null;
  }


  void _validateForm() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("プロフィール (2/3)"),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("あなたのことを教えてください", style: Theme.of(context).textTheme.titleLarge),
                SizedBox(height: 8),
                Text("より正確な分析のために使用します。", style: TextStyle(color: kTextDarkSecondary)),
                SizedBox(height: 32),
                TextFormField(
                  controller: _heightController,
                  decoration: InputDecoration(
                    labelText: "身長 (cm)",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumeric(value, "身長"),
                  onChanged: (value) => _validateForm(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  decoration: InputDecoration(
                    labelText: "体重 (kg)",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumeric(value, "体重"),
                  onChanged: (value) => _validateForm(),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled ? kPrimaryColor : Colors.grey[600],
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
                  ),
                  onPressed: _isButtonEnabled ? () {
                    if (_formKey.currentState!.validate()) {
                      ref.read(userProfileProvider.notifier).updateHeight(_heightController.text);
                      ref.read(userProfileProvider.notifier).updateWeight(_weightController.text);
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OnboardingGoalScreen()),
                      );
                    }
                  } : null,
                  child: Text("次へ"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


