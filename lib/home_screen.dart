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
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [kPrimaryColor.withOpacity(0.6), Theme.of(context).scaffoldBackgroundColor],
                stops: [0.0, 0.3],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: ListView(
              padding: EdgeInsets.only(bottom: 100),
              children: [
                _buildHeader(context, ref),
                _buildAiFeedbackCard(context, ref),
                _buildSummaryCards(context),
                _buildRecommendedHeader(context, ref),
                _buildRecommendedList(context),
                _buildActivityGraph(context),
                _buildRecentActivity(context),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final userName = ref.watch(userProfileProvider).name;


    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "こんにちは、$userNameさん！",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),
              ),
              SizedBox(height: 4),
              Text(
                "今日もフォームを改善しましょう",
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              ref.read(mainNavIndexProvider.notifier).state = 3;
            },
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/images/shoulderstretch.jpg"),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAiFeedbackCard(BuildContext context, WidgetRef ref) {
    final userGoal = ref.watch(userProfileProvider).goal;
    final isDark = Theme.of(context).brightness == Brightness.dark;


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
      padding: const EdgeInsets.all(16.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: isDark ? kCardDark : kCardLight,
        elevation: 4,
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: targetMenu)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Icon(Icons.smart_toy_outlined, color: kPrimaryColor, size: 20),
                    SizedBox(width: 8),
                    Text("AIからのフィードバック", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        feedbackText,
                        style: TextStyle(fontSize: 14, height: 1.5, color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.chevron_right, color: kTextDarkSecondary),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSummaryCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          _buildInfoCard("本日の活動時間", "45m", Icons.timer_outlined, kPrimaryColor.withOpacity(0.1), kPrimaryColor),
          SizedBox(width: 16),
          _buildInfoCard("消費カロリー", "320 kcal", Icons.local_fire_department_outlined, Colors.orange.withOpacity(0.1), Colors.orange),
        ],
      ),
    );
  }


  Widget _buildInfoCard(String title, String value, IconData icon, Color backgroundColor, Color iconColor) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: kTextDarkSecondary, fontSize: 12)),
                  SizedBox(height: 4),
                  Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildRecommendedHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("あなたへのおすすめ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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


  Widget _buildRecommendedList(BuildContext context) {
    final recommendedItems = DUMMY_TRAININGS.take(3).toList();


    return Container(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: recommendedItems.length,
        itemBuilder: (context, index) {
          final item = recommendedItems[index];
          final Widget imageWidget;
          
          if (item.isAsset) {
            imageWidget = Image.asset(
                item.imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              );
          } else {
            imageWidget = CachedNetworkImage(
              imageUrl: item.imagePath,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(color: kPrimaryColor, strokeWidth: 2.0),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error, color: kHighlight),
            );
          }


          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: item)));
            },
            child: Container(
              width: 256,
              margin: EdgeInsets.only(right: 16),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageWidget,
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(
                            item.description, 
                            style: TextStyle(
                              color: kTextDarkSecondary, 
                              fontSize: 12
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildActivityGraph(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? kTextDarkSecondary : kTextLightSecondary;


    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("週間活動量", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 150,
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
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 35,
                          interval: 20,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            return Text("${value.toInt()}分", style: TextStyle(color: textColor, fontSize: 10));
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: textColor.withOpacity(0.1),
                          strokeWidth: 1,
                        );
                      },
                    ),
                    barGroups: [
                      _makeBar(context, 0, 30),
                      _makeBar(context, 1, 45),
                      _makeBar(context, 2, 20),
                      _makeBar(context, 3, 0),
                      _makeBar(context, 4, 50, color: kPrimaryColor),
                      _makeBar(context, 5, 15),
                      _makeBar(context, 6, 40),
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


  Widget _buildRecentActivity(BuildContext context) {
    final recentActivities = [
      {"title": "基本のスクワット", "desc": "15回 x 3セット", "icon": Icons.fitness_center},
      {"title": "プッシュアップ", "desc": "10回 x 3セット", "icon": Icons.fitness_center},
    ];
    final isDark = Theme.of(context).brightness == Brightness.dark;


    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("最近のアクティビティ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white : kTextLight)),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentActivities.length,
            itemBuilder: (context, index) {
              final item = recentActivities[index];
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isDark ? kCardDark : kPrimaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(item["icon"] as IconData, color: kPrimaryColor),
                  ),
                  title: Text(item["title"] as String, style: TextStyle(fontWeight: FontWeight.w500)),
                  subtitle: Text(item["desc"] as String, style: TextStyle(color: kTextDarkSecondary)),
                  trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
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


  BarChartGroupData _makeBar(BuildContext context, int x, double y, {Color color = const Color(0xFF03A9F4)}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = color == const Color(0xFF03A9F4) ? (isDark ? Colors.blue[700] : Colors.blue[300]) : color;


    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: barColor,
          width: 16,
          borderRadius: BorderRadius.circular(4),
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


