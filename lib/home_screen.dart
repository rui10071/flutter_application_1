import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';
import 'selection_screen.dart';
import 'mydata_screen.dart';
import 'profile_screen.dart';
import 'details_screen.dart';
import 'training_model.dart';
import 'main_screen.dart';


class HomeScreen extends ConsumerStatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad),
    );
    _controller.forward();
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?q=80&w=2940&auto=format&fit=crop",
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
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.8),
                    Colors.black,
                  ],
                  stops: [0.0, 0.4, 0.8, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ListView(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 120),
                children: [
                  _buildHeader(context, ref),
                  
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: [
                        _buildDailyProgressCard(context),
                        SizedBox(height: 16),
                        _buildAiFeedbackCard(context, ref),
                        SizedBox(height: 32),
                      ],
                    ),
                  ),
                  
                  _buildRecommendedHeader(context, ref),
                  _buildRecommendedList(context),
                  SizedBox(height: 32),
                  _buildActivityGraph(context),
                  SizedBox(height: 24),
                  _buildRecentActivity(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userProfileProvider).name;


    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "お帰りなさい",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                userName,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => ref.read(mainNavIndexProvider.notifier).state = 3,
            child: Container(
              width: 48,
              height: 48,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: kPrimaryColor.withOpacity(0.8), width: 2),
                boxShadow: [
                  BoxShadow(color: kPrimaryColor.withOpacity(0.3), blurRadius: 12),
                ],
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: "https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2080&auto=format&fit=crop",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) => Icon(Icons.person, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildGlassCard({required Widget child, EdgeInsetsGeometry? padding, VoidCallback? onTap}) {
    final widget = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: child,
        ),
      ),
    );


    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: widget);
    }
    return widget;
  }


  Widget _buildDailyProgressCard(BuildContext context) {
    return _buildGlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.bolt, color: kPrimaryColor, size: 18),
                    SizedBox(width: 6),
                    Text("本日の目標", style: TextStyle(color: kPrimaryColor, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text("45", style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold, fontFamily: 'Lexend', height: 1.0)),
                    SizedBox(width: 4),
                    Text("/ 60 分", style: TextStyle(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 16),
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        Container(
                          height: 6,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        Container(
                          height: 6,
                          width: constraints.maxWidth * (45 / 60), // 親要素の幅に対する割合で計算
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [kPrimaryColor, Color(0xFF2E7D32)]),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [BoxShadow(color: kPrimaryColor.withOpacity(0.5), blurRadius: 6)],
                          ),
                        ),
                      ],
                    );
                  }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAiFeedbackCard(BuildContext context, WidgetRef ref) {
    final userGoal = ref.watch(userProfileProvider).goal;
    
    String feedbackText;
    String targetMenuId;


    switch (userGoal) {
      case "筋力をアップしたい":
        feedbackText = "「プッシュアップ」の負荷を高める時期です。";
        targetMenuId = "pushup";
        break;
      case "ダイエット・減量したい":
        feedbackText = "「全身HIIT」で燃焼効率を上げましょう。";
        targetMenuId = "hiit";
        break;
      case "フォームを改善したい":
      default:
        feedbackText = "昨日の「スクワット」で膝のブレを検知しました。";
        targetMenuId = "squat";
        break;
    }
    
    final targetMenu = DUMMY_TRAININGS.firstWhere((m) => m.id == targetMenuId, orElse: () => DUMMY_TRAININGS.first);


    return _buildGlassCard(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: targetMenu)));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(color: kPrimaryColor.withOpacity(0.2), shape: BoxShape.circle),
                    child: Icon(Icons.smart_toy_outlined, color: kPrimaryColor, size: 16),
                  ),
                  SizedBox(width: 10),
                  Text("AI分析", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.0, fontSize: 12)),
                ],
              ),
              Icon(Icons.arrow_forward, color: Colors.white38, size: 18),
            ],
          ),
          SizedBox(height: 12),
          Text(
            feedbackText,
            style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9)),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Text("復習する", style: TextStyle(color: kPrimaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              Icon(Icons.play_arrow_rounded, color: kPrimaryColor, size: 16),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildRecommendedHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text("おすすめ", style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 20,
            color: Colors.white
          )),
          GestureDetector(
            onTap: () => ref.read(mainNavIndexProvider.notifier).state = 1,
            child: Text("すべて見る", style: TextStyle(color: Colors.white54, fontSize: 12)),
          ),
        ],
      ),
    );
  }


  Widget _buildRecommendedList(BuildContext context) {
    final recommendedItems = DUMMY_TRAININGS.take(3).toList();


    return Container(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 24),
        itemCount: recommendedItems.length,
        itemBuilder: (context, index) {
          final item = recommendedItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)));
            },
            child: Container(
              width: 180,
              margin: EdgeInsets.only(right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: item.isAsset
                                ? Image.asset(item.imagePath, fit: BoxFit.cover)
                                : CachedNetworkImage(imageUrl: item.imagePath, fit: BoxFit.cover),
                          ),
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                  stops: [0.6, 1.0],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: kPrimaryColor,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(item.difficulty, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.black)),
                                ),
                                SizedBox(height: 4),
                                Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildActivityGraph(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
            child: Text("アクティビティ", style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 20,
              color: Colors.white
            )),
          ),
          _buildGlassCard(
            child: Container(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 60,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => Color(0xFF1a2c22),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const labels = ['月', '火', '水', '木', '金', '土', '日'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(labels[value.toInt()], style: TextStyle(color: Colors.white38, fontSize: 10, fontWeight: FontWeight.bold)),
                          );
                        },
                        reservedSize: 20,
                      ),
                    ),
                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  barGroups: [
                    _makeBar(0, 30),
                    _makeBar(1, 45),
                    _makeBar(2, 20),
                    _makeBar(3, 0),
                    _makeBar(4, 50, isHighlight: true),
                    _makeBar(5, 15),
                    _makeBar(6, 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRecentActivity(BuildContext context) {
    final recentActivities = [
      {"title": "基本のスクワット", "desc": "15回 x 3セット", "icon": Icons.fitness_center},
      {"title": "プッシュアップ", "desc": "10回 x 3セット", "icon": Icons.fitness_center},
    ];


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Padding(
            padding: const EdgeInsets.only(left: 4.0, bottom: 12.0),
            child: Text("履歴", style: TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 20,
              color: Colors.white
            )),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentActivities.length,
            separatorBuilder: (context, index) => SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = recentActivities[index];
              return _buildGlassCard(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                onTap: () {
                  final menu = DUMMY_TRAININGS.firstWhere((m) => m.title == item["title"], orElse: () => DUMMY_TRAININGS.first);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: menu)));
                },
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item["icon"] as IconData, color: Colors.white70, size: 20),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item["title"] as String, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14)),
                          SizedBox(height: 2),
                          Text(item["desc"] as String, style: TextStyle(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.white38, size: 18),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  BarChartGroupData _makeBar(int x, double y, {bool isHighlight = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isHighlight ? kPrimaryColor : Colors.white.withOpacity(0.3),
          width: 8,
          borderRadius: BorderRadius.circular(4),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 60,
            color: Colors.white.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}


