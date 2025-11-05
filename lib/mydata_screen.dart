import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'theme.dart';

final selectedPeriodProvider = StateProvider<String>((ref) => '日');

class MyDataScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedPeriodProvider);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: 100),
          children: [
            _buildAppBar(context),
            _buildPeriodSelector(context, ref),
            if (selectedPeriod == '日')
              _buildDailyWorkoutChart(context)
            else if (selectedPeriod == '週')
              _buildFormChart(context)
            else
              _buildMonthlyLoadChart(context),
            _buildHistoryHeader(context),
            _buildHistoryList(context),
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

  Widget _buildPeriodSelector(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedPeriod = ref.watch(selectedPeriodProvider);

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
            _buildPeriodButton(context, ref, "日", selectedPeriod == "日"),
            _buildPeriodButton(context, ref, "週", selectedPeriod == "週"),
            _buildPeriodButton(context, ref, "月", selectedPeriod == "月"),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodButton(BuildContext context, WidgetRef ref, String text, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          ref.read(selectedPeriodProvider.notifier).state = text;
        },
        child: Container(
          decoration: isSelected
              ? BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: Offset(0, 2))],
                )
              : null,
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

  Widget _buildFormChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("フォーム安定度の推移 (週)", style: Theme.of(context).textTheme.titleMedium),
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

  Widget _buildMonthlyLoadChart(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("月別 負荷の推移 (ダミー)", style: Theme.of(context).textTheme.titleMedium),
              SizedBox(height: 8),
              Text("MAX 85 kg", style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
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
                          FlSpot(0, 2.5), FlSpot(1, 3.5), FlSpot(2, 3.0), FlSpot(3, 4.0),
                          FlSpot(4, 4.2), FlSpot(5, 4.0), FlSpot(6, 4.5), FlSpot(7, 4.8),
                        ],
                        isCurved: false,
                        color: kHighlight,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        dotData: FlDotData(show: true),
                        belowBarData: BarAreaData(show: false),
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
    final List<Map<String, String>> history = [
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

