import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpodをインポート
import 'package:fl_chart/fl_chart.dart';
import 'theme.dart';
import 'widgets/bottom_nav_bar.dart';

// 選択中のタブを管理するためのProvider (Riverpod)
final selectedPeriodProvider = StateProvider<String>((ref) => '日'); // 初期値を '日' に

class MyDataScreen extends ConsumerWidget { // StatelessWidgetからConsumerWidgetに変更
  @override
  Widget build(BuildContext context, WidgetRef ref) { // WidgetRef ref を追加
    final selectedPeriod = ref.watch(selectedPeriodProvider); // 現在選択中のタブを取得

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: 100),
              children: [
                _buildAppBar(context),
                _buildPeriodSelector(context, ref), // refを渡す
                // 選択中のタブに応じて表示するグラフを切り替える
                if (selectedPeriod == '日')
                  _buildDailyWorkoutChart(context)
                else // 週・月はとりあえずフォーム安定度グラフのまま
                  _buildFormChart(context),
                _buildHistoryHeader(context),
                _buildHistoryList(context),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomNavBar(currentIndex: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 48),
          Text("マイデータ", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  // WidgetRef ref を引数に追加
  Widget _buildPeriodSelector(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedPeriod = ref.watch(selectedPeriodProvider); // 現在選択中のタブを取得

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            // タブを「日・週・月」に変更
            _buildPeriodButton(context, ref, "日", selectedPeriod == "日"),
            _buildPeriodButton(context, ref, "週", selectedPeriod == "週"),
            _buildPeriodButton(context, ref, "月", selectedPeriod == "月"),
          ],
        ),
      ),
    );
  }

  // WidgetRef ref を引数に追加し、タップ時の処理を追加
  Widget _buildPeriodButton(BuildContext context, WidgetRef ref, String text, bool isSelected) {
    return Expanded(
      child: GestureDetector( // タップ可能にする
        onTap: () {
          // タップされたら選択中のタブを更新する (Riverpod)
          ref.read(selectedPeriodProvider.notifier).state = text;
        },
        child: Container( // Containerで囲んでタップ範囲を広げる
          decoration: isSelected
              ? BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))],
                )
              : null, // 非選択時は色なし
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color,
              )
            )
          ),
        ),
      ),
    );
  }

  // --- ResultScreenからコピーしてきた「日のグラフ」 ---
  Widget _buildDailyWorkoutChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? kTextDarkSecondary : kTextLightSecondary;

    final workoutData = {
      'プッシュアップ': 20.0,
      'スクワット': 30.0,
      'プランク': 60.0,
    };
    final labels = workoutData.keys.toList();
    final values = workoutData.values.toList();
    final maxValue = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) * 1.2 : 10.0;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
            // Text("今日の運動量", style: Theme.of(context).textTheme.titleMedium), // タイトルは不要かも
            // SizedBox(height: 8),
            Card(
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
                              width: 16,
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
      ),
    );
  }
  // --- ここまで追加 ---

  // 元々あったフォーム安定度グラフ (週・月で使う)
  Widget _buildFormChart(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("フォーム安定度の推移", style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              Text("85 点", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              SizedBox(height: 24),
              Container(
                height: 150,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: [
                          FlSpot(0, 3.5), FlSpot(1, 1.5), FlSpot(2, 2.0), FlSpot(3, 3.0), FlSpot(4, 1.8), FlSpot(5, 3.2),
                          FlSpot(6, 2.5), FlSpot(7, 2.2), FlSpot(8, 4.0), FlSpot(9, 4.8), FlSpot(10, 0.5), FlSpot(11, 2.8),
                          FlSpot(12, 4.2), FlSpot(13, 1.0),
                        ],
                        isCurved: true,
                        color: kPrimaryColor,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            colors: [kPrimaryColor.withOpacity(0.3), kPrimaryColor.withOpacity(0.0)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Text("トレーニング履歴", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHistoryList(BuildContext context) {
    final history = [
      {"title": "スクワット", "desc": "50kg, 10回 x 3セット"},
      {"title": "ベンチプレス", "desc": "60kg, 8回 x 3セット"},
      {"title": "デッドリフト", "desc": "80kg, 5回 x 3セット"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
             border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1))
          ),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.fitness_center, color: Theme.of(context).textTheme.bodyLarge?.color),
            ),
            title: Text(history[index]["title"]!, style: TextStyle(fontWeight: FontWeight.w500)),
            subtitle: Text(history[index]["desc"]!, style: TextStyle(color: kTextDarkSecondary)),
            trailing: Icon(Icons.chevron_right, color: kTextDarkSecondary),
            onTap: () {},
          ),
        );
      },
    );
  }
}

