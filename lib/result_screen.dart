import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // グラフ用にインポート
import 'theme.dart';
import 'widgets/bottom_nav_bar.dart';

class ResultScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundDark,
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: ListView( // SingleChildScrollViewからListViewに変更
              padding: EdgeInsets.fromLTRB(16, 0, 16, 100),
              children: [
                SizedBox(height: 40),
                Text(
                  "素晴らしいトレーニングでした！",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                // _buildScoreIndicator(), // ← 総合スコアを削除
                _buildDailyWorkoutChart(context), // ← 今日の運動量グラフを追加
                SizedBox(height: 32),
                _buildPerformanceDetails(context),
                SizedBox(height: 24),
                _buildMemoSection(context),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            // ナビバーの currentIndex を 2 (記録) に変更
            child: BottomNavBar(currentIndex: 2),
          ),
        ],
      ),
    );
  }

  // --- 今日の運動量グラフ (種目ごと) を追加 ---
  Widget _buildDailyWorkoutChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? kTextDarkSecondary : kTextLightSecondary;

    // ダミーデータ (プッシュアップ: 20回, スクワット: 30回, プランク: 60秒)
    final workoutData = {
      'プッシュアップ': 20.0,
      'スクワット': 30.0,
      'プランク': 60.0, // 秒数もそのまま突っ込む (テキトー)
    };
    final labels = workoutData.keys.toList();
    final values = workoutData.values.toList();
    final maxValue = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) * 1.2 : 10.0; // 最大値 + 20%

    return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
          Text(
            "今日の運動量",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Card(
            color: kCardDark, // 背景色を指定
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 150, // グラフの高さ
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: maxValue, // Y軸の最大値
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
                          reservedSize: 30, // ラベル用のスペース
                        ),
                      ),
                      leftTitles: AxisTitles( // Y軸 (左側)
                        sideTitles: SideTitles(
                          showTitles: true, // 目盛りを表示
                          reservedSize: 40, // 目盛り用のスペース
                          getTitlesWidget: (double value, TitleMeta meta) {
                             if (value == 0 || value == maxValue ~/ 2 || value == maxValue) {
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
                            width: 16, // 棒の太さ
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
  // --- ここまで追加 ---


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
                subtitle: "完璧！フォームが安定していましたね！",
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


