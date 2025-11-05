import 'package:flutter/material.dart';
import 'theme.dart';
import 'onboarding_goal_screen.dart';

class OnboardingProfileScreen extends StatelessWidget {
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("あなたのことを教えてください", style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: 8),
              Text("より正確な分析のために使用します。", style: TextStyle(color: kTextDarkSecondary)),
              SizedBox(height: 32),
              TextField(
                decoration: InputDecoration(
                  labelText: "身長 (cm)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: "体重 (kg)",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 32),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OnboardingGoalScreen()),
                  );
                },
                child: Text("次へ"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

