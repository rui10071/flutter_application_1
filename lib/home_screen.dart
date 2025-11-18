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


class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [kPrimaryColor.withOpacity(0.6), Theme.of(context).scaffoldBackgroundColor],
                      stops: [0.0, 0.3],
                    )
                  : null,
              color: isDark ? null : kBackgroundLight,
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.only(bottom: 100),
              children: [
                _buildHeader(context, ref, isDark),
                
                // 入れ替え：本日の進捗を先に表示
                _buildDailyProgressCard(context),
                
                // 入れ替え：AIアドバイスをその下に
                _buildAiFeedbackCard(context, ref, isDark),
                
                _buildRecommendedHeader(context, ref, isDark),
                _buildRecommendedList(context, isDark),
                _buildActivityGraph(context, isDark),
                _buildRecentActivity(context, isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(BuildContext context, WidgetRef ref, bool isDark) {
    final userName = ref.watch(userProfileProvider).name;
    final textColor = isDark ? Colors.white : kTextLight;


    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "こんにちは、$userNameさん",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              SizedBox(height: 4),
              Text("今日もトレーニングを続けましょう", style: TextStyle(color: isDark ? Colors.white70 : kTextLightSecondary, fontSize: 14)),
            ],
          ),
          GestureDetector(
            onTap: () => ref.read(mainNavIndexProvider.notifier).state = 3,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: isDark ? Colors.white : kPrimaryColor, width: 2),
              ),
              child: CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAiFeedbackCard(BuildContext context, WidgetRef ref, bool isDark) {
    final userGoal = ref.watch(userProfileProvider).goal;
    final cardColor = isDark ? kCardDark : Colors.white;
    final textColor = isDark ? Colors.white : kTextLight;
    
    String feedbackText;
    String targetMenuId;


    switch (userGoal) {
      case "筋力をアップしたい":
        feedbackText = "AIが「プッシュアップ」の復習を推奨しています。前回より負荷を上げてみましょう。";
        targetMenuId = "pushup";
        break;
      case "ダイエット・減量したい":
        feedbackText = "目標達成のため「全身HIIT」がおすすめです。心拍数を上げて脂肪を燃焼させましょう。";
        targetMenuId = "hiit";
        break;
      case "フォームを改善したい":
      default:
        feedbackText = "昨日の「スクワット」のフォーム（膝）が乱れていました。復習しましょう。";
        targetMenuId = "squat";
        break;
    }
    
    final targetMenu = DUMMY_TRAININGS.firstWhere((m) => m.id == targetMenuId, orElse: () => DUMMY_TRAININGS.first);


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: cardColor,
        elevation: isDark ? 0 : 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: targetMenu)));
          },
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.smart_toy, color: kPrimaryColor, size: 20),
                    SizedBox(width: 8),
                    Text("AIアドバイス", style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor)),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  feedbackText,
                  style: TextStyle(fontSize: 15, height: 1.5, fontWeight: FontWeight.w500, color: textColor),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("確認する", style: TextStyle(color: isDark ? kTextDarkSecondary : kTextLightSecondary, fontSize: 12)),
                    Icon(Icons.chevron_right, color: isDark ? kTextDarkSecondary : kTextLightSecondary, size: 16),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildDailyProgressCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: kPrimaryColor.withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("本日の活動", style: TextStyle(color: Colors.white70, fontSize: 14)),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text("45", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold, fontFamily: 'Lexend')),
                      SizedBox(width: 4),
                      Text("min", style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                  SizedBox(height: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("目標: 60 min", style: TextStyle(color: Colors.white54, fontSize: 12)),
                      SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: 45 / 60,
                          backgroundColor: Colors.black26,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          minHeight: 6,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.timer_outlined, color: Colors.white, size: 32),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRecommendedHeader(BuildContext context, WidgetRef ref, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 8, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("あなたへのおすすめ", style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold, 
            fontSize: 18,
            color: isDark ? Colors.white : kTextLight
          )),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text("すべて見る", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold)),
            onPressed: () {
              ref.read(mainNavIndexProvider.notifier).state = 1;
            },
          ),
        ],
      ),
    );
  }


  Widget _buildRecommendedList(BuildContext context, bool isDark) {
    final recommendedItems = DUMMY_TRAININGS.take(3).toList();


    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: recommendedItems.length,
        itemBuilder: (context, index) {
          final item = recommendedItems[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)));
            },
            child: Container(
              width: 240,
              margin: EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isDark ? kCardDark : Colors.white,
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    child: item.isAsset
                        ? Image.asset(item.imagePath, height: 120, width: double.infinity, fit: BoxFit.cover)
                        : CachedNetworkImage(imageUrl: item.imagePath, height: 120, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: isDark ? Colors.white : kTextLight), maxLines: 1, overflow: TextOverflow.ellipsis),
                        SizedBox(height: 4),
                        Text(item.description, style: TextStyle(color: isDark ? kTextDarkSecondary : kTextLightSecondary, fontSize: 12)),
                      ],
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


  Widget _buildActivityGraph(BuildContext context, bool isDark) {
    final textColor = isDark ? kTextDarkSecondary : kTextLightSecondary;


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("週間活動量", style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold, 
            fontSize: 18,
            color: isDark ? Colors.white : kTextLight
          )),
          SizedBox(height: 12),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: isDark ? 0 : 2,
            color: isDark ? kCardDark : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 160,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 60,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipColor: (group) => isDark ? kCardDark : Colors.white,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            const labels = ['月', '火', '水', '木', '金', '土', '日'];
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(labels[value.toInt()], style: TextStyle(color: textColor, fontSize: 12)),
                            );
                          },
                          reservedSize: 30,
                        ),
                      ),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    barGroups: [
                      _makeBar(context, 0, 30, isDark),
                      _makeBar(context, 1, 45, isDark),
                      _makeBar(context, 2, 20, isDark),
                      _makeBar(context, 3, 0, isDark),
                      _makeBar(context, 4, 50, isDark, isHighlight: true),
                      _makeBar(context, 5, 15, isDark),
                      _makeBar(context, 6, 40, isDark),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRecentActivity(BuildContext context, bool isDark) {
    final recentActivities = [
      {"title": "基本のスクワット", "desc": "15回 x 3セット", "icon": Icons.fitness_center},
      {"title": "プッシュアップ", "desc": "10回 x 3セット", "icon": Icons.fitness_center},
    ];


    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("最近のアクティビティ", style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold, 
            color: isDark ? Colors.white : kTextLight, 
            fontSize: 18
          )),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentActivities.length,
            itemBuilder: (context, index) {
              final item = recentActivities[index];
              return Card(
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: isDark ? 0 : 2,
                color: isDark ? kCardDark : Colors.white,
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item["icon"] as IconData, color: kPrimaryColor),
                  ),
                  title: Text(item["title"] as String, style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.white : kTextLight)),
                  subtitle: Text(item["desc"] as String, style: TextStyle(color: isDark ? kTextDarkSecondary : kTextLightSecondary)),
                  trailing: Icon(Icons.chevron_right, color: isDark ? kTextDarkSecondary : kTextLightSecondary),
                  onTap: () {
                    final menu = DUMMY_TRAININGS.firstWhere((m) => m.title == item["title"], orElse: () => DUMMY_TRAININGS.first);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: menu)));
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }


  BarChartGroupData _makeBar(BuildContext context, int x, double y, bool isDark, {bool isHighlight = false}) {
    final barColor = isHighlight ? kPrimaryColor : (isDark ? Colors.blueGrey[700] : Colors.blueGrey[200]);


    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 12,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 60,
            color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
          ),
        ),
      ],
    );
  }
}


