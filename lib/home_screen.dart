import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: 100),
          children: [
            _buildHeader(context, ref),
            _buildSummaryCards(),
            _buildRecommendedHeader(context, ref),
            _buildRecommendedList(context),
            _buildActivityGraph(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage("assets/images/burpee.jpg"),
              ),
              SizedBox(width: 12),
              Text(
                "こんにちは、健太さん！",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.account_circle_outlined, color: Theme.of(context).textTheme.bodyLarge?.color),
            iconSize: 28,
            onPressed: () {
              ref.read(mainNavIndexProvider.notifier).state = 3;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("本日の活動時間", style: TextStyle(color: kTextDarkSecondary, fontSize: 14)),
                    SizedBox(height: 4),
                    Text("5h 30m", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("本日の消費カロリー", style: TextStyle(color: kTextDarkSecondary, fontSize: 14)),
                    SizedBox(height: 4),
                    Text("1,200 kcal", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("あなたへのおすすめ", style: Theme.of(context).textTheme.titleLarge),
          TextButton(
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
    final List<Map<String, dynamic>> feedback = [
      {"title": "AIからのフィードバック", "desc": "昨日のスクワットのフォーム（膝）が乱れていました。復習しましょう。", "isAIFeedback": true, "imagePath": "assets/images/deadlift.jpg", "isAsset": true},
    ];
    
    final recommendedItems = DUMMY_TRAININGS.take(3).toList();

    return Container(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: feedback.length + recommendedItems.length,
        itemBuilder: (context, index) {
          
          if (index == 0) {
            final item = feedback[0];
            final bool isAIFeedback = item["isAIFeedback"] as bool? ?? false;

            return GestureDetector(
              onTap: () {
                final squatMenu = DUMMY_TRAININGS.firstWhere((m) => m.id == "squat", orElse: () => DUMMY_TRAININGS.first);
                Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen(menu: squatMenu)));
              },
              child: Container(
                width: 256,
                margin: EdgeInsets.only(right: 16),
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  color: isAIFeedback ? kPrimaryColor.withOpacity(0.15) : Theme.of(context).cardTheme.color,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        item["imagePath"]! as String,
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["title"]! as String, style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 4),
                            Text(
                              item["desc"]! as String, 
                              style: TextStyle(
                                color: isAIFeedback ? kTextDark : kTextDarkSecondary, 
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
          }
          
          final item = recommendedItems[index - 1];
          final Widget imageWidget = item.isAsset
            ? Image.asset(
                item.imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              )
            : Image.network(
                item.imagePath,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              );

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
          Text("週間活動量", style: Theme.of(context).textTheme.titleLarge),
          SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 128,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    barTouchData: BarTouchData(enabled: true),
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
                          reservedSize: 30,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            if (value == 0 || value == 50 || value == 100) {
                              return Text("${value.toInt()}分", style: TextStyle(color: textColor, fontSize: 10));
                            }
                            return Text("");
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    barGroups: [
                      _makeBar(0, 60),
                      _makeBar(1, 20),
                      _makeBar(2, 80),
                      _makeBar(3, 10),
                      _makeBar(4, 90, color: Color(0xFFFF9800)),
                      _makeBar(5, 0),
                      _makeBar(6, 40),
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

  BarChartGroupData _makeBar(int x, double y, {Color color = const Color(0xFF03A9F4)}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 16,
          borderRadius: BorderRadius.circular(4),
        ),
      ],
    );
  }
}

