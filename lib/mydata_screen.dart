import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'theme.dart';
import 'details_screen.dart'; 
import 'training_model.dart'; 
import 'training_history.dart'; 
import 'result_screen.dart'; 
import 'memo_list_screen.dart'; 


final selectedPeriodProvider = StateProvider<String>((ref) => '概要');


class MyDataScreen extends ConsumerStatefulWidget {
  @override
  _MyDataScreenState createState() => _MyDataScreenState();
}


class _MyDataScreenState extends ConsumerState<MyDataScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;


  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
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
    final selectedPeriod = ref.watch(selectedPeriodProvider);


    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text("トレーニング記録", style: TextStyle(fontFamily: 'Lexend', fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white)),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: "https://images.unsplash.com/photo-1599058917212-d750089bc07e?q=80&w=2938&auto=format&fit=crop",
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
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  SizedBox(height: 8), 
                  _buildPeriodSelector(context, ref),
                  Expanded(
                    child: selectedPeriod == '概要'
                        ? _buildSummaryGrid(context)
                        : _buildGraphsList(context, ref, selectedPeriod),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildPeriodSelector(BuildContext context, WidgetRef ref) {
    final selectedPeriod = ref.watch(selectedPeriodProvider);
    final periods = ["概要", "日", "週", "月", "年"];


    return Container(
      height: 40,
      margin: EdgeInsets.only(bottom: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final period = periods[index];
          final isSelected = selectedPeriod == period;
          return Container(
            margin: EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                ref.read(selectedPeriodProvider.notifier).state = period;
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: isSelected ? kPrimaryColor : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? kPrimaryColor : Colors.white.withOpacity(0.1),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        period,
                        style: TextStyle(
                          color: isSelected ? Colors.black : Colors.white70,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  Widget _buildSummaryGrid(BuildContext context) {
    final summaryData = [
      {
        "title": "スクワット",
        "total": "120 回",
        "avg": "85 点",
        "image": "https://images.unsplash.com/photo-1541534741688-6078c6bfb5c5?q=80&w=2940&auto=format&fit=crop",
      },
      {
        "title": "プッシュアップ",
        "total": "80 回",
        "avg": "72 点",
        "image": "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=2940&auto=format&fit=crop",
      },
      {
        "title": "プランク",
        "total": "15 分",
        "avg": "90 点",
        "image": "https://images.unsplash.com/photo-1599058917212-d750089bc07e?q=80&w=2938&auto=format&fit=crop",
      },
      {
        "title": "ヨガ",
        "total": "3 時間",
        "avg": "‐",
        "image": "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?q=80&w=2787&auto=format&fit=crop",
      },
    ];


    return GridView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 100),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: summaryData.length,
      itemBuilder: (context, index) {
        final data = summaryData[index];
        final imagePath = data['image'] as String;


        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: imagePath,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(color: Color(0xFF122017)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            data['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (data['avg'] != "‐")
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "${data['avg']}",
                              style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      "合計: ${data['total']}",
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  Widget _buildGraphsList(BuildContext context, WidgetRef ref, String period) {
    final menus = ["スクワット", "プッシュアップ", "プランク"];
    
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: menus.length + 1, 
      itemBuilder: (context, index) {
        if (index == menus.length) {
          return _buildHistoryButton(context);
        }
        return _buildMenuChartCard(context, menus[index], period);
      },
    );
  }


  Widget _buildHistoryButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
             decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MemoListScreen()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, color: kPrimaryColor),
                      SizedBox(width: 12),
                      Text("履歴とメモを見る", style: TextStyle(color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildMenuChartCard(BuildContext context, String menuTitle, String period) {
    final textColor = Colors.white38;
    
    List<FlSpot> spots;
    double maxY;
    
    if (menuTitle.contains("プランク")) {
      maxY = 120; 
      spots = [FlSpot(0, 30), FlSpot(1, 45), FlSpot(2, 40), FlSpot(3, 60), FlSpot(4, 90), FlSpot(5, 60), FlSpot(6, 120)];
    } else {
      maxY = 30; 
      if (menuTitle.contains("スクワット")) {
        spots = [FlSpot(0, 10), FlSpot(1, 15), FlSpot(2, 15), FlSpot(3, 20), FlSpot(4, 20), FlSpot(5, 25), FlSpot(6, 30)];
      } else {
        spots = [FlSpot(0, 5), FlSpot(1, 8), FlSpot(2, 8), FlSpot(3, 10), FlSpot(4, 12), FlSpot(5, 10), FlSpot(6, 15)];
      }
    }


    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(menuTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                    Text("$period単位", style: TextStyle(color: textColor, fontSize: 12)),
                  ],
                ),
                SizedBox(height: 24),
                Container(
                  height: 150,
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 6,
                      minY: 0,
                      maxY: maxY,
                      gridData: FlGridData(
                        show: true, 
                        drawVerticalLine: false, 
                        horizontalInterval: maxY / 4,
                        getDrawingHorizontalLine: (value) => FlLine(color: Colors.white.withOpacity(0.05), strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            interval: maxY / 2,
                            getTitlesWidget: (value, meta) => Text("${value.toInt()}", style: TextStyle(color: textColor, fontSize: 10, fontFamily: 'Lexend')),
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const days = ['月', '火', '水', '木', '金', '土', '日'];
                              if (value.toInt() < days.length) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(days[value.toInt()], style: TextStyle(color: textColor, fontSize: 10)),
                                );
                              }
                              return Text("");
                            },
                          ),
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
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
      ),
    );
  }
}


