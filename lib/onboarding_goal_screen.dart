import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'main_screen.dart'; 
import 'profile_screen.dart';


class OnboardingGoalScreen extends ConsumerWidget {
  final List<String> goals = [
    "フォームを改善したい",
    "筋力をアップしたい",
    "ダイエット・減量したい",
    "健康を維持したい",
    "リハビリ・怪我予防",
  ];
  
  final bool isChangingGoal;


  OnboardingGoalScreen({this.isChangingGoal = false});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(isChangingGoal ? "目標を変更" : "目標を選択 (3/3)", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Lexend', color: Colors.white)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Color(0xFF121212)],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("主な目的を教えてください", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 8),
                Text("あなたに合ったメニューをおすすめします。", style: TextStyle(color: Colors.white54)),
                SizedBox(height: 32),
                Expanded(
                  child: ListView.builder(
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                title: Text(goals[index], style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                trailing: Icon(Icons.chevron_right, color: kPrimaryColor),
                                onTap: () {
                                  ref.read(userProfileProvider.notifier).updateGoal(goals[index]);
                                  _completeOnboarding(context, ref); 
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!isChangingGoal) ...[
                  SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        _completeOnboarding(context, ref); 
                      },
                      child: Text(
                        "あとで選択する",
                        style: TextStyle(color: Colors.white38, fontSize: 14),
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }


  void _completeOnboarding(BuildContext context, WidgetRef ref) {
    if (isChangingGoal) {
      Navigator.pop(context);
    } else {
      ref.read(mainNavIndexProvider.notifier).state = 0;


      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
        (route) => false,
      );
    }
  }
}


