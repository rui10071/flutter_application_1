import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'theme.dart';

final selectedPeriodProvider = StateProvider<String>((ref) => '週');

final _dailySpots = [FlSpot(8, 75), FlSpot(9, 80), FlSpot(18, 70), FlSpot(19, 85)];
final _weeklySpots = [FlSpot(0, 75), FlSpot(1, 80), FlSpot(2, 70), FlSpot(3, 85), FlSpot(4, 90), FlSpot(5, 88), FlSpot(6, 92)];
final _monthlySpots = [FlSpot(0, 80), FlSpot(3, 85), FlSpot(7, 75), FlSpot(10, 80), FlSpot(15, 82), FlSpot(20, 88), FlSpot(25, 90), FlSpot(29, 85)];
final _yearlySpots = [FlSpot(0, 60), FlSpot(1, 65), FlSpot(2, 70), FlSpot(3, 72), FlSpot(4, 75), FlSpot(5, 70), FlSpot(6, 78), FlSpot(7, 80), FlSpot(8, 75), FlSpot(9, 80), FlSpot(10, 85), FlSpot(11, 80)];

final _dailyLabels = {0: '0時', 6: '6時', 12: '12時', 18: '18時', 23: '24時'};
final _weeklyLabels = {0: '月', 1: '火', 2: '水', 3: '木', 4: '金', 5: '土', 6: '日'};
final _monthlyLabels = {0: '1日', 7: '8日', 14: '15日', 21: '22日', 29: '30日'};
final _yearlyLabels = {0: '1月', 2: '3月', 4: '5月', 6: '7月', 8: '9月', 10: '11月'};

final chartDataProvider = Provider((ref) {
  final period = ref.watch(selectedPeriodProvider);
  switch (period) {
    case '日':
      return (title: "フォーム安定度 (本日)", avg: "平均 78 点", spots: _dailySpots, labels: _dailyLabels, interval: 6.0, showDots: true);
    case '月':
      return (title: "フォーム安定度 (今月)", avg: "平均 82 点", spots: _monthlySpots, labels: _monthlyLabels, interval: 7.0, showDots: false);
    case '年':
      return (title: "フォーム安定度 (今年)", avg: "平均 75 点", spots: _yearlySpots, labels: _yearlyLabels, interval: 2.0, showDots: true);
    case '週':
    default:
      return (title: "フォーム安定度 (今週)", avg: "平均 85 点", spots: _weeklySpots, labels: _weeklyLabels, interval: 1.0, showDots: true);
  }
});

class MyDataScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? kTextDarkSecondary : kTextLightSecondary;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.only(bottom: 100),
          children: [
            _buildAppBar(context),
            _buildPeriodSelector(context, ref),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildChartCard(context, ref, textColor),
            ),
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
    final periods = ["日", "週", "月", "年"];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[800] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: periods.map((period) {
            return _buildPeriodButton(context, ref, period, selectedPeriod == period);
          }).toList(),
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

  Widget _buildChartCard(BuildContext context, WidgetRef ref, Color textColor) {
    final data = ref.watch(chartDataProvider);

    final lineChartData = LineChartData(
      minY: 0,
      maxY: 100,
      gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 25),
      titlesData: FlTitlesData(
        show: true,
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: _buildYAxis(textColor, "点"),
        bottomTitles: _buildXAxis(textColor, data.labels, interval: data.interval),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: data.spots,
          isCurved: true,
          color: kPrimaryColor,
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: data.showDots),
          belowBarData: _buildChartBelowBar(),
        ),
      ],
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data.title, style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 8),
            Text(data.avg, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
            SizedBox(height: 24),
            Container(
              height: 150,
              child: LineChart(lineChartData),
            ),
          ],
        ),
      ),
    );
  }

  AxisTitles _buildYAxis(Color textColor, String unit) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (double value, TitleMeta meta) {
          if (value == 0 || value == 50 || value == 100) {
            return Text("${value.toInt()}$unit", style: TextStyle(color: textColor, fontSize: 10));
          }
          return Text("");
        },
      ),
    );
  }

  AxisTitles _buildXAxis(Color textColor, Map<int, String> labels, {double interval = 1.0}) {
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        interval: interval,
        getTitlesWidget: (double value, TitleMeta meta) {
          final text = labels[value.toInt()];
          if (text != null) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              space: 4,
              child: Text(text, style: TextStyle(color: textColor, fontSize: 10)),
            );
          }
          return Text("");
        },
      ),
    );
  }
  
  BarAreaData _buildChartBelowBar() {
    return BarAreaData(
      show: true,
      gradient: LinearGradient(
        colors: [kPrimaryColor.withOpacity(0.3), kPrimaryColor.withOpacity(0.0)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
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
      {"title": "プッシュアップ", "desc": "自重, 20回 x 3セット"},
      {"title": "ランジ", "desc": "自重, 15回 x 3セット"},
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

