import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'theme.dart';
import 'main_screen.dart';
import 'training_model.dart';
import 'training_history.dart';


class ResultScreen extends ConsumerStatefulWidget {
  final TrainingMenu menu;
  final TrainingHistoryItem? historyItem;


  ResultScreen({required this.menu, this.historyItem});


  @override
  _ResultScreenState createState() => _ResultScreenState();
}


class _ResultScreenState extends ConsumerState<ResultScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _memoController;
  late String _reps;
  late int _score;
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  bool _isFromHistory = false;


  @override
  void initState() {
    super.initState();
    _isFromHistory = widget.historyItem != null;
    _reps = widget.historyItem?.reps ?? "20回";
    _score = widget.historyItem?.score ?? 85;
    _memoController = TextEditingController(text: widget.historyItem?.memo ?? "");


    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _scoreAnimation = Tween<double>(begin: 0, end: _score.toDouble()).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic)
    );


    _animationController.forward();
  }


  @override
  void dispose() {
    _memoController.dispose();
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16, top: 8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                if (!_isFromHistory && _memoController.text.isNotEmpty) {
                  ref.read(trainingHistoryProvider.notifier).addEntry(
                    menu: widget.menu,
                    reps: _reps,
                    score: _score,
                    memo: _memoController.text,
                  );
                }
                Navigator.popUntil(context, (route) => route.isFirst);
                ref.read(mainNavIndexProvider.notifier).state = 0;
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kPrimaryColor, kBackgroundDark],
                stops: [0.0, 0.6],
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 40),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    _isFromHistory ? "トレーニング結果" : "GREAT JOB!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lexend',
                      letterSpacing: 2.0,
                      shadows: [Shadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.menu.title,
                    style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 40),
                  
                  // スコアサークル（ゲージ）
                  _buildScoreCircle(context),
                  
                  SizedBox(height: 40),
                  
                  // スタッツグリッド
                  _buildStatsGrid(context),
                  
                  SizedBox(height: 32),
                  _buildMemoSection(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildScoreCircle(BuildContext context) {
    return AnimatedBuilder(
      animation: _scoreAnimation,
      builder: (context, child) {
        return Container(
          height: 220,
          width: 220,
          child: Stack(
            children: [
              // 背景の円
              PieChart(
                PieChartData(
                  startDegreeOffset: 270,
                  sectionsSpace: 0,
                  centerSpaceRadius: 80,
                  sections: [
                    PieChartSectionData(
                      color: kPrimaryColor.withOpacity(0.3), // 残り部分の色
                      value: 100,
                      radius: 20,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              // メインのゲージ
              PieChart(
                PieChartData(
                  startDegreeOffset: 270,
                  sectionsSpace: 0,
                  centerSpaceRadius: 80,
                  sections: [
                    PieChartSectionData(
                      color: Colors.white,
                      value: _scoreAnimation.value,
                      radius: 20,
                      showTitle: false,
                    ),
                    PieChartSectionData(
                      color: Colors.transparent,
                      value: 100 - _scoreAnimation.value,
                      radius: 20,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              // 中央のテキスト
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "SCORE",
                      style: TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 2.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "${_scoreAnimation.value.toInt()}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lexend',
                            height: 1.0,
                          ),
                        ),
                        Text(
                          "点",
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "Excellent",
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.timer_outlined, widget.menu.duration, "時間")),
        SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.fitness_center, _reps, "回数")),
        SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.local_fire_department_outlined, "50 kcal", "消費")),
      ],
    );
  }


  Widget _buildStatCard(IconData icon, String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: kPrimaryColor, size: 28),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: kTextDarkSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }


  Widget _buildMemoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
          child: Text(
            "トレーニングメモ",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: _memoController,
            enabled: !_isFromHistory,
            maxLines: 4,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: _isFromHistory ? "メモはありません" : "今日の気づきを残しましょう...",
              hintStyle: TextStyle(color: kTextDarkSecondary),
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}


