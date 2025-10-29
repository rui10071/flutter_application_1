import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'theme.dart';
import 'selection_screen.dart';
import 'mydata_screen.dart';
import 'profile_screen.dart';
import 'details_screen.dart';
import 'widgets/bottom_nav_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: 100),
              children: [
                _buildHeader(context),
                _buildSummaryCards(),
                _buildRecommendedHeader(context),
                _buildRecommendedList(context),
                _buildActivityGraph(context),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BottomNavBar(currentIndex: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage("https://lh3.googleusercontent.com/a/ACg8ocL8H-js-L2B5-ylkGk22otY83f-hO9a-b-T7-Z-y-8h=s96-c"),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
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

  Widget _buildRecommendedHeader(BuildContext context) {
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
              Navigator.push(context, MaterialPageRoute(builder: (context) => SelectionScreen()));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedList(BuildContext context) {
    final items = [
      {"title": "モーニングヨガ", "desc": "15分 | 初級", "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuCfgHdBL6e4Ybmu597OawI6e2HgfsbLGKvuKxPf64r7HkKU1eYr_61Z5nlAP7I9X9EnZPMMV1Ln6vg08V_2OTHObLS3KOo_k1g90nvZNPuoBMb-Fz526BAHj3qVKymn35MsM7jbsKwVpFQw8NQDQJyPOmESD_AbA05IWqBRLexjlrCFdoiL2VhGMs4TBMXgMfELGaNSuLFjtqgP8-4Olyd6dHbJYrTbkzN6Hc4QgYMngJ4VJDlEpB4NQHQ-71-R--xjLvYOVAQgZ8c"},
      {"title": "全身HIIT", "desc": "20分 | 中級", "image": "https://lh3.googleusercontent.com/aida-public/AB6AXuDYNMMyV-bjyPdUqKHo12TgcsCwSux6uCC6wz9yOJB3KKEhcVoKANz5j60uETqsGmeycTSKxzXxKAEQK-zztpze-n-oU73rJ0FNovznXW4TRLcp2R84pRnNsM4-Lh7KnBwkJFo090xKG1SDx5_qVLD9Z2TP4bBVUAYQOdpMR0mOcOM59O8e1i_PgViGkSAtpcywgzE3DUCVMbpMbIvEt3cb3YxP4pU8VtORNuwmIz0kvryEqS2ydWrTzUF9-I1ismKCYoNFfegiUx8"},
      {"title": "肩の集中トレーニング", "desc": "10分 | 中級", "image": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=2940&auto=format&fit=crop"},
    ];

    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsScreen()));
            },
            child: Container(
              width: 256,
              margin: EdgeInsets.only(right: 16),
              child: Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      items[index]["image"]!,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(items[index]["title"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 4),
                          Text(items[index]["desc"]!, style: TextStyle(color: kTextDarkSecondary, fontSize: 12)),
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

