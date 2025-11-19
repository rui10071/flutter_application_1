import 'dart:ui';
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


class _ResultScreenState extends ConsumerState<ResultScreen> with TickerProviderStateMixin {
  late TextEditingController _memoController;
  late String _reps;
  late int _score;
  late AnimationController _animationController;
  late Animation<double> _scoreAnimation;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
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
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut)
    );


    _animationController.forward();
    _fadeController.forward();
  }


  @override
  void dispose() {
    _memoController.dispose();
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16, top: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.2)),
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
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    kPrimaryColor.withOpacity(0.2),
                    Colors.black,
                  ],
                  stops: [0.0, 0.6],
                ),
              ),
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 40),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Text(
                      _isFromHistory ? "履歴詳細" : "お疲れ様！",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        shadows: [Shadow(color: kPrimaryColor.withOpacity(0.5), blurRadius: 20)],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    Text(
                      widget.menu.title,
                      style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 48),
                    
                    _buildScoreCircle(context),
                    
                    SizedBox(height: 48),
                    
                    _buildStatsGrid(context),
                    
                    SizedBox(height: 32),
                    _buildMemoSection(context),
                  ],
                ),
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
          height: 240,
          width: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: kPrimaryColor.withOpacity(0.1), blurRadius: 40, spreadRadius: 10),
                  ],
                ),
              ),
              PieChart(
                PieChartData(
                  startDegreeOffset: 270,
                  sectionsSpace: 0,
                  centerSpaceRadius: 90,
                  sections: [
                    PieChartSectionData(
                      color: kPrimaryColor,
                      value: _scoreAnimation.value,
                      radius: 25,
                      showTitle: false,
                      gradient: LinearGradient(colors: [kPrimaryColor, Colors.tealAccent]),
                    ),
                    PieChartSectionData(
                      color: Colors.white.withOpacity(0.05),
                      value: 100 - _scoreAnimation.value,
                      radius: 25,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "スコア",
                    style: TextStyle(color: Colors.white54, fontSize: 14, letterSpacing: 2.0, fontWeight: FontWeight.bold),
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
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lexend',
                          height: 1.0,
                          shadows: [Shadow(color: kPrimaryColor.withOpacity(0.5), blurRadius: 10)],
                        ),
                      ),
                      Text(
                        "点",
                        style: TextStyle(color: Colors.white70, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 12),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: kPrimaryColor.withOpacity(0.5)),
                    ),
                    child: Text(
                      "素晴らしい",
                      style: TextStyle(color: kPrimaryColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildStatsGrid(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: _buildStatCard(Icons.timer_outlined, widget.menu.duration, "時間")),
        SizedBox(width: 16),
        Expanded(child: _buildStatCard(Icons.fitness_center, _reps, "回数")),
        // カロリー削除済み
      ],
    );
  }


  Widget _buildStatCard(IconData icon, String value, String label) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Icon(icon, color: kPrimaryColor, size: 28),
              SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'Lexend'),
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(color: Colors.white54, fontSize: 10, letterSpacing: 1.0),
              ),
            ],
          ),
        ),
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
            "メモ",
            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
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
                  hintText: _isFromHistory ? "メモはありません" : "今日のトレーニングの感想を残しましょう...",
                  hintStyle: TextStyle(color: Colors.white38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(20),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}


