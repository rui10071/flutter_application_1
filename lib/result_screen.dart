import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart'; 
import 'theme.dart';
import 'main_screen.dart';

class ResultScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: kBackgroundDark,
      appBar: AppBar(
        backgroundColor: kBackgroundDark,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
              ref.read(mainNavIndexProvider.notifier).state = 2;
            },
          ),
        ],
      ),
      body: ListView( 
        padding: EdgeInsets.fromLTRB(16, 0, 16, 100),
        children: [
          SizedBox(height: 20),
          Text(
            "素晴らしいトレーニングでした！",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          _buildDailyWorkoutChart(context), 
          SizedBox(height: 32),
          _buildPerformanceDetails(context),
          SizedBox(height: 24),
          _buildMemoSection(context),
        ],
      ),
    );
  }

  Widget _buildDailyWorkoutChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? kTextDarkSecondary : kTextLightSecondary;

    final workoutData = {
      'プッシュアップ': 20.0,
      'フォーム安定度': 85.0,
    };
    final labels = workoutData.keys.toList();
    final values = workoutData.values.toList();
    final maxValue = 100.0;

    return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Text(
            "プッシュアップの結果",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            color: kCardDark, 
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 150, 
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxValue, 
                    barTouchData: BarTouchData(enabled: true),
                    titlesData: FlTitlesData(
                      show: true,
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (double value, TitleMeta meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < labels.length) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                space: 8.0,
                                child: Text(labels[index], style: TextStyle(color: textColor, fontSize: 10)),
                              );
                            }
                            return Container();
                          },
                          reservedSize: 30, 
                        ),
                      ),
                      leftTitles: AxisTitles( 
                        sideTitles: SideTitles(
                          showTitles: true, 
                          reservedSize: 40, 
                          getTitlesWidget: (double value, TitleMeta meta) {
                             if (value == 0 || value == 50 || value == 100) {
                                return Text(value.toInt().toString(), style: TextStyle(color: textColor, fontSize: 10));
                             }
                              return Text('');
                          }
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(show: false),
                    gridData: FlGridData(show: false),
                    barGroups: List.generate(labels.length, (index) {
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: values[index],
                            color: kPrimaryColor,
                            width: 24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
       ],
    );
  }

  Widget _buildPerformanceDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "パフォーマンス詳細",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: kCardDark,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildDetailItem(
                icon: Icons.check_circle,
                title: "フォーム評価",
                subtitle: "85点！ フォームが安定していました！",
              ),
              Divider(color: Colors.grey[800], height: 1),
              _buildDetailItem(
                icon: Icons.fitness_center,
                title: "プッシュアップ",
                subtitle: "回数",
                trailing: "20回",
              ),
              Divider(color: Colors.grey[800], height: 1),
              _buildDetailItem(
                icon: Icons.local_fire_department,
                title: "消費カロリー",
                subtitle: "推定値",
                trailing: "50 kcal",
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem({required IconData icon, required String title, required String subtitle, String? trailing}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xFF264532),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: trailing == null ? kPrimaryColor : Colors.white, size: 28),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                SizedBox(height: 2),
                Text(subtitle, style: TextStyle(color: Color(0xFF96c5a9), fontSize: 14)),
              ],
            ),
          ),
          if (trailing != null)
            Text(trailing, style: TextStyle(color: Colors.white, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildMemoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "トレーニングメモ",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        TextField(
          maxLines: 4,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: kCardDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: "良かった点、改善点などを書きましょう...",
            hintStyle: TextStyle(color: kTextDarkSecondary),
          ),
        ),
      ],
    );
  }
}

