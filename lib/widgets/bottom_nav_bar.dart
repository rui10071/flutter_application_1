import 'package:flutter/material.dart';
import '../theme.dart';
import '../home_screen.dart';
import '../selection_screen.dart';
import '../mydata_screen.dart';
import '../profile_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 1)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(context, icon: Icons.home, label: "ホーム", index: 0, screen: HomeScreen()),
          _buildNavItem(context, icon: Icons.fitness_center, label: "トレーニング", index: 1, screen: SelectionScreen()),
          _buildNavItem(context, icon: Icons.bar_chart, label: "記録", index: 2, screen: MyDataScreen()),
          _buildNavItem(context, icon: Icons.person, label: "プロフィール", index: 3, screen: ProfileScreen()),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, {required IconData icon, required String label, required int index, required Widget screen}) {
    final isSelected = (index == currentIndex);
    final color = isSelected ? kPrimaryColor : kTextDarkSecondary;

    return GestureDetector(
      onTap: () {
        if (isSelected) return;
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => screen,
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28, fill: isSelected ? 1.0 : 0.0),
          SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

