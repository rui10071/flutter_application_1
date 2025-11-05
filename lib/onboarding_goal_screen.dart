import 'package:flutter/material.dart';
import 'theme.dart';
import 'main_screen.dart';

class OnboardingGoalScreen extends StatelessWidget {
  final List<String> goals = [
    "フォームを改善したい",
    "筋力をアップしたい",
    "ダイエット・減量したい",
    "健康を維持したい",
    "リハビリ・怪我予防",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("目的を選択 (3/3)"),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("主な目的を教えてください", style: Theme.of(context).textTheme.titleLarge),
            SizedBox(height: 8),
            Text("あなたに合ったメニューをおすすめします。", style: TextStyle(color: kTextDarkSecondary)),
            SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: goals.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      child: ListTile(
                        title: Text(goals[index], style: TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Icon(Icons.chevron_right),
                        onTap: () {
                          _completeOnboarding(context);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {
                  _completeOnboarding(context);
                },
                child: Text(
                  "あとで選択する",
                  style: TextStyle(color: kTextDarkSecondary, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _completeOnboarding(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MainScreen()),
      (route) => false,
    );
  }
}

